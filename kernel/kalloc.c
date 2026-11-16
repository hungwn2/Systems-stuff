// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

#define STEAL_BATCH 50
void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run
{
  struct run *next;
};

struct
{
  struct spinlock lock;
  struct run *freelist;
} kmem[NCPU];

void kinit()
{
  for (int i = 0; i < NCPU; i++)
    initlock(&kmem[i].lock, "kmem");
  freerange(end, (void *)PHYSTOP);
}

void freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char *)PGROUNDUP((uint64)pa_start);
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)

void kfree(void *pa)
{
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 ||
      (char *)pa < end ||
      (uint64)pa >= PHYSTOP)
    panic("kfree");

  memset(pa, 1, PGSIZE);

  r = (struct run *)pa;

  push_off();
  int id = cpuid();

  acquire(&kmem[id].lock);

  r->next = kmem[id].freelist;
  kmem[id].freelist = r;

  release(&kmem[id].lock);
  pop_off();
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.

void *
kalloc(void)
{
  struct run *r = 0;

  push_off();
  int id = cpuid();

  // Try the local CPU's freelist.
  acquire(&kmem[id].lock);

  r = kmem[id].freelist;

  if (r)
    kmem[id].freelist = r->next;

  release(&kmem[id].lock);

  if (r == 0)
  {
    // Local freelist is empty. Steal from another CPU.
    for (int i = 0; i < NCPU; i++)
    {
      if (i == id)
        continue;

      acquire(&kmem[i].lock);

      struct run *head = kmem[i].freelist;

      if (head)
      {
        struct run *tail = head;
        int count = 1;

        // Find up to STEAL_BATCH pages.
        while (count < STEAL_BATCH && tail->next)
        {
          tail = tail->next;
          count++;
        }

        // Detach the batch from the donor.
        kmem[i].freelist = tail->next;
        tail->next = 0;

        release(&kmem[i].lock);

        // Return the first page.
        r = head;
        struct run *remaining = r->next;
        r->next = 0;

        // Put the remaining pages on our local freelist.
        if (remaining)
        {
          acquire(&kmem[id].lock);

          tail->next = kmem[id].freelist;
          kmem[id].freelist = remaining;

          release(&kmem[id].lock);
        }

        break;
      }

      release(&kmem[i].lock);
    }
  }

  pop_off();

  if (r)
    memset((char *)r, 5, PGSIZE);

  return (void *)r;
}
