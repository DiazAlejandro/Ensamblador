TITLE
;Jorge Fernando Perez Cruz
.286
spila SEGMENT STACK
    DB 32 DUP ('stack_')
spila ENDS

sdatos SEGMENT
    arre DB 3 DUP(?),'$'    ;Estructura de pila 
    texto db 'Dame un numero ',0AH,0DH,'$'
    espacio db 0AH,0DH,'$'
    indice DW (?),'$'
sdatos ENDS

scodigo SEGMENT 'CODE'
    ASSUME SS:spila,DS:sdatos,CS:scodigo
    Princ Proc Far
        PUSH DS
        PUSH 0
        MOV AX,SDATOS
        MOV DS,AX
        
        LEA BX,arre
        MOV SI,0
        
        LLENAR:
        MOV AH,09h
        lea dx,texto
        INT 21H
        
        MOV AH,01h
        INT 21H
        
        MOV AH,09h
        lea dx,espacio
        INT 21H
        
        MOV BX[SI],AL
        INC SI
        
        CMP SI,3        
        JB LLENAR       
        
        mov ax,0600h    
        mov bh,7        
        mov cx,0000h
        mov dx, 184FH
        int 10h
        
        MOV SI,0        ;inicializo de nuevo SI para que el indice regrese al inicio del arreglo
        LEA DI,arre     ;A DI le asigno el contenido de la direccion del arreglo
        INC DI          ;POSICIONO DI UN ESPACIO ADELANTE para comparar
        
        
        termino:
        MOV AL,[SI]     ;comparo con el final de la cadena para saber si llegue al final del arreglo
        CMP AL,'$'
        JE final
  
        ordenamiento:
        MOV BL,[DI]     ;comparo con el final de la cadena para saber si llegue al final del arreglo 
        CMP BL,'$'      
        JE regresa 

;--------------------------
        ordena:
        MOV AL,[SI]     ;comparo el numero con el siguiente y pregunto si es mayor
        CMP AL,[DI]
        JA mayor
        
        menor:              ;si es menor incrementa 
        INC DI
        JMP ordenamiento

        mayor:
        MOV BL,[DI]         ;si es mayor cambia los valores
        MOV [DI],AL
        MOV [SI],BL
        INC DI
        JMP ordenamiento

        regresa:
        INC SI
        MOV DI,SI
        INC DI
        JMP termino

;-------------------------------------------
        
        final:
        MOV SI,0
        MOV AH,09h
        LEA DX,arre[SI] ;imprime todo lo que contenga el arreglo
        INT 21H
        
        RET
    Princ ENDP
scodigo ENDS
END Princ