.MODEL SMALL
PRINT MACRO CADENA
    LEA DX,CADENA
    MOV AH,09H
    INT 21H
ENDM

PRINT_C macro CARACTER
    mov AH, 02H
    mov DL, CARACTER
    int 21H
ENDM

PRINT_RC MACRO FILA, COLUMNA
    MOV AH,02H 
    MOV BH,00H    
    MOV DH,FILA     
    MOV DL,COLUMNA  
    INT 10H
ENDM

CONVERT_COORD MACRO COORDXY, REG
    MOV AX, REG
    MOV BL, 8
    DIV BL
    MOV COORDXY, AL
ENDM

INGRESA_CAD MACRO ARREGLO
    LOCAL LLENAR
    MOV SI, 0
    LLENAR:     
        MOV AH, 01H
        INT 21H 
        MOV ARREGLO[SI], AL
        INC SI 
        CMP SI, 4
        JBE LLENAR
ENDM 

GET_CARACTER_POSICION MACRO 
    MOV AH, 08H ;LEE EL CARACTER Y ATRIBUTO EN LA POSICI?N DEL CURSOR
    MOV BH, 00H ; BLOQUE DEL N?MERO DE PAGINA  --> EN AL RETORNA EL CARACTER
    INT 10H
ENDM
    
PRINT_COLOR MACRO CARACTER,COLOR
    MOV AH,09H
    MOV AL,CARACTER
    MOV BH,0
    MOV BL,COLOR
    MOV CX,1
    INT 10H
ENDM

.STACK
.486

.DATA
    SALTO     DB 0AH, 0DH, '$'
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
    AUX       DB (?),'$'
    AUX2      DB (?),'$'
    AUX3      DB (?),'$'
    REF       DB 'NUMERO DE REPETICIONES: ','$'
    CADPOS    DB  10 DUP(),'$'
    POS       DB 'POSICION: ','$'
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

       ;inc BX
        CLIC2:         ;por aqui borr? algo que no serv?a
        MOV AX,01H
        INT 33H
        MOV AX,05H
        INT 33H
        cmp BX, 1 
        JE IZQ
        JMP CLIC2

    IZQ:
     CONVERT_COORD COORDX, CX
        CONVERT_COORD COORDY, DX
        CMP COORDY, 7
        JB CLIC2
        CMP COORDY, 8
        JAE CLIC2
        PRINT_RC COORDY, COORDX
        GET_CARACTER_POSICION
        
        
        MOV SI,0
        MOV CH,0
        MOV AUX2, 30H
        MOV AUX3, 56
      
        SEARCH: 
            CMP CAD1[SI],AL
            JE FOUND
            INC SI
            INC BL
            INC AUX2
            CMP CAD1[SI],'$'
            JE PRINT_RESULT
             JMP SEARCH
          
        FOUND:
            INC SI
            INC CH
            INC AUX2
            PRINT_RC 13, AUX3
            INC AUX3
            PRINT AUX2
            JMP SEARCH

        PRINT_RESULT: 
            MOV SI,0
            PRINT_RC 11, 30
            MOV AUX,CH
            ADD AUX,30H
            PRINT REF
            PRINT_RC 11,56
            PRINT AUX            
            PRINT_RC 13,30
            PRINT POS
            ;JMP CLIC2 
            call PAUSE ;llama a pausa, para que le des enter
            cmp al,0DH ;c0dH es enter, compara si al tiene el enter
            jne CLIC2 ;si NO es igual, se va a clic2
            JMP MENU ;si lo es, salta a menu
            
            
        
        
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
        
MAIN ENDP
    CLEAN PROC
        MOV AH, 0Fh  
        INT 10H   
        MOV AH, 0
        INT 10H
        RET
    CLEAN ENDP
    
    READ PROC
        MOV AH, 01H
        INT 21H
        RET
    READ ENDP
    
    PAUSE PROC
        MOV AH, 07H
        INT 21H
        RET
    PAUSE ENDP
    
    FIN: 
        call CLEAN ;limpia y muestra el letrero de salir 
        .EXIT
        RET
END MAIN