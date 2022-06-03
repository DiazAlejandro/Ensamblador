.286
;*************** MACROS **************
PRINT MACRO CADENA
    MOV AH,09H
    LEA DX,CADENA
    INT 21H
ENDM

POSICION MACRO FILA, COLUMNA
    MOV AH,02H  ; FUNCI?N PARA COLOCAR EL CURSOR
    MOV DH,FILA  ; 25 EN DECIMAL - FILA
    MOV DL,COLUMNA  ; 80 EN DECIMAL - COLUMNAS
    INT 10H
ENDM

.MODEL SMALL 
.STACK
.DATA
    CADENA1 DB 'MOUSE ACTIVO :)','$'
    
    COORDX  DW ?,'$'
    COORDY  DW ?,'$'
.CODE
    MAIN PROC FAR 
        MOV AX,@DATA
        MOV DS,AX
        
        ;RESTABLECER Y OBTENER EL ESTADO DEL MOUSE
        MOV AX,0
        INT 31H
        CMP AX,0
        JNE IMPRIMIR
        
        ;MOSTRAR EL PUNTERO DEL RAT?N 
        MOV AX,1
        INT 33H
        
        ;OCULTAR EL PUNTERO DEL RAT?N 
        ;MOV AX,2
        ;INT 33H
        
        ;OBTENER POSICI?N Y ESTADO DEL RAT?N 
        MOV AX,3
        INT 33H
        TEST BX,1
        JNE BTN_IZQUIERDO
        MOV COORDX, CX
        MOV COORDY, DX
        
        BTN_IZQUIERDO:
            POSICION 4H, 14H 
            PRINT COORDX
        ; LIMITES HORIZONTALES Y VERTICALES
        MOV AX,7
        MOV CX,40
        MOV DX,10
        INT 33H
        
        MOV AX,8
        INT 33H
        MOV CX,400
        MOV DX,50
        INT 33H
        IMPRIMIR: 
            PRINT CADENA1
            
    ENDP
END MAIN

