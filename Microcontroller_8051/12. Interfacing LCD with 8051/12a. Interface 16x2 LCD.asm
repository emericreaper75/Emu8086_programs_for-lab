; Experiment 12a: Interface a 16x2 LCD with 8051
ORG 0000H
    MOV P2, #38H             ; 8-bit, 2-line LCD mode
    ACALL LCD_COMMAND
    MOV P2, #0EH             ; Display on, cursor on
    ACALL LCD_COMMAND
    MOV P2, #'A'
    ACALL LCD_DATA
    SJMP $
LCD_COMMAND:
    CLR P3.0
    SETB P3.1
    CLR P3.1
    RET
LCD_DATA:
    SETB P3.0
    SETB P3.1
    CLR P3.1
    RET
END
