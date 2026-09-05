; ---------------------------------------------------------
; ALP demonstrating 8051 Register Banks (0-3)
; Bank select bits RS1,RS0 live in PSW.4 and PSW.3
; Bank 0: PSW = xx00xxxx   Bank 1: PSW = xx01xxxx
; Bank 2: PSW = xx10xxxx   Bank 3: PSW = xx11xxxx
; ---------------------------------------------------------
ORG 0000H                ; reset vector: execution starts here on power-up
    LJMP MAIN              ; jump over the interrupt vector area to MAIN

ORG 0030H                ; place main code after the interrupt vector table
MAIN:                     ; label: start of main program
    ; ---- Bank 0 (default) ----
    MOV PSW,#00H            ; set RS1,RS0 = 00 -> select Register Bank 0
    MOV R0,#11H              ; store 11H into R0 of Bank 0
    MOV R1,#22H              ; store 22H into R1 of Bank 0

    ; ---- Bank 1 ----
    MOV PSW,#08H            ; set RS1,RS0 = 01 -> select Register Bank 1
    MOV R0,#33H              ; store 33H into R0 of Bank 1 (physically different byte)
    MOV R1,#44H              ; store 44H into R1 of Bank 1

    ; ---- Bank 2 ----
    MOV PSW,#10H            ; set RS1,RS0 = 10 -> select Register Bank 2
    MOV R0,#55H              ; store 55H into R0 of Bank 2
    MOV R1,#66H              ; store 66H into R1 of Bank 2

    ; ---- Bank 3 ----
    MOV PSW,#18H            ; set RS1,RS0 = 11 -> select Register Bank 3
    MOV R0,#77H              ; store 77H into R0 of Bank 3
    MOV R1,#88H              ; store 88H into R1 of Bank 3

    ; ---- Switch back to Bank 0 and verify data retained ----
    MOV PSW,#00H            ; switch back to Bank 0
    MOV A,R0                 ; A = 11H -> proves each bank keeps its own R0/R1

    SJMP $                  ; infinite loop: halt program execution here
    END                     ; end of source file
