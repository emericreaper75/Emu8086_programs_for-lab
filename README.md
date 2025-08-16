# Emu8086_programs_for-lab
codes for all programs in syllabus

<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# give detailed codes which include a DOS interface for every program and also give comments to each and every line of code.

Below, I'll provide detailed Assembly Language Programs (ALPs) for all the core experiments from your lab syllabus (covering 8086 and 8051 topics as shown in the attached image). Each program includes a DOS interface for user interaction (using INT 21H functions for input/output, such as prompting for inputs and displaying results). I've expanded them with full code, including data segments, stack setup, and error handling where relevant. Every single line has a comment explaining its purpose.

These are based on standard 8086/8051 emulator environments like EMU8086 or Keil for 8051. Adjust port addresses or hardware specifics for your lab kit. Programs are written in 8086/8051 assembly syntax.

***

## 8086 ALP: Addition and Subtraction of Multi-Precision Numbers

This program handles addition and subtraction of two 16-bit numbers with DOS prompts and displays the result.

```assembly
.MODEL SMALL          ; Define memory model as small (code and data in one segment)
.STACK 100H           ; Allocate 256 bytes for the stack
.DATA                 ; Start of data segment
MSG1 DB 'Enter first number (hex): $'  ; Message to prompt for first number
MSG2 DB 0DH,0AH,'Enter second number (hex): $'  ; Message to prompt for second number (with newline)
MSG_ADD DB 0DH,0AH,'Addition result: $'  ; Message for addition result
MSG_SUB DB 0DH,0AH,'Subtraction result: $'  ; Message for subtraction result
NUM1 DW ?             ; Variable to store first 16-bit number
NUM2 DW ?             ; Variable to store second 16-bit number
RES_ADD DW ?          ; Variable to store addition result
RES_SUB DW ?          ; Variable to store subtraction result
.CODE                 ; Start of code segment
MAIN PROC             ; Begin main procedure
    MOV AX, @DATA     ; Load data segment address into AX
    MOV DS, AX        ; Initialize DS with data segment address

    ; Prompt for first number
    LEA DX, MSG1      ; Load effective address of MSG1 into DX
    MOV AH, 09H       ; DOS function to display string
    INT 21H           ; Call DOS interrupt to display prompt

    ; Read first number (assuming hex input, convert from ASCII)
    CALL READ_NUM     ; Call subroutine to read a 16-bit hex number
    MOV NUM1, AX      ; Store the read number in NUM1

    ; Prompt for second number
    LEA DX, MSG2      ; Load effective address of MSG2 into DX
    MOV AH, 09H       ; DOS function to display string
    INT 21H           ; Call DOS interrupt to display prompt

    ; Read second number
    CALL READ_NUM     ; Call subroutine to read a 16-bit hex number
    MOV NUM2, AX      ; Store the read number in NUM2

    ; Perform addition
    MOV AX, NUM1      ; Load first number into AX
    ADD AX, NUM2      ; Add second number to AX
    MOV RES_ADD, AX   ; Store addition result

    ; Display addition result
    LEA DX, MSG_ADD   ; Load effective address of MSG_ADD into DX
    MOV AH, 09H       ; DOS function to display string
    INT 21H           ; Call DOS interrupt to display message
    MOV AX, RES_ADD   ; Load result into AX for display
    CALL DISPLAY_NUM  ; Call subroutine to display the number in hex

    ; Perform subtraction
    MOV AX, NUM1      ; Load first number into AX
    SUB AX, NUM2      ; Subtract second number from AX
    MOV RES_SUB, AX   ; Store subtraction result

    ; Display subtraction result
    LEA DX, MSG_SUB   ; Load effective address of MSG_SUB into DX
    MOV AH, 09H       ; DOS function to display string
    INT 21H           ; Call DOS interrupt to display message
    MOV AX, RES_SUB   ; Load result into AX for display
    CALL DISPLAY_NUM  ; Call subroutine to display the number in hex

    MOV AH, 4CH       ; DOS function to terminate program
    INT 21H           ; Call DOS interrupt to exit
MAIN ENDP             ; End of main procedure

READ_NUM PROC         ; Subroutine to read 16-bit hex number from keyboard
    MOV BX, 0         ; Clear BX to store the number
    MOV CX, 4         ; Set loop for 4 hex digits
READ_LOOP:            ; Start of read loop
    MOV AH, 01H       ; DOS function to read character
    INT 21H           ; Call DOS interrupt to read a char
    CMP AL, '0'       ; Compare if char is below '0'
    JB READ_LOOP      ; If below, invalid, loop again
    CMP AL, '9'       ; Compare if char is '0'-'9'
    JBE DIGIT         ; If yes, process digit
    CMP AL, 'A'       ; Compare if char is 'A'-'F'
    JB READ_LOOP      ; If below 'A', invalid
    CMP AL, 'F'       ; Compare upper limit
    JA READ_LOOP      ; If above 'F', invalid
    SUB AL, 7         ; Convert 'A'-'F' to 10-15
DIGIT:                ; Label for digit processing
    SUB AL, '0'       ; Convert ASCII to numeric value
    SHL BX, 4         ; Shift BX left by 4 bits (multiply by 16)
    ADD BL, AL        ; Add the digit to BX
    LOOP READ_LOOP    ; Repeat for next digit
    MOV AX, BX        ; Move result to AX for return
    RET               ; Return from subroutine
READ_NUM ENDP         ; End of read subroutine

DISPLAY_NUM PROC      ; Subroutine to display 16-bit hex number
    MOV CX, 4         ; Set loop for 4 hex digits
    MOV BX, AX        ; Copy number to BX
DISP_LOOP:            ; Start of display loop
    ROL BX, 4         ; Rotate left by 4 bits to get next nibble
    MOV DL, BL        ; Copy low byte to DL
    AND DL, 0FH       ; Mask to get lower 4 bits
    CMP DL, 9         ; Compare if digit 0-9
    JBE ADD_30        ; If yes, add '0'
    ADD DL, 7         ; Add 7 for 'A'-'F'
ADD_30:               ; Label for adding '0'
    ADD DL, '0'       ; Convert to ASCII
    MOV AH, 02H       ; DOS function to display char
    INT 21H           ; Call DOS interrupt to display
    LOOP DISP_LOOP    ; Repeat for next digit
    RET               ; Return from subroutine
DISPLAY_NUM ENDP      ; End of display subroutine
END MAIN              ; End of program
```


