.286
.MODEL SMALL
    INCLUDE LIBMO.lib
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
                JE VAL1
                CMP COORDY, 8
                JE OPCION2
                CMP COORDY, 9
                JE OPCION3
                
            OPCION1:
                CALL CLEAN
                PRINT_RC 7H, 1EH
                PRINT LETRERO1
                INGRESA_CAD CADENA1
                MOV BAN,1
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
                CALL LEER
                MOV VAR,AL
                
                MOV SI,0 
                MOV A,30 
                PRINT SALTO
                REPETIR:
                    MOV BX, OFFSET CADENA1
                    MOV CL,0
                    MOV CL, BX[SI]
                    CMP VAR,CL
                    
                    JE PRINT_OPC1
                    JNE PRINT_OPC2
                    
                    PRINT_OPC1:
                        PRINT_RC 9,A
                        PRINT_COLOR CL, 03H 
                        INC A
                        JMP CONT 
                        
                    PRINT_OPC2:
                        PRINT_RC 9,A
                        PRINT_COLOR CL, 0FH
                        INC A
                        JMP CONT
                    CONT: 
                        
                    PRINT SALTO
                        INC SI
                        CMP SI,4
                        JBE REPETIR 
                        PRINT SALTO
                        PRINT_RC 10,30
                        PRINT CONTINUAR
                        CALL LEER
                        CALL CLEAN
                        JMP MENU 
    ENDP
    
    
END MAIN