.data

A_Array:	.word 0, 0, 0, 0, 0
B_Array:	.word 1, 2, 4, 8, 16

.text

main:
	la t0, A_Array # Load A_Array address into register t0
	la t1, B_Array # Load B_Array address into register t1
	
	addi s0, zero, 0  # variable i = 0 in register s0
	addi gp, zero, 4 # temp reg holds 4
	
for:	slti s11, s0, 5 # i < 5
	beq s11, zero, leaveFor
	mul s1, s0, gp # i * 4
	mul s2, s0, gp
	add s1, t1, s1 # address of B[i]
	add s2, t0, s2 # address of A[i]
	lw a0, 0(s1)
	addi a0, a0, -1
	sw a0, 0(s2)
	addi s0, s0, 1
	j for

leaveFor:
	addi s0, s0, -1
	addi s5, zero, -1 # s5 temp holding -1
while:	beq s0, s5, leaveWhile
	mul s1, s0, gp # i * 4
	mul s2, s0, gp
	add s1, t1, s1 # address of B[i]
	add s2, t0, s2 # address of A[i]
	lw a1, 0(s1)
	lw a2, 0(s2)
	add a3, a1, a2
	addi a4, zero, 2
	mul a3, a3, a4
	sw a3, 0(s2)
	addi s0, s0, -1
	j while
	
leaveWhile:
	li  a7,10       #system call for an exit
    	ecall
	