; ---------------------------------------------------------
; 50 us delay using Timer1 in Mode 0 (13-bit timer)
; Blinks all pins of Port 2
; 13-bit count for 50 us @ 12MHz = 8192 - 50 = 8142 = 1FCEH
; TL1 gets lower 5 bits, TH1 gets upper 8 bits
; ---------------------------------------------------------
ORG 0000H                ; reset vector: execution starts here
    LJMP MAIN              ; jump to MAIN, skipping interrupt vector area

ORG 0030H                ; main code placed after interrupt vector table
MAIN:                     ; label: start of main program
    MOV TMOD,#00H           ; TMOD=00H -> Timer1 selected, Mode 0 (13-bit)
AGAIN:                     ; label: start of repeating blink loop
    MOV TH1,#0FEH            ; load high 8 bits of the 13-bit count (FEH)
    MOV TL1,#00EH            ; load low 5 bits of the 13-bit count (0EH)
    SETB TR1                 ; start Timer1 running
WAIT:                       ; label: wait for timer overflow
    JNB TF1,WAIT              ; loop here while overflow flag TF1 is still 0
    CLR TR1                  ; stop Timer1 once it has overflowed
    CLR TF1                  ; clear overflow flag for the next round
    CPL P2                   ; complement (toggle) all 8 pins of Port 2
    SJMP AGAIN                ; repeat forever, creating a blinking effect
    END                      ; end of source file
