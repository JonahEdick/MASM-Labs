.386
.model flat,stdcall
.stack 4096

ExitProcess proto, dwExitCode:dword

.data
    Lab1 word 90
    Lab2 word 80
    Lab3 word 70
    Lab4 word 100
    LabAvg word ?

    Quiz1 word 100
    Quiz2 word 90
    Quiz3 word 50
    QuizAvg word ?

    Homework1 word 90
    Homework2 word 80
    HomeworkAvg word ?

    ExamPoints word 115
    ExamGrade word ?

    ClassAvg word ?

.code
main proc
    
    mov ax,Lab1
    add ax,Lab2
    add ax,Lab3
    add ax,Lab4
    mov bx,4
    mov dx,0
    div bx
    mov LabAvg,ax

    mov ax,Quiz1
    add ax,Quiz2
    add ax,Quiz3    
    mov bx,3
    mov dx,0
    div bx
    mov QuizAvg,ax

    mov dx, 0
    mov ax,Homework1
    add ax,Homework2
    mov bx,2
    mov dx,0
    div bx
    mov HomeworkAvg,ax

    mov ax,ExamPoints
    mov bx,100
    mul bx
    mov bx,127
    mov dx,0
    div bx
    mov ExamGrade,ax
  

    mov ax,LabAvg
    mov bx,35
    mul bx
    mov bx,100
    mov dx,0
    div bx
    mov ClassAvg,ax

    mov ax, QuizAvg
    mov bx, 10
    mul bx
    mov bx, 100
    mov dx, 0
    div bx
    add ClassAvg,ax

    mov ax, HomeworkAvg
    mov bx, 10
    mul bx
    mov bx, 100
    mov dx, 0
    div bx
    add ClassAvg,ax

    mov ax, ExamGrade
    mov bx, 25
    mul bx
    mov bx, 100
    mov dx, 0
    div bx
    add ClassAvg,ax

    mov ax,ClassAvg
    mov bx,100
    mul bx
    mov bx,80
    mov dx, 0
    div bx
    mov ClassAvg,ax

    invoke ExitProcess,0

main endp
end main
