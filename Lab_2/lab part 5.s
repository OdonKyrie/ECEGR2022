.data

int_A: .word 0
int_B: .word 0
int_C: .word 0

.text

main:

addi t0,zero,5
addi t1,zero,10

addi sp,sp,-8
sw t0,4(sp)
sw t1,0(sp)

add a0,zero,t0
jal addc
sw t1, int_A,s0

lw t1, 0(sp)
add a0,zero,t1
jal additup
sw t1, int_B,s0

addi sp,sp 8

lw t0,int_A
lw t1,int_B
add t2,t0,t1
sw, t2,int_C,s0

li a2,10
ecall

additup:
add t0,zero,zero
add t1,zero,zero

for: slt t3,t0,a0
beq t3,zero,escapefor
addi t2,t0,1
add t1,t1,t2
addi t0,t0,1
j for

escapefor:
ret
