.data

.text
main:
	addi a0, zero, 3
	jal Fibonacci
	mv s0, a0
	
	addi a0, zero, 10
	jal Fibonacci
	mv s1, a0
	
	addi a0, zero, 20
	jal Fibonacci
	mv s2, a0
	
	li a7, 10
	ecall
	
Fibonacci:
	li	t0, 1
	beq	a0, zero, Exit # If n = 0
	beq	a0, t0, Exit # If n = 1
	
	# Else
	addi	sp, sp, -8
	sw	a0, 0(sp)
	sw	ra, 4(sp)
	
	addi	a0, a0, -1
	jal Fibonacci
	
	lw	t1, 0(sp)
	sw	a0, 0(sp)
	
	addi	a0, t1, -2
	jal Fibonacci
	
	lw	t1, 0(sp)
	add	a0, a0, t1
	
	lw	ra, 4(sp)
	addi	sp, sp, 8
	
Exit:
	ret