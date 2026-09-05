; ## 8086 ALP: Check if a Number is Odd or Even
.MODEL SMALL          ; Model
.STACK 100H           ; Stack

.DATA                 ; Data
MSG DB 'Enter number (hex): $'  ; Prompt
MSG_ODD DB 0DH,0AH,'Odd$ '     ; Odd msg
MSG_EVEN DB 0DH,0AH,'Even$ '   ; Even msg
NUM DW ?              ; Number

.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set DS

    LEA DX, MSG       ; Prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    CALL READ_NUM     ; Read

    MOV NUM, AX       ; Store
    TEST AX, 0001H    ; Test LSB
    JZ EVEN_LABEL     ; If zero, even
    LEA DX, MSG_ODD   ; Load odd
    JMP DISP          ; Display
EVEN_LABEL:           ; Even label
    LEA DX, MSG_EVEN  ; Load even
DISP:                 ; Display
    MOV AH, 09H       ; Func
    INT 21H           ; Call

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End

; READ_NUM from first
END MAIN              ; End
