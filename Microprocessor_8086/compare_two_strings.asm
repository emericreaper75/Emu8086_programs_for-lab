; ## 8086 ALP: Compare Two Strings
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG1 DB 'Enter string 1 ($ end): $' ; Prompt1
MSG2 DB 0DH,0AH,'Enter string 2 ($ end): $' ; Prompt2
MSG_EQ DB 0DH,0AH,'Equal$ ' ; Equal msg
MSG_NEQ DB 0DH,0AH,'Not equal$ ' ; Not msg
STR1 DB 50 DUP(?)     ; Str1
STR2 DB 50 DUP(?)     ; Str2
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    LEA DX, MSG1      ; Prompt1
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    LEA SI, STR1      ; Point to str1
    CALL READ_STR_SUB ; Read sub (adapt from length program)

    LEA DX, MSG2      ; Prompt2
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    LEA SI, STR2      ; Point to str2
    CALL READ_STR_SUB ; Read

    LEA SI, STR1      ; SI to str1
    LEA DI, STR2      ; DI to str2
    MOV CX, 50        ; Max len
    CLD               ; Clear direction (forward)
    REPE CMPSB        ; Compare until unequal or CX=0
    JZ EQUAL          ; If zero flag, equal
    LEA DX, MSG_NEQ   ; Load not eq
    JMP DISP_CMP      ; Display
EQUAL:                ; Equal label
    LEA DX, MSG_EQ    ; Load eq
DISP_CMP:             ; Display label
    MOV AH, 09H       ; Func
    INT 21H           ; Call

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End
; Add READ_STR_SUB similar to read loop
END MAIN              ; End
