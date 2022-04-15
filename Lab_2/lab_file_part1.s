# UNTITLED PROGRAM

	.data		# Data declaration section
	
varZ:	.word	0

	.text

main:			# Start of code section
	
	
	addi a0, zero, 15 # int A = 15
	addi a1, zero, 10 # int B = 10
	addi a2, zero, 5 # int C = 5
	addi a3, zero, 2 # int D = 2
	addi a4, zero, 18 # int E = 18
	addi a5, zero, -3 # int F = -3
	
	sub t0, a0, a1 # A-B
	mul t1, a2, a3 # C*D
	sub t2, a4, a5 # E-F
	div t3, a0, a2 # A/C
	
	add s0, t0, t1 # (A-B) + (C*D)
	add s1, s0, t2 # ((A_B) + (C*D)) + (E-F)
	sub s2, s1, t3 # (((A_B) + (C*D)) + (E-F)) - (A/C)
	
	sw s2, varZ, t6 # assign varZ to final result in register s2
	
# END OF PROGRAM
