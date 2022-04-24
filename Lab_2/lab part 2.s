.data
	Var_Z: .word 0
.text

main:
#using argueents that are set to zero in order to make sure that the arguements are set correctly
addi a0,zero,15 #a
addi a1,zero,10 #b
addi a2,zero,5  #c
addi a3,zero,2  #d
addi a4,zero,18 #e
addi a5,zero,-3 #f
#easier to do our parethese seprately to be held temporarily in order to not effect our results in the long run
mul t0 a2,a3
div t1 a0,a2
sub t3 a0,a1
sub t4 a4,a5
#storing our saved equations here to get our final answer which we will store in Z
add s0 t3,t0
add s1 s0,t4
sub s2 s1,t1
#sw our answer
sw s2,Var_Z,t6

#test
