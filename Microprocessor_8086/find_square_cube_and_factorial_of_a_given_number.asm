; ## 8086 ALP: Find Square, Cube, and Factorial of a Given Number
.MODEL SMALL          ; Small model
.STACK 100H           ; Stack allocation
.DATA                 ; Data
MSG DB 'Enter number (0-9 decimal): $'  ; Prompt
MSG_SQ DB 0DH,0AH,'Square: $'  ; Square message
MSG_CU DB 0DH,0AH,'Cube: $'    ; Cube message
MSG_FA DB 0DH,0AH,'Factorial: $' ; Fact message
NUM DB ?              ; Input number
SQUARE DW ?           ; Square result
CUBE DW ?             ; Cube result
FACT DW 1             ; Factorial result (init 1)
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init DS
    MOV DS, AX        ; Set DS

    LEA DX, MSG       ; Load prompt
    MOV AH, 09H       ; Display func
    INT 21H           ; Display

    MOV AH, 01H       ; Read char func
    INT 21H           ; Read digit
    SUB AL, '0'       ; Convert ASCII to num
    MOV NUM, AL       ; Store

    ; Square
    MOV AL, NUM       ; Load num
    MUL AL            ; Square (AL * AL)
    MOV SQUARE, AX    ; Store

    LEA DX, MSG_SQ    ; Load message
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    MOV AX, SQUARE    ; Load result
    CALL DISP_DEC     ; Display decimal (subroutine below)

    ; Cube
    MOV AL, NUM       ; Load num
    MUL NUM           ; * num (square)
    MUL NUM           ; * num (cube)
    MOV CUBE, AX      ; Store

    LEA DX, MSG_CU    ; Load message
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    MOV AX, CUBE      ; Load
    CALL DISP_DEC     ; Display

    ; Factorial
    MOV AL, NUM       ; Load num
    CMP AL, 0         ; If 0
    JE FACT_DONE      ; Fact=1
    MOV CX, AX        ; Set loop counter
FACT_LOOP:            ; Fact loop
    MUL FACT          ; Multiply accum by counter
    LOOP FACT_LOOP    ; Decrement and loop
FACT_DONE:            ; Label
    MOV FACT, AX      ; Store

    LEA DX, MSG_FA    ; Load message
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    MOV AX, FACT      ; Load
    CALL DISP_DEC     ; Display

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End

DISP_DEC PROC         ; Display decimal subroutine
    MOV BX, 10        ; Divisor 10
    MOV CX, 0         ; Digit count
PUSH_LOOP:            ; Push digits
    MOV DX, 0         ; Clear DX
    DIV BX            ; Divide AX by 10 (rem in DX)
    PUSH DX           ; Push remainder
    INC CX            ; Inc count
    CMP AX, 0         ; If AX=0
    JNZ PUSH_LOOP     ; Loop
POP_LOOP:             ; Pop and display
    POP DX            ; Pop digit
    ADD DL, '0'       ; To ASCII
    MOV AH, 02H       ; Display char
    INT 21H           ; Call
    LOOP POP_LOOP     ; Repeat
    RET               ; Return
DISP_DEC ENDP         ; End sub
END MAIN              ; End
