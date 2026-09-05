; ---------------------------------------------------------
; 25 ms delay using Timer0 in Mode 1 (16-bit timer)
; Blinks all pins of Port 0
; Assumes 12 MHz crystal -> 1 machine cycle = 1 us
; Count = 65536 - 25000 = 40536 = 9E58H -> TH0=9EH, TL0=58H
; ---------------------------------------------------------
ORG 0000H                ; reset vector: execution starts here
    LJMP MAIN              ; jump to MAIN, skipping interrupt vector area

ORG 0030H                ; main code placed after interrupt vector table
MAIN:                     ; label: start of main program
    MOV TMOD,#01H           ; TMOD=01H -> Timer0 selected, Mode 1 (16-bit)
AGAIN:                     ; label: start of repeating blink loop
    MOV TH0,#09EH            ; load high byte of the 16-bit count (9EH)
    MOV TL0,#058H            ; load low byte of the 16-bit count (58H)
    SETB TR0                 ; start Timer0 running
WAIT:                       ; label: wait for timer overflow
    JNB TF0,WAIT              ; loop here while overflow flag TF0 is still 0
    CLR TR0                  ; stop Timer0 once it has overflowed
    CLR TF0                  ; clear overflow flag for the next round
    CPL P0                   ; complement (toggle) all 8 pins of Port 0
    SJMP AGAIN                ; repeat forever, creating a blinking effect
    END                      ; end of source file
