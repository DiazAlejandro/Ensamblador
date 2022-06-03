TITLE
.286

PILA SEGMENT STACK "STACK"
    DB 32 DUP("STACK___")
PILA ENDS

DATOS SEGMENT 
    Arreg DB 3 DUP (0),'$'
    LETRERO DB 'LOS NUMEROS SON: ','$'
    espacio DB 0AH,0DH, '$'
DATOS ENDS 

CODE SEGMENT "CODE"
    ASSUME CS:CODE,DS:DATOS,SS:PILA
    MAIN PROC FAR 
        MOV AX, DATOS
        MOV DS, AX
        LEA BX,Arreg
        MOV SI,0
        MOV CX,3
        ciclo:
            MOV ah,01h
            INT 21h
            MOV BX[SI],al
            INC SI
            LOOP ciclo
        
        MOV AH,09H
        LEA DX,espacio
        INT 21H  
        MOV AH,09H
        LEA DX,LETRERO
        INT 21H
        MOV ah,09h
        LEA DX,Arreg
        INT 21H              
        
     RET
     MAIN ENDP
CODE ENDS
END MAIN