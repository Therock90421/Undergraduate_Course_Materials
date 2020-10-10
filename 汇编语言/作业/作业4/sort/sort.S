.section .data
 testdata:
   .int 6, -5, 3, 1, -8, 7, 0, 2, 4, 9
.section .text
.globl _start
_start:
        subl	$8, %esp
	movl	$40, 4(%esp)
        movl	$testdata, (%esp)

  	call	insert_sort
#output
 	
	call	as_puts
#exit
	call	as_exit

#void insert_sort(int a[ ], int n)
.text
        .globl  insert_sort
        .type   insert_sort, @function
insert_sort:
.LFB0:
        pushl   %edi              #edi =a
        pushl   %esi
        pushl   %ebx
        movl    16(%esp),%edi
        movl    20(%esp),%esi     
        subl    $4, %esi              #esi = n-1 
        testl   %esi, %esi
        jle     .L1
        movl    %edi, %eax
.L2:
      
        
        addl    $4, %eax         #eax = a+i  i begin with 1
        movl    (%eax),%edx       #edx = temp = a[i]
    
        movl    %eax,%ecx         #ecx = a+i
        subl    %edi,%ecx         #ecx = i
        subl    $4, %ecx              #ecx = i-1=j
          
.L3:      
        movl    (%edi,%ecx),%ebx  #ebx = a[i]
        cmpl    %edx,%ebx
        jle      .L5
        
        movl    %ebx,4(%edi,%ecx)
        subl    $4, %ecx                 #j--

        cmpl    $0,%ecx
        jge      .L3
.L5:
        movl    %edx,4(%edi,%ecx)
        sub     $4,%esi              #esi = n-i
        jnz      .L2
.L1:
        popl    %ebx
        popl    %esi
        popl    %edi
        ret

# int as_puts(char *s, int n)
 .globl  as_puts
        .type   as_puts, @function
as_puts:
	push	%ebx
	movl	$4, %eax
	movl	$1, %ebx
	movl	8(%esp), %ecx
	movl	$40, %edx
	int	$0x80
	pop	%ebx
	ret



# void as_exit(void)
 .globl  as_exit
        .type   as_exit, @function
as_exit:
	movl	$1, %eax
	movl	$0, %ebx
	int	$0x80
