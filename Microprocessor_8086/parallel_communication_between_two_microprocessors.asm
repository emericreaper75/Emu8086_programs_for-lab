; ## 8086 ALP: Parallel Communication Between Two Microprocessors
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG_MODE DB 'Enter S for send, R for receive: $' ; Prompt
MSG_DATA DB 0DH,0AH,'Enter data byte (hex): $' ; Data prompt
MSG_REC DB 0DH,0AH,'Received: $' ; Rec msg
PORTA EQU 00H         ; Port A
CONTROL EQU 03H       ; Control
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    LEA DX, MSG_MODE  ; Load mode prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    MOV AH, 01H       ; Read char
    INT 21H           ; Call
    CMP AL, 'S'       ; Check send
    JE SEND_MODE      ; Send

RECEIVE_MODE:         ; Receive label
    MOV AL, 9BH       ; Control word for input
    OUT CONTROL, AL   ; Set

    LEA DX, MSG_REC   ; Load rec msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    IN AL, PORTA      ; Read from port A
    CALL DISP_BYTE_HEX ; Display (adapt DISPLAY_NUM for byte)

    JMP EXIT_COMM     ; Exit

SEND_MODE:            ; Send label
    MOV AL, 80H       ; Control for output
    OUT CONTROL, AL   ; Set

    LEA DX, MSG_DATA  ; Load data prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    CALL READ_BYTE    ; Read byte
    OUT PORTA, AL     ; Send to port A

EXIT_COMM:            ; Exit label
    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End
; Add subs as needed
END MAIN              ; End
