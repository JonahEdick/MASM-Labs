;Developer:		Jonah C. Edick
;Due Date:		04/22/2021
;Assignment:	Lab09
;Description:	This ASM Solution is designed to take in a number of transaction from the user and
;				proceeds to have the user fill out the date, description, and amount for each transaction.
;				They also enter their initial starting amount for the user. After the user enters all
;				necesarry information, it displays a report for each transaction as well as how that transaction
;				afftected the total outcome.

include Irvine32.inc

.data

;User Generated Data - Data that is either entered from the user or calculated from the user's inputs.
	dateWidth 	=		11
	descWidth 	=		80
	dates 		byte 	20*dateWidth 	dup(?)
	tempDate 	byte	dateWidth		dup(?)
	descript	byte	20*descWidth	dup(?)
	tempDesc	byte	descWidth		dup(?)
	transAmt	sdword	20				dup(?)
	tempAmt 	sdword						?
	transCode	byte	2				dup(?)
	transCodes	byte	20*2			dup(?)
	startBal	sdword					    ?
	numTrans	dword					    ?
	currBal		sdword						?
	
	
;Promts - Prompts that will be shown to the user either asking for information or displays headings.

	transCodeP	byte	"Select one of the following to perform.",0
	aCodeP 		byte	"(A) ATM Use",0
	bCodeP		byte	"(B) Bank Fee",0
	cCodeP 		byte	"(C) Checks",0
	dCodeP 		byte	"(D) Deposits",0
	qCodeP		byte	"(Q) Quit",0
	userChoiceP byte	"Choice: ",0
	atmP		byte	"ATM Transaction.",0
	bankFeeP	byte	"Bank Fee.",0
	checkP		byte	"Check.",0
	depositP	byte	"Deposit.",0
	startAmtP	byte	"Enter Starting Balance: ",0
	transDteP	byte	"Enter Transaction Date: ",0
	transAmtP	byte	"Enter Transaction Amount(In Pennies): ",0
	transDscP	byte	"Enter Transaction Description: ",0
	startBalP	byte	"Starting Balance: ",0
	codeP		byte	"Transaction Code: ",0
	dateP		byte	"Date: ",0
	descP		byte	"Description: ",0
	amtP		byte	"Amount: ",0
	currBalP	byte	"Current Balance: ",0
	finBalP		byte	"Final Balance: ",0
	headerP		byte	"Checking Account Summary",0
	footerP		byte	"How are your finances???",0
	lineP		byte	"~~~~~~~~~~~~~~~~~~~~~~~~",0
	ZeroErrorP	byte 	"Transaction Entry Denied - Cannot have a value of $0.00",0

.code

main proc

;Get Starting Balance

	Call	GetStartingBalance

;Get Perform Transactions

	Call	PerformTransactions
	
;Display Report

	Call 	DisplayReport
	

Invoke ExitProcess,0

main endp

;Processes

PerformTransactions	proc
	push	eax
	push	edx

	mov		numTrans, 0

	.while(numTrans < 20 && transCode != 'Q' && transCode != 'q')

	mov		eax, 0
	mov		transAmt, eax
	Call 	GetTransCode

	.if(transCode != 'Q' && transCode != 'q')
	   
	    Call 	PerformUserChoice

		.if(tempAmt != 0)

			.if(tempAmt < 0)
				neg		tempAmt
			.endif

			Call UpdateTransLog

		.endif

		.if(tempAmt == 0)
			mov		edx, offset ZeroErrorP
			Call	WriteString
		.endif

	.endif

	.endw

	push	edx
	push	eax

	ret
PerformTransactions endp


