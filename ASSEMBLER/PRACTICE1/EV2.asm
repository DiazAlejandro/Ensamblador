.MODEL SMALL
INCLUDE EV2.lib
.STACK
.486

.DATA
    OPCIONES  DB 'MENU','$'
    OPC1      DB '1) LEER CADENA','$'
    OPC2      DB '2) ESCANEAR CADENA','$'
    OPC3      DB '3) SALIR','$'
    COORDX    DB (?), '$'
    COORDY    DB (?), '$'
    MSGCAD    DB 'INSERTE CADENA: ','$'
    CAD1      DB  5 DUP(),'$'
    BANDERA   DW 'F','$'
    CONTINUAR DB 'CONTINUAR...','$'
    MSGCAR    DB 'INSERTE CARACTER : ','$'
    NO_EXISTE DB '!NO EXISTE ALGUNA CADENA!','$'
    AUX2      DB (?),'$'
    AUX3      DB (?),'$'
    POS       DB 'POSICION: ','$'
    VACIO     DB '               ','$'

.CODE    
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX
    
    MENU: 
        CALL CLEAN
        PRINT_RC 5,34
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
        CMP COORDX, 30
        JB  CLIC
        CMP COORDY, 6
        JE VALIDACION10
        CMP COORDY, 7
        JE VALIDACION20
        CMP COORDY, 8
        JE VALIDACION30
        JMP CLIC
    
    READ_CAD:
        CALL CLEAN
        PRINT_RC 7,30
        PRINT MSGCAD
        PRINT_RC 8, 30
        INGRESA_CAD CAD1
        PRINT_RC 10, 30
        PRINT CONTINUAR
        MOV BANDERA,'V'
        CALL PAUSE
        CALL CLEAN
        JMP MENU
    
    READ_CAR:
        CALL CLEAN 
        MOV SI, BANDERA
        MOV DI, 'F'
        CMPSW 
            JE  SIN_CADENA
            JNE SELECCIONAR
    
    SELECCIONAR:
        CALL CLEAN 
        PRINT_RC 7, 30
        PRINT CAD1
 
    CLIC2:
        MOV AX,01H
        INT 33H
        MOV AX,03H
        INT 33H
        
        TEST BX, 1 
        JNE IZQ
        JMP CLIC2
    IZQ:
        CONVERT_COORD COORDX, CX
        CONVERT_COORD COORDY, DX
        CMP COORDY, 24
        JE MENU
        CMP COORDY, 7
        JB CLIC2
        CMP COORDY, 8
        JAE CLIC2
        
        PRINT_RC 09,44
        PRINT VACIO
        
        PRINT_RC COORDY, COORDX
        GET_CARACTER_POSICION
        
        MOV SI,0
        MOV AUX2, 30H
        MOV AUX3, 44
        SEARCH: 
            CMP CAD1[SI],AL
            JE FOUND
            INC SI
            INC AUX2
            CMP CAD1[SI],'$'
            JE PRINT_RESULT
            JMP SEARCH
        FOUND:
            INC SI
            INC AUX2
            PRINT_RC 09, AUX3
            INC AUX3
            PRINT AUX2

            INC AUX3
            JMP SEARCH
 
        PRINT_RESULT:
            MOV SI,0        
            PRINT_RC 9,30
            PRINT POS
            JMP CLIC2 
        
    SIN_CADENA: 
        CALL CLEAN
        PRINT_RC 7, 30
        PRINT NO_EXISTE 
        CALL PAUSE
        CALL CLEAN
        JMP MENU   
        
    VALIDACION10:
        CMP COORDX, 43
        JA  CLIC
        JMP READ_CAD
        
    VALIDACION20:
        CMP COORDX, 47
        JA CLIC 
        JMP READ_CAR

    VALIDACION30:
        CMP COORDX, 38
        JA CLIC 
        JMP FIN
        
     FIN: 
        CALL CLEAN 
        .EXIT
        RET
MAIN ENDP
    
END MAIN