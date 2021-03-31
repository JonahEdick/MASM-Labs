;   Programmer: Jonah C. Edick
;   Due:        02/26/2021
;   Description: This program is designed to produce an invoice for a shovel shipping company 
;                that has 4 different size boxes and a set price on their shovels.
;                The program calculates how many boxes are required and produces an invoice
;                for the customer.

.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword

.data
    
    ;Set Box Elements
        ;Set Box Capacities
        boxCapacities   word    20,15,20,5,1

        ;Set Box Shipping Costs
        boxCosts        word    1900,1575,1150,0625,0135

    ;Set Shovel Price
    shovelPrice     word    0425

;Set Calculated Outcomes
numBoxesReturned    word    5 dup(?)
boxShipCost         word    5 dup(?)
productCost         word    5 dup(?)

numShovelsRemaining word    ?

subTotals           word    2 dup(?)
totalBill           word    ?
totalConvertedBill  word    2 dup(?)


shovelsRequested    word    52


.code

    main proc

    ;Calculate Box Cost
        ;Calculate Number of Boxes Needed
            ;Extra Large Box
        mov ax, shovelsRequested
        mov bx, boxCapacities
        mov dx, 0
        div bx
        mov numBoxesReturned, ax
        mov numShovelsRemaining, dx

            ;Large Box
        mov ax, numShovelsRemaining
        mov bx, [boxCapacities + 2]
        mov dx, 0
        div bx
        mov [numBoxesReturned + 2], ax
        mov numShovelsRemaining, dx

            ;Medium Box
        mov ax, numShovelsRemaining
        mov bx, [boxCapacities + 4]
        mov dx, 0
        div bx
        mov [numBoxesReturned + 4], ax
        mov numShovelsRemaining, dx

            ;Small Box
        mov ax, numShovelsRemaining
        mov bx, [boxCapacities + 6]
        mov dx, 0
        div bx
        mov [numBoxesReturned + 6], ax
        mov numShovelsRemaining, dx

            ;Extra Small Box
        mov ax, numShovelsRemaining
        mov bx, [boxCapacities + 8]
        mov dx, 0
        div bx
        mov [numBoxesReturned + 8], ax
        mov numShovelsRemaining, dx

        ;Calculate Box Prices
            ;Extra Large Box
        mov ax, numBoxesReturned
        mov bx, boxCosts
        mul bx
        mov boxShipCost, ax

        mov ax, numBoxesReturned
        mov bx, boxCapacities
        mul bx
        mov bx, shovelPrice
        mul bx
        mov productCost, ax
            
            ;Large Box
        mov ax, [numBoxesReturned + 2]
        mov bx, [boxCosts + 2]
        mul bx
        mov [boxShipCost + 2], ax

        mov ax, [numBoxesReturned + 2]
        mov bx, [boxCapacities + 2]
        mul bx
        mov bx, shovelPrice
        mul bx
        mov [productCost + 2], ax

            ;Medium Box
        mov ax, [numBoxesReturned + 4]
        mov bx, [boxCosts + 4]
        mul bx
        mov [boxShipCost + 4], ax

        mov ax, [numBoxesReturned + 4]
        mov bx, [boxCapacities + 4]
        mul bx
        mov bx, shovelPrice
        mul bx
        mov [productCost + 4], ax

            ;Small Box
        mov ax, [numBoxesReturned + 6]
        mov bx, [boxCosts + 6]
        mul bx
        mov [boxShipCost + 6], ax

        mov ax, [numBoxesReturned + 6]
        mov bx, [boxCapacities + 6]
        mul bx
        mov bx, shovelPrice
        mul bx
        mov [productCost + 6], ax

            ;Extra Small Box
        mov ax, [numBoxesReturned + 8]
        mov bx, [boxCosts + 8]
        mul bx
        mov [boxShipCost + 8], ax

        mov ax, [numBoxesReturned + 8]
        mov bx, [boxCapacities + 8]
        mul bx
        mov bx, shovelPrice
        mul bx
        mov [productCost + 8], ax

    ;Calculate
        ;Calculate Subtotals
            ;Case Shipping Subtoatls
        mov ax, boxShipCost
        add ax, [boxShipCost + 2]
        add ax, [boxShipCost + 4]
        add ax, [boxShipCost + 6]
        add ax, [boxShipCost + 8]
        mov subTotals, ax

            ;Shovel Product Cost
        mov ax, productCost
        add ax, [productCost + 2]
        add ax, [productCost + 4]
        add ax, [productCost + 6]
        add ax, [productCost + 8]
        mov [subTotals + 2], ax

        ;Calculate Total Bill
        mov ax, subTotals
        add ax, [subTotals +2]
        mov totalBill, ax

        ;Convert Total Bill
        mov ax, totalBill
        mov bx, 100
        mov dx, 0
        div bx
        mov totalConvertedBill, ax
        mov [totalConvertedBill + 2], dx

    invoke ExitProcess, 0

    main endp

end main