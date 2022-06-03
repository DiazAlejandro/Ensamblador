.286
DATOS SEGMENT 
    DATO1   DB (?)
    LETRERO DB 'INGRESA NUMERO:$'
    SALTO   DB 0AH, 0DH, '$'
    RESULT  DB (?),'$'
DATOS ENDS

PILA SEGMENT STACK "STACK"
PILA ENDS

CODE SEGMENT "CODE"
    ASSUME CS:CODE,DS:DATOS,SS:PILA
    MAIN PROC FAR

        MOV AX,DATOS         
        MOV DS,AX            

        CALL READ 
            MOV DATO1,AL
        CALL READ 
            ADD AL,DATO1
            SUB AL,30h
            MOV RESULT,AL

        ;SALTO DE LINEA
        MOV DL, 10      
        MOV AH, 02H     
        INT 21H 
             
        MOV AH,09H       
        LEA DX,RESULT
        INT 21H          
        RET
    MAIN ENDP

    READ PROC
        ;IMPRIMIR LETRERO DE REFERENCIA
        MOV AH,9H
        LEA DX,LETRERO
        INT 21H 
        ; LEER ENTRADA DE TEXTO
        MOV AH,01H
        INT 21H
        RET
    READ ENDP

CODE ENDS 
END MAIN