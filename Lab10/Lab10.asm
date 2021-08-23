;Developer:		Jonah C. Edick
;Due Date:		05/03/2021
;Assignment:	Lab10
;Description:	This Assembly Solution is designed to take in any number of Customer Orders and process them
;				to display their order reciept as well as calculate their tax and total bill. This solution
;				utilizes the Stack Structure in order to return different informatioin using a set of
;				parameters that are pushed onto the stack using the same process by utilizing ebp and esp.
;				This solution also error handles any negative numbers and refuses the customer to put 0 for
;				all items in the purchase.

include Irvine32.inc

.data

;User Generated Data - Data that is either entered from the user or calculated from the user's inputs.

	recursionOption	byte	2	dup(?)
	customerName	byte	20	dup(?)
	customerAddress	byte	50	dup(?)
	customerCity	byte	20	dup(?)
	customerState	byte	3	dup(?)
	customerZip		byte	6	dup(?)
	doorAmount		sdword			?
	windowAmount	sdword			?
	hatchAmount		sdword			?
	taxPercent		dword			7
	doorCost		dword			123476
	windowCost		dword			5687
	hatchCost		dword			59543
	
;Promts - Prompts that will be shown to the user either asking for information or displays headings.
	recursionPrompt	byte	"Would You Like To Perform A Sale (Y/N): ",0
	namePrompt		byte	"Enter Your Name: ",0
	addressPrompt	byte	"Enter Your Address: ",0
	cityPrompt		byte	"Enter Your City: ",0
	statePrompt		byte	"Enter Your State (Initials): ",0
	zipPrompt		byte	"Enter Your Zip Code: ",0
	doorPrompt		byte	"Enter Franklin Door Amount: ",0
	windowPrompt	byte	"Enter Window Kit Amount: ",0
	hatchPrompt		byte	"Enter Hatch Kit Amount: ",0
	headerPrompt	byte	"Edick Hardword LLC.",0
	custInfoPrompt	byte	"~Customer Info~",0
	outNamePrompt	byte	"Name: ",0
	outAddPrompt	byte	"Address: ",0
	outCityPrompt	byte	"City: ",0
	outStatePrompt	byte	"State: ",0
	outZipPrompt	byte	"Zip: ",0
	outDoorPrompt	byte	"Franklin Doors: ",0
	outWindowPrompt	byte	"Window Kits: ",0
	outHatchPrompt	byte	"Hatch Kits: ",0
	outTaxPrompt	byte	"Tax: ",0
	outTotalPrompt	byte	"Total: ",0
	dollarSign		byte	"$",0
	atSign			byte	" @ ",0
	decimal			byte	".",0
	lParenthesis	byte	"(",0
	rParenthesis	byte	") ",0

.code

main proc

Call ProcessCustomerSales

Invoke ExitProcess,0

main endp

;Processes

;Proccess Customer Sales
ProcessCustomerSales proc
	
	Call GetRecursionOption

	cmp		recursionOption,"N"
	je		FinishSales

	cmp		recursionOption,"n"
	je		FinishSales

PerformSale:

	;Get Sale Info
	Call 	GetSaleInfo

	;Display Bill
	Call	DisplayBill

	;Get Recursion Option
	Call 	GetRecursionOption

	cmp		recursionOption,"Y"
	je		PerformSale

	cmp		recursionOption,"y"
	je		PerformSale

FinishSales:

	ret
ProcessCustomerSales endp

;Get Sale Info
GetSaleInfo proc
	;Get Customer Information
		;Get Customer Name
		push	offset namePrompt
		push	offset customerName
		push	lengthof customerName
		Call 	GetCustomerInformation

		;Get Customer Address
		push	offset addressPrompt
		push	offset customerAddress
		push	lengthof customerAddress
		Call 	GetCustomerInformation

		;Get Customer City
		push	offset cityPrompt
		push	offset customerCity
		push	lengthof customerCity
		Call 	GetCustomerInformation

		;Get Customer State
		push	offset statePrompt
		push	offset customerState
		push	lengthof customerState
		Call 	GetCustomerInformation

		;Get Customer Zip
		push	offset zipPrompt
		push	offset customerZip
		push	lengthof customerZip
		Call 	GetCustomerInformation

		Call 	Crlf

	;Get Purchase Information
	GetOrderAmounts:
		;Get Franklin Doors Amount
		push	offset doorPrompt
		push	offset doorAmount
		Call	GetPurchaseInformation

		;Get Window Kit Amount
		push	offset windowPrompt
		push	offset windowAmount
		Call	GetPurchaseInformation

		;Get Hatch Kit Amount
		push	offset hatchPrompt
		push	offset hatchAmount
		Call	GetPurchaseInformation

		Call 	Crlf

		cmp		doorAmount, 0
		jne		FinishOrder

		cmp		windowAmount, 0
		jne		FinishOrder

		cmp		hatchAmount, 0
		jne		FinishOrder

		jmp		GetOrderAmounts

	FinishOrder:
		Call Clrscr
	
	ret
