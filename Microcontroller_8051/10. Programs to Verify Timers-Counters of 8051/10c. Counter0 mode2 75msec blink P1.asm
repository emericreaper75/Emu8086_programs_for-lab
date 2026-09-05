; Experiment 10c: Counter0 mode 2, external pulse counting, blink P1
ORG 0000H
    MOV TMOD, #06H
    MOV TH0, #00H
    MOV TL0, #00H
    SETB TR0
LOOP10C:
    JNB TF0, LOOP10C
    CLR TF0
    CPL P1
    SJMP LOOP10C
END
