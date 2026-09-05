; ## 8086 ALP: Serial Communication Between Two Microprocessors
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
; Similar msgs as parallel
DATA_PORT EQU 00H     ; 8251 data port
CMD_PORT EQU 01H      ; Command port
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    ; Assume mode prompt and read as above

    ; Init 8251
    MOV AL, 0         ; Reset
    OUT CMD_PORT, AL  ; Write
    MOV AL, 40H       ; Mode: async, 8bit, no parity
    OUT CMD_PORT, AL  ; Write
    MOV AL, 4EH       ; Command: enable tx/rx
    OUT CMD_PORT, AL  ; Write

    ; For send: read data, OUT DATA_PORT, AL
    ; For receive: IN AL, DATA_PORT, display

    ; Similar structure as parallel
    ; Exit
MAIN ENDP             ; End
END MAIN              ; End
