.286
TITLE ''

DATOS SEGMENT
    a DB 33
    b DB 33
    c DB 4
    d DB 2
    x DB ?
    n2 DB 11
    suma DB ?
    resta DB ?
    divi DB ?
    mult DB ?
    
DATOS ENDS


PILA SEGMENT STACK"STACK"
    DW 32 DUP(0)
PILA ENDS


CODIGO SEGMENT 
    ASSUME DS:DATOS, SS:PILA, CS:CODIGO
    PRINCIPAL PROC
    MOV AX, DATOS   ;=Mover a AX lo que tiene DATOS
    MOV DS, AX      ;=Mover a SD lo que tiene AX

    ;=Area del programa
    MOV al, a
    ADD al, b   ;Suma
    MOV suma, al
    
    MOV al, c
    SUB al, d   ;Resta
    MOV resta, al
    
    MOV bl, suma
    MOV al, resta
    DIV bl      ; División
    MOV divi, al

    MOV al, divi
    MOV bl, n2
    MUL bl      ; Multiplicación
    MOV x, al
    
    
    MOV DL, AL      ;=Mover a DL lo que tiene AL, DL Se utuliza para impresiones en pantalla
    MOV AH, 02H     ;=02H Se utuliza para imprimir numeros
    INT 21H         ;=Ejecutamos la interrupcion 21H
    ;=Cierra Area del programa
    MOV AH, 4CH
    INT 21H

    PRINCIPAL ENDP
CODIGO ENDS
END PRINCIPAL