	.file	"t.c"
	.text
	.globl	_enqueue
	.def	_enqueue;	.scl	2;	.type	32;	.endef
_enqueue:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	je	L2
	movl	12(%ebp), %eax
	movl	20(%eax), %edx
	movl	-4(%ebp), %eax
	movl	20(%eax), %eax
	cmpl	%eax, %edx
	jle	L5
L2:
	movl	8(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, (%eax)
	movl	12(%ebp), %eax
	movl	-4(%ebp), %edx
	movl	%edx, (%eax)
	jmp	L4
L7:
	movl	-4(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -4(%ebp)
L5:
	movl	-4(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	L6
	movl	12(%ebp), %eax
	movl	20(%eax), %edx
	movl	-4(%ebp), %eax
	movl	(%eax), %eax
	movl	20(%eax), %eax
	cmpl	%eax, %edx
	jle	L7
L6:
	movl	-4(%ebp), %eax
	movl	(%eax), %edx
	movl	12(%ebp), %eax
	movl	%edx, (%eax)
	movl	-4(%ebp), %eax
	movl	12(%ebp), %edx
	movl	%edx, (%eax)
L4:
	nop
	leave
	ret
	.globl	_dequeue
	.def	_dequeue;	.scl	2;	.type	32;	.endef
_dequeue:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	je	L9
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
L9:
	movl	-4(%ebp), %eax
	leave
	ret
	.section .rdata,"dr"
LC0:
	.ascii "%s = \0"
LC1:
	.ascii "[%d %d]->\0"
LC2:
	.ascii "NULL\0"
	.text
	.globl	_printList
	.def	_printList;	.scl	2;	.type	32;	.endef
_printList:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$LC0, (%esp)
	call	_printf
	jmp	L12
L13:
	movl	12(%ebp), %eax
	movl	20(%eax), %edx
	movl	12(%ebp), %eax
	movl	8(%eax), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$LC1, (%esp)
	call	_printf
	movl	12(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, 12(%ebp)
L12:
	cmpl	$0, 12(%ebp)
	jne	L13
	movl	$LC2, (%esp)
	call	_puts
	nop
	leave
	ret
	.globl	_proc
	.bss
	.align 32
_proc:
	.space 37080
	.globl	_freeList
	.align 4
_freeList:
	.space 4
	.globl	_readyQueue
	.align 4
_readyQueue:
	.space 4
	.globl	_running
	.align 4
_running:
	.space 4
	.section .rdata,"dr"
LC3:
	.ascii "no more proc\0"
	.text
	.globl	_kfork
	.def	_kfork;	.scl	2;	.type	32;	.endef
_kfork:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$_freeList, (%esp)
	call	_dequeue
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	jne	L15
	movl	$LC3, (%esp)
	call	_puts
	movl	$-1, %eax
	jmp	L16
L15:
	movl	-16(%ebp), %eax
	movl	$0, 16(%eax)
	movl	-16(%ebp), %eax
	movl	$1, 20(%eax)
	movl	_running, %eax
	movl	8(%eax), %edx
	movl	-16(%ebp), %eax
	movl	%edx, 12(%eax)
	movl	$1, -12(%ebp)
	jmp	L17
L18:
	movl	$1024, %eax
	subl	-12(%ebp), %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	addl	$4, %edx
	movl	$0, 8(%eax,%edx,4)
	addl	$1, -12(%ebp)
L17:
	cmpl	$9, -12(%ebp)
	jle	L18
	movl	$_body, %edx
	movl	-16(%ebp), %eax
	movl	%edx, 4116(%eax)
	movl	-16(%ebp), %eax
	leal	4084(%eax), %edx
	movl	-16(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	-16(%ebp), %eax
	movl	8(%eax), %eax
L16:
	leave
	ret
	.section .rdata,"dr"
LC4:
	.ascii "freeList\0"
	.text
	.globl	_kexit
	.def	_kexit;	.scl	2;	.type	32;	.endef
_kexit:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	_running, %eax
	movl	$0, 16(%eax)
	movl	_running, %eax
	movl	$0, 20(%eax)
	movl	_running, %eax
	movl	%eax, 4(%esp)
	movl	$_freeList, (%esp)
	call	_enqueue
	movl	_freeList, %eax
	movl	%eax, 4(%esp)
	movl	$LC4, (%esp)
	call	_printList
	call	_tswitch
	nop
	leave
	ret
	.section .rdata,"dr"
LC5:
	.ascii "kfork failed \0"
LC6:
	.ascii "proc %d kforked a child = %d\12\0"
LC7:
	.ascii "readyQueue\0"
	.text
	.globl	_do_kfork
	.def	_do_kfork;	.scl	2;	.type	32;	.endef
_do_kfork:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	call	_kfork
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jns	L21
	movl	$LC5, (%esp)
	call	_puts
	jmp	L22
L21:
	movl	_running, %eax
	movl	8(%eax), %eax
	movl	-12(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$LC6, (%esp)
	call	_printf
	movl	_readyQueue, %eax
	movl	%eax, 4(%esp)
	movl	$LC7, (%esp)
	call	_printList
L22:
	movl	-12(%ebp), %eax
	leave
	ret
	.globl	_do_switch
	.def	_do_switch;	.scl	2;	.type	32;	.endef
_do_switch:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	call	_tswitch
	nop
	leave
	ret
	.globl	_do_exit
	.def	_do_exit;	.scl	2;	.type	32;	.endef
_do_exit:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	call	_kexit
	nop
	leave
	ret
	.section .rdata,"dr"
LC8:
	.ascii "proco %d starts from body()\12\0"
	.align 4
LC9:
	.ascii "***************************************\0"
LC10:
	.ascii "proc %d running: parent=%d\12\0"
LC11:
	.ascii "enter a key [f|s|q] : \0"
	.text
	.globl	_body
	.def	_body;	.scl	2;	.type	32;	.endef
_body:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	_running, %eax
	movl	8(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$LC8, (%esp)
	call	_printf
L31:
	movl	$LC9, (%esp)
	call	_puts
	movl	_running, %eax
	movl	12(%eax), %edx
	movl	_running, %eax
	movl	8(%eax), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$LC10, (%esp)
	call	_printf
	movl	$LC11, (%esp)
	call	_printf
	call	_getchar
	movl	%eax, -12(%ebp)
	call	_getchar
	cmpl	$115, -12(%ebp)
	je	L27
	cmpl	$115, -12(%ebp)
	jg	L31
	cmpl	$102, -12(%ebp)
	je	L29
	cmpl	$113, -12(%ebp)
	je	L30
	jmp	L28
L29:
	call	_do_kfork
	jmp	L28
L27:
	call	_do_switch
	jmp	L28
L30:
	call	_do_exit
	nop
L28:
	jmp	L31
	.section .rdata,"dr"
LC12:
	.ascii "init complete: p0 running\0"
	.text
	.globl	_init
	.def	_init;	.scl	2;	.type	32;	.endef
_init:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$0, -12(%ebp)
	jmp	L33
L34:
	movl	-12(%ebp), %eax
	imull	$4120, %eax, %eax
	addl	$_proc, %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	%edx, 8(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 16(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 20(%eax)
	movl	-16(%ebp), %eax
	leal	4120(%eax), %edx
	movl	-16(%ebp), %eax
	movl	%edx, (%eax)
	addl	$1, -12(%ebp)
L33:
	cmpl	$8, -12(%ebp)
	jle	L34
	movl	$0, _proc+32960
	movl	$_proc, _freeList
	movl	$0, _readyQueue
	movl	$_freeList, (%esp)
	call	_dequeue
	movl	%eax, _running
	movl	_running, %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	$0, 16(%eax)
	movl	-16(%ebp), %eax
	movl	$0, 12(%eax)
	movl	_freeList, %eax
	movl	%eax, 4(%esp)
	movl	$LC4, (%esp)
	call	_printList
	movl	$LC12, (%esp)
	call	_puts
	nop
	leave
	ret
	.section .rdata,"dr"
LC13:
	.ascii "Welcome to multitasking\0"
LC14:
	.ascii "P0: switch process\0"
	.text
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
	subl	$16, %esp
	call	___main
	movl	$LC13, (%esp)
	call	_printf
	call	_init
	call	_kfork
L37:
	movl	$LC14, (%esp)
	call	_puts
	movl	_readyQueue, %eax
	testl	%eax, %eax
	je	L37
	call	_tswitch
	jmp	L37
	.section .rdata,"dr"
LC15:
	.ascii "proc %d in scheduler()\12\0"
LC16:
	.ascii "next running = %d\12\0"
	.text
	.globl	_scheduler
	.def	_scheduler;	.scl	2;	.type	32;	.endef
_scheduler:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	_running, %eax
	movl	8(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$LC15, (%esp)
	call	_printf
	movl	_running, %eax
	movl	16(%eax), %eax
	testl	%eax, %eax
	jne	L39
	movl	_running, %eax
	movl	%eax, 4(%esp)
	movl	$_readyQueue, (%esp)
	call	_enqueue
L39:
	movl	_readyQueue, %eax
	movl	%eax, 4(%esp)
	movl	$LC7, (%esp)
	call	_printList
	movl	$_readyQueue, (%esp)
	call	_dequeue
	movl	%eax, _running
	movl	_running, %eax
	movl	8(%eax), %eax
	movl	%eax, 4(%esp)
	movl	$LC16, (%esp)
	call	_printf
	nop
	leave
	ret
	.def	___main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
	.def	_printf;	.scl	2;	.type	32;	.endef
	.def	_puts;	.scl	2;	.type	32;	.endef
	.def	_tswitch;	.scl	2;	.type	32;	.endef
	.def	_getchar;	.scl	2;	.type	32;	.endef