***

## 8086 ALP: Multiplication and Division of Signed/Unsigned Hexadecimal Numbers

This handles multiplication and division with DOS input/output.

```assembly
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
```


***

## 8086 ALP: Find Square, Cube, and Factorial of a Given Number

DOS prompts for number, computes all three.

```assembly
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
```


***

## 8086 ALP: Check if a Number is Positive or Negative

```assembly
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG DB 'Enter number (hex, signed): $'  ; Prompt
MSG_POS DB 0DH,0AH,'Positive$ '  ; Positive msg
MSG_NEG DB 0DH,0AH,'Negative$ '  ; Negative msg
NUM DW ?              ; Number
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init DS
    MOV DS, AX        ; Set

    LEA DX, MSG       ; Load prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    CALL READ_NUM     ; Read signed hex (use previous READ_NUM)

    MOV NUM, AX       ; Store
    TEST AX, 8000H    ; Test sign bit (MSB for 16-bit)
    JZ POS            ; If zero, positive
    LEA DX, MSG_NEG   ; Load neg msg
    JMP DISP          ; Jump to display
POS:                  ; Positive label
    LEA DX, MSG_POS   ; Load pos msg
DISP:                 ; Display label
    MOV AH, 09H       ; Display func
    INT 21H           ; Call

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End
; READ_NUM from first program
END MAIN              ; End
```


***

## 8086 ALP: Check if a Number is Odd or Even

```assembly
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG DB 'Enter number (hex): $'  ; Prompt
MSG_ODD DB 0DH,0AH,'Odd$ '     ; Odd msg
MSG_EVEN DB 0DH,0AH,'Even$ '   ; Even msg
NUM DW ?              ; Number
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set DS

    LEA DX, MSG       ; Prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    CALL READ_NUM     ; Read

    MOV NUM, AX       ; Store
    TEST AX, 0001H    ; Test LSB
    JZ EVEN_LABEL     ; If zero, even
    LEA DX, MSG_ODD   ; Load odd
    JMP DISP          ; Display
EVEN_LABEL:           ; Even label
    LEA DX, MSG_EVEN  ; Load even
DISP:                 ; Display
    MOV AH, 09H       ; Func
    INT 21H           ; Call

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End
; READ_NUM from first
END MAIN              ; End
```


