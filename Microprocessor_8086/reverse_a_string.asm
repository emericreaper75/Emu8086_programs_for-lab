; ## 8086 ALP: Reverse a String
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
; Same input as length
MSG_REV DB 0DH,0AH,'Reversed: $' ; Msg
REV_STR DB 50 DUP(?)  ; Reversed buffer
.CODE                 ; Code
; After reading STR and LEN
    LEA SI, STR       ; SI to start
    LEA DI, REV_STR   ; DI to rev start
    ADD SI, LEN       ; SI to end (before $)
    DEC SI            ; Adjust
    MOV CX, LEN       ; Loop count
REV_LOOP:             ; Reverse loop
    MOV AL, [SI]      ; Load char from end
    MOV [DI], AL      ; Store in rev
    DEC SI            ; Dec source
    INC DI            ; Inc dest
    LOOP REV_LOOP     ; Repeat
    MOV BYTE PTR [DI], '$' ; Terminate

    LEA DX, MSG_REV   ; Load msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    LEA DX, REV_STR   ; Load rev string
    MOV AH, 09H       ; Display
    INT 21H           ; Call
; Exit
