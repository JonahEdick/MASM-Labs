;Name: 		Jonah C. Edick
;Due Date: 	 04/16/2021
;Assignment: 	 Lab08
;Description: 	 This assembly solution takes inputs from the user (names and transaction amounts)
;		      and stores them into arrays. It also sums the transaction amounts for each person and displays a
;		      report summary to the user. All inputs and outputs use the command prompts. Utilizes processes and
;		      loops to perform processes for each person. This adition to this assembly solution added on conditional
;             error handling so that the user cannot enter an inapropriate input as well as it lets the user input 
;             as many inputs as they desite (to a maximum of 80).

include Irvine32.inc

.data

;User Generated Data - Data that is either entered from the user or calculated from the user's inputs.

    person1Sp	sdword  80  dup(0)  ;Person 1 Transactions, max of 80 Transactions
    person2Sp	sdword  80  dup(0)  ;Person 2 Transactions, max of 80 Transactions
    person1Nm	byte    40  dup(?)	;Person 1 Name, ASCII array with max name size of 40 ASCII characters
    person2Nm	byte    40  dup(?)  ;Person 2 Name, ASCII array with max name size of 40 ASCII characters
    transNums	dword   2   dup(?)  ;Number of Transactions for each Person - Calculated as the user progresses.
    totals      dword   2   dup(?)  ;Total spending for each Person, calcultaed from personSp's
    userChoice  byte    2   dup(?)  ;Used to determine if the user is going to continue adding transactions.

;Promts - Prompts that will be shown to the user either asking for information or displays headings

    zeroMsg        byte "Cannot Enter A $0.00 Transaction.",0
    inputErrorP    byte "Please Put In A Valid Response.",0 
    getUserChoiceP byte "Would you like to input another transaction (Y/N): ",0 ;Prompts the user for another transaction.
    getName1P      byte "Please Enter Name for the First Person: ",0  ;Prompts the user for the first person's name
    getName2P      byte "Please Enter Name for the Second Person: ",0  ;Prompts the user for the first person's name
    transactionP   byte "Transaction ",0
    colon          byte ": ",0
    apostS         byte "'s ",0
    transactionsP  byte "Transactions.",0
    sumHeader      byte "Transaction Summary Report",0
    sumSpacer      byte "~~~~~~~~~~~~~~~~~~~~~~~~~~",0
    nameP          byte "Name: ",0
    totalP         byte "Total Amount Spent: ",0

.code

main proc

;Get User Data

    ;Get User 1 Data & Transactions

        mov     edi, offset person1Nm
        mov     edx, offset getName1p
        Call    WriteString
        Call    GetUserData

        mov     edi, offset person1Sp
        mov     bh, 1

        mov     edx, offset person1Nm
        Call    WriteString
        mov     edx, offset apostS
        Call    WriteString
        mov     edx, offset transactionsP
        Call    WriteString
        Call    Crlf
    
        Call    GetTransactionData

        mov     esi, offset transNums
        mov     [esi], bh
        add     esi, type transNums

        Call Crlf
        Call WaitMsg
        Call Clrscr

    ;Get User 2 Data & Transactions

        mov edi, offset person2Nm
        mov edx, offset getName2p
        Call WriteString
        Call GetUserData

        mov     edi, offset person2Sp
        mov     bh, 1

        mov     edx, offset person2Nm
        Call    WriteString
        mov     edx, offset apostS
        Call    WriteString
        mov     edx, offset transactionsP
        Call    WriteString
        Call    Crlf

        Call    GetTransactionData

        mov     [esi], bh

        Call Crlf
        Call WaitMsg
        Call Clrscr


;Calculate Totals

    ;Get User 1 Total
        mov     edi, offset person1Sp
        mov     esi, offset transNums
        mov     ecx, [esi]
        mov     ebx, type person1Sp

        Call    CalculateTotals

        mov     edi, offset totals
        mov     [edi], eax
        add     esi, type transNums

    ;Get User 2 Total
        mov     edi, offset person2Sp
        mov     ecx, [esi]
        mov     ebx, type person2Sp

        Call    CalculateTotals

        mov     edi, offset totals
        add     edi, type totals
        mov     [edi], eax