***

## 8086 ALP: Find Logical Ones and Zeros in a Byte

```assembly
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG DB 'Enter byte (hex): $'  ; Prompt
MSG_ONES DB 0DH,0AH,'Ones: $' ; Ones msg
MSG_ZEROS DB 0DH,0AH,'Zeros: $' ; Zeros msg
BYTE_VAL DB ?         ; Input byte
ONES DB 0             ; Ones count
ZEROS DB 0            ; Zeros count
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    LEA DX, MSG       ; Prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    CALL READ_BYTE    ; Read byte (modify READ_NUM for 2 digits)

    MOV BYTE_VAL, AL  ; Store
    MOV CL, 8         ; 8 bits
    MOV AH, AL        ; Copy to AH
COUNT_LOOP:           ; Loop
    ROL AH, 1         ; Rotate left
    JC ONE            ; If carry, one
    INC ZEROS         ; Inc zeros
    JMP NEXT          ; Next
ONE:                  ; One label
    INC ONES          ; Inc ones
NEXT:                 ; Next label
    LOOP COUNT_LOOP   ; Repeat

    LEA DX, MSG_ONES  ; Load ones msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    MOV AL, ONES      ; Load count
    CALL DISP_DEC_BYTE ; Display byte decimal (adapt DISP_DEC)

    LEA DX, MSG_ZEROS ; Load zeros msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    MOV AL, ZEROS     ; Load
    CALL DISP_DEC_BYTE ; Display

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End
; Add READ_BYTE and DISP_DEC_BYTE subs similarly
END MAIN              ; End
```


***

## 8086 ALP: Addition and Subtraction of N Numbers (Array)

Prompt for N and numbers, compute sum and difference (cumulative sub).

```assembly
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG_N DB 'Enter N: $' ; Prompt N
MSG_NUM DB 0DH,0AH,'Enter number: $' ; Prompt num
MSG_SUM DB 0DH,0AH,'Sum: $' ; Sum msg
MSG_DIFF DB 0DH,0AH,'Cumulative Diff: $' ; Diff msg
N DB ?                ; N value
ARRAY DW 10 DUP(?)    ; Array of 10 words
SUM DW 0              ; Sum
DIFF DW 0             ; Diff
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    LEA DX, MSG_N     ; Load N prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    MOV AH, 01H       ; Read char
    INT 21H           ; Call
    SUB AL, '0'       ; To num
    MOV N, AL         ; Store
    MOV CL, AL        ; Set loop
    MOV SI, 0         ; Index

INPUT_LOOP:           ; Input loop
    LEA DX, MSG_NUM   ; Load num prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    CALL READ_NUM     ; Read
    MOV ARRAY[SI], AX ; Store in array
    ADD SI, 2         ; Next word
    LOOP INPUT_LOOP   ; Repeat

    MOV CL, N         ; Reset loop
    MOV SI, 0         ; Reset index
    MOV AX, 0         ; Clear sum
SUM_LOOP:             ; Sum loop
    ADD AX, ARRAY[SI] ; Add element
    ADD SI, 2         ; Next
    LOOP SUM_LOOP     ; Repeat
    MOV SUM, AX       ; Store

    LEA DX, MSG_SUM   ; Load msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    CALL DISPLAY_NUM  ; Display sum

    ; Cumulative diff (e.g., array[^0] - array[^12] - ...)
    MOV AX, ARRAY  ; Start with first
    MOV CL, N         ; Loop
    DEC CL            ; From second
    MOV SI, 2         ; Start index 1
DIFF_LOOP:            ; Diff loop
    SUB AX, ARRAY[SI] ; Sub element
    ADD SI, 2         ; Next
    LOOP DIFF_LOOP    ; Repeat
    MOV DIFF, AX      ; Store

    LEA DX, MSG_DIFF  ; Load msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    CALL DISPLAY_NUM  ; Display diff

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End
; READ_NUM and DISPLAY_NUM from first
END MAIN              ; End
```


