; ## 8051 ALP: Interface LCD in 4-Bit/8-Bit Mode
ORG 0000H             ; Origin
LCD_DATA EQU P1       ; Data port
RS BIT P2.0           ; Register select
EN BIT P2.1           ; Enable
MAIN:                 ; Main
    MOV A, #38H       ; Init 8-bit mode (or #28H for 4-bit)
    ACALL CMD         ; Send command

    MOV A, #0EH       ; Display on
    ACALL CMD         ; Send

    MOV A, #'H'       ; Sample char
    ACALL DATA_WR     ; Write data

    SJMP $            ; Loop

CMD:                  ; Command sub
    CLR RS            ; RS=0 for cmd
    MOV LCD_DATA, A   ; Send data
    SETB EN           ; Enable pulse
    CLR EN            ; Clear
    ACALL DELAY       ; Delay
    RET               ; Return

DATA_WR:              ; Data sub
    SETB RS           ; RS=1 for data
    MOV LCD_DATA, A   ; Send
    SETB EN           ; Pulse
    CLR EN            ; Clear
    ACALL DELAY       ; Delay
    RET               ; Return

DELAY:                ; Delay
    MOV R0, #255      ; Count
DL1:                  ; Loop1
    DJNZ R0, DL1      ; Dec jump
    RET               ; Return
END                   ; End
