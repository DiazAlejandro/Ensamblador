.MODEL SMALL
INCLUDE GENERAL.LIB
.STACK 
.DATA
    LETMENU DB 'MENU $'
    LET1    DB '1.-LEER LA CADENA $'
    LET2    DB '2.-ESCANEAR LA CADENA $'
    LET3    DB '3.-SALIR $'
    INGRESA DB 'INGRESE UNA CADENA $'
    SALIDA  DB 'LA CADENA INGRESADA ES $'
    CAD     DB 5 DUP (?),'$'
    COORDX  DB ?,'$'
    COORDY  DB ?,'$'
    CARCARTER DB ?,'$'
    BAND    DB 1 DUP (?)
    BUSCA   DB 'INTRODUCE LA LETRA A BUSCAR: $'
    NOENC   DB  'LA LETRA NO SE ENCUENTRA EN LA CADENA $'
    ENC     DB 'LA LETRA SI SE ENCUENTRA EN LA CADENA $'
    MENSAJE DB  'AUN NO HA INGRESADO UNA CADENA $'
    
.CODE
.486
    MAIN PROC FAR 
    MOV AX,@DATA
    MOV DS,AX 
    MOV ES,AX
  
    MENU:
        CALL LIMPIA
        CALL MOUSE
        CURSORPOS 05H, 27H
        IMPRIMIR LETMENU
        CURSORPOS 07H, 21H
        IMPRIMIR LET1
        CURSORPOS 08H, 21H
        IMPRIMIR LET2
        CURSORPOS 09H, 21H
        IMPRIMIR LET3
     
    BOTON:
        MOV AX,01H 
        INT 33H 
        MOV AX,03H 
        INT 33H 
        CMP BX,1 
        JE COORDENADAS 
        CMP BX,2 
        JMP BOTON

    COORDENADAS:
        RECUPERA_COORD CX 
        MOV COORDX, AL 
        RECUPERA_COORD DX
        MOV COORDY, AL 
       
        CMP COORDX,33       
        JB BOTON
        CMP COORDY, 07
        JE COMPARA
        CMP COORDY,08
        JE COMPARA1

        CMP COORDY,09
        JE COMPARA2
        JMP BOTON
   
    UNO:
       CALL LIMPIA
       CURSORPOS 07H, 19H
       IMPRIMIR INGRESA
       LEER CAD
       CURSORPOS 08H, 19H
       IMPRIMIR SALIDA
       IMPRIMIR CAD
       CALL PAUSE
       MOV BAND,1
       JMP MENU

    DOS:
       CALL LIMPIA
       CURSORPOS 07H, 17H
       IMPRIMIR BUSCA
       CALL LEER_CAR
       MOV CARCARTER,AL
       MOV DI, OFFSET CAD
       MOV CX, 5
       CLD
       REPNE SCASB
       CURSORPOS 08H, 17H
       JNZ NOENCUENTRA
       CURSORPOS 08H, 17H
       IMPRIMIR ENC
       MOV DI,0
       CURSORPOS 09H, 17H

    BUSCALETRA:
       MOV BL,CAD[DI]  
       CMP BL,CARCARTER 
       JE PINTALETRA
       COLOREAR BL,0FH
       INC DI
       CMP DI,5
       JB BUSCALETRA
       CALL PAUSE
       JMP MENU
        
    PINTALETRA:
       COLOREAR BL,03H
       INC DI
       CMP DI,5
       JB BUSCALETRA
       CALL PAUSE
       JMP MENU

    NOENCUENTRA:
       CURSORPOS 08H, 17H
       IMPRIMIR NOENC 
       CALL PAUSE
       JMP MENU

    COMPARA:
       CMP COORDX,49 
       JA BOTON
       JMP UNO

    COMPARA1:
       CMP COORDX,53
       JA BOTON
       JMP VAL

    COMPARA2:
       CMP COORDX,41
       JA BOTON
       JMP SALIRSE
    VAL:
       CMP BAND,1
       JE DOS
       JNE ERROR

    ERROR:
       CALL LIMPIA
       CURSORPOS 08H, 17H
       IMPRIMIR MENSAJE
       CALL PAUSE
       JMP MENU
       
    SALIRSE:
       CALL OCULTARPUNTERO
       MOV AL,03H
       INT 10H
      .EXIT
      
MAIN ENDP      
    
PAUSE ENDP
    
END MAIN
