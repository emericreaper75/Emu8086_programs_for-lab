; ---------------------------------------------------------
; 75 ms delay using Counter0/Timer0 register in Mode 2
; (8-bit auto-reload). Mode 2 overflows every 250 us here
; (256-6=250), so 300 overflows = 75000 us = 75 ms.
; Blinks all pins of Port 1
; ---------------------------------------------------------
ORG 0000H                ; reset vector: execution starts here
    LJMP MAIN              ; jump to MAIN, skipping interrupt vector area

ORG 0030H                ; main code placed after interrupt vector table
MAIN:                     ; label: start of main program
    MOV TMOD,#02H           ; TMOD=02H -> Timer0 selected, Mode 2 (8-bit auto-reload)
AGAIN:                     ; label: start of repeating blink loop
    MOV R2,#300              ; R2 = 300, number of 250us overflows needed for 75ms
    MOV TH0,#06H              ; TH0 = 06H, the auto-reload value (256-6=250us period)
    MOV TL0,#06H              ; TL0 = 06H, initial count loaded same as reload value
    SETB TR0                  ; start Timer0 running
LOOP1:                       ; label: wait-and-count loop
    JNB TF0,LOOP1              ; loop here while overflow flag TF0 is still 0
    CLR TF0                   ; clear overflow flag (TL0 auto-reloads from TH0)
    DJNZ R2,LOOP1              ; decrement R2; if not zero yet, wait for next overflow
    CLR TR0                   ; stop Timer0 after 300 overflows (75ms elapsed)
    CPL P1                    ; complement (toggle) all 8 pins of Port 1
    SJMP AGAIN                 ; repeat forever, creating a blinking effect
    END                       ; end of source file
