; ## 8051 ALP: Arithmetic Operations (Addition, Subtraction, Multiplication, Division)
ORG 0000H             ; Origin
MSG DB "Enter A B: "  ; Prompt (for simulator)
NUM1 DB ?             ; Num1
NUM2 DB ?             ; Num2
RES_ADD DB ?          ; Add
RES_SUB DB ?          ; Sub
RES_MUL DB ?          ; Mul
RES_DIV DB ?          ; Div quot
REM_DIV DB ?          ; Rem
MAIN:                 ; Main label
    ; Simulate input (in practice, use serial)
    MOV NUM1, #25H    ; Sample input1
    MOV NUM2, #10H    ; Sample input2

    MOV A, NUM1       ; Load num1
    ADD A, NUM2       ; Add num2
    MOV RES_ADD, A    ; Store

    MOV A, NUM1       ; Load
    SUBB A, NUM2      ; Sub (with borrow if needed)
    MOV RES_SUB, A    ; Store

    MOV A, NUM1       ; Load
    MOV B, NUM2       ; Load to B
    MUL AB            ; Mul (A low, B high)
    MOV RES_MUL, A    ; Store low

    MOV A, NUM1       ; Load
    MOV B, NUM2       ; Load divisor
    DIV AB            ; Div (A quot, B rem)
    MOV RES_DIV, A    ; Quot
    MOV REM_DIV, B    ; Rem

    ; Display via serial or LCD (adapt)
    SJMP $            ; Infinite loop
END                   ; End
