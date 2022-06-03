.286
PRINT_COLOR MACRO CARACTER, LETRA
    MOV AH,09H      
    MOV AL,CARACTER 
    MOV BL,LETRA    
    MOV CX,1         
    INT 10H        
ENDM

PRINT_C MACRO CARACTER 
    MOV AH,02H
    MOV DL,CARACTER
    INT 21H
ENDM

PRINT MACRO CADENA
    MOV AH,09H
    LEA DX,CADENA
    INT 21H
ENDM

CLIC MACRO
    ESPERA:
        MOV AX, 03H
        INT 33H
        CMP BX, 01
        JE CLIC_IZQ
        JMP ESPERA
ENDM

CONVERT_COORD MACRO COORDXY, REG
    MOV AX, REG
    MOV BL, 8
    DIV BL
    MOV COORDXY, AL
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

PRINT_RC MACRO FILA, COLUMNA
    MOV AH,02H      
    MOV DH,FILA     
    MOV DL,COLUMNA  
    INT 10H
ENDM

.MODEL SMALL
.STACK

.DATA
    SALTO  DB 0AH, 0DH, '$'
    OPC1   DB '1. LEER CADENA','$'
    OPC2   DB '2. ESCANEAR CADENA','$'
    OPC3   DB '3. SALIR','$'
    COORDX DB(?), '$'
    COORDY DB(?), '$'
    LETRERO1 DB 'INGRESE UNA CADENA: ','$'
    CADENA1  DB 5 DUP (?)
    LETRERO2 DB 'INGRESE CARACTER: ','$'
    COINC  DB 'SE ENCUENTRA EN LA CADENA','$'
    SINRE  DB 'NO SE ENCUENTRA EN LA CADENA','$'
    PEDIR  DB 'INGRESA CARACTER:','$'
    CONTINUAR DB 'CONTINUAR...','$'
    NOHAYC DB 'NO HAY CADENA','$'
    A   DB 0    ; VALOR L?MITE 
    BAN DB (?),'$'
    VAR DB(?),'$'
    
.CODE
    MAIN PROC FAR 
        MOV AX, @DATA
        MOV DS, AX 
        MOV ES, AX
        INICIO: 
        MOV AX, 00H 
        INT 33H
        
        MENU: 
            PRINT_RC 7, 30
            PRINT OPC1
            PRINT SALTO
            PRINT_RC 8, 30
            PRINT OPC2
            PRINT SALTO
            PRINT_RC 9, 30
            PRINT OPC3
        CLIC_FNT:    
            MOV AX, 01H 
            INT 33H  
            CLIC
            
            VAL1: 
            CMP COORDX, 44
                JA INICIO 
                JMP OPCION1
                
        CLIC_IZQ:
            CONVERT_COORD COORDX, CX
            CONVERT_COORD COORDY, DX
            CMP COORDY, 7
            JE OPCION1
            CMP COORDY, 8
            JE OPCION2
            CMP COORDY, 9
            JE OPCION3

        OPCION1:
            CALL CLEAN
            PRINT_RC 7H, 1EH
            PRINT LETRERO1
            INGRESA_CAD CADENA1
            PRINT CONTINUAR
            CALL CLEAN
            JMP MENU
            
        OPCION3: 
        .EXIT
                    
        OPCION2:
            CALL CLEAN
            CMP BAN,0
            JE OPCION1
            PRINT_RC 7H, 1EH
            PRINT PEDIR            
            
    ENDP
    CLEAN PROC
        MOV AH,0Fh  
        int 10H  
        MOV AH, 0
        INT 10H
    CLEAN ENDP
    
    LEER PROC
        MOV AH,01H
        INT 21H
    LEER ENDP
    
    PAUSE PROC NEAR
        MOV AH, 07H
        INT 21H
        RET
    PAUSE ENDP
END MAIN