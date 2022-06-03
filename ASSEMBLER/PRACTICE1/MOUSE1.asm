.286

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
    MOV AH,02H      ; FUNCI?N PARA COLOCAR EL CURSOR
    MOV DH,FILA     ; 25 EN DECIMAL - FILA
    MOV DL,COLUMNA  ; 80 EN DECIMAL - COLUMNAS
    INT 10H
ENDM

.MODEL SMALL
.STACK

.DATA
    SALTO DB 0AH, 0DH, '$'
    OPC1  DB '1. LEER CADENA','$'
    OPC2  DB '2. ESCANEAR CADENA','$'
    OPC3  DB '3. SALIR','$'
    COORDX DB(?), '$'
    COORDY DB(?), '$'
    LETRERO1 DB 'INGRESE UNA CADENA: ','$'
    CADENA1  DB 5 DUP (?)
    LETRERO2 DB 'INGRESE CARACTER: ','$'
    COINC DB 'SE ENCUENTRA EN LA CADENA','$'
    SINRE DB 'NO SE ENCUENTRA EN LA CADENA','$'
    POSICION DW ?,'$'
    PEDIR DB 'INGRESA CARACTER:','$'
    CONTINUAR DB 'CONTINUAR...','$'
.CODE
    MAIN PROC FAR 
        MOV AX, @DATA
        MOV DS, AX 
        MOV ES, AX
        
        MOV AX, 00H ;OBTENER ESTADO DEL MOUSE
        INT 33H
            
        MENU: 
            PRINT_RC 7H, 1EH
            PRINT OPC1
            PRINT SALTO
            PRINT_RC 8H, 1EH
            PRINT OPC2
            PRINT SALTO
            PRINT_RC 9H, 1EH
            PRINT OPC3
            
        CICLO_CLIC:
            MOV AX, 01H ; MOSTRAR
            INT 33H  
            CLIC
            
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
            PRINT LETRERO1
            INGRESA_CAD CADENA1
            CALL CLEAN
            JMP MENU
            
        OPCION3: 
        .EXIT
                    
        OPCION2:
            CALL CLEAN
            ;PEDIR CARACTER QUE SE GUARDA EN AL
            PRINT PEDIR
            CALL LEER
            ;MOVER LA DIRECCION DE LA CADENA Y FIJAR EL CONTADOR
            MOV DI, OFFSET CADENA1
            MOV CX, 5
            MOV POSICION,5
            
            ;CICLO PARA BUSCAR EN LA CADENA
            CLD                ; DIRECCI?N = AVANCE
            REPNE SCASB        ; REPITE MIENTRAS NO SEA IGUAL
            JNZ SALIR          ; TERMINA SI NO ENCONTR? LA LETRA
            JZ COINCIDENCIA    ; SI ENCUENTRA LA COINCIDENCIA
            DEC DI
            
            SALIR: 
                PRINT SALTO
                PRINT SINRE 
                PRINT CONTINUAR
                CALL LEER
                CALL CLEAN
                JMP MENU
                
            COINCIDENCIA:
                PRINT SALTO
                PRINT COINC
                PRINT SALTO
                SUB POSICION,CX
                ADD POSICION,48
                PRINT POSICION
                PRINT SALTO
                PRINT CONTINUAR
                CALL LEER
                CALL CLEAN
                JMP MENU 
    ENDP
    
    CLEAN PROC
        mov ah,0Fh  
        int 10H  
        MOV AH, 0
        INT 10H
        RET
    ENDP
    
    LEER PROC
        MOV AH,01H
        INT 21H
        RET
    ENDP
END MAIN