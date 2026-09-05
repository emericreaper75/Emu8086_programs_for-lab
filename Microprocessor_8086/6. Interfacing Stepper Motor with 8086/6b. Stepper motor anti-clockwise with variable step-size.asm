; Experiment 6b: Stepper motor anti-clockwise with variable step-size
.MODEL SMALL
.STACK 100H
.DATA
PORTA EQU 080H
.STEP_COUNT DB 8
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV CX, 0
    MOV CL, STEP_COUNT
ANTI_CLOCKWISE:
    ; Output the reverse phase sequence to the interface port here.
    ; OUT PORTA, AL
    LOOP ANTI_CLOCKWISE
    MOV AX, 4C00H
    INT 21H
MAIN ENDP
END MAIN
