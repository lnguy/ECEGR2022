# UNTITLED PROGRAM

	.data		# Data declaration section
	
varZ:	.word	2
varI:	.word	0

	.text

main:			# Start of code section
	
	
	lw  ra, varZ # Load Z
	lw sp, varI # int i = 0
	
for:	slti s11, sp, 21 # s11 = 1 when i < 21 which is the same as i <= 20
	beq s11, zero, leaveFor
	addi ra, ra, 1 # Z++
	addi sp, sp, 2 # i = i + 2
	j for
	
leaveFor:

doWhile:
	addi ra, ra, 1 # Z++
	slti s11, ra, 100
	beq s11, zero, leaveDo
	j doWhile

leaveDo:
	
while:	slt s11, zero, sp
	beq s11, zero, leaveWhile
	addi ra, ra, -1
	addi sp, sp, -1
	j while
	
leaveWhile:
	sw ra, varZ, t6 # assign varZ to final result in register s2
	
# END OF PROGRAM
