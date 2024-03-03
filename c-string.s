@ c-string.s
@ Jayden Lee

.DATA

promptSTR:			    .STRING	"Enter a string: "
newLineSTR:			    .STRING	"\n"
outputMessage:	    .STRING	"The string is: \"%s\" \n"
countMessage:		    .STRING	"There are %d characters in: \"%s\". \n"
countVowelsMessage:	.STRING	"There are %d vowels in \"%s\". \n"
firstUpperMessage:	.STRING	"Upper case first character of each word: \"%s\". \n"
shoutingMessage:	  .STRING	"Shouting: \"%s\". \n"
extraSpacesMessage:	.STRING	"Extra spaces removed: \"%s\". \n"


.SET	BUFFER_SIZE, 100
inputBuffer:		.SKIP	BUFFER_SIZE+1


.TEXT
.GLOBAL	main


main:
		STMDB		SP!, {FP, LR}
		MOV			FP,	 SP
				
		LDR			R0,	=promptSTR
		BL			printf		

		LDR			R0,	=inputBuffer
		MOV			R1,	#BUFFER_SIZE
		
		BL			getline
		
		LDR			R0,	=outputMessage
		LDR			R1,	=inputBuffer
		BL			printf
		
		LDR			R0,	=inputBuffer
		BL			countCharacters
		
		MOV			R1,	R0
		LDR			R0, =countMessage
		
		LDR			R2, =inputBuffer
		BL			printf
		
		LDR			R0,	=inputBuffer
		BL			countVowels
		
		MOV			R1,	R0
		LDR			R0, =countVowelsMessage
		LDR			R2, =inputBuffer
		BL			printf
		
		LDR			R0,	=inputBuffer
		BL			firstUpper
		
		LDR			R0, =firstUpperMessage
		LDR			R1, =inputBuffer
		BL			printf		
		
		LDR			R0,	=inputBuffer
		BL			shout
		
		LDR			R0, =shoutingMessage
		LDR			R1, =inputBuffer
		BL			printf
		
		LDR			R0,	=inputBuffer
		BL			removeExtraSpaces
		
		LDR			R0, =extraSpacesMessage
		LDR			R1, =inputBuffer
		BL			printf
		
		
		
	exit:

		LDMIA		SP!, {FP, LR}

		MOV			R0, #0
		BX			LR




getline:
//**************************************************
// Description: A function that reads user input string
// INPUT:
//		R0 is the address of the start of the string
//		R1 is the maximum length of the string
// OUTPUT:
//		None
//**************************************************
		STMDB		SP!, {FP, LR}
		MOV			FP,	 SP
		STMDB		SP!, {R4, R5}
		
		MOV			R4,	R0
		MOV			R5,	R1
		
	read:

		BL			getchar
		CMP			R0,	#'\n'
		BEQ			readDone
		STRB		R0,	[R4]
		ADD			R4,	R4,	#1
		SUBS		R5,	R5, #1
		BNE			read
				

	readDone:
		MOV			R12, #0
		STRB		R12, [R4, R5]
		
		LDMIA		SP!, {R4, R5}
		LDMIA		SP!, {FP, LR}
		BX			LR


countCharacters:
//**************************************************
// Description: A function that counts the number of characters in a given string
// INPUT:
//		R0 is the address of the start of the string
// OUTPUT:
//		R0 is the count of characters
//**************************************************
		STMDB		SP!, {FP, LR}
		MOV			FP,	 SP	

		MOV			R1, R0
		MOV			R0, #0
	countCharactersLoop:
		LDRB		R2, [R1]
		CMP			R2, #0
		BEQ			countCharactersDone
		ADD			R0, R0, #1
		ADD			R1, R1, #1
		B			  countCharactersLoop
	countCharactersDone:
		LDMIA		SP!, {FP, LR}
		BX			LR


toUpper:
//**************************************************
// Description: A function that capitalizes the given character
// INPUT:
//		R0 is a character
// OUTPUT:
//		R0 is the uppercased character
//**************************************************
		CMP			R0,	#'a'
		BXLO		LR
		
		CMP			R0,	#'z'
		BXHS		LR
		
		AND			R0,	R0,	#0B11011111
		BX			LR
		
		