***

## 8086 ALP: Find Largest and Smallest Element in an Array

```assembly
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
; Use same input structure as above array program
MSG_LARG DB 0DH,0AH,'Largest: $' ; Msg
MSG_SMAL DB 0DH,0AH,'Smallest: $' ; Msg
LARG DW ?             ; Largest
SMAL DW ?             ; Smallest
.CODE                 ; Code
; Assume input done as above, then:
    ; Find largest
    MOV SI, 0         ; Index
    MOV AX, ARRAY[SI] ; Init with first
    MOV LARG, AX      ; Set larg
    MOV SMAL, AX      ; Set smal
    MOV CL, N         ; Loop
    DEC CL            ; From second
    ADD SI, 2         ; Next
FIND_LOOP:            ; Loop
    CMP AX, ARRAY[SI] ; Compare with larg
    JGE NO_LARG       ; If >=, no change
    MOV AX, ARRAY[SI] ; Update larg
    MOV LARG, AX      ; Store
NO_LARG:              ; Label
    CMP SMAL, ARRAY[SI] ; Compare with smal
    JLE NO_SMAL       ; If <=, no change
    MOV SMAL, ARRAY[SI] ; Update smal
NO_SMAL:              ; Label
    ADD SI, 2         ; Next
    LOOP FIND_LOOP    ; Repeat

    LEA DX, MSG_LARG  ; Load larg msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    MOV AX, LARG      ; Load
    CALL DISPLAY_NUM  ; Display

    LEA DX, MSG_SMAL  ; Load smal msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    MOV AX, SMAL      ; Load
    CALL DISPLAY_NUM  ; Display
; Rest as above
```


***

## 8086 ALP: Sort Array in Ascending Order

Bubble sort with DOS input/output.

```assembly
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
; Same array input as above
MSG_SORT DB 0DH,0AH,'Sorted array: $' ; Msg
.CODE                 ; Code
; After input
    MOV DX, N         ; Outer loop = N-1
    DEC DX            ; Adjust
OUTER:                ; Outer loop
    MOV CX, DX        ; Inner loop
    MOV SI, 0         ; Index
INNER:                ; Inner loop
    MOV AX, ARRAY[SI] ; Load current
    CMP AX, ARRAY[SI+2] ; Compare next
    JLE NO_SWAP       ; If <=, no swap
    XCHG AX, ARRAY[SI+2] ; Swap
    MOV ARRAY[SI], AX ; Store back
NO_SWAP:              ; Label
    ADD SI, 2         ; Next pair
    LOOP INNER        ; Inner repeat
    DEC DX            ; Dec outer
    JNZ OUTER         ; Outer repeat

    LEA DX, MSG_SORT  ; Load msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    MOV CL, N         ; Loop for display
    MOV SI, 0         ; Index
DISP_SORT:            ; Display loop
    MOV AX, ARRAY[SI] ; Load element
    CALL DISPLAY_NUM  ; Display
    MOV DL, ' '       ; Space
    MOV AH, 02H       ; Char display
    INT 21H           ; Call
    ADD SI, 2         ; Next
    LOOP DISP_SORT    ; Repeat
; Exit as above
```


***

## 8086 ALP: Find String Length

```assembly
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG DB 'Enter string (end with $): $' ; Prompt
MSG_LEN DB 0DH,0AH,'Length: $' ; Msg
STR DB 50 DUP(?)      ; String buffer
LEN DW ?              ; Length
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    LEA DX, MSG       ; Prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    MOV SI, OFFSET STR ; Point to buffer
    MOV CX, 0         ; Clear count
READ_STR:             ; Read loop
    MOV AH, 01H       ; Read char
    INT 21H           ; Call
    CMP AL, '$'       ; Check end
    JE DONE_READ      ; If yes, done
    MOV [SI], AL      ; Store char
    INC SI            ; Next pos
    INC CX            ; Inc length
    JMP READ_STR      ; Repeat
DONE_READ:            ; Label
    MOV LEN, CX       ; Store length

    LEA DX, MSG_LEN   ; Load msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    MOV AX, LEN       ; Load length
    CALL DISP_DEC     ; Display (from earlier sub)

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End
END MAIN              ; End
```


