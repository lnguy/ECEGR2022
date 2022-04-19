.data

intA: .word 0
intB: .word 0
intC: .word 0

.text

main:
	addi t0, zero, 5
	addi t1, zero, 10
	
	addi sp, sp, -8
	sw t0, 4(sp)
	sw t1, 0(sp)
	
	add a0, zero, t0
	jal AddItUp
	sw t1, intA, s0
	
	lw t1, 0(sp)
	add a0, zero, t1
	jal AddItUp
	sw t1, intB, s0
	
	addi sp, sp, 8
	
	lw t0, intA
	lw t1, intB
	add t2, t0, t1
	sw t2, intC, s0
	
	li		a7,10			# system call for an exit
	ecall
	
AddItUp:
	add t0, zero, zero
	add t1, zero, zero
	
for:	slt t6, t0, a0
	beq t6, zero, leaveFor
	addi t2, t0, 1
	add t1, t1, t2
	addi t0, t0, 1
	j for

leaveFor:
	ret