countVowels:
//**************************************************
// Description: A function that counts the number of vowels in a given string
// INPUT:
//		R0 is the address of the start of the string
// OUTPUT:
//		R0 is the count of characters
//**************************************************
		STMDB		SP!, {FP, LR}
		MOV			FP,	 SP			
		STMDB		SP!, {R4, R5}
		
		MOV			R4, R0
		MOV			R5,	#0
		
	countVowelsLoop:
		LDRB		R0, [R4, #1]
		CMP			R0, #0
		BEQ			countVowelsDone
		
		BL			toUpper
		
		CMP			R0,	#'A'
		BEQ			increment
		
		CMP			R0,	#'E'
		BEQ			increment
		
		CMP			R0,	#'I'
		BEQ			increment
		
		CMP			R0,	#'O'
		BEQ			increment
		
		CMP			R0,	#'U'
		BEQ			increment
		
		ADD			R4,	R4,	#1
		B			  countVowelsLoop
		
	increment:
		ADD			R4, R4, #1
		ADD			R5, R5, #1
		B			  countVowelsLoop
		
	countVowelsDone:
		MOV			R0,	R5
		
		LDMIA		SP!, {R4, R5}
		LDMIA		SP!, {FP, LR}
		BX			LR


//TODO
firstUpper:
//**************************************************
// Description: A function that capitalizes the first letter of each word in a given string
// Description: 
// INPUT:
//		R0 is the address of the start of the string
// OUTPUT:
//		None
//**************************************************
		
		STMDB		SP!, {FP, LR}
		MOV			FP,	 SP			
		STMDB		SP!, {R4}
		
		MOV			R4,	R0
		LDRB		R0,	[R4]
		BL			toUpper
		STRB		R0,	[R4]
		
	firstUpperLoop:
		ADD			R4,	R4,	#1
		LDRB		R0,	[R4]
		
		CMP			R0,	#' '
		BEQ			firstUpperToUpper
		
		CMP			R0,	#0
		BEQ			firstUpperExit
		
		B			  firstUpperLoop		
	
	firstUpperToUpper:
		ADD			R4,	R4, #1
		LDRB		R0,	[R4]
		
		// Optional CMP & BEQ. Keeps looping if there are consequtive spaces
		//CMP			R0,	#' '				
		//BEQ			firstUpperToUpper
		
		BL			toUpper
		STRB		R0,	[R4]
		B			  firstUpperLoop
		
	firstUpperExit:
		LDMIA		SP!, {R4}
		LDMIA		SP!, {FP, LR}
		
		BX			LR
		
shout:
//**************************************************
// Description: A function that capitalizes the given string
// INPUT:
//		R0 is the address of the start of the string
// OUTPUT:
//		None
//**************************************************

		STMDB		SP!, {FP, LR}
		MOV			FP,	 SP
		STMDB		SP!, {R4}
		
		MOV			R4, R0
		
	shoutLoop:
		LDRB		R0,	[R4]
		CMP			R0,	#0
		BEQ			shoutDone
		BL			toUpper
		STRB		R0,	[R4]
		ADD			R4,	R4,	#1
		B			  shoutLoop
	
	shoutDone:
		LDMIA		SP!, {R4}
		LDMIA		SP!, {FP, LR}
		BX			LR		

//TODO
removeExtraSpaces:
//**************************************************
// Description: A function that removes extra spaces
// INPUT:
//		R0 is the address of the start of the string
// OUTPUT:
//		None
//**************************************************
        STMDB   SP!, {FP, LR}
        MOV     FP,  SP
        STMDB   SP!, {R4, R5}
    
        MOV     R4,  R0  // reading pointer
        MOV     R5,  R0  // writing pointer

    extraSpaceLoop:
        LDRB    R0, [R4]
        ADD		  R4,	R4,	#1
        
        CMP     R0, #' '
        BEQ     checkNextChar

        CMP     R0, #0
        BEQ     extraSpaceExit 

        STRB    R0, [R5]
        ADD		  R5,	R5,	#1
        B       extraSpaceLoop

    checkNextChar:
        LDRB    R1, [R4]
        CMP     R1, #' '
        BEQ     extraSpaceLoop

        STRB    R0, [R5]
        ADD		R5,	R5,	#1
        B       extraSpaceLoop

    extraSpaceExit:
        MOV     R0, #0
        STRB    R0, [R5]

        LDMIA   SP!, {R4, R5}
        LDMIA   SP!, {FP, LR}
		    BX			LR
