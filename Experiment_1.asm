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
