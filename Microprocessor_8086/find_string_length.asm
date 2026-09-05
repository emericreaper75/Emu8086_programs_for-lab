; ## 8086 ALP: Find String Length
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG DB 'Enter string (end with $): $' ; Prompt
MSG_LEN DB 0DH,0AH,'Length: $' ; Msg
STR DB 50 DUP(?)      ; String buffer
LEN DW ?              ; Length
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    LEA DX, MSG       ; Prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    MOV SI, OFFSET STR ; Point to buffer
    MOV CX, 0         ; Clear count
READ_STR:             ; Read loop
    MOV AH, 01H       ; Read char
    INT 21H           ; Call
    CMP AL, '$'       ; Check end
    JE DONE_READ      ; If yes, done
    MOV [SI], AL      ; Store char
    INC SI            ; Next pos
    INC CX            ; Inc length
    JMP READ_STR      ; Repeat
DONE_READ:            ; Label
    MOV LEN, CX       ; Store length

    LEA DX, MSG_LEN   ; Load msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    MOV AX, LEN       ; Load length
    CALL DISP_DEC     ; Display (from earlier sub)

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End
END MAIN              ; End
