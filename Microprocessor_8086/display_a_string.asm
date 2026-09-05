; ## 8086 ALP: Display a String
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
