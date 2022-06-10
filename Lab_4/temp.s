	.data
begn:	.asciz	"Enter a temperature in Fahrenheit: "
Cel:	.asciz	"Converted to Celcius: "
Kel:	.asciz	"Converted to Kelvin: "
newln:	.asciz	"\r\n"
Var1:	.float 32.0
Var2:	.float 5.0
Var3:	.float 9.0
Var4:	.float 273.15
	.text
main:
	li	a7, 4			#system call for print string
	la	a0, begn
	ecall
	li	a7, 6
	ecall
	
	fmv.s	fa1, fa0
	
	jal	tempConv
	
	li	a7, 10		#system call for an exit
	ecall

tempConv:
	flw	ft0, Var1, t0
	flw	ft1, Var2, t0
	flw	ft2, Var3, t0
	flw	ft3, Var4, t0
	
	fsub.s	ft4, fa1, ft0		# input - 32.0
	fmul.s	ft4, ft4, ft1		# (input - 32.0) * 5
	fdiv.s	ft4, ft4, ft2		# ((input - 32.0) * 5) * 9
	fadd.s	ft5, ft4, ft3		# - 273.15
	
	
	li	a7, 4
	la	a0, Cel
	ecall
	
	li	a7, 2
	fmv.s	fa0, ft4
	ecall
	
	li	a7,4			#system call for print string
	la	a0,newln
	ecall
	
	li	a7, 4
	la	a0, Kel
	ecall
	
	li	a7, 2
	fmv.s	fa0, ft5
	ecall
	
	li	a7,4			#system call for print string
	la	a0,newln
	ecall
	
	ret