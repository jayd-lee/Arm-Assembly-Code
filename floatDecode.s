@ floatDecode.s
@ Jayden Lee


.DATA

programSTR:		.ASCIZ	"This program will input and decode an IEEE-754 Floating Point Numbers.\nIt will square the nubmer and decode it. Next, if possible, it will take\nthe square root of the number and decode it. This will repeat until the \nuser enters Zero.\n\n"

promptSTR:		.ASCIZ	"Enter the single precision floating point value (0 to exit): "
initialSTR:		.ASCIZ	"The initial vlaue is: "
squareSTR:		.ASCIZ	"The value squared is: "
rootSTR:		.ASCIZ	"The root of the value is: "

fltFMT:			.STRING	"%f"	

printSTR:		.STRING	"%s"

printInitial:		.STRING	"The initial value is:\t  "
printSquare:		.STRING	"The value squared is:\t  "
printRoot:		.STRING	"The root of the value is: "

printSign:		.STRING	"%s1."


negativeSign:		.STRING	"-"
positiveSign:		.STRING	"+"
printE:			.STRING	" E%d\n"



.balign 4
fltInput:		.SKIP	4

.TEXT
.GLOBAL	main



main:

		STMDB			  SP!,	{R4, LR}
		VSTMDB			SP!,	{S16}
		
		LDR			    R0,	=programSTR
		BL			    printf

	prompt:
	
		LDR			    R0,	=promptSTR
		BL			    printf

		LDR			    R0,	=fltFMT
		LDR			    R1, =fltInput
		BL			    scanf
		
		// only load the value once
		LDR			    R4,	=fltInput
		VLDR.F32		S16, [R4]
		
		VMOV.F32		R0, S16
		MOVS			  R0,	R0
		BEQ			    exit
		
		LDR			    R0,	=printInitial
		BL			    printf
		
		VMOV.F32		R0, S16		
		BL			    floatDecode
		
		LDR			    R0,	=printSquare
		BL			    printf
		
		
		VMUL.F32		S0,	S16, S16
		VMOV.F32		R0,	S0
		BL			    floatDecode
		
		VMOV.F32		R0, S16
		MOVS			  R0,	R0
		BMI			    prompt
		
		LDR			    R0,	=printRoot
		BL			    printf

		VSQRT.F32		S0,	S16
		VMOV.F32	  R0,	S0
		BL			    floatDecode

		B			      prompt
		
	exit:
		VLDMIA	SP!,	{S16}
		LDMIA		SP!,	{R4, LR}
		
		MOV			R0,	#0
		BX			LR
		
	
/*
 floatDecode function prints out a normalized binary for an IEEE-764 floating point value
 
 Input R0 = bits for a IEEE single precision floating point value
 
 Output is void/no return value
*/


floatDecode:

		STMDB		SP!,	{R4, R5, R6, LR}
		
		MOVS		R5,	R0
		
		// Seeing if negative by seeing the negative flag set from main
		BMI			negative
		
		LDR			R0, =printSign
		LDR			R1,	=positiveSign
		BL			printf
		B			  continuePrompt
		
	negative:
		LDR			R0, =printSign
		LDR			R1,	=negativeSign
		BL			printf

	continuePrompt:	
	
		// Getting only the exponent to determine the n in E"n"
		LSL			R6,	R5,	#1
		LSR			R6,	#24
		SUB			R6,	R6,	#127
	
	
		// Shift 9 to get fraction bits at the front
		LSLS		R5, R5, #9	

		// counter to print out 23 values
		MOV			R4, #23
		
	inner_loop:
		LSLS		R5, R5, #1
		BCS			print_one


		/* print_zero */
		MOV			R0, #'0'
		BL			putchar
		B			  continue
			
		print_one:
		MOV			R0, #'1'
		BL			putchar
	
	continue:
	
		SUBS		R4, R4, #1
		BNE			inner_loop
		
		LDR			R0,	=printE
		MOV			R1,	R6
		BL			printf
		
		LDMIA		SP!,	{R4, R5, R6, LR}
		BX			LR
