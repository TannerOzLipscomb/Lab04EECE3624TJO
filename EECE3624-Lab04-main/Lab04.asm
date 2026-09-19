/**************************************************************************
 *     File: Lab04.asm
 * Lab Name: 
 *   Author: 
 *  Created: 
 *
 * This program...
 *************************************************************************/ 
 .def n = R16
.def result = R17
.org 0x0000 ; next instruction will be written to address 0x0000
            ; (the location of the reset vector)
rjmp main	; set reset vector to point to the main code entry point

main:       ; jump here on reset

		; initialize the stack (RAMEND = 0x10FF by default for the ATmega128A)
		ldi R16, HIGH(RAMEND)
		out SPH, R16
		ldi R16, low(RAMEND)
		out SPL, R16

		LDI  n, 4	; load a value into n
		PUSH n	; push it on the stack
		CALL factN	; calculate the factorial of n
		POP  result	; pop result off stack
here:
		RJMP here	; loop forever

factN:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Comments regarding the factN subroutine go here
	; This soubroutine computes the factorial of n. n must not be greater than 5.
	; An input greater than 5 will produce an overeflow. The code uses recursion to
	; compute fact(n) = n * fact(n-1). The result of the factorial computation will
	; be placed on the stack in the same location that n is placed prior to calling 
	; factN. Push n onto the stack then call factN and then pop the result of the 
	; stack. This code does not preserve registers R18, R19, R0, or R1. This code 
	; also changes the Y registers. 
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; recursive factorial code begins here
	IN YH, SPH
	IN YL, SPL				; Update Y pointer to SP
	LDD R18, Y+3
	CPI R18, 1				; Chack for base case
	BRNE recursiveCase
	ret						; Base case is fact(1) = 1 but 1 is already on the stack
recursiveCase:
	DEC R18
	PUSH R18				; reduce fact(n) to fact(n-1) and push
	CALL factN
	IN YH, SPH				; Update Y to SP as SP changes
	IN YL, SPL
	POP R18					; Grab fact(n-1)
	LDD R19, Y+4			; Grab n
	MUL R18, R19			; Multiply and store in R0
	STD Y+4, R0				; Place fact(n-1) on the stack before the return address
	ret 
	; return from the factN subroutine