GetSaleInfo endp

;Display Bill
DisplayBill proc
	push	eax
	push	ebx
	push	ecx
	push	edx

	;Display Header
	mov		edx, offset headerPrompt
	Call	WriteString
	Call	Crlf
	Call	Crlf

	mov		edx, offset custInfoPrompt
	Call	WriteString
	Call	Crlf

	;Display Customer Information
		;Display Name
		push	offset outNamePrompt
		push	offset customerName
		Call	DisplayCustomerInformation

		;Display Address
		push	offset outAddPrompt
		push	offset customerAddress
		Call	DisplayCustomerInformation

		;Display City
		push	offset outCityPrompt
		push	offset customerCity
		Call	DisplayCustomerInformation

		;Display State
		push	offset outStatePrompt
		push	offset customerState
		Call	DisplayCustomerInformation

		;Display Zip
		push	offset outZipPrompt
		push	offset customerZip
		Call	DisplayCustomerInformation

		Call	Crlf

	;Display Sale Information
		;Display Franklin Doors
		push	offset outDoorPrompt
		push	doorAmount
		push	doorCost
		Call	DisplaySaleInformation

		;Display Window Kits
		push	offset outWindowPrompt
		push	windowAmount
		push	windowCost
		Call	DisplaySaleInformation

		;Display 
		push	offset outHatchPrompt
		push	hatchAmount
		push	hatchCost
		Call	DisplaySaleInformation

	;Display Footer
	;Calculate Amount - Set Start to $0.00
	mov		ebx, 0

	;Add Franklin Doors
	push	doorCost
	push	doorAmount
	Call	CalculateTotal

	;Add Window Kits
	push	windowCost
	push	windowAmount
	Call	CalculateTotal

	;Add Hatch Kits
	push	hatchCost
	push	hatchAmount
	Call	CalculateTotal

	;Display Tax Amount
	Call	DisplayTax

	;Display Total
	Call	DisplayTotal


	Call	Crlf
	Call	Crlf
	Call	WaitMsg
	Call	Clrscr

	pop		edx
	pop		ecx
	pop		ebx
	pop		eax

	ret
DisplayBill endp

;Get Recursion Option
GetRecursionOption proc
	push	ecx
	push	edx

RecursionCheck:

	mov		edx, offset recursionPrompt
	Call	WriteString

	mov		edx, offset recursionOption
	mov		ecx, lengthof recursionOption
	push	eax
	Call	ReadString
	pop		eax

	Call 	Clrscr

	cmp		recursionOption, "Y"
	je		RecusionClear

	cmp		recursionOption, "y"
	je		RecusionClear

	cmp		recursionOption, "N"
	je		RecusionClear

	cmp		recursionOption, "n"
	je		RecusionClear

	jmp		RecursionCheck

RecusionClear:

	pop		edx
	pop		ecx

	ret
GetRecursionOption endp

;Get Customer Information
GetCustomerInformation proc
	push	ebp
	mov		ebp, esp

	push	edx
	push	ecx

	mov		edx, [ebp + 16]
	Call	WriteString

	mov		edx, [ebp + 12]
	mov		ecx, [ebp + 8]
	push	eax
	Call 	ReadString
	pop		eax


	pop		ecx
	pop		edx
	pop		ebp

	ret		12
GetCustomerInformation endp

;Get Purchase Information
GetPurchaseInformation proc

	push	ebp
	mov		ebp, esp
	push	edx
	push	eax
	push	esi

	mov		edx, [ebp + 12]
	Call 	WriteString
	Call	ReadInt

	cmp		eax,0
	jge		AssignValue

	neg		eax

	AssignValue:	
	mov		esi, [ebp + 8]
	mov		[esi], eax

	pop		esi
	pop		eax
	pop		edx
	pop		ebp

	ret		8
GetPurchaseInformation endp

