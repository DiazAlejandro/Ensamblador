.MODEL SMALL
INCLUDE PO2.lib
.STACK
.486

.DATA
    SALTO    DB 0AH, 0DH, '$'
    OPCIONES DB 'MENU','$'
    OPC1     DB '1) INGRESAR CADENA','$'
    OPC2     DB '2) ESCANEAR CARACTER','$'
    OPC3     DB '3) SALIR','$'
    COORDX   DB(?), '$'
    COORDY   DB(?), '$'
    LETRERO1 DB 'INGRESE UNA CADENA: ','$'
    CADENA1  DB 5 DUP (?)
    CONTINUAR DB 'CONTINUAR...','$'
    BANDERA   DW 'F','$'
    EXISTE_C  DB 'NO HAY CADENA','$'
    EXISTE_V  DB 'HAY CADENA','$'
    PEDIR_C   DB 'INGRESE CARACTER ','$'
    VAR       DB (?), '$'
    NOTFOUND  DB 'NO EXISTE EL CARACTER EN LA CADENA','$'
    AUX_POS   DB (?),'$'

.CODE    
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX
    
    MENU: 
        CALL CLEAN
        PRINT_RC 5,38
        PRINT OPCIONES
        PRINT_RC 6,30
        PRINT OPC1
        PRINT_RC 7,30
        PRINT OPC2
        PRINT_RC 8,30
        PRINT OPC3
        
    CLIC:
        MOV AX,01H
        INT 33H
        MOV AX,05H
        INT 33H
        
        CMP BX, 1 
        JE FUNCION_MENU
        CMP BX, 0
        JMP CLIC
        
    FUNCION_MENU:
        CONVERT_COORD COORDX, CX
        CONVERT_COORD COORDY, DX
        CMP COORDX,29
        JB  CLIC
        CMP COORDY, 6
        JE  VALIDACION10
        CMP COORDY, 7
        JE  VALIDACION20
        CMP COORDY, 8
        JE  VALIDACION30
        JMP CLIC
    
    INGRESAR_CAD: 
        CALL CLEAN
        PRINT_RC 7, 30
        PRINT LETRERO1
        PRINT_RC 8, 30
        INGRESA_CAD CADENA1
        PRINT_RC 10, 30
        PRINT CONTINUAR
        MOV BANDERA,'V'
        CALL PAUSE
        CALL CLEAN
        JMP MENU
    
    INGRESAR_CAR:
        CALL CLEAN 
        MOV SI, BANDERA
        MOV DI, 'F'
        CMPSW 
            JE  SIN_CADENA
            JNE BUSCAR_CARACTER 
        
       
        BUSCAR_CARACTER:
            PRINT_RC 10, 30
            PRINT EXISTE_V 
            PRINT_RC 11, 30
            PRINT PEDIR_C
            CALL LEER
            MOV VAR,AL
            MOV DI, OFFSET CADENA1
            MOV CX, 5
            CLD
            REPNE SCASB
            JNZ NOT_FOUND
        
            MOV DI,0
            MOV AUX_POS, 30
        FIND_CAR:
            MOV BL,CADENA1[DI]
            CMP BL,VAR
            JE PRINT_CARACTER
            PRINT_RC 13, AUX_POS
            PRINT_COLOR BL,0FH
            INC AUX_POS
            INC DI
            CMP DI,5
            JB FIND_CAR
            CALL PAUSE
            JMP MENU
        
        PRINT_CARACTER:
            PRINT_RC 13, AUX_POS
            INC AUX_POS
            PRINT_COLOR BL,03H
            INC DI
            CMP DI,5
            JB FIND_CAR
            CALL PAUSE
            JMP MENU 
      
        SIN_CADENA: 
            CALL CLEAN
            PRINT_RC 7H, 1EH
            PRINT EXISTE_C 
            CALL PAUSE
            CALL CLEAN
            JMP MENU
     
        NOT_FOUND:
            PRINT_RC 13, 30
            PRINT NOTFOUND
            CALL PAUSE
            JMP MENU
   
    VALIDACION10:
        CMP COORDX, 47
        JA  CLIC
        JMP INGRESAR_CAD
    VALIDACION20:
        CMP COORDX, 49
        JA  CLIC
        JMP INGRESAR_CAR
    VALIDACION30:
        CMP COORDX, 37
        JA  CLIC
        JMP FIN

    FIN: 
        .EXIT
        RET
        
MAIN ENDP

    
END MAIN
