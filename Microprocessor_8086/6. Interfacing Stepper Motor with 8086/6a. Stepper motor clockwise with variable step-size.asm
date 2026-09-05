; ## 8086 ALP: Interface Stepper Motor Clockwise/Anti-Clockwise
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG_DIR DB 'Enter C for clockwise, A for anti: $' ; Prompt
PORTA EQU 00H         ; Port A address (adjust for kit)
CONTROL EQU 03H       ; Control port
CW_SEQ DB 09H, 05H, 06H, 0AH ; Clockwise sequence
ACW_SEQ DB 0AH, 06H, 05H, 09H ; Anti-clockwise
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    LEA DX, MSG_DIR   ; Load prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    MOV AH, 01H       ; Read char
    INT 21H           ; Call
    CMP AL, 'C'       ; Check C
    JE CW_DIR         ; Clockwise
    LEA BX, ACW_SEQ   ; Load anti seq
    JMP SET_SEQ       ; Jump
CW_DIR:               ; CW label
    LEA BX, CW_SEQ    ; Load cw seq

SET_SEQ:              ; Set label
    MOV AL, 80H       ; Control word (mode 0, output)
    OUT CONTROL, AL   ; Write to control

    MOV CX, 4         ; 4 steps
    MOV SI, 0         ; Index
STEP_LOOP:            ; Step loop
    MOV AL, [BX+SI]   ; Load sequence byte
    OUT PORTA, AL     ; Output to port A
    CALL DELAY        ; Call delay sub
    INC SI            ; Next seq
    LOOP STEP_LOOP    ; Repeat

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End

DELAY PROC            ; Delay sub
    MOV DX, 0FFFFH    ; Large value
DELAY_LOOP:           ; Loop
    DEC DX            ; Dec
    JNZ DELAY_LOOP    ; Repeat
    RET               ; Return
DELAY ENDP            ; End
END MAIN              ; End
