; Experiment 10b: Timer1 mode 0, approximately 50 microseconds, blink P2
ORG 0000H
    MOV TMOD, #00H
LOOP10B:
    MOV TH1, #0FCH
    MOV TL1, #018H
    SETB TR1
WAIT10B:
    JNB TF1, WAIT10B
    CLR TR1
    CLR TF1
    CPL P2
    SJMP LOOP10B
END
