.data
Var_Z: .word 2
Var_I: .word 0

.text

main:

lw a0, Var_Z
lw sp, Var_I

for: #label
slti s1, sp, 21
beq s1,zero,escape
addi, sp,sp,2
j for #sends back to the top of loop

escape:

whiledo:
addi a0,a0,1
slti s1,a0,100
beq s1,zero,escapedo
j whiledo

escapedo:

while: slt s1,zero,sp
beq s1,zero,escapewhile
addi a0,a0,-1
addi sp,sp,-1
j while

escapewhile:
sw a0,Var_Z,t1
