; ---------------------------------------------------------
; ALP to reverse a string and check if it is a palindrome
; ---------------------------------------------------------
.MODEL SMALL                    ; small memory model
.STACK 100H                     ; 256-byte stack
.DATA                           ; data segment starts
    STR1       DB 'MADAM$'      ; input string, '$' marks its end
    LEN        DW ?             ; will hold the string length (uninitialized word)
    REV        DB 20 DUP('$')   ; buffer for reversed string, pre-filled with '$'
    MSG_REV    DB 13,10,'Reversed string: $'          ; label text for reversed string
    MSG_PAL    DB 13,10,'The string IS a palindrome$' ; message if palindrome
    MSG_NOTPAL DB 13,10,'The string is NOT a palindrome$' ; message if not

.CODE                           ; code segment starts
MAIN PROC                       ; begin MAIN procedure
    MOV AX,@DATA                 ; load data segment address
    MOV DS,AX                    ; set DS to access our variables

    ; ---- find string length ----
    LEA SI,STR1                  ; SI = address of first character of STR1
    MOV CX,0                     ; CX will count characters, start at 0
FINDLEN:                         ; label: length-finding loop
    CMP BYTE PTR [SI],'$'         ; check if current byte is the terminator '$'
    JE DONE_LEN                   ; if yes, length found, exit loop
    INC SI                        ; move to next character
    INC CX                        ; increment character count
    JMP FINDLEN                   ; repeat until '$' found
DONE_LEN:                        ; label: length found
    MOV LEN,CX                    ; store the computed length in LEN

    ; ---- reverse the string ----
    LEA SI,STR1                  ; SI = start of original string again
    ADD SI,CX                    ; SI = start + length -> points just past last char
    DEC SI                        ; SI now points to the LAST character of STR1
    LEA DI,REV                    ; DI = address of the reversed-string buffer
    MOV CX,LEN                    ; CX = number of characters to copy
REVLOOP:                          ; label: reversal loop
    MOV AL,[SI]                    ; AL = character from the end of STR1
    MOV [DI],AL                    ; copy it into REV buffer (front to back)
    DEC SI                         ; move source pointer backward (towards start)
    INC DI                         ; move destination pointer forward
    LOOP REVLOOP                   ; decrement CX, repeat until all chars copied
    MOV BYTE PTR [DI],'$'          ; terminate the reversed string with '$'

    ; ---- display reversed string ----
    LEA DX,MSG_REV                ; DX = address of "Reversed string:" label
    MOV AH,09H                    ; DOS function to display a string
    INT 21H                       ; print the label
    LEA DX,REV                    ; DX = address of the reversed string
    MOV AH,09H                    ; DOS display-string function again
    INT 21H                       ; print the reversed string

    ; ---- palindrome check: compare original vs reversed ----
    LEA SI,STR1                   ; SI = start of original string
    LEA DI,REV                    ; DI = start of reversed string
    MOV CX,LEN                    ; CX = number of characters to compare
CMPLOOP:                          ; label: comparison loop
    MOV AL,[SI]                    ; AL = character from original string
    MOV BL,[DI]                    ; BL = character from reversed string
    CMP AL,BL                      ; compare the two characters
    JNE NOTPAL                     ; if they differ, it's not a palindrome
    INC SI                         ; move to next character in original
    INC DI                         ; move to next character in reversed
    LOOP CMPLOOP                   ; decrement CX, repeat until all compared

    LEA DX,MSG_PAL                ; all characters matched: DX = palindrome message
    MOV AH,09H                    ; DOS display-string function
    INT 21H                       ; print "IS a palindrome"
    JMP EXITPGM                   ; skip the not-palindrome branch

NOTPAL:                           ; label: mismatch found
    LEA DX,MSG_NOTPAL             ; DX = not-a-palindrome message
    MOV AH,09H                    ; DOS display-string function
    INT 21H                       ; print "NOT a palindrome"

EXITPGM:                          ; label: common exit point
    MOV AH,4CH                    ; DOS function to terminate program
    INT 21H                       ; return control to DOS
MAIN ENDP                        ; end of MAIN procedure
END MAIN                         ; end of program, entry point is MAIN
