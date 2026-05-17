.globl running, scheduler, tswitch
tswitch:
SAVE:   pushl %eax
        pushl %ebx
        pushl %ecx
        pushl %edx
        pushl %ebp
        pushl %esi
        pushl %edi
        pushfl
        movl running, %ebx
        movl %esp, 4(%ebx)
FIND:   call scheduler
RESUME: movl running, %ebx
        movl 4(%ebx), %esp
        popfl
        popl %edi
        popl %esi
        popl %edx
        popl %ecx
        popl %ebx
        popl %eax
        ret
                pacman -S mingw-w64-i686-toolchain                pacman -S mingw-w64-i686-toolchain