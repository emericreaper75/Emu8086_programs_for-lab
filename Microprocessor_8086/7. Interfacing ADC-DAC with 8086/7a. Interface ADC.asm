; Experiment 7a: Interface ADC with 8086
.MODEL SMALL
.STACK 100H
.DATA
ADC_DATA EQU 080H
ADC_CTRL EQU 081H
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV AL, 01H
    OUT ADC_CTRL, AL         ; Start conversion
WAIT_ADC:
    IN AL, ADC_CTRL          ; Read end-of-conversion status
    TEST AL, 80H
    JZ WAIT_ADC
    IN AL, ADC_DATA          ; Read converted sample
    MOV AX, 4C00H
    INT 21H
MAIN ENDP
END MAIN
