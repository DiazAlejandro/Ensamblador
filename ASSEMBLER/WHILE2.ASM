TITLE 'WHILE 2'
COMMENT &
    EJEMPLO DE UNA INSTRUCCIÓN WHILE 
    --> INSTRUCCIÓN EN LENGUAJE DE ALTO NIVEL
        WHILE (A>=B) DO 
            B:= B+1
        DONDE A = 5
              B = 0
&

; **************************************************
; SEGMENTO DE DATOS                                *
; **************************************************
    DATOS SEGMENT ; DEFINICIÓN DEL SEGMENTO DE DATOS
        A DB 5    ; VALOR AL QUE SE QUIERE LLEGAR
        B DB 0    ; VALOR QUE FUNCIONARÁ COMO INCREMENTO
        NOMBRE DB 'ALEJANDRO$'
    DATOS ENDS    ; FIN DEL SEGMENTO DE DATOS

; **************************************************
; SEGMENTO DE PILA                                 *
; **************************************************
    PILA SEGMENT STACK "STACK" ; DEFINICIÓN DEL SEGMENTO DE PILA
    PILA ENDS                  ; FIN DEL SEGMENTO DE PILA

; **************************************************
; SEGMENTO DE CÓDIGO                               *
; **************************************************

    CODE SEGMENT "CODE" ; DEFINICIÓN DEL SEGMENTO DE CÓDIGO
        ASSUME CS:CODE,DS:DATOS,SS:PILA ; LLAMA LOS SEGMENTOS DE CÓGIGO 
        START PROC ; INICIO DEL PROCEDIMIENTO PRINCIPAL 
            MOV AX,DATOS
            MOV DS,AX 

            MOV BL,A

            MIENTRAS: CMP BL,B  ; COMPARA 5,B
                JBE FIN         ; SALTA SI 'B' ES MAYOR O IGUAL QUE 'BL'
                ; INSTRUCCIONES QUE SE EJECUTAN MIENTRAS QUE B SEA MENOR QUE BL
                INC B           ; INCREMENTA B:=B+1
                    ; IMPRIMIR 
                MOV AH,09H
                LEA DX,NOMBRE 
                INT 21H 
                    ; SALTO DE LINEA
                MOV DL,10
                MOV AH,02H
                INT 21H

                JMP MIENTRAS    ; SALTAR AL CMP (MIENTRAS)
            FIN: 

        ENDP START ; FIN DEL PROCEDIMIENTO PRINCIPAL 
    CODE ENDS      ; FIN DEL SEGMENTO DE CÓDIGO 
    END START      ; FIN DEL PROGRAMA 
