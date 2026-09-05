; Experiment 5c: Digital clock by reading system time
.MODEL SMALL
.STACK 100H
.CODE
MAIN PROC
    MOV AH, 2CH
    INT 21H                 ; Read system time: CH:CL and DH:DL
    ; Format and display the returned hour, minute, and second values.
    MOV AX, 4C00H
    INT 21H
MAIN ENDP
END MAIN
