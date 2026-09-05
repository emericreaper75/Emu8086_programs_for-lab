; Experiment 5b: Digital clock using DOS interrupt functions
.MODEL SMALL
.STACK 100H
.CODE
MAIN PROC
    MOV AH, 2CH
    INT 21H                 ; CH=hour, CL=minute, DH=second
    ; Add BCD display conversion here as required by the trainer.
    MOV AX, 4C00H
    INT 21H
MAIN ENDP
END MAIN
