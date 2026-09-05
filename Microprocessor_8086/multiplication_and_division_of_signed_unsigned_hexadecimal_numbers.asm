; ## 8086 ALP: Multiplication and Division of Signed/Unsigned Hexadecimal Numbers
.MODEL SMALL          ; Define memory model as small
.STACK 100H           ; Allocate stack
.DATA                 ; Data segment
MSG1 DB 'Enter first number (hex): $'  ; Prompt for first
MSG2 DB 0DH,0AH,'Enter second number (hex): $'  ; Prompt for second
MSG_MUL DB 0DH,0AH,'Multiplication result: $'  ; Message for mul result
MSG_DIV DB 0DH,0AH,'Division quotient: $'     ; Message for div quotient
NUM1 DW ?             ; First number
NUM2 DW ?             ; Second number
RES_MUL DD ?          ; 32-bit mul result (DX:AX)
QUOT DW ?             ; Division quotient
REMAIN DW ?           ; Division remainder
.CODE                 ; Code segment
MAIN PROC             ; Main procedure
    MOV AX, @DATA     ; Initialize DS
    MOV DS, AX        ; Set data segment

    LEA DX, MSG1      ; Load prompt 1
    MOV AH, 09H       ; Display string function
    INT 21H           ; Display prompt

    CALL READ_NUM     ; Read first number
    MOV NUM1, AX      ; Store it

    LEA DX, MSG2      ; Load prompt 2
    MOV AH, 09H       ; Display function
    INT 21H           ; Display prompt

    CALL READ_NUM     ; Read second number
    MOV NUM2, AX      ; Store it

    ; Multiplication (unsigned, use IMUL for signed)
    MOV AX, NUM1      ; Load first into AX
    MOV BX, NUM2      ; Load second into BX
    MUL BX            ; Multiply (result in DX:AX)
    MOV WORD PTR RES_MUL, AX  ; Store low word
    MOV WORD PTR RES_MUL+2, DX ; Store high word

    LEA DX, MSG_MUL   ; Load mul message
    MOV AH, 09H       ; Display function
    INT 21H           ; Display

    MOV AX, WORD PTR RES_MUL+2 ; Display high word
    CALL DISPLAY_NUM  ; Display it
    MOV AX, WORD PTR RES_MUL   ; Display low word
    CALL DISPLAY_NUM  ; Display it

    ; Division (unsigned, use IDIV for signed)
    MOV DX, 0         ; Clear DX for dividend
    MOV AX, NUM1      ; Load dividend into AX
    MOV BX, NUM2      ; Load divisor into BX
    DIV BX            ; Divide (quot in AX, rem in DX)
    MOV QUOT, AX      ; Store quotient
    MOV REMAIN, DX    ; Store remainder

    LEA DX, MSG_DIV   ; Load div message
    MOV AH, 09H       ; Display function
    INT 21H           ; Display

    MOV AX, QUOT      ; Load quotient
    CALL DISPLAY_NUM  ; Display it

    MOV AH, 4CH       ; Terminate program
    INT 21H           ; Exit
MAIN ENDP             ; End main

; READ_NUM and DISPLAY_NUM subroutines same as above program
END MAIN              ; End program
