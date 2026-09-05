; ## 8086 ALP: Design Digital Clock Using INT 21H
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG DB 'Press any key to exit clock$ ' ; Msg
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    LEA DX, MSG       ; Load msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call

CLOCK_LOOP:           ; Clock loop
    MOV AH, 2CH       ; Get system time
    INT 21H           ; Call (CH=hr, CL=min, DH=sec)
    MOV AL, CH        ; Hour to AL
    CALL DISP_BYTE    ; Display hour (adapt DISP_DEC_BYTE)
    MOV DL, ':'       ; Colon
    MOV AH, 02H       ; Char
    INT 21H           ; Display
    MOV AL, CL        ; Min
    CALL DISP_BYTE    ; Display
    MOV DL, ':'       ; Colon
    MOV AH, 02H       ; Char
    INT 21H           ; Display
    MOV AL, DH        ; Sec
    CALL DISP_BYTE    ; Display

    MOV DL, 0DH       ; Carriage return
    MOV AH, 02H       ; Char
    INT 21H           ; Display
    MOV DL, 0AH       ; Line feed
    MOV AH, 02H       ; Char
    INT 21H           ; Display

    MOV AH, 01H       ; Check key press
    INT 16H           ; Bios keyboard (non-blocking)
    JNZ EXIT_CLOCK    ; If key, exit
    JMP CLOCK_LOOP    ; Loop
EXIT_CLOCK:           ; Exit label
    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End

DISP_BYTE PROC        ; Display 8-bit dec
    MOV AH, 0         ; Clear high
    CALL DISP_DEC     ; Call earlier sub
    RET               ; Return
DISP_BYTE ENDP        ; End
END MAIN              ; End
