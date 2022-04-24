.data 

Aarray: .word 0,0,0,0,0
Barray: .word 1,2,4,8,16

.text

main:

la t1, Aarray
la t2, Barray

addi s0,zero,0
addi gp,zero,4

for: slti s1,s0, 5
beq s1,zero,escapefor
mul s2,s0,gp
mul s3,s0,gp
add s1,t1,s1
add s2,t0,s2
lw a0,0(s1)
addi a0,a0,-1
sw a0, 0(s2)
addi s0,s0,1
j for

escapefor:
addi s0,s0,-1
addi s4,zero,-1

while: beq s0,s4,escapewhile
mul s1,s0,gp
mul s2,s0,gp
add s1,t1,s1
add s2,t0,s2
lw a1,0(s1)
lw a2,0(s2)
add a3,a1,a2
addi a5,zero,2
mul a3,a3,a4
sw a3,0(s2)
addi s0,s0,-1
j while

escapewhile:
li a6,10
ecall
