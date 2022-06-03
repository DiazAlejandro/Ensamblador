PRINT MACRO CADENA
    MOV AH,09H
    LEA DX,CADENA
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

.286
.MODEL SMALL 
.STACK

.DATA
    CADENA1 DB 5 DUP (?)
    CADENA2 DB 5 DUP (?)
    PEDIR   DB 'INGRESA CADENA:','$'
    
    SALTO   DB 0AH, 0DH, '$'
    LETRERO DB 'CADENAS FINALES:','$'
    CADIF   DB 'CADENAS DIFERENTES','$'
    CADIG   DB 'CADENAS IGUALLES','$'
    
    QUEST   DB '?DESEA COMPARAR OTRA CADENA?','$'
    BANDERA DB 'S','$'
    OPC     DB ?,'$'

.CODE
    MAIN PROC FAR 
        REPETIR: 
            MOV AX,@DATA
            MOV DS,AX
            MOV ES,AX
            
            PRINT PEDIR
            INGRESA_CAD CADENA1
            PRINT SALTO

            PRINT PEDIR
            INGRESA_CAD CADENA2
            PRINT SALTO
            
            LEA SI,CADENA2
            LEA DI,CADENA1

            MOV CX,4
            REP CMPSB     
            JNE DIFERENTE
            JE  IGUAL
        
        DIFERENTE:
            PRINT SALTO
            PRINT CADIF
            JMP PREGUNTA
        
        IGUAL:
            PRINT SALTO
            PRINT CADIG
            JMP PREGUNTA
        
        PREGUNTA: 
            PRINT SALTO
            PRINT QUEST
            CALL LEER
            CMP BANDERA,AL 
            JE 
            
            
            
        FIN: .EXIT
    MAIN ENDP   
    
    LEER PROC
        MOV AH,01H
        INT 21H
        RET
    ENDP
END MAIN 