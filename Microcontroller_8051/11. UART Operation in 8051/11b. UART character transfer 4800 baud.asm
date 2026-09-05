; Experiment 11b: UART character transfer at 4800 baud
ORG 0000H
    MOV TMOD, #20H
    MOV TH1, #0FAH
    MOV SCON, #50H
    SETB TR1
    MOV SBUF, #'B'
WAIT11B:
    JNB TI, WAIT11B
    CLR TI
    SJMP $
END
