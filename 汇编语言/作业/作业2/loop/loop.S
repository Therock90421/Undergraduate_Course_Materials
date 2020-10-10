#loop.S
.section .data
  stringvar: .ascii	"0123456789abcdef"
  stringvars: .ascii "abcdef"
.section .text
.globl _start
_start:

  mov   	$10, %ecx
  mov   	$stringvar, %ebx
  mov           stringvar, %eax
  
L1:
  xchg	%al, %ah
  mov  %al,(%ebx)
  mov  %ah,1(%ebx)   
  add	$1,  %ebx
  add   $2,  %eax
loop  L1 
 
  mov   	$6, %ecx
  mov   	$stringvars, %ebx
  mov           stringvars, %eax 

L2:
  
  xchg	%al, %ah
  mov  %ax,(%ebx)
     
  add	$1,  %ebx
  add   $2,  %eax
 loop  L2
#output
	movl	$4, %eax
	movl	$1, %ebx
	movl	$stringvar, %ecx
	movl	$10, %edx
	int	$0x80

        movl	$4, %eax
	movl	$1, %ebx
	movl	$stringvars, %ecx
	movl	$6, %edx
	int	$0x80







#exit
	movl	$1, %eax
	movl	$0, %ebx
	int	$0x80
