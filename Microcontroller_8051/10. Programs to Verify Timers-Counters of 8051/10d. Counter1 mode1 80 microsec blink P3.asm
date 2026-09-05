; ---------------------------------------------------------
; 80 us delay using Counter1/Timer1 register in Mode 1
; (16-bit). Count = 65536 - 80 = 65456 = FFB0H
; Blinks all pins of Port 3
; ---------------------------------------------------------
ORG 0000H                ; reset vector: execution starts here
    LJMP MAIN              ; jump to MAIN, skipping interrupt vector area

ORG 0030H                ; main code placed after interrupt vector table
MAIN:                     ; label: start of main program
    MOV TMOD,#10H           ; TMOD=10H -> Timer1 selected, Mode 1 (16-bit)
AGAIN:                     ; label: start of repeating blink loop
    MOV TH1,#0FFH            ; load high byte of the 16-bit count (FFH)
    MOV TL1,#0B0H            ; load low byte of the 16-bit count (B0H)
    SETB TR1                 ; start Timer1 running
WAIT:                       ; label: wait for timer overflow
    JNB TF1,WAIT              ; loop here while overflow flag TF1 is still 0
    CLR TR1                  ; stop Timer1 once it has overflowed
    CLR TF1                  ; clear overflow flag for the next round
    CPL P3                   ; complement (toggle) all 8 pins of Port 3
    SJMP AGAIN                ; repeat forever, creating a blinking effect
    END                      ; end of source file
