;   Programmer: Jonah C. Edick
;   Due:        02/19/2021
;   Description: This program is designed to calulate an amount of 
;                items 2 boxes can cary based on their volumes.

.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

.data

; Set Dimensions

productW            word 12
productL            word 6
productH            word 10
smallBoxW           word 30
smallBoxL           word 15
smallBoxH           word 25
smallBoxWTotal      word ?
smallBoxLTotal      word ?
smallBoxHTotal      word ?
smallBoxTotal       word ?
largeBoxW           word 50
largeBoxL           word 20
largeBoxH           word 17
largeBoxWTotal      word ?
largeBoxLTotal      word ?
largeBoxHTotal      word ?
largeBoxTotal       word ?

.code
main proc

;   Calculate Box Max Capacity for Each Box

;       Calculate Max Items Per Dimension

;           Calculate Item Width Amount

mov ax, smallBoxW
mov bx, productW
mov dx,0
div bx
mov smallBoxWTotal, ax

;           Calculate Item Length Amount

mov ax, smallBoxL
mov bx, productL
mov dx, 0
div bx
mov smallBoxLTotal, ax

;           Calculate Item Height Amount

mov ax, smallBoxH
mov bx, productH
mov dx, 0
div bx
mov smallBoxHTotal, ax

;       Calculate Total Items

mov ax, smallBoxWTotal
mov bx, smallBoxLTotal
mul bx
mov bx, smallBoxHTotal
mul bx
mov smallBoxTotal, ax

;       Calculate Max Items Per Dimension

;           Calculate Item Width Amount

mov ax, largeBoxW
mov bx, productW
mov dx,0
div bx
mov largeBoxWTotal, ax

;           Calculate Item Length Amount

mov ax, largeBoxL
mov bx, productL
mov dx, 0
div bx
mov largeBoxLTotal, ax

;           Calculate Item Height Amount

mov ax, largeBoxH
mov bx, productH
mov dx, 0
div bx
mov largeBoxHTotal, ax

;       Calculate Total Items

mov ax, largeBoxWTotal
mov bx, largeBoxLTotal
mul bx
mov bx, largeBoxHTotal
mul bx
mov largeBoxTotal, ax


    invoke ExitProcess, 0

main endp


end main