.section .data
iostring:
  .asciz "ab1g2hA0H56po9wK78nB"
.section .text
.globl _start
_start:

        mov     $iostring,%ebx
        mov     %ebx, %ecx
        
      L1:
        movb    (%ebx),%al
        test    %al, %al
        je      L4
        cmp     $'a',  %al
        jb      L3
        cmp     $'z',  %al
        ja      L3
      L2:
        sub     $0x20,%al
        movb    %al,(%ecx)
        inc     %ebx
        inc     %ecx
        
        jmp     L1
      L3:
        
        inc     %ebx
        inc     %ecx
        
        jmp     L1
      L4:
        movb    $10,(%ecx)
        
#output
	movl	$4, %eax
	movl	$1, %ebx
	movl	$iostring, %ecx
        mov     $20, %edx
	int	$0x80
#exit
	movl	$1, %eax
	movl	$0, %ebx
	int	$0x80

