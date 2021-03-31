;   Programmer:     Jonah C. Edick
;   Due:            02/19/2021
;   Description:    This program is designed to process drawer descrepencies
;                   for a business and give back a total amount for all of
;                   the employees for the week. This program utilizes double
;                   words and loops to perform its tasks.

.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

.data

    ;load employee data
    employeeCounts1  sdword 8,10,14,-14,0
    employeeShifts1  dword  ($-employeeCounts1)/type employeeCounts1
    
    employeeCounts2  sdword -16,9
    employeeShifts2  dword  ($-employeeCounts2)/type employeeCounts2

    employeeCounts3  sdword 10,-9,13
    employeeShifts3  dword lengthof employeeCounts3

    employeeCounts4  sdword -8
    employeeShifts4  dword lengthof employeeCounts4

    employeeDesc     sdword 4 dup(?)    ;each employee descrepincy
    employeeDescNum  dword  lengthof employeeDesc
    totalDesc        sdword ?           ;total drawer descrepincy


.code
main proc

;Process Each Employee Count

    ;Tally Employee One Descrepincy

    ;Tally Employee One Descrepincy
    mov edi, offset employeeCounts1 ;loads first employee first count
    mov ecx, employeeShifts1        ;loads number of shifts
    mov eax, 0                      ;sets the initial total to 0

    lpemp1:

    mov ebx, [edi]
    add eax, ebx

    add edi, type employeeShifts1

    loop lpemp1

    mov employeeDesc, eax ;loads descrepincy into apropriate slot

    ;Tally Employee Two Descrepincy
    mov edi, offset employeeCounts2 ;loads first employee first count
    mov ecx, employeeShifts2        ;loads number of shifts
    mov eax, 0                      ;sets the initial total to 0

    lpemp2:

    mov ebx, [edi]
    add eax, ebx

    add edi, type employeeShifts2

    loop lpemp2

    mov [employeeDesc + 4], eax ;loads descrepincy into apropriate slot

    ;Tally Employee Three Descrepincy
    mov edi, offset employeeCounts3 ;loads first employee first count
    mov ecx, employeeShifts3        ;loads number of shifts
    mov eax, 0                      ;sets the initial total to 0

    lpemp3:

    mov ebx, [edi]
    add eax, ebx

    add edi, type employeeShifts3

    loop lpemp3

    mov [employeeDesc + 8], eax ;loads descrepincy into apropriate slot

    ;Tally Employee Four Descrepincy
    mov edi, offset employeeCounts4 ;loads first employee first count
    mov ecx, employeeShifts4        ;loads number of shifts
    mov eax, 0                      ;sets the initial total to 0

    lpemp4:

    mov ebx, [edi]
    add eax, ebx

    add edi, type employeeShifts4

    loop lpemp4

    mov [employeeDesc + 12], eax ;loads descrepincy into apropriate slot

    mov edi, offset employeeDesc
    mov ecx, employeeDescNum
    mov eax, 0

    lptotals:

    mov ebx, [edi]
    add eax, ebx

    add edi, type employeeDescNum

    loop lptotals

    mov totalDesc, eax

    invoke ExitProcess, 0

main endp


end main