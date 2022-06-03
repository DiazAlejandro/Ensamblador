.286
.MODEL SMALL 
.STACK

;********** MACROS ***********
PRINT MACRO CADENA
    MOV AH,09H
    LEA DX,CADENA
    INT 21H
ENDM

PRINT_C MACRO CARACTER 
    MOV AH,02H
    MOV DL,CARACTER
    INT 21H
ENDM

INGRESA_CAD MACRO CADENA
        LOCAL CICLO 
        MOV BX, OFFSET CADENA
        MOV SI,0     
        CICLO: 
            CALL LEER 
            MOV BX[SI],AL
            INC SI
            CMP SI,4
        JBE CICLO   
ENDM


.DATA
    CADENA1 DB 5 DUP (?)
    PEDIR   DB 'INGRESA CADENA:','$'
    PEDIR_C DB 'INGRESA CARACTER:','$'
    SALTO   DB 0AH, 0DH, '$'
    COINC DB 'SE ENCUENTRA EN LA CADENA','$'
    SINRE DB 'NO SE ENCUENTRA EN LA CADENA','$'
    POSICION DW ?,'$'

.CODE
    MAIN PROC FAR 
    
        REPEAT_:        
        MOV AX,@DATA
        MOV DS,AX
        MOV ES,AX
        
        ;PEDIR CADENA 
        PRINT PEDIR
        INGRESA_CAD CADENA1
        PRINT SALTO
        
        ;PEDIR CARACTER QUE SE GUARDA EN AL
        PRINT PEDIR_C
        CALL LEER
        
        ;MOVER LA DIRECCI?N DE LA CADENA Y FIJAR EL CONTADOR
        MOV DI, OFFSET CADENA1
        MOV CX, 5
        MOV POSICION,1
        REPET:
        ;CICLO PARA BUSCAR EN LA CADENA
        CLD                ; DIRECCI?N = AVANCE
        REPNE SCASB        ; REPITE MIENTRAS NO SEA IGUAL
        JNZ SALIR          ; TERMINA SI NO ENCONTR? LA LETRA
        JZ COINCIDENCIA    ; SI ENCUENTRA LA COINCIDENCIA
        DEC DI
        
        SALIR: 
            PRINT SALTO
            PRINT SINRE 
            INC POSICION
            JMP FIN
            
        COINCIDENCIA:
            PRINT SALTO
            PRINT COINC
            PRINT SALTO
            
            PRINT POSICION
            INC POSICION
            PRINT SALTO
            CMP POSICION,0
            JNE REPET
            JMP FIN
            
        FIN: 
            RET
        
    MAIN ENDP   
    
    LEER PROC
        MOV AH,01H
        INT 21H
        RET
    ENDP
    
END MAIN 