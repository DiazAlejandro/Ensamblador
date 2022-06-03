.286
DATOS SEGMENT 
    CADENA DB 4 DUP(?),'$'
    LETRERO DB ' INGRESA NUMERO:$'
    SALTO DB 0AH, '$'
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
        MOV AH, 09H  
        LEA DX, SALTO
        INT 21H

        ; IMPRIMIR ARREGLO
        MOV AH,09H
        LEA DX,CADENA
        INT 21H

        ; ORDENAR ARREGLO DE MAYOR A MENOR
        MOV CL,3                      ; BASE DE REPETICIÓN DE ACUERDO AL TAMAÑO DEL ARREGLO
        MIENTRAS: CMP CL,3            ; PRIMER CICLO 
            JB IMPRIMIR               ; IMPRIME CUANDO (CL<3)
            INC CL                    ; INCREMENTA EN UNO
            ; INDICE DE REFERENCIA PARA MOVERSE DENTRO DEL ARREGLO
            MOV SI,0
            MOV DI,1

            CICLO_ORD:                ; SEGUNDO CICLO    
                MOV AL,BX[SI]         ; MOVER A 'AL' EL VALOR EN LA POSICION BX[SI]
                MOV AH,BX[DI]         ; MOVER A 'AH' EL VALOR EN LA POSICION BX[DI]

                CMP AL,AH             ; COMPARA AL,AH
                JB MAYOR              ; CUANDO AL>AH       
                JA MENOR              ; CUANDO AL<AH

                MAYOR: ; 1 4 
                    MOV BX[SI],AH     ; CAMBIA LOS VALORES
                    MOV BX[DI],AL
                    JMP INCREMENTAR   ; INCREMENTA LOS INDICES

                MENOR:                ; CUANDO ES MENOR AL<AH SOLO INCREMENTA
                    JMP INCREMENTAR

                INCREMENTAR:          ; INCREMENTA LOS INDICES
                    INC SI
                    INC DI
                
                CMP SI,3
            JBE CICLO_ORD             ; REGRESA AL SEGUNDO CICLO CUANDO (SI<=3)
        JMP MIENTRAS                  ; REGREGSA AL CICLO PRINCIPAL

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