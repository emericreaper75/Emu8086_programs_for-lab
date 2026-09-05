; ----------------------------------
; Sort array in Ascending Order
; ----------------------------------

; ## 8086 ALP: Sort Array in Ascending Order
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

; ------------------------------
; Sort  array DESCENDING order 
; ------------------------------
.MODEL SMALL                   ; use small memory model (1 code + 1 data segment)
.STACK 100H                    ; reserve 256 bytes for the stack
.DATA                          ; start of data segment
    ARR   DB 5,3,8,1,9,2       ; the array of 6 bytes to be sorted
    N     EQU 6                ; N = number of elements in the array (constant)
    MSG1  DB 13,10,'Descending Sorted Array: $'  ; message string, CR/LF then text, '$' terminates it

.CODE                          ; start of code segment
MAIN PROC                      ; begin procedure MAIN
    MOV AX,@DATA                ; load data segment address into AX
    MOV DS,AX                   ; copy it into DS so we can access ARR/MSG1

    MOV CX,N-1                  ; outer loop counter = N-1 (bubble sort passes)
OUTER:                          ; label: start of outer loop
    PUSH CX                     ; save outer loop counter on stack (CX reused below)
    LEA SI,ARR                  ; SI = address of the first array element
INNER:                          ; label: start of inner comparison loop
    MOV AL,[SI]                  ; AL = current element
    MOV AH,[SI+1]                ; AH = next element
    CMP AL,AH                    ; compare current vs next
    JAE SKIP                     ; if AL >= AH, already descending, skip swap
    XCHG AL,AH                   ; otherwise swap the two values in registers
    MOV [SI],AL                  ; write swapped value back to current position
    MOV [SI+1],AH                ; write swapped value back to next position
SKIP:                            ; label: no-swap landing point
    INC SI                       ; move pointer to next element
    LOOP INNER                   ; decrement CX, repeat INNER until CX=0
    POP CX                       ; restore outer loop counter from stack
    LOOP OUTER                   ; decrement CX, repeat OUTER until CX=0

    ; ---- display result ----
    LEA DX,MSG1                  ; DX = address of message string
    MOV AH,09H                   ; DOS function 09H = display string
    INT 21H                      ; call DOS interrupt to print MSG1

    LEA SI,ARR                   ; SI = address of first array element again
    MOV CX,N                     ; CX = number of elements to print
PRINT:                           ; label: print loop
    MOV DL,[SI]                   ; DL = current array element (numeric value)
    ADD DL,30H                    ; convert single digit 0-9 to its ASCII code
    MOV AH,02H                    ; DOS function 02H = display single character
    INT 21H                       ; print the digit character in DL
    MOV DL,' '                    ; DL = space character (separator)
    INT 21H                       ; print the space
    INC SI                        ; move to next array element
    LOOP PRINT                    ; decrement CX, repeat until all elements printed

    MOV AH,4CH                   ; DOS function 4CH = terminate program
    INT 21H                      ; return control to DOS
MAIN ENDP                       ; end of procedure MAIN
END MAIN                        ; end of program, MAIN is the entry point
