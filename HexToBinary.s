/*
ARM Assembly Program that converts Hex to Binary, and prints both
*/


// Store the hexadecimal values in an array
// Create a loop to process each hexadeicmal value:
	// print the hexadecimal value
		//Process each bit of the hexadecimal value
		//Shift the most significant bit into the carry flag
		//Check the carry flag to determine whether to print a 0 or a 1
		//Repeat for all 32 bits
//Move to the next hexadecimal value in the array


.data

formatString:	.ASCIZ "Hex: \t%#010X\t Binary:\t"
newlineString:	.ASCIZ	"\n"

hex:			.WORD	0x12345678, 0xFEDCBA98, 0x01010101, 0x6d6d6d6d, 0xCAFEFEED, 0x8BADF00D, 0xFFFFFFFF, 0x00000000


.TEXT
.GLOBAL main



main:
		SUB		SP,	SP, #20
		STR		LR,	[SP, #16]
		STR		R4,	[SP, #12]
		STR		R5,	[SP, #8]
		STR		R6,	[SP, #4]
		STR		R7,	[SP, #0]
		
		LDR 	R0, = newlineString
		BL 		printf
		
		LDR		R5, = hex
		
		MOV		R4, #0				// counter for outer loop
		
		
outer_loop:
		
		LDR		R6, [R5, R4, LSL #2]
		LDR		R0, = formatString
		MOV		R1, R6
		BL		printf
		
		MOV		R7, #32 			// counter for inner loop

inner_loop:
		LSLS		R6, R6, #1
		BCS		print_one

/* print_zero */
		MOV		R0, #'0'
		BL		putchar
		B		  continue
		
print_one:
		MOV		R0, #'1'
		BL		putchar

continue:
		SUBS	R7, R7, #1
		BNE		inner_loop
		
		LDR		R0, = newlineString
		BL		printf
		
		ADD		R4, R4, #1
		CMP		R4,	#8
		BNE		outer_loop
				
				
exit:
		LDR		R7,	[SP, #0]
		LDR		R6,	[SP, #4]
		LDR		R5,	[SP, #8]
		LDR		R4,	[SP, #12]
		LDR		LR,	[SP, #16]
		ADD		SP,	SP, #20

		MOV		R0, #0
		BX		LR
		 
	
