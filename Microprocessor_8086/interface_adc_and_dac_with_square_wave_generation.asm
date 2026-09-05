; ## 8086 ALP: Interface ADC and DAC with Square Wave Generation
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG DB 'Generating square wave... Press key to stop$ ' ; Msg
DAC_PORT EQU 00H      ; DAC port (adjust)
ADC_PORT EQU 01H      ; ADC port
CONTROL EQU 03H       ; Control
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    LEA DX, MSG       ; Load msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    MOV AL, 80H       ; Control word
    OUT CONTROL, AL   ; Set output

SQUARE_LOOP:          ; Square loop
    MOV AL, 00H       ; Low value
    OUT DAC_PORT, AL  ; Output low
    CALL DELAY        ; Delay

    MOV AL, 0FFH      ; High value
    OUT DAC_PORT, AL  ; Output high
    CALL DELAY        ; Delay

    ; Optional: Read from ADC
    IN AL, ADC_PORT   ; Read ADC

    MOV AH, 01H       ; Check key
    INT 16H           ; Bios
    JZ SQUARE_LOOP    ; Loop if no key

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End
; DELAY from above
END MAIN              ; End
