; Experiment 9d: 8051 register bank selection
ORG 0000H
    MOV PSW, #00H            ; Select register bank 0
    MOV R0, #25H
    MOV PSW, #08H            ; Select register bank 1
    MOV R0, #52H
    SJMP $
END