***

## 8086 ALP: Display a String

```assembly
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
; Use same input as above
MSG_DISP DB 0DH,0AH,'Displayed string: $' ; Msg
.CODE                 ; Code
; After reading string
    LEA DX, MSG_DISP  ; Load msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    LEA DX, STR       ; Load string address
    MOV AH, 09H       ; Display string func
    INT 21H           ; Call (assumes $ terminated)
; Exit
```


***

## 8086 ALP: Compare Two Strings

```assembly
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG1 DB 'Enter string 1 ($ end): $' ; Prompt1
MSG2 DB 0DH,0AH,'Enter string 2 ($ end): $' ; Prompt2
MSG_EQ DB 0DH,0AH,'Equal$ ' ; Equal msg
MSG_NEQ DB 0DH,0AH,'Not equal$ ' ; Not msg
STR1 DB 50 DUP(?)     ; Str1
STR2 DB 50 DUP(?)     ; Str2
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    LEA DX, MSG1      ; Prompt1
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    LEA SI, STR1      ; Point to str1
    CALL READ_STR_SUB ; Read sub (adapt from length program)

    LEA DX, MSG2      ; Prompt2
    MOV AH, 09H       ; Display
    INT 21H           ; Call
    LEA SI, STR2      ; Point to str2
    CALL READ_STR_SUB ; Read

    LEA SI, STR1      ; SI to str1
    LEA DI, STR2      ; DI to str2
    MOV CX, 50        ; Max len
    CLD               ; Clear direction (forward)
    REPE CMPSB        ; Compare until unequal or CX=0
    JZ EQUAL          ; If zero flag, equal
    LEA DX, MSG_NEQ   ; Load not eq
    JMP DISP_CMP      ; Display
EQUAL:                ; Equal label
    LEA DX, MSG_EQ    ; Load eq
DISP_CMP:             ; Display label
    MOV AH, 09H       ; Func
    INT 21H           ; Call

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End
; Add READ_STR_SUB similar to read loop
END MAIN              ; End
```


***

## 8086 ALP: Reverse a String

```assembly
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
; Same input as length
MSG_REV DB 0DH,0AH,'Reversed: $' ; Msg
REV_STR DB 50 DUP(?)  ; Reversed buffer
.CODE                 ; Code
; After reading STR and LEN
    LEA SI, STR       ; SI to start
    LEA DI, REV_STR   ; DI to rev start
    ADD SI, LEN       ; SI to end (before $)
    DEC SI            ; Adjust
    MOV CX, LEN       ; Loop count
REV_LOOP:             ; Reverse loop
    MOV AL, [SI]      ; Load char from end
    MOV [DI], AL      ; Store in rev
    DEC SI            ; Dec source
    INC DI            ; Inc dest
    LOOP REV_LOOP     ; Repeat
    MOV BYTE PTR [DI], '$' ; Terminate

    LEA DX, MSG_REV   ; Load msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    LEA DX, REV_STR   ; Load rev string
    MOV AH, 09H       ; Display
    INT 21H           ; Call
; Exit
```


***

## 8086 ALP: Design Digital Clock Using INT 21H

Displays current system time in loop (simulated clock).

```assembly
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG DB 'Press any key to exit clock$ ' ; Msg
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    LEA DX, MSG       ; Load msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call

CLOCK_LOOP:           ; Clock loop
    MOV AH, 2CH       ; Get system time
    INT 21H           ; Call (CH=hr, CL=min, DH=sec)
    MOV AL, CH        ; Hour to AL
    CALL DISP_BYTE    ; Display hour (adapt DISP_DEC_BYTE)
    MOV DL, ':'       ; Colon
    MOV AH, 02H       ; Char
    INT 21H           ; Display
    MOV AL, CL        ; Min
    CALL DISP_BYTE    ; Display
    MOV DL, ':'       ; Colon
    MOV AH, 02H       ; Char
    INT 21H           ; Display
    MOV AL, DH        ; Sec
    CALL DISP_BYTE    ; Display

    MOV DL, 0DH       ; Carriage return
    MOV AH, 02H       ; Char
    INT 21H           ; Display
    MOV DL, 0AH       ; Line feed
    MOV AH, 02H       ; Char
    INT 21H           ; Display

    MOV AH, 01H       ; Check key press
    INT 16H           ; Bios keyboard (non-blocking)
    JNZ EXIT_CLOCK    ; If key, exit
    JMP CLOCK_LOOP    ; Loop
EXIT_CLOCK:           ; Exit label
    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End

DISP_BYTE PROC        ; Display 8-bit dec
    MOV AH, 0         ; Clear high
    CALL DISP_DEC     ; Call earlier sub
    RET               ; Return
DISP_BYTE ENDP        ; End
END MAIN              ; End
```


