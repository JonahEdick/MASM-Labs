;Name: 		Jonah C. Edick
;Due Date: 	 03/20/2021
;Assignment: 	 Lab06
;Description: 	 This assembly solution takes inputs from the user (names, transaction numbers, and transaction amounts)
;		      and stores them into arrays. It also sums the transaction amounts for each person and displays a
;		      report summary to the user. All inputs and outputs use the command prompts. Utilizes processes and
;		      loops to perform processes for each person.

include Irvine32.inc

.data

;User Generated Data - Data that is either entered from the user or calculated from the user's inputs.

    person1Sp	 dword 80 dup(0)     ;Person 1 Transactions, max of 80 Transactions
    person2Sp	 dword 80 dup(0)     ;Person 2 Transactions, max of 80 Transactions
    person1Nm	 byte  40 dup(?)	 ;Person 1 Name, ASCII array with max name size of 40 ASCII characters
    person2Nm	 byte  40 dup(?)	 ;Person 2 Name, ASCII array with max name size of 40 ASCII characters
    transNums	 dword  2 dup(?)	 ;Number of Transactions for each Person - Entered from the user
    totals      dword  2 dup(?)	 ;Total spending for each Person, calcultaed from personSp's

;Promts - Prompts that will be shown to the user either asking for information or displays headings

     getName1P      byte  "Please Enter Name for the First Person: ",0  ;Prompts the user for the first person's name
     getName2P      byte "Please Enter Name for the Second Person: ",0  ;Prompts the user for the first person's name
     numTransP      byte                  "Number of Transactions: ",0  ;Prompts the user for the number of transactions
     transactionP   byte                              "Transaction ",0
     colon          byte                                        ": ",0
     apostS         byte                                       "'s ",0
     transactionsP  byte                             "Transactions.",0
     sumHeader      byte                "Transaction Summary Report",0
     sumSpacer      byte                "~~~~~~~~~~~~~~~~~~~~~~~~~~",0
     nameP          byte                                    "Name: ",0
     totalP         byte                      "Total Amount Spent: ",0

.code

main proc

;Get User Data

    ;Get User 1 Data
    mov edi, offset person1Nm
    mov esi, offset transNums
    mov edx, offset getName1p
    Call WriteString

    Call GetUserData

    ;Get User 2 Data
    mov edi, offset person2Nm
    add esi, type transNums
    mov edx, offset getName2p
    Call WriteString

    Call GetUserData

    Call Crlf
    Call Crlf
    Call WaitMsg

    Call Clrscr

;Get Transaction Data

    ;Get User 1 Transactions
    mov edi, offset person1Sp
    
    mov esi, offset transNums
    mov ecx, [esi]
    
    mov bh, 1

    mov edx, offset person1Nm
    Call WriteString
    mov edx, offset apostS
    Call WriteString
    mov edx, offset transactionsP
    Call WriteString
    Call Crlf
    
    Call GetTransactionData

    Call Crlf

    ;Get User 2 Transactions
    mov edi, offset person2Sp
    
    add esi, type transNums
    mov ecx, [esi]
    
    mov bh, 1

    mov edx, offset person2Nm
    Call WriteString
    mov edx, offset apostS
    Call WriteString
    mov edx, offset transactionsP
    Call WriteString
    Call Crlf
    
    Call GetTransactionData

    Call Crlf
    Call Crlf
    Call WaitMsg

    Call Clrscr

;Calculate Totals

    ;Get User 1 Total
    mov edi, offset person1Sp
    mov esi, offset transNums
    mov ecx, [esi]

    Call CalculateTotals

    mov edi, offset totals
    mov [edi], eax
    add esi, type transNums

    ;Get User 2 Total
    mov edi, offset person2Sp
    mov ecx, [esi]

    Call CalculateTotals

    mov edi, offset totals
    add edi, type offset totals
    mov [edi], eax

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
;Promtps the user to input a Name and Transaction Number
    mov edx, edi
    mov ecx, 40
    Call ReadString

    mov edx, offset numTransP
    Call WriteString
    Call ReadDec
    mov [esi], eax

    ret
GetUserData endp


GetTransactionData proc
;Prompts to the user the inputed name and asks for a Transaction Amount
;for each transaction based on the inputed Transaction Number
    
    getTLoop:

    mov edx, offset transactionP
    Call WriteString
    movzx eax, bh
    Call WriteDec
    mov edx, offset colon
    Call WriteString

    Call ReadDec

    mov [edi], eax

    add edi, 4
    inc bh

    loop getTLoop

    ret
GetTransactionData endp

CalculateTotals proc
;Computes the sum of all Transaction Amounts for each Name
    mov eax, 0

    cmpTotLp:
    add eax, [edi]
    add edi, 4
    loop cmpTotLp

    ret
CalculateTotals endp


DisplayReportSummary proc
;Displays a detailed summary of each Name's Transactions as well as their Total Spending Amount

    mov bl, 1
    mov edx, offset transactionsP
    Call WriteString
    Call Crlf

    dispLp:
    mov al, bl
    Call WriteDec

    mov edx, offset colon
    Call WriteString

    mov edx, edi
    mov eax, [edi]
    Call WriteDec
    
    inc bl
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

end main