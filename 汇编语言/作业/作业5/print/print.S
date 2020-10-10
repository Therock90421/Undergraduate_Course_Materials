.section .data
  var: .int 0x80001234 
                            #0x0812abcd
.section .text
.globl  _start
_start:
  pushl var
  call  print_hex
  mov   $1, %eax
  mov   $0, %ebx
  int   $0x80

.type print_hex, @function
print_hex:
  push  %ebp
  mov   %esp, %ebp
  sub   $16, %esp
  mov  %ebx, 12(%esp)
  mov  8(%ebp),%ecx
  movb  $'0', 0(%esp)
  movb  $'x', 1(%esp)
  movb  $0, 10(%esp)
  lea   9(%esp), %eax
  lea   2(%esp), %ebx
  
  test   $0x80000000,  %ecx          #positive or negative
  jnz    W                  #negetive  go W 
  L1:
  mov   %ecx, %edx
  test  %cl,%cl
  jnz   L0
  shrl  $4,%ecx
  jmp   L1
  L0:
  mov   %ecx, %edx
  andb  $0xf, %dl
  cmpb  $10, %dl
  jb    L2
  addb  $0x57, %dl
  jmp   L3
L2:
  orb   $0x30, %dl
L3:
  movb  %dl, (%eax)
  dec   %eax
  shrl  $4, %ecx
  cmp   %ebx, %eax
  jae   L0
  
  mov  $10, %eax
  L4:
  movl   2(%esp),%ecx
  cmp  $0x30,%cl
  ja   L5
  movb  $'0', 1(%esp)
  movb  $'x', 2(%esp)
  inc    %esp
  dec   %eax
  jmp   L4
  L5:
  mov   %eax,%edx
  mov   $4, %eax
  mov   $1, %ebx
  mov   %esp, %ecx
  jmp   L
  
    
  W:
  not   %ecx
  add   $1,%ecx             #negative  
  movb  $'-', 0(%esp)
  movb  $'0', 1(%esp)
  movb  $'x', 2(%esp)
  movb  $0, 11(%esp)
  lea   10(%esp), %eax
  lea   3(%esp), %ebx
  
  W1:
  mov   %ecx, %edx
  test  %cl,%cl
  jnz   W0
  shrl  $4,%ecx
  jmp   W1
  W0:
  mov   %ecx, %edx
  andb  $0xf, %dl
  cmpb  $10, %dl
  jb    W2
  addb  $0x57, %dl
  jmp   W3
W2:
  orb   $0x30, %dl
W3:
  movb  %dl, (%eax)
  dec   %eax
  shrl  $4, %ecx
  cmp   %ebx, %eax
  jae   W0
  
  mov  $11, %eax
  W4:
  movl   2(%esp),%ecx
  cmp  $0x30,%cl
  ja   W5
  movb  $'0', 1(%esp)
  movb  $'0', 2(%esp)
  movb  $'x', 3(%esp)
  inc    %esp
  dec   %eax
  jmp   W4
  W5:
  mov   %eax,%edx
  mov   $4, %eax
  mov   $1, %ebx
  mov   %esp, %ecx
  jmp   L 
  
  L:
  int   $0x80
  mov 12(%esp), %ebx
  leave
  ret
