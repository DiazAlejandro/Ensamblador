PILA SEGMENT STACK "STACK"
    DB 32 DUP('STACK___')
PILA ENDS

DATOS SEGMENT 
    A DB (?)
    B DB (?)
    LETRERO DB 'EL NÚMERO MAYOR ES: ','$'
    LETRERO2 DB 'SON IGUALES:', '$'
DATOS ENDS 

CODE SEGMENT "CODE"
    ASSUME CS:CODE,DS:DATOS,SS:PILA
    MAIN PROC FAR 
        PUSH DS
        PUSH 0
        MOV AX, DATOS
        MOV DS, AX 

        MOV AH,01H
        INT 21H
        MOV A,AL
        MOV AH,01H
        INT 21H
        
        CMP A,AL
            JA MAYORA ; a > B
            JE IGUALES ; A = B 
            JMP MAYORB
        MAYORA: MOV AH,09H
                LEA DX,LETRERO
                INT 21H
                MOV DL,A
                MOV AH,02H
                INT 21H
                JMP FIN

        IGUALES:MOV AH,09H
                LEA DX,LETRERO2
                INT 21H
                JMP FIN

        MAYORB: MOV AH,09H
                LEA DX,LETRERO
                INT 21H
                MOV DL,B
                MOV AH,02H
                INT 21H
                JMP FIN
        FIN: RET
    MAIN ENDP
CODE ENDS
END MAIN
             
