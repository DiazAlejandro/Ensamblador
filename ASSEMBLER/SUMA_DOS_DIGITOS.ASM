COMMENT !
    ESTO ES UN COMENTARIO
!

COMMENT &
    ESTO ES UN COMENTARIO
&
DATOS SEGMENT ; DEFINICIÓN DEL SEGMENTO DE DATOS
    NUM1 DB 8
    NUM2 DB 2
DATOS ENDS     ; FIN DEL SEGMENTO DE DATOS

PILA SEGMENT STACK "STACK" ; DEFINICIÓN DEL SEGMENTO DE PILA
PILA ENDS     ; FIN DEL SEGMENTO DE PILA 

CODE SEGMENT "CODE" ; DEFINICIÓN DEL SEGMENTO DE CODIGO
    ASSUME CS:CODE,DS:DATOS,SS:PILA
    START PROC      ; INICIO DEL PROCEDIMIENTO PRINCIPAL 
        MOV AX,DATOS
        MOV DS,AX

        MOV AH,0
        MOV AL,'8'
        ADD AL,'2'
        AAA
        OR  AX,30H

        MOV DX,AX
        MOV AH,02H
        INT 21H

    START ENDP
CODE ENDS           ; FIN DEL SEGMENTO DE CODIGO 
END START           ; FIN DEL PROGRAMA