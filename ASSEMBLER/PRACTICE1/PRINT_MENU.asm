; DESE?AR LAS POSICIONES DE UN MENU EN PANTALLA

PRINT MACRO CADENA
    MOV AH,09H
    LEA DX,CADENA
    INT 21H
ENDM

POSICION MACRO FILA, COLUMNA
    MOV AH,02H  ; FUNCI?N PARA COLOCAR EL CURSOR
    MOV DH,FILA  ; 12 EN DECIMAL - FILA
    MOV DL,COLUMNA  ; 40 EN DECIMAL - COLUMNAS
    INT 10H
    
ENDM

.286
.MODEL SMALL 
.STACK

.DATA
    LETRERO DB 'MENU (INTRODUCE OPCI?N)$'
.CODE
    MAIN PROC FAR 
        MOV AX,@DATA
        MOV DS,AX
        POSICION 0CH, 28H
        PRINT LETRERO
    .EXIT     
    MAIN ENDP   
END MAIN 