;Display Customer Information
DisplayCustomerInformation proc
	push	ebp
	mov		ebp, esp
	push	edx

	mov		edx, [ebp + 12]
	Call	WriteString

	mov		edx, [ebp + 8]
	Call 	WriteString
	Call	Crlf

	pop		edx
	pop		ebp

	ret		8
DisplayCustomerInformation endp

;Display Sale Information
DisplaySaleInformation proc

	push	ebp
	mov		ebp, esp

	push	eax
	push	ebx
	push	edx

	;Display Title
	mov		edx, [ebp + 16]
	Call	WriteString

	;Display Amount
	mov		eax, [ebp + 12]
	Call	WriteDec

	;Display @ and $
	
	mov		edx, offset atSign
	Call	WriteString

	mov		edx, offset dollarSign
	Call 	WriteString

	;Display Product Cost
	mov		eax, [ebp + 8]
	mov		ebx, 100
	xor		edx, edx
	div		ebx

	Call	WriteDec

	mov		eax, edx

	mov		edx, offset decimal
	Call	WriteString

	Call	RoundChange
	Call	CheckChange
	Call	WriteDec
	Call	Crlf

	;Display Whole Cost
	mov		edx, offset dollarSign
	Call	WriteString

	mov		eax, [ebp + 8]
	mov		ebx, [ebp + 12]
	mul		ebx
	xor		edx, edx
	mov		ebx, 100
	div		ebx

	Call	WriteDec

	mov		eax, edx

	mov		edx, offset decimal
	Call	WriteString

	Call	RoundChange
	Call	CheckChange
	Call 	WriteDec
	Call 	Crlf
	Call	Crlf

	pop		edx
	pop		ebx
	pop		eax
	pop		ebp

	ret		12
DisplaySaleInformation	endp

;Calculate Sub Total
CalculateTotal proc

	push	ebp
	mov		ebp, esp

	push	eax
	push	ecx

	mov		eax, [ebp + 12]
	mov		ecx, [ebp + 8]
	mul		ecx

	add		ebx, eax

	pop		ecx
	pop		eax
	pop		ebp

	ret		8
CalculateTotal endp

;Display Taxes
DisplayTax proc

	push	eax
	push	ecx
	push	edx

	;Tax: 
	mov		edx, offset outTaxPrompt
	Call	WriteString

	;(Tax Decimal)
	mov		edx, offset lParenthesis
	Call	WriteString

	mov		eax, taxPercent
	mov		ecx, 100
	xor		edx, edx
	div		ecx

	Call	WriteDec

	mov		eax, edx

	mov		edx, offset decimal
	Call	WriteString
	Call	WriteDec

	mov		edx, offset rParenthesis
	Call	WriteString

	;Write Tax Amount
	mov		edx, offset	dollarSign
	Call	WriteString

	mov		eax, ebx
	mov		ecx, taxPercent
	mul		ecx

	mov		ecx, 10000
	xor		edx, edx

	div		ecx

	Call	WriteDec

	mov		eax, edx

	mov		edx, offset decimal
	Call	WriteString

	Call	RoundChange
	Call	CheckChange
	Call	WriteDec

	Call	Crlf
	Call	Crlf

	pop		edx
	pop		ecx
	pop		eax
	
	ret		
DisplayTax endp

;Display Total Bill
DisplayTotal proc
	push	ebp
	mov		ebp, esp
	push	eax
	push	ecx
	push	edx

	mov		edx, offset outTotalPrompt
	Call	WriteString

	mov		edx, offset dollarSign
	Call	WriteString

	mov		eax, ebx
	mov		ecx, taxPercent
	add		ecx, 100
	mul		ecx
	mov		ecx, 10000
	xor		edx, edx
	div		ecx

	Call	WriteDec

	mov		eax, edx

	mov		edx, offset decimal
	Call	WriteString

	Call	RoundChange
	Call	CheckChange
	Call	WriteDec

	pop		edx
	pop		ecx
	pop		eax
	pop		ebp

	ret		
DisplayTotal endp

RoundChange proc
	push	ecx
	push	edx

	mov		ecx, 10

	StartRound:
	cmp		eax,100
	jl		EndRound

	xor		edx, edx
	div		ecx

	.if(edx > 4)
		add		eax, 1
	.endif

	jmp		StartRound

	EndRound:

	pop		edx
	pop		ecx

	ret
RoundChange endp

CheckChange proc
	push	eax

	.if(eax < 10)
		mov		eax, 0
		Call	WriteDec
	.endif

	pop		eax

	ret
CheckChange endp

end main