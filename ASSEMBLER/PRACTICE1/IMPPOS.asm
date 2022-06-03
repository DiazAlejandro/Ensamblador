; ESCRIBIR EN UNA POSICI?N DE PANTALLA

PRINT MACRO CADENA
    MOV AH,09H
    LEA DX,CADENA
    INT 21H
ENDM

.286
.MODEL SMALL 
.STACK

.DATA
    LETRERO DB 'HOLA$'
.CODE
    MAIN PROC FAR 
        MOV AX,@DATA
        MOV DS,AX
        CALL POSICION_CURSOR
        PRINT LETRERO
    .EXIT     
    MAIN ENDP   

    ; ****************************************
    ; PROCEDIMIENTO PARA POSICIONAR EL CURSOR
    ; ****************************************
    POSICION_CURSOR PROC
        MOV AH,02H  ; FUNCI?N PARA COLOCAR EL CURSOR
        MOV DH,0CH  ; 12 EN DECIMAL - FILA
        MOV DL,28H  ; 40 EN DECIMAL - COLUMNAS
        INT 10H
        RET
    ENDP

END MAIN 