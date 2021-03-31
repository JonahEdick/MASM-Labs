;Developer:		Jonah C. Edick
;Due Date:		03/26/2021
;Assignment:	Lab07
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
	descript	byte	20*descWidth	dup(?)
	transAmt	sdword	20				dup(?)
	startBal	sdword					    ?
	numTrans	dword					    ?
	currBal		sdword						?
	
	
;Promts - Prompts that will be shown to the user either asking for information or displays headings.

	numTransP	byte	 		"Enter Number of Transactions: ",0
	startAmtP	byte		   	 	  "Enter Starting Balance: ",0
	transDteP	byte		   		  "Enter Transaction Date: ",0
	transAmtP	byte	"Enter Transaction Amount(In Pennies): ",0
	transDscP	byte		   "Enter Transaction Description: ",0
	startBalP	byte						"Starting Balance: ",0
	dateP		byte									"Date: ",0
	descP		byte							 "Description: ",0
	amtP		byte								  "Amount: ",0
	currBalP	byte						 "Current Balance: ",0
	finBalP		byte						   "Final Balance: ",0
	headerP		byte				  "Checking Account Summary",0
	footerP		byte				  "How are your finances???",0
	lineP		byte				  "~~~~~~~~~~~~~~~~~~~~~~~~",0
.code

main proc

;Get Number of Entries

	Call	GetNumberofEntries
	
;Get Starting Balance

	Call	GetStartingBalance
	
;Load Each Transaction

	Call	LoadEachTransaction
	
;Display Report

	Call DisplayReport
	

Invoke ExitProcess,0

main endp

;Processes

GetNumberofEntries	proc
	;Gets numTrans
	push	eax
	push	edx
	
	mov		edx, offset numTransP
	Call	WriteString
	Call	ReadDec
	mov		numTrans, eax
	
	pop		edx
	pop		eax
	
	ret
GetNumberofEntries	endp


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


LoadEachTransaction	proc

	mov		ecx, numTrans
	
	LoadLoop:
	
	Call	GetDate
	Call	GetDescription
	Call	GetAmount
	
	loop LoadLoop

	ret
LoadEachTransaction	endp


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
	
	mov		eax, type dates
	mul		ecx
	mov		ecx, dateWidth
	mul		ecx	
	
	mov		esi, offset dates
	add		esi, eax
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

	push eax
	push ecx
	push edx
	push esi

	mov		edx, offset transDscP
	Call	WriteString
	
	mov		eax, type descript
	mul		ecx
	mov		ecx, descWidth
	mul		ecx
	
	mov		esi, offset descript
	add		esi, eax
	mov		edx, esi
	mov		ecx, descWidth
	Call	ReadString
	mov		esi, edx

	pop 	esi
	pop		edx
	pop		ecx
	pop		eax

	ret
GetDescription		endp


GetAmount			proc

	push eax
	push ecx
	push edx
	push esi


	mov		edx, offset transAmtP
	Call	WriteString
	
	mov		eax, type transAmt
	mul		ecx
	
	mov		esi, offset transAmt
	add		esi, eax
	mov		edx, esi
	Call	ReadInt
	mov		[esi], eax
	
	Call 	CRLF

	pop 	esi
	pop		edx
	pop		ecx
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
	
	mov		esi, offset transAmt
	mov		eax, type	transAmt
	mul		ecx
	
	add		esi, eax
	
	mov		eax, [esi]
	mov		ebx, currBal
	
	add		eax, ebx
	
	mov		currBal, eax

	pop		esi
	pop		ebx
	pop		esi
	
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