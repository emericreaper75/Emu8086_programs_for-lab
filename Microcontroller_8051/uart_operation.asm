; ## 8051 ALP: UART Operation
ORG 0000H             ; Origin
MAIN:                 ; Main
    MOV TMOD, #20H    ; Timer1 mode2
    MOV TH1, #0FDH    ; 9600 baud (at 11.059MHz crystal)
    MOV SCON, #50H    ; UART mode1, REN=1
    SETB TR1          ; Start timer

    MOV SBUF, #'A'    ; Send char
WAIT_TX:              ; Wait tx
    JNB TI, WAIT_TX   ; Wait TI flag
    CLR TI            ; Clear

    ; Receive: JNB RI, $; MOV A, SBUF; CLR RI
    SJMP $            ; Loop
END                   ; End
