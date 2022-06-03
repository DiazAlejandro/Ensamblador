.MODEL SMALL
PRINT MACRO CADENA
    MOV AH,09H
    LEA DX,CADENA
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
    SALTO    DB 0AH, 0DH, '$'
    OPCIONES DB 'MENU','$'
    OPC1     DB '1) SUMA','$'
    OPC2     DB '2) RESTA','$'
    OPC3     DB '3) COMPARAR','$'
    OPC4     DB '4) ESCANEAR','$'
    OPC5     DB '5) SALIR','$'
    COORDX   DB (?), '$'
    COORDY   DB (?), '$'
    MSGOP1   DB 'INSERTE EL OPERADOR 1: ','$'
    MSGOP2   DB 'INSERTE EL OPERADOR 2: ','$'
    OP1      DB (?), '$'
    OP2      DB (?), '$'
    RESULT   DB 'RESULTADO = ','$'
    CONTINUAR DB 'CONTINUAR...','$'
    MSGCAD1   DB 'INSERTE LA CADENA 1: ','$'
    MSGCAD2   DB 'INSERTE LA CADENA 2: ','$'
    IGUAL     DB 'CADENAS IGUALES','$'
    NOIGUAL   DB 'CADENAS DIFERENTES','$'
    CAD1      DB 5 DUP(?), '?'
    CAD2      DB 5 DUP(?), '?'

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
        PRINT_RC 9,30
        PRINT OPC4
        PRINT_RC 10,30
        PRINT OPC5
        
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
        CMP COORDY, 9
        JE  VALIDACION40
        CMP COORDY, 10
        JE  VALIDACION50
        JMP CLIC
    
    SUMAR: 
        CALL CLEAN
        PRINT_RC 6,27
        PRINT MSGOP1
        CALL READ
        MOV OP1, AL
        PRINT_RC 7,27
        PRINT MSGOP2
        CALL READ
        ADD OP1,AL
        SUB OP1, 30H
        JMP PRINT_RESULT
    
    RESTAR:
        CALL CLEAN
        PRINT_RC 6,27
        PRINT MSGOP1
        CALL READ
        MOV OP1, AL
        PRINT_RC 7,27
        PRINT MSGOP2
        CALL READ
        SUB OP1,AL
        ADD OP1, 30H
        JMP PRINT_RESULT
        
    PRINT_RESULT:
        PRINT_RC 9,27
        PRINT MSGCAD1
        PRINT_C OP1
        PRINT_RC 11,27
        PRINT CONTINUAR
        CALL PAUSE
        JMP MENU
        
    COMPARAR:
        CALL CLEAN 
        PRINT_RC 6,27
        PRINT MSGCAD1
        INGRESA_CAD CAD1        
        PRINT_RC 8,27
        PRINT MSGCAD2
        INGRESA_CAD CAD2
        LEA SI, CAD1
        LEA DI, CAD2
        MOV CX,5
        REPE CMPSB
        JE IGUALES
        JNE DIFERENTE
        
    IGUALES: 
        PRINT_RC 10,27
        PRINT IGUAL
        PRINT_RC 11,27
        PRINT CONTINUAR
        CALL PAUSE
        JMP MENU
        
    DIFERENTE: 
        PRINT_RC 10,27
        PRINT NOIGUAL
        PRINT_RC 11,27
        PRINT CONTINUAR
        CALL PAUSE
        JMP MENU
    
        
    VALIDACION10:
        CMP COORDX, 36
        JA  CLIC
        JMP SUMAR
    VALIDACION20:
        CMP COORDX, 37
        JA  CLIC
        JMP RESTAR
    VALIDACION30:
        CMP COORDX, 40
        JA  CLIC
        JMP COMPARAR
    VALIDACION40:
        CMP COORDX, 40
        JA  CLIC
        JMP FIN
    VALIDACION50:
        CMP COORDX, 37
        JA  CLIC
        JMP FIN

    FIN: 
        .EXIT
        RET
        
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
    
END MAIN