;Display Report Summary

    mov edx, offset sumHeader
    Call WriteString
    Call Crlf
    mov edx, offset sumSpacer
    Call WriteString
    Call Crlf

    ;Display User 1 Report Summary
        mov edx, offset nameP
        Call WriteString
        mov edi, offset person1Nm
        mov edx, edi
        Call WriteString
        Call Crlf

        mov edi, offset person1Sp
        mov esi, offset transNums
        mov ecx, [esi]
        mov esi, offset totals

        Call DisplayReportSummary

    ;Display User 2 Report Summary
        mov edx, offset nameP
        Call WriteString
        mov edi, offset person2Nm
        mov edx, edi
        Call WriteString
        Call Crlf

        mov edi, offset person2Sp
        mov esi, offset transNums
        add esi, type transNums
        mov ecx, [esi]
        mov esi, offset totals
        add esi, type totals

        Call DisplayReportSummary

        Call Crlf
        Call Crlf
        Call WaitMsg

Invoke ExitProcess,0

main endp

;Processes

GetUserData proc
;Promtps the user to input a Name
    mov     edx, edi
    mov     ecx, 40
    Call    ReadString
    Call    Crlf

    ret
GetUserData endp

GetTransactionData proc
;Prompts to the user the inputed name and asks for a Transaction Amount
;for each transaction based on the user choice (Max of 80)

    jmp     getTrans

    fixNegNum:
    neg     eax
    jmp     postFix

    fixZeroNum:

    mov     edx, offset zeroMsg
    Call    WriteString
    Call    Crlf
    jmp     getTrans

    addTrans:
    inc     bh

    getTrans:

    mov     edx, offset transactionP
    Call    WriteString
    movzx   eax, bh
    Call    WriteDec
    mov     edx, offset colon
    Call    WriteString

    Call    ReadInt

    cmp     eax, 0
    je      fixZeroNum

    cmp     eax, 0
    jl      fixNegNum

    postFix:

    mov     [edi], eax

    add     edi, 4

    getUserChoice:

    mov     edx, offset getUserChoiceP
    Call    WriteString

    mov     edx, offset userChoice
    mov     ecx, lengthof userChoice
    push    eax
    call    ReadString
    pop     eax

    cmp     userChoice, 'Y'
    je      addTrans

    cmp     userChoice, 'y'
    je      addTrans

    cmp     userChoice, 'N'
    je      doneGettingTrans

    cmp     userChoice, 'n'
    je      doneGettingTrans

    Call    OutputError

    jmp     getUserChoice

    doneGettingTrans:

    ret
GetTransactionData endp

CalculateTotals proc
;Computes the sum of all Transaction Amounts for each Name
    mov eax, 0

    cmpTotLp:
    add eax, [edi]
    add edi, ebx
    loop cmpTotLp

    ret
CalculateTotals endp

DisplayReportSummary proc
;Displays a detailed summary of each Name's Transactions as well as their Total Spending Amount

    mov ebx, 1
    mov edx, offset transactionsP
    Call WriteString
    Call Crlf

    dispLp:
    mov eax, ebx
    Call WriteDec

    mov edx, offset colon
    Call WriteString

    mov edx, edi
    mov eax, [edi]
    Call WriteDec
    
    inc ebx
    add edi, 4

    Call Crlf

    loop dispLp

    mov edx, offset totalP
    Call WriteString
    mov eax, [esi]
    Call WriteDec

    Call Crlf

    mov edx, offset sumSpacer
    Call WriteString
    Call Crlf

    ret
DisplayReportSummary endp

OutputError proc
;Outputs the error message to the user for an invalid response.
    push    edx

    mov     edx, offset inputErrorP
    Call    WriteString
    Call    Crlf

    pop     edx
    ret
OutputError endp

end main