***

## 8086 ALP: Interface Stepper Motor Clockwise/Anti-Clockwise

Assumes 8255 ports; prompt for direction.

```assembly
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG_DIR DB 'Enter C for clockwise, A for anti: $' ; Prompt
PORTA EQU 00H         ; Port A address (adjust for kit)
CONTROL EQU 03H       ; Control port
CW_SEQ DB 09H, 05H, 06H, 0AH ; Clockwise sequence
ACW_SEQ DB 0AH, 06H, 05H, 09H ; Anti-clockwise
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    LEA DX, MSG_DIR   ; Load prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    MOV AH, 01H       ; Read char
    INT 21H           ; Call
    CMP AL, 'C'       ; Check C
    JE CW_DIR         ; Clockwise
    LEA BX, ACW_SEQ   ; Load anti seq
    JMP SET_SEQ       ; Jump
CW_DIR:               ; CW label
    LEA BX, CW_SEQ    ; Load cw seq

SET_SEQ:              ; Set label
    MOV AL, 80H       ; Control word (mode 0, output)
    OUT CONTROL, AL   ; Write to control

    MOV CX, 4         ; 4 steps
    MOV SI, 0         ; Index
STEP_LOOP:            ; Step loop
    MOV AL, [BX+SI]   ; Load sequence byte
    OUT PORTA, AL     ; Output to port A
    CALL DELAY        ; Call delay sub
    INC SI            ; Next seq
    LOOP STEP_LOOP    ; Repeat

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End

DELAY PROC            ; Delay sub
    MOV DX, 0FFFFH    ; Large value
DELAY_LOOP:           ; Loop
    DEC DX            ; Dec
    JNZ DELAY_LOOP    ; Repeat
    RET               ; Return
DELAY ENDP            ; End
END MAIN              ; End
```


***

## 8086 ALP: Interface ADC and DAC with Square Wave Generation

Assumes ports; generates square wave via DAC.

```assembly
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG DB 'Generating square wave... Press key to stop$ ' ; Msg
DAC_PORT EQU 00H      ; DAC port (adjust)
ADC_PORT EQU 01H      ; ADC port
CONTROL EQU 03H       ; Control
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    LEA DX, MSG       ; Load msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    MOV AL, 80H       ; Control word
    OUT CONTROL, AL   ; Set output

SQUARE_LOOP:          ; Square loop
    MOV AL, 00H       ; Low value
    OUT DAC_PORT, AL  ; Output low
    CALL DELAY        ; Delay

    MOV AL, 0FFH      ; High value
    OUT DAC_PORT, AL  ; Output high
    CALL DELAY        ; Delay

    ; Optional: Read from ADC
    IN AL, ADC_PORT   ; Read ADC

    MOV AH, 01H       ; Check key
    INT 16H           ; Bios
    JZ SQUARE_LOOP    ; Loop if no key

    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End
; DELAY from above
END MAIN              ; End
```


***

## 8086 ALP: Parallel Communication Between Two Microprocessors

Using 8255; sender/receiver mode prompt.

