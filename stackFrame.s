@ stackFrame.s
@ Jayden Lee

.DATA


prompt1STR:		.ASCIZ	"\nEnter the 1st integer (0 to exit): "
prompt2STR:		.ASCIZ	"Enter the 2nd integer: "
prompt3STR:		.ASCIZ	"Enter the 3rd integer: "
prompt4STR:		.ASCIZ	"Enter the 4th integer: "
prompt5STR:		.ASCIZ	"Enter the 5th integer: "
prompt6STR:		.ASCIZ	"Enter the 6th integer: "
resultSTR:		.ASCIZ	"The result is:  %d \n"
callSTR:		  .ASCIZ	"Now Calling:	Add5Subtract1 ( %d, %d, %d, %d, %d, %d);\n"

fltDec:			  .STRING	"%d"

.TEXT
.GLOBAL	main


main:
		STMDB		SP!,	{FP, LR}
		MOV			FP,		SP
		
		SUB			SP, SP, #24
	prompt:
		LDR			R0,	=prompt1STR
		BL			printf
		
		LDR			R0,	=fltDec
		ADD			R1, FP, #-24
		BL			scanf
		
		LDR			R0, [FP, #-24]
		CMP			R0,	#0
		BEQ			exit

		LDR			R0,	=prompt2STR
		BL			printf
		
		LDR			R0,	=fltDec
		ADD			R1, FP, #-20
		BL			scanf
		
		LDR			R0,	=prompt3STR
		BL			printf
		
		LDR			R0,	=fltDec
		ADD			R1, FP, #-16
		BL			scanf
		
		LDR			R0,	=prompt4STR
		BL			printf
		
		LDR			R0,	=fltDec
		ADD			R1, FP, #-12
		BL			scanf
		
		LDR			R0,	=prompt5STR
		BL			printf
		
		LDR			R0,	=fltDec
		ADD			R1, FP, #-8
		BL			scanf
		
		LDR			R0,	=prompt6STR 
		BL			printf
		
		LDR			R0,	=fltDec
		ADD			R1, FP, #-4
		BL			scanf
		
		
		SUB			SP,	SP,	#12
		LDR			R0, =callSTR
		LDR			R1, [FP, #-24]
		LDR			R2, [FP, #-20]
		LDR			R3, [FP, #-16]
		
		LDR			R12, [FP, #-12]
		STR			R12, [SP, #0]
		
		LDR			R12, [FP, #-8]
		STR			R12, [SP, #4]
		
		LDR			R12, [FP, #-4]
		STR			R12, [SP, #8]

		BL			printf
		ADD			SP,	SP,	#12
		
		
		SUB			SP,	SP,	#8
		LDR			R0, [FP, #-24]
		LDR			R1, [FP, #-20]
		LDR			R2, [FP, #-16]
		LDR			R3, [FP, #-12]
		
		LDR			R12, [FP, #-8]
		STR			R12, [SP, #0]
		
		LDR			R12, [FP, #-4]
		STR			R12, [SP, #4]
		
		BL			Add5Subtract1
		ADD			SP,	SP,	#8
		
		
		MOV			R1, R0
		LDR			R0, =resultSTR
		BL			printf
		
		B			  prompt
		
	exit:

		ADD			SP, SP, #24
		LDMIA		SP!,	{FP, LR}

		MOV			R0, #0
		BX			LR



           	
/*
Add5Subtract1 function takes in 6 numbers, adding the first 5 and then subtracting the last 1.
The return value is the result of that arithmetic, stored in R0
*/
Add5Subtract1:
		STMDB		SP!,	{FP, LR}
		MOV			FP,		SP
		
		ADD			R0,	R0, R1
		ADD			R0,	R0,	R2
		ADD			R0,	R0,	R3
		
		LDR			R12, [FP, #8]
		ADD			R0,	R0,	R12
		
		LDR			R12, [FP, #12]
		SUB			R0,	R0,	R12
		
		LDMIA		SP!,	{FP,LR}
		BX			LR
		
		
