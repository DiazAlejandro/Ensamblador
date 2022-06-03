PILA SEGMENT STACK "STACK"
    DB 32 DUP('STACK___')
PILA ENDS

DATOS SEGMENT 
    A DB (0),'$'
    B DB (?),'$'
DATOS ENDS 

CODE SEGMENT "CODE"
    ASSUME CS:CODE,DS:DATOS,SS:PILA
    MAIN PROC FAR 
        PUSH DS
        PUSH 0 

        MOV AX,DATOS
        MOV DS,AX
        ;LEO EL PRIMER VALOR 
        MOV AH,01H
        INT 21H
        MOV A,AL

        ;LEO EL SEGUNDO VALOR
        MOV AH,01H
        INT 21H
        MOV B,AL

        ;SENTENCIA IF
        MOV AH,A
        CMP AH,B
        JA SUMAB
        ADD A,1
            ;IMPRIME EL VALOR DE A
            MOV AH,09H
            MOV DX, OFFSET A
            INT 21H
            JMP FIN
        
        SUMAB: ADD B,1
        ;IMPRIME EL VALOR DE B
        
        MOV AH,09H
        LEA DX,B
        INT 21H

        FIN: RET
    ENDP MAIN
CODE ENDS
END MAIN
