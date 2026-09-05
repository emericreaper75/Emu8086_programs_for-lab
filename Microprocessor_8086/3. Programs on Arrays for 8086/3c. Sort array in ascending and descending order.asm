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
