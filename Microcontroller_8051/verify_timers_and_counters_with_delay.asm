; ## 8051 ALP: Verify Timers and Counters with Delay
ORG 0000H             ; Origin
MAIN:                 ; Main
    MOV TMOD, #01H    ; Timer0 mode1
    MOV TH0, #0FCH    ; High byte for delay (e.g., 1ms at 12MHz)
    MOV TL0, #18H     ; Low byte
    SETB TR0          ; Start timer
WAIT:                 ; Wait label
    JNB TF0, WAIT     ; Wait for overflow
    CLR TR0           ; Stop
    CLR TF0           ; Clear flag

    ; Repeat for mode2 or counter (use ET0, etc.)
    SJMP $            ; Loop
END                   ; End
