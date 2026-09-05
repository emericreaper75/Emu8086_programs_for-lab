; ## 8051 ALP: Logical Operations (AND, OR, XOR)
ORG 0000H             ; Origin
NUM1 DB #0FH          ; Sample
NUM2 DB #F0H          ; Sample
RES_AND DB ?          ; And
RES_OR DB ?           ; Or
RES_XOR DB ?          ; Xor
MAIN:                 ; Main
    MOV A, NUM1       ; Load
    ANL A, NUM2       ; And
    MOV RES_AND, A    ; Store

    MOV A, NUM1       ; Load
    ORL A, NUM2       ; Or
    MOV RES_OR, A     ; Store

    MOV A, NUM1       ; Load
    XRL A, NUM2       ; Xor
    MOV RES_XOR, A    ; Store

    SJMP $            ; Loop
END                   ; End