UpdateTransLog		proc

	push	eax
	push	ebx
	push	ecx
	push	edx
	push	esi

	;Update Trans Code
	mov		ebx, numTrans

	mov		esi, offset transCodes
	mov		eax, type transCodes
	mul		ebx

	add		esi, eax

	mov		edx, offset transCode

	mov		[esi], edx

	;Update Trans Date
	mov		esi, offset dates
	mov		eax, type dates
	mul		ebx

	add		esi, eax

	mov		edx, offset tempDate

	mov		[esi], edx

	;Update Trans Desc
	mov		esi, offset descript
	mov		eax, type descript
	mul		ebx

	add		esi, eax

	mov		edx, offset tempDesc

	mov		[esi], edx

	;Update Trans Amount
	mov		esi, offset transAmt
	mov		eax, type transAmt
	mul		ebx

	add		esi, eax

	mov		edx, tempAmt

	mov		[esi], eax

	add		ebx, 1
	mov		numTrans, ebx

	pop		esi
	pop		edx
	pop		ecx
	pop		ebx
	pop		eax

	ret
UpdateTransLog		endp


PerformUserChoice	proc
		push	edx


	.if(transCode == 'A' || transCode == 'a')
		mov		edx, offset atmP
		Call	WriteString
		Call	GetDate
		Call	GetDescription
		Call	GetAmount
	.endif

	.if(transCode == 'B' || transCode == 'b')
		mov		edx, offset bankFeeP
		Call	WriteString
		Call	GetDate
		Call	GetDescription
		Call	GetAmount
	.endif

	.if(transCode == 'C' || transCode == 'd')
		mov		edx, offset checkP
		Call	WriteString
		Call	GetDate
		Call	GetDescription
		Call	GetAmount
	.endif

	.if(transCode == 'D' || transCode == 'd')
		mov		edx, offset depositP
		Call	WriteString
		Call	GetDate
		Call	GetDescription
		Call	GetAmount
	.endif

	pop		edx

	ret
PerformUserChoice	endp


GetTransCode		proc
	;Gets numTrans
	push	eax
	push	ecx
	push	edx
	
	mov		edx, offset transCodeP
	Call	WriteString
	Call	CRLF
	
	mov		edx, offset aCodeP
	Call	WriteString
	Call	CRLF

	mov		edx, offset bCodeP
	Call	WriteString
	Call	CRLF

	mov		edx, offset cCodeP
	Call	WriteString
	Call	CRLF

	mov		edx, offset dCodeP
	Call	WriteString
	Call	CRLF

	mov		edx, offset qCodeP
	Call	WriteString
	Call	CRLF

	mov		edx, offset transCode
	mov		ecx, lengthof transCode
	push	eax
	Call	ReadString
	pop		eax
	
	pop		edx
	pop		ecx
	pop		eax
	
	ret
GetTransCode	endp


GetStartingBalance	proc
	
	push	eax
	push	edx

	mov 	edx, offset startAmtP
	Call	WriteString
	Call	ReadDec
	mov		startBal, eax
	mov		currBal, eax

	Call 	CRLF

	pop		edx
	pop		eax
	
	ret
GetStartingBalance	endp


DisplayReport		proc

	Call Clrscr
	Call DisplayHeading
	Call ProcessEachTransaction
	Call DisplayFooter

	ret
DisplayReport		endp


GetDate				proc
	
	push eax
	push ecx
	push edx
	push esi


	mov		edx, offset transDteP
	Call	WriteString
	
	mov		esi, offset tempDate
	mov		edx, esi
	mov		ecx, dateWidth
	Call	ReadString
	mov		esi, edx

	pop 	esi
	pop		edx
	pop		ecx
	pop		eax
	
	ret
GetDate				endp
	

GetDescription		proc

	push 	eax
	push 	ecx
	push 	edx
	push 	esi

	mov		edx, offset transDscP
	Call	WriteString
	
	mov		esi, offset tempDesc
	mov		edx, esi
	mov		ecx, descWidth
	Call	ReadString

	pop 	esi
	pop		edx
	pop		ecx
	pop		eax

	ret
GetDescription		endp


GetAmount			proc

	push eax
	push edx

	mov		edx, offset transAmtP
	Call	WriteString
	
	Call	ReadInt
	mov		tempAmt, eax
	
	Call 	CRLF

	pop		edx
	pop		eax

	ret
GetAmount			endp


DisplayHeading		proc
	push	eax
	push 	edx
	
	mov 	edx, offset headerP
	Call 	WriteString
	Call 	CRLF
	
	mov 	edx, offset lineP
	Call 	WriteString
	Call 	CRLF
	
	mov 	edx, offset startBalP
	Call 	WriteString
	
	mov		eax, startBal
	Call	WriteInt
	
	Call CRLF
	Call CRLF
	
	pop 	edx
	pop		eax
	ret
