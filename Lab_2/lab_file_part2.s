# Working with variables in memory

    .data   # Data declaration section

varA:   .word   10
varB:   .word   15
varC:   .word   6
varZ:   .word   0

    .text

main:       # Start of code section

	lw  a0, varA # Load A
	lw  a1, varB # Load B
	lw  a2, varC # Load C
	lw  a3, varZ # Load Z
	
	addi ra, zero, 5
	
	slt t0, a0, a1 # A < B
	slt t1, ra, a2 # C > 5
	and s0, t0, t1 # (A < B) && (C > 5)
	
	# If Statenent
	beq s0, zero, ElseIf # if ((A < B) && (C > 5))
	addi a3, zero, 1 # Z = 1
	j Exit
	
	# Else if statement
ElseIf: slt s1, a1, a0 # A < B
	addi t5, a2, 1 # (C+1)
	addi t5, t5, -7 # (C+1)-7
	beq a2, zero, trueCheck # (C+1)-7 == 0 (if conditional is true)
	beq s1, zero, trueCheck # checks if (A < B) is true
	
	# This is the Else statement
	addi a3, zero, 3 # Z = 3
	j Exit
	
trueCheck: addi a3, zero, 2 # Z = 2
	j Exit
	
Exit:	addi sp, zero, 1
	addi gp, zero, 2
	addi tp, zero, 3
	
	# Switch case
	beq a3, sp, case1
	beq a3, gp, case2
	beq a3, tp, case3
	addi a3, zero, 0
	j Leave
	
case1:	addi a3, zero, -1
	j Leave
case2:	addi a3, zero, -2
	j Leave
case3:	addi a3, zero, -3
	j Leave
Leave:	sw a3, varZ, t6 # assign varZ to final result in register s2

	

# END OF PROGRAM
