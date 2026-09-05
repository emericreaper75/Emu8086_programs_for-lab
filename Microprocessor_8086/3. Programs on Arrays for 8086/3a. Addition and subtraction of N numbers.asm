; ## 8086 ALP: Addition and Subtraction of N Numbers (Array)
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
