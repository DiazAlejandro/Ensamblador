.286
DATOS SEGMENT 
    ARREGLO DB 3 DUP(?),'$'
    LETRERO DB ' INGRESA NUMERO:$'
DATOS ENDS

PILA SEGMENT STACK "STACK"
    
PILA ENDS

CODE SEGMENT "CODE"
    ASSUME CS:CODE,DS:DATOS,SS:PILA
    MAIN PROC FAR
        MOV AX,DATOS         
        MOV DS,AX            

        LEA BX,ARREGLO
        MOV SI,0             

        MOV CX,3 ; TAMAÑO DEL ARREGLO

        ETIQUETA: 
            ;IMPRIMIR LETRERO DE REFERENCIA
            MOV AH,9H
            LEA DX,LETRERO
            INT 21H 

            ; LEER ENTRADA DE TEXTO 
            MOV AH,01H
            INT 21H

            ; GUARDAR EN EL ARREGLO
            MOV BX[SI], AL 
            INC SI         
        LOOP ETIQUETA

        ;SALTO DE LINEA
        MOV DL, 10      
        MOV AH, 02H     
        INT 21H         

        ; IMPRIMIR ARREGLO
        MOV AH,09H
        LEA DX,ARREGLO
        INT 21H
    MAIN ENDP
CODE ENDS 
END MAIN