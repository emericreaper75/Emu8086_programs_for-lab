; ## 8086 ALP: Check if a Number is Positive or Negative
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG DB 'Enter number (hex, signed): $'  ; Prompt
MSG_POS DB 0DH,0AH,'Positive$ '  ; Positive msg
MSG_NEG DB 0DH,0AH,'Negative$ '  ; Negative msg
NUM DW ?              ; Number
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init DS
    MOV DS, AX        ; Set

    LEA DX, MSG       ; Load prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    CALL READ_NUM     ; Read signed hex (use previous READ_NUM)

    MOV NUM, AX       ; Store
    TEST AX, 8000H    ; Test sign bit (MSB for 16-bit)
    JZ POS            ; If zero, positive
    LEA DX, MSG_NEG   ; Load neg msg
    JMP DISP          ; Jump to display
POS:                  ; Positive label
    LEA DX, MSG_POS   ; Load pos msg
DISP:                 ; Display label
    MOV AH, 09H       ; Display func
    INT 21H           ; Call

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End
; READ_NUM from first program
END MAIN              ; End
