.286
.MODEL SMALL
INCLUDE LIBRERIA.lib
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
            PRINT OPC1
            PRINT SALTO
            PRINT OPC2
            PRINT SALTO
            PRINT OPC3
            
        CICLO_CLIC:
            MOV AX, 01H ; MOSTRAR
            INT 33H  
            CLIC
            
            CLIC_IZQ:
                CONVERT_COORD COORDX, CX
                CONVERT_COORD COORDY, DX
                CMP COORDX, 0
                JNE CICLO_CLIC
                
                CMP COORDY, 0
                JE OPCION1
                CMP COORDY, 1
                JE OPCION2
                CMP COORDY, 2
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
            ;MOVER LA DIRECCI?N DE LA CADENA Y FIJAR EL CONTADOR
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
    
END MAIN