; ## 8086 ALP: Find Largest and Smallest Element in an Array
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