DisplayHeading		endp


ProcessEachTransaction	proc
	push 	ecx
	
	mov		ecx, numTrans
	
	ProcessLoop:

	Call	ShowCode
	Call	ShowDate
	Call	ShowDescription
	Call	ShowAmount
	Call 	UpdateBalance
	Call	ShowBalance
	
	loop ProcessLoop

	pop		ecx

	ret
ProcessEachTransaction	endp


DisplayFooter			proc
	push 	edx
	
	mov		edx, offset finBalP
	mov		eax, currBal
	Call	WriteString
	Call	WriteInt
	Call	CRLF
	
	mov 	edx, offset lineP
	Call 	WriteString
	Call 	CRLF
	
	mov 	edx, offset footerP
	Call 	WriteString
	Call 	CRLF
	Call 	CRLF
	
	pop 	edx
	ret
DisplayFooter			endp


ShowCode				proc
	push	eax
	push	esi
	push	edx
	push	ecx
	
	mov		edx, offset codeP
	Call	WriteString
	
	mov		esi, offset transCodes
	mov		eax, type transCodes
	mul		ecx
	mov		ecx, 2
	mul		ecx
	
	add		esi, eax
	
	mov		edx, esi
	Call	WriteString
	
	Call	CRLF

	pop		ecx
	pop		edx
	pop		esi
	pop		edx
	ret
ShowCode				endp


ShowDate				proc

	push	eax
	push	esi
	push	edx
	push	ecx
	
	mov		edx, offset dateP
	Call	WriteString
	
	mov		esi, offset dates
	mov		eax, type dates
	mul		ecx
	mov		ecx, dateWidth
	mul		ecx
	
	add		esi, eax
	
	mov		edx, esi
	Call	WriteString
	
	Call	CRLF

	pop		ecx
	pop		edx
	pop		esi
	pop		edx

	ret
ShowDate				endp


ShowDescription			proc
	
	push	eax
	push	esi
	push	edx
	push	ecx
	
	mov		edx, offset descP
	Call	WriteString
	
	mov		esi, offset descript
	mov		eax, type descript
	mul		ecx
	mov		ecx, descWidth
	mul		ecx
	
	add		esi, eax
	
	mov		edx, esi
	Call	WriteString
	
	Call	CRLF

	pop		ecx
	pop		edx
	pop		esi
	pop		edx
	
	ret
ShowDescription			endp


ShowAmount				proc

	push	eax
	push	esi
	push	edx
	push	ecx
	
	mov		edx, offset amtP
	Call	WriteString
	
	mov		esi, offset transAmt
	mov		eax, type transAmt
	mul		ecx
	
	add		esi, eax
	
	mov		eax, [esi]
	Call	WriteInt
	
	Call	CRLF

	pop		ecx
	pop		edx
	pop		esi
	pop		edx
	
	ret
ShowAmount				endp


UpdateBalance			proc

	push	eax
	push	ebx
	push	esi
	push	edi

	mov		esi, offset transCodes
	mov		eax, type	transCodes
	mul		ecx
	add		esi, eax

	mov		edx, [esi]

	
	mov		esi, offset transAmt
	mov		eax, type	transAmt
	mul		ecx
	
	add		esi, eax
	
	mov		eax, [esi]
	mov		ebx, currBal
	
	.if(edx == 'D' || edx == 'd')
	add		eax, ebx
	.endif

	.if(edx != 'D' && edx != 'd')
	sub 	eax, ebx
	.endif

	mov		currBal, eax

	pop		edi
	pop		esi
	pop		ebx
	pop		eax
	
	ret
UpdateBalance			endp


ShowBalance				proc

	push	eax
	push	edx

	mov		edx, offset currBalP
	mov		eax, currBal
	Call	WriteString
	Call	WriteInt
	Call	CRLF
	Call	CRLF
	
	pop		edx
	pop		eax

	ret
ShowBalance				endp


end main