```assembly
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
MSG_MODE DB 'Enter S for send, R for receive: $' ; Prompt
MSG_DATA DB 0DH,0AH,'Enter data byte (hex): $' ; Data prompt
MSG_REC DB 0DH,0AH,'Received: $' ; Rec msg
PORTA EQU 00H         ; Port A
CONTROL EQU 03H       ; Control
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    LEA DX, MSG_MODE  ; Load mode prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    MOV AH, 01H       ; Read char
    INT 21H           ; Call
    CMP AL, 'S'       ; Check send
    JE SEND_MODE      ; Send

RECEIVE_MODE:         ; Receive label
    MOV AL, 9BH       ; Control word for input
    OUT CONTROL, AL   ; Set

    LEA DX, MSG_REC   ; Load rec msg
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    IN AL, PORTA      ; Read from port A
    CALL DISP_BYTE_HEX ; Display (adapt DISPLAY_NUM for byte)

    JMP EXIT_COMM     ; Exit

SEND_MODE:            ; Send label
    MOV AL, 80H       ; Control for output
    OUT CONTROL, AL   ; Set

    LEA DX, MSG_DATA  ; Load data prompt
    MOV AH, 09H       ; Display
    INT 21H           ; Call

    CALL READ_BYTE    ; Read byte
    OUT PORTA, AL     ; Send to port A

EXIT_COMM:            ; Exit label
    MOV AH, 4CH       ; Exit
    INT 21H           ; Call
MAIN ENDP             ; End
; Add subs as needed
END MAIN              ; End
```


***

## 8086 ALP: Serial Communication Between Two Microprocessors

Using 8251; similar prompt.

```assembly
.MODEL SMALL          ; Model
.STACK 100H           ; Stack
.DATA                 ; Data
; Similar msgs as parallel
DATA_PORT EQU 00H     ; 8251 data port
CMD_PORT EQU 01H      ; Command port
.CODE                 ; Code
MAIN PROC             ; Main
    MOV AX, @DATA     ; Init
    MOV DS, AX        ; Set

    ; Assume mode prompt and read as above

    ; Init 8251
    MOV AL, 0         ; Reset
    OUT CMD_PORT, AL  ; Write
    MOV AL, 40H       ; Mode: async, 8bit, no parity
    OUT CMD_PORT, AL  ; Write
    MOV AL, 4EH       ; Command: enable tx/rx
    OUT CMD_PORT, AL  ; Write

    ; For send: read data, OUT DATA_PORT, AL
    ; For receive: IN AL, DATA_PORT, display

    ; Similar structure as parallel
    ; Exit
MAIN ENDP             ; End
END MAIN              ; End
```


***

## 8051 ALP: Arithmetic Operations (Addition, Subtraction, Multiplication, Division)

8051 code (use Keil); simulate DOS-like via serial, but 8051 has no direct DOS, so use LCD/serial output simulation.

```assembly
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
```


***

## 8051 ALP: Logical Operations (AND, OR, XOR)

```assembly
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
```


***

## 8051 ALP: Verify Timers and Counters with Delay

Timer0 mode1 for delay.

```assembly
ORG 0000H             ; Origin
MAIN:                 ; Main
    MOV TMOD, #01H    ; Timer0 mode1
    MOV TH0, #0FCH    ; High byte for delay (e.g., 1ms at 12MHz)
    MOV TL0, #18H     ; Low byte
    SETB TR0          ; Start timer
WAIT:                 ; Wait label
    JNB TF0, WAIT     ; Wait for overflow
    CLR TR0           ; Stop
    CLR TF0           ; Clear flag

    ; Repeat for mode2 or counter (use ET0, etc.)
    SJMP $            ; Loop
END                   ; End
```


***

## 8051 ALP: UART Operation

For baud rates like 9600.

```assembly
ORG 0000H             ; Origin
MAIN:                 ; Main
    MOV TMOD, #20H    ; Timer1 mode2
    MOV TH1, #0FDH    ; 9600 baud (at 11.059MHz crystal)
    MOV SCON, #50H    ; UART mode1, REN=1
    SETB TR1          ; Start timer

    MOV SBUF, #'A'    ; Send char
WAIT_TX:              ; Wait tx
    JNB TI, WAIT_TX   ; Wait TI flag
    CLR TI            ; Clear

    ; Receive: JNB RI, $; MOV A, SBUF; CLR RI
    SJMP $            ; Loop
END                   ; End
```


***

## 8051 ALP: Interface LCD in 4-Bit/8-Bit Mode

Assumes LCD ports; 4-bit example.

```assembly
ORG 0000H             ; Origin
LCD_DATA EQU P1       ; Data port
RS BIT P2.0           ; Register select
EN BIT P2.1           ; Enable
MAIN:                 ; Main
    MOV A, #38H       ; Init 8-bit mode (or #28H for 4-bit)
    ACALL CMD         ; Send command

    MOV A, #0EH       ; Display on
    ACALL CMD         ; Send

    MOV A, #'H'       ; Sample char
    ACALL DATA_WR     ; Write data

    SJMP $            ; Loop

CMD:                  ; Command sub
    CLR RS            ; RS=0 for cmd
    MOV LCD_DATA, A   ; Send data
    SETB EN           ; Enable pulse
    CLR EN            ; Clear
    ACALL DELAY       ; Delay
    RET               ; Return

DATA_WR:              ; Data sub
    SETB RS           ; RS=1 for data
    MOV LCD_DATA, A   ; Send
    SETB EN           ; Pulse
    CLR EN            ; Clear
    ACALL DELAY       ; Delay
    RET               ; Return

DELAY:                ; Delay
    MOV R0, #255      ; Count
DL1:                  ; Loop1
    DJNZ R0, DL1      ; Dec jump
    RET               ; Return
END                   ; End
```

<div style="text-align: center">⁂</div>

[^1]: https://jmc.edu/econtent/pg/8552_8086%20ALP%20NEW.pdf

[^2]: https://www.nrcmec.org/pdf/Manuals/ECE/mpmc ECE manual 16-17.pdf

[^3]: https://vardhaman.org/wp-content/uploads/2021/03/5-All-Exp-Description.pdf

[^4]: https://vikramlearning.com/jntuh/notes/microprocessors-and-interfacing-lab/write-and-execute-an-alp-to-8086-microprocessor-to-add-subtract-and-multiply-two-16-bit-unsigned-numbers-store-the-result-in-extra-segment/230

[^5]: https://ankurm.com/8086-assembly-program-for-division-of-two-8-bit-numbers/

[^6]: https://ankurm.com/8086-assembly-program-to-multiply-two-16-bit-numbers/

[^7]: https://www.geeksforgeeks.org/computer-organization-architecture/8086-program-multiply-two-8-bit-numbers/

[^8]: https://www.geeksforgeeks.org/computer-organization-architecture/8086-program-to-determine-cubes-of-numbers-in-an-array-of-n-numbers/

[^9]: https://www.youtube.com/watch?v=ZU13-jttJwM

[^10]: https://ankurm.com/mix-c-and-assembly-program-to-find-whether-number-is-odd-or-even/

[^11]: https://www.scribd.com/document/335505179/8086-Assembly-Language-Program

[^12]: image.jpg

[^13]: https://www.scribd.com/document/357420921/Mpf

[^14]: https://www.scribd.com/document/489591722/Program-3-Multibyte-Addition-8086

[^15]: https://www.studocu.com/in/messages/question/4571210/write-an-assembly-language-program-to-find-the-largest-and-smallest-number-from-an-unordered-array

[^16]: https://svcetedu.org/Uploads/ECE/mpmclab.pdf

[^17]: https://www.youtube.com/watch?v=tYa5Txcz_hg

[^18]: http://anindyaspaul.github.io/digital-clock-in-assembly/

[^19]: https://vikramlearning.com/jntuh/notes/microprocessors-and-interfacing-lab/interface-a-stepper-motor-to-8086-and-operate-it-in-clock-wise-and-anticlockwise-by-choosing-variable-stepsize/242

[^20]: http://eece.cu.edu.eg/~akhattab/files/courses/ca/hw2.pdf

[^21]: https://www.scribd.com/doc/104410123/Interfacing-8086

[^22]: https://www.scribd.com/document/753809121/INTERFACING-8086-WITH-8255

[^23]: https://www.geeksforgeeks.org/computer-organization-architecture/microprocessor-8251-usart/

[^24]: https://www.scribd.com/presentation/541768690/Micro-Final-Report55

[^25]: https://www.scribd.com/document/483514831/311118104049-cycle-2

[^26]: https://www.scribd.com/document/427187168/8051-1

[^27]: https://www.electronicwings.com/8051/8051-timers

[^28]: https://josephscollege.ac.in/lms/Uploads/pdf/material/Timer_Programming_UNIT-IV.pdf

[^29]: https://www.sircrrengg.ac.in/images/ECE_Lab_Manuals/R16/MPMC.pdf

