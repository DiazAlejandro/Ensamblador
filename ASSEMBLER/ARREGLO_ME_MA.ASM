.286
DATOS SEGMENT 
    CADENA DB 4 DUP(?),'$'
    LETRERO DB ' INGRESA NUMERO:$'
DATOS ENDS

PILA SEGMENT STACK "STACK"
    
PILA ENDS

CODE SEGMENT "CODE"
    ASSUME CS:CODE,DS:DATOS,SS:PILA
    MAIN PROC FAR
        MOV AX,DATOS          ; MUEVE EL SEGMENTO DE DATOS A AX
        MOV DS,AX             ; MUEVE A DATA SEGMENT,AX

        MOV BX, OFFSET CADENA ; MUEVE LA DIRECCIÓN DE LA CADENA A BX
        MOV SI,0              ; INDICE DEL ARREGLO

        CICLO: 
            ;IMPRIMIR LETRERO DE REFERENCIA
            MOV AH,9H
            LEA DX,LETRERO
            INT 21H 

            ; LEER ENTRADA DE TEXTO 
            MOV AH,01H
            INT 21H

            ; GUARDAR EN EL ARREGLO
            MOV BX[SI], AL ; MOVER LA ENTRADA DEL TECLADO A LA POSICIÓN DEL ARREGLO[SI]
            INC SI         ; SUMA +1 AL INDICE DEL ARREGLO
            CMP SI,3       ; COMPARA SI CON 3 

        JBE CICLO  ; (SI <= 3) REGRESA AL CICLO
        
        ;SALTO DE LINEA
        MOV DL, 10      ; NUEVA LINEA
        MOV AH, 02H     ; INSTRUCCIÓN PARA COLOCAR EL CURSOR
        INT 21H         ; PETICIÓN DE FUNCIÓN AL DOS

        ; IMPRIMIR ARREGLO
        MOV AH,09H
        LEA DX,CADENA
        INT 21H

        MOV CL,3                      ; BASE DE REPETICIÓN DE ACUERDO AL TAMAÑO DEL ARREGLO
        MIENTRAS: CMP CL,3            ; PRIMER CICLO 
            JB IMPRIMIR               ; IMPRIME CUANDO (CL<3)
            INC CL                    ; INCREMENTA EN UNO
        
            MOV SI,0
            MOV DI,1
                CICLO_ORD: 
                    MOV AH,BX[SI]
                    MOV AL,BX[DI]

                    CMP AH,AL
                    JA MOVER
                    JB INCREMENTAR

                    MOVER: 
                        MOV BX[SI],AL
                        MOV BX[DI],AH
                        JMP INCREMENTAR 

                    INCREMENTAR:
                        INC SI
                        INC DI
                    CMP SI,3
                JB CICLO_ORD
            JMP MIENTRAS

        IMPRIMIR:
            ;SALTO DE LINEA
                MOV DL, 10      ; NUEVA LINEA
                MOV AH, 02H     ; INSTRUCCIÓN PARA COLOCAR EL CURSOR
                INT 21H         ; PETICIÓN DE FUNCIÓN AL DOS
            ; IMPRIMIR ARREGLO 
                MOV AH,09H
                LEA DX,CADENA
                INT 21H

        
        RET
    MAIN ENDP
CODE ENDS 
END MAIN