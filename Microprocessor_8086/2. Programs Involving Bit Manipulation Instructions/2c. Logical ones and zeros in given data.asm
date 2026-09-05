; ## 8086 ALP: Find Logical Ones and Zeros in a Byte
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG DB 'Enter byte (hex): $'  ; Prompt
MSG_ONES DB 0DH,0AH,'Ones: $' ; Ones msg
MSG_ZEROS DB 0DH,0AH,'Zeros: $' ; Zeros msg
BYTE_VAL DB ?         ; Input byte
ONES DB 0             ; Ones count
ZEROS DB 0            ; Zeros count
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    LEA DX, MSG       ; Prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    CALL READ_BYTE    ; Read byte (modify READ_NUM for 2 digits)

    MOV BYTE_VAL, AL  ; Store
    MOV CL, 8         ; 8 bits
    MOV AH, AL        ; Copy to AH
COUNT_LOOP:           ; Loop
    ROL AH, 1         ; Rotate left
    JC ONE            ; If carry, one
    INC ZEROS         ; Inc zeros
    JMP NEXT          ; Next
ONE:                  ; One label
    INC ONES          ; Inc ones
NEXT:                 ; Next label
    LOOP COUNT_LOOP   ; Repeat

    LEA DX, MSG_ONES  ; Load ones msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    MOV AL, ONES      ; Load count
    CALL DISP_DEC_BYTE ; Display byte decimal (adapt DISP_DEC)

    LEA DX, MSG_ZEROS ; Load zeros msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    MOV AL, ZEROS     ; Load
    CALL DISP_DEC_BYTE ; Display

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End
; Add READ_BYTE and DISP_DEC_BYTE subs similarly
END MAIN              ; End
