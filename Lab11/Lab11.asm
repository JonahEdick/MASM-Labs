;Developer:		Jonah C. Edick
;Due Date:		05/07/2021
;Assignment:	Lab11
;Description:	This Assembly Solution is designed to take an integer from a user
;				and convert it to the base of the users choosing from 2 to 16.
;				This solution allows the user to convert any amount of numbers
;				that they choose. This solution immplements a stack structure to
;				call the same process while passing in different parameters when 
;				retrieving the numbers form the user as well as when the solution
;				displays the result, it implements recursive processing by passing in
;				an updated parameter into the same process until the condition of
;				the recursion is met.

include Irvine32.inc

.data

	userChoice	byte 2  dup(?)
	userNumber	sdword		?	
	userBase 	dword		?

	choicePrompt	byte	"What Would You Like To Do?",0
	cChoicePrompt	byte	"(C)onvert A Number",0
	qChoicePrompt	byte	"(Q)uit",0
	getChoicePrmt	byte	"Choice: ",0
	fixChoicePrmt	byte	"Please Select A Valid Option",0
	numToConPrompt	byte	"Number To Conver: ",0
	baseToConPrompt	byte	"Base To Convert To (2-16): ",0
	convertNumP1	byte	"Converted Number (",0
	convertNumP2	byte	" to base ",0
	convertNumP3	byte	"): ",0
	numAPrompt		byte	"A",0
	numBPrompt		byte	"B",0
	numCPrompt		byte	"C",0
	numDPrompt		byte	"D",0
	numEPrompt		byte	"E",0
	numFPrompt		byte	"F",0

.code
main proc

Call	ConvertNumbers

Invoke ExitProcess,0

main endp

ConvertNumbers proc

	Call	GetUserChoice

	.while(userChoice != "Q" && userChoice != "q")
		Call	PerformUserChoice
		Call 	GetUserChoice
	.endw

	ret
ConvertNumbers endp

GetUserChoice proc

	push	eax
	push	edx
	push	ecx

	mov		edx, offset choicePrompt
	Call	WriteString
	Call	Crlf

	GetChoiceCheck:

	mov		edx, offset cChoicePrompt
	Call	WriteString
	Call	Crlf

	mov		edx, offset qChoicePrompt
	Call	WriteString
	Call	Crlf

	mov		edx, offset getChoicePrmt
	Call	WriteString

	mov		edx, offset userChoice
	mov		ecx, lengthof userChoice
	push	eax
	Call	ReadString
	pop		eax

	Call 	Clrscr

	pop		ecx
	pop		edx
	pop		eax

	ret
GetUserChoice endp

PerformUserChoice proc

	.if(userChoice == "C" || userChoice == "c")

		push	offset userNumber
		push	offset numToConPrompt
		Call	GetNumber
		Call	Crlf

		push	offset userBase
		push	offset baseToConPrompt
		Call	GetNumber
		Call	Crlf

		.while(userBase < 2 || userBase > 16)
			push	offset userBase
			push	offset baseToConPrompt
			Call	GetNumber
		.endw

		Call	Clrscr

		Call	DisplayNumber

		Call	Crlf
		Call	Crlf
		Call	WaitMsg
		Call	Clrscr

	.endif

	ret
PerformUserChoice endp

GetNumber proc
	push	ebp
	mov		ebp, esp

	push	eax
	push	edx
	push	esi

	mov		edx, [ebp + 8]
	Call	WriteString
	Call	ReadInt

	mov		esi,[ebp + 12]
	mov		[esi], eax

	pop		esi
	pop		edx
	pop		eax
	pop		ebp

	ret 	8
GetNumber endp

DisplayNumber proc
	push	eax
	push	edx

	mov		edx, offset convertNumP1
	Call	WriteString

	mov		eax, userNumber
	Call	WriteDec

	mov		edx, offset convertNumP2
	Call	WriteString

	mov		eax, userBase
	Call	WriteDec

	mov		edx, offset convertNumP3
	Call	WriteString

	.if(userNumber == 0)
		mov		eax, userNumber
		Call	WriteDec
	.else
		push	userNumber
		push	userBase
		Call 	ConvertNumber
	.endif

	pop		edx
	pop		eax

	ret
DisplayNumber endp

ConvertNumber proc
	push	ebp
	mov		ebp, esp

	push	eax
	push	ebx
	push	edx

	mov		eax, [ebp + 12]
	mov		ebx, [ebp + 8]
	xor		edx, edx
	div		ebx

	.if(eax != 0)
		push	eax
		push	[ebp + 8]
		Call	ConvertNumber

		push	edx
		Call	DisplayDigit
	.else
		push	edx
		Call	DisplayDigit
	.endif

	pop		edx
	pop		ebx
	pop		eax
	pop		ebp

	ret		8
ConvertNumber endp

DisplayDigit proc
	push	ebp
	mov		ebp, esp

	push	eax
	push	edx

	mov		eax, [ebp + 8]

	.if(eax == 15)
		mov		edx, offset numFPrompt
		Call	WriteString
	.endif

	.if(eax == 14)
		mov		edx, offset numEPrompt
		Call	WriteString
	.endif

	.if(eax == 13)
		mov		edx, offset numDPrompt
		Call	WriteString
	.endif

	.if(eax == 12)
		mov		edx, offset numCPrompt
		Call	WriteString
	.endif

	.if(eax == 11)
		mov		edx, offset numBPrompt
		Call	WriteString
	.endif

	.if(eax == 10)
		mov		edx, offset numAPrompt
		Call	WriteString
	.endif

	.if(eax < 10)
		mov		eax, [ebp + 8]
		Call	WriteDec
	.endif

	pop		edx
	pop		eax
	pop		ebp

	ret		4
DisplayDigit endp

end main