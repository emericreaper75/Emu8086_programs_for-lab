; Experiment 11c: UART character transfer at 2400 baud
ORG 0000H
    MOV TMOD, #20H
    MOV TH1, #0F4H
    MOV SCON, #50H
    SETB TR1
    MOV SBUF, #'C'
WAIT11C:
    JNB TI, WAIT11C
    CLR TI
    SJMP $
END
