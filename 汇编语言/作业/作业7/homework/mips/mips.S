.section .data
iostring:
  .asciz "ab1g2hA0H56po9wK78nB"
.section .text
.globl __start
__start:

la    $a0,iostring
addu  $a1,$0,$a0


$L1:
lb    $v0,0($a0)
beq   $v0,$0,$L4
nop
addi  $v0,$v0,-97
bltz  $v0,$L3
addi  $v0,$v0,97
addi  $v0,$v0,-122
bgtz  $v0,$L3
addi  $v0,$v0,122




$L2:
addi  $v0,$v0,-32
sb    $v0,0($a0)
addiu $a0,$a0,1
addiu $a1,$a1,1

j     $L1


$L3:
addiu $a0,$a0,1
addiu $a1,$a1,1


j     $L1

$L4:

addiu  $v0,$v0,10
sb     $v0,0($a1)


addiu  $v0,$0,4004
addiu  $a0,$0,1
la     $a1,iostring
addiu  $a2,$0,20
syscall

addiu  $v0,$0,4001
addiu  $a0,$0,0
syscall  
