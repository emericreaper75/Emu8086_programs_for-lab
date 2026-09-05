; ---------------------------------------------------------
; ALP for Digital Clock Design BY READING SYSTEM TIME
; Uses DOS function AH=2CH (Get System Time) instead of a
; manually-ticked software clock.
; ---------------------------------------------------------
.MODEL SMALL                    ; small memory model
.STACK 100H                     ; 256-byte stack
.DATA                           ; data segment starts
    MSG DB 13,10,'System Time (HH:MM:SS): $'  ; label text printed before the time

.CODE                           ; code segment starts
MAIN PROC                       ; begin MAIN procedure
    MOV AX,@DATA                 ; load data segment address
    MOV DS,AX                    ; set DS so MSG can be accessed

    LEA DX,MSG                   ; DX = address of the label string
    MOV AH,09H                   ; DOS function 09H = display string
    INT 21H                      ; print "System Time (HH:MM:SS): "

    MOV AH,2CH                   ; DOS function 2CH = Get System Time
    INT 21H                      ; call DOS; returns time in CH,CL,DH,DL
    ; CH = hour, CL = minute, DH = second, DL = 1/100 sec (unused here)

    MOV AL,CH                    ; AL = hour value returned by DOS
    CALL PRINT2DIGIT             ; print hour as two ASCII digits
    MOV DL,':'                   ; DL = colon separator character
    MOV AH,02H                   ; DOS function 02H = display one character
    INT 21H                      ; print the colon

    MOV AL,CL                    ; AL = minute value returned by DOS
    CALL PRINT2DIGIT             ; print minute as two ASCII digits
    MOV DL,':'                   ; DL = colon separator character
    MOV AH,02H                   ; DOS function 02H = display one character
    INT 21H                      ; print the colon

    MOV AL,DH                    ; AL = second value returned by DOS
    CALL PRINT2DIGIT             ; print second as two ASCII digits

    MOV AH,4CH                   ; DOS function 4CH = terminate program
    INT 21H                      ; return control to DOS
MAIN ENDP                       ; end of MAIN procedure

; Prints AL (0-99) as two ASCII digits
PRINT2DIGIT PROC                ; begin PRINT2DIGIT subroutine
    PUSH AX                      ; save AX so caller's value isn't lost
    PUSH BX                      ; save BX (used as divisor register)
    PUSH DX                      ; save DX (used for character output)
    MOV AH,0                     ; clear AH so AX = AL (value to convert)
    MOV BL,10                    ; BL = 10, the divisor for splitting digits
    DIV BL                       ; AX/BL -> AL = tens digit, AH = ones digit
    ADD AL,30H                   ; convert tens digit to its ASCII code
    MOV DL,AL                    ; DL = ASCII tens digit, ready to print
    PUSH AX                      ; save AX (still holds ones digit in AH)
    MOV AH,02H                   ; DOS function 02H = display character
    INT 21H                      ; print the tens digit
    POP AX                       ; restore AX to get back the ones digit
    MOV DL,AH                    ; DL = ones digit (numeric)
    ADD DL,30H                   ; convert ones digit to its ASCII code
    MOV AH,02H                   ; DOS function 02H = display character
    INT 21H                      ; print the ones digit
    POP DX                       ; restore original DX
    POP BX                       ; restore original BX
    POP AX                       ; restore original AX
    RET                          ; return to caller
PRINT2DIGIT ENDP                ; end of PRINT2DIGIT subroutine
END MAIN                        ; end of program, entry point is MAIN
