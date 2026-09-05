; Experiment 10d: Counter1 mode 1, external pulse counting, blink P3
ORG 0000H
    MOV TMOD, #50H
    MOV TH1, #00H
    MOV TL1, #00H
    SETB TR1
LOOP10D:
    JNB TF1, LOOP10D
    CLR TF1
    CPL P3
    SJMP LOOP10D
END
