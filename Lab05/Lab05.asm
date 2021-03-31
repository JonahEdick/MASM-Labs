;   Programmer:     Jonah C. Edick
;   Due:            03/12/2021
;   Description:    This program is designed to take an orriginal array of times and a given employee rate
;					and calculate the dues for each customer, the total due, the average due, and the average
;					times. This also converts everything to a Hours, Minutes (decimal and actual), Dollars,
;					and Cents

.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

.data

;Set Employee Data

     custOTm     dword   105, 10, 82, 150, 60    ;Hours for each Client
     custDue     dword   lengthof custOTm dup(?) ;Amounts Due for each Client
     custHrs     dword   lengthof custOTm dup(?) ;Converted Hours for each Client
     custMinD	  dword   lengthof custOTm dup(?) ;Converted Minutes Decimal
     custMinS	  dword   lengthof custOTm dup(?) ;Converted Minutes Minutes
     dolsDue     dword   lengthof custOTm dup(?) ;Dollars Due for each Client
     censDue     dword   lengthof custOTm dup(?) ;Cents Due
	
	
     totDue	dword	?
	totTime	dword	?
	totCMinsD	dword	?
	totCMinsM	dword	?
	totCDols	dword	?
	totCCens	dword	?
	totCTime	dword	?
	
	
	avgHrs      dword   ?
     avgMinD     dword   ?
	avgMinM     dword   ?
     avgDol      dword   ?
     avgCen      dword   ?

     empHrRt     dword   2200                    ;Employee hourly rate

.code
main proc

;Calculate Amounts Due
    mov edi, offset custOTm
    mov esi, offset custDue
    mov ecx, lengthof custOTm
    mov ebx, empHrRt

    call CalculateAmountsDue

;Calculate Totals

;Calculate Total Hours
    mov edi, offset custOTm
    mov ecx, lengthof custOTm
    mov edx, type custOTm

    call CalculateTotal

    mov totTime, eax

;CalculateTotalDue
    mov edi, offset custDue
    mov ecx, lengthof custDue
    mov edx, type custDue

    call CalculateTotal

    mov totDue, eax

;Convert
	;Convert Total Hours
	
	mov edi, offset custOTm
	mov ecx, type	custOTm
	mov esi, offset	custHrs
	
	mlp1: 
	
	mov eax, [edi]
	mov ebx, 10
	
	call Convert
	
	mov [esi], eax
	
	add edi, type custOTm
	add	esi, type custHrs
	
	
	loop mlp1
	
	mov eax, totTime
	mov ebx, 10
	
	call Convert
	
	mov totCTime, eax
	
	;Convert Total Minutes Decimal

	mov edi, offset custOTm
	mov ecx, type	custOTm
	mov esi, offset	custMinD
	
	mlp2: 
	
	mov eax, [edi]
	mov ebx, 10
	
	call Convert
	
	mov [esi], edx
	
	add edi, type custOTm
	add	esi, type custMinD
	
	loop mlp2
	
	mov eax, totTime
	mov ebx, 10
	
	call Convert
	
	mov totCMinsD, edx
	
	;Convert Total Minutes Mimutes

	mov edi, offset custOTm
	mov ecx, type	 custOTm
	mov esi, offset custMinS
	
	mlp3: 
	
	mov eax, [edi]
	mov ebx, 60
	mul ebx
	
	mov ebx, 100
	
	call Convert
	
	mov [esi], edx
	
	add edi, type custOTm
	add	esi, type custMinS
	
	loop mlp3
	
	mov eax, totTime
	mov ebx, 60
	mul ebx
	
	mov ebx, 100
	
	call Convert
	
	mov totCMinsM, edx

	;Convert Total Dollars
	
	mov edi, offset custDue
	mov ecx, type	custDue
	mov esi, offset	dolsDue
	
	mlp4: 
	
	mov eax, [edi]
	div ebx
	mov ebx, 1000
	
	call Convert
	
	mov [esi], eax
	
	add edi, type custDue
	add	esi, type dolsDue

	loop mlp4
	
	mov eax, totDue
	mov ebx, 1000
	
	call Convert
	
	mov totCDols, eax
	
	;Convert Total Cents
	
	mov edi, offset custDue
	mov ecx, type	custDue
	mov esi, offset	censDue
	
	mlp5:
	
	mov eax, [edi]
	div ebx
	mov ebx, 1000
	
	call Convert
	
	mov [esi], edx
	
	add edi, type custDue
	add	esi, type censDue
	
	loop mlp5
	
	mov eax, totDue
	mov ebx, 1000
	
	call Convert
	
	mov totCCens, edx

;Calculate Averages
	;Calculate Average Hours
	
	mov eax, totCTime
	mov ebx, lengthof custOTm
	
	call CalculateAverage
	
	mov avgHrs, eax
	
	;Calculate Average Minutes Decimal
	
	mov eax, totCMinsD
	mov ebx, lengthof custOTm
	
	call CalculateAverage
	
	mov avgMinD, eax
	
	;Calculate Average Minutes Minutes
	
	mov eax, totCMinsM
	mov ebx, lengthof custOTm
	
	call CalculateAverage
	
	mov avgMinM, eax
	
	;Calculate Average Dollars
	
	mov eax, totCDols
	mov ebx, lengthof custDue
	
	call CalculateAverage
	
	mov avgDol, eax
	
	;Calculate Average Dollars
	
	mov eax, totCCens
	mov ebx, lengthof custDue
	
	call CalculateAverage
	
	mov avgCen, eax

    invoke ExitProcess,0

main endp

CalculateAmountsDue proc

    lp1:

    mov eax, [edi]
    mul ebx
    mov [esi], eax
    add edi, type custOTm
    add esi, type custDue
    
    loop lp1

    ret
CalculateAmountsDue endp

CalculateTotal proc

    mov eax, 0

    lp2:

    mov ebx, [edi]
    add eax, ebx
    add edi, edx

    loop lp2

    ret
CalculateTotal endp

CalculateAverage proc

    mov edx, 0
    div ebx

    ret
CalculateAverage endp

Convert proc

    mov edx, 0
    div ebx

    ret
Convert endp

end main