TITLE
.286

include Li.lib

spila SEGMENT stack
      DB 32 DUP ('stack___')
spila ENDS
sdatos SEGMENT
    msgMenu db 'Menu$'
    msgSuma db '1.- Suma ',10,13,'$'
    msgResta db '2.- Resta ',10,13,'$'
    msgComparar db '3.- Comparar ',10,13,'$'
    msgEscanear db '4.- Escanear ',10,13,'$'
    msgSalir db '4.- Salir ',10,13,'$'
    msgInsertarOp db 'Clic en el numero: $'
    msgInserteOper1 db 'Ingrese primer numero: $'
    msgInserteOper2 db 'Inserte segundo numero: $'
    msgResultado db 'El resultado es: $'
    msj1 db 0ah,0dh, 'Ingresa cadena 1: ', '$'
    msj2 db 0ah,0dh, 'Ingresa cadena 2: ', '$'
    msj3 db 0ah,0dh, 'Son iguales ', '$'
    msj4 db 0ah,0dh, 'Son diferentes ', '$'
    vec1 db 50 dup(' '), '$'  
    vec2 db 50 dup(' '), '$'  
    operando1 db ?
    cordX db 0
    cordY db 0
        var1 db 9 dup(),'$'
         strn db 9 dup(),'$'
   
    var2 db ?,'$'
    auxc db 0,'$'
    cont2 db 0,'$'
    let db "Ingresa la Palabra: ",'$'
    let2 db "Elija la Vocal con el Mouse ...",'$'
    let20 db ">>SI SE ENCUENTRA<<",'$'
    let30 db "Veces que se Repite = ",'$'
    let40 db "Posiciones = ",'$'
    let3 db ">>NO SE ENCUENTRA<<",'$'
    
    let7 db "caracter a inspeccionar: ",'$'
    contaux db 0,'$'
    letra db ?,'$'
    coorX DW (0),'$'
    coorY DW (0),'$'
    tam dw ?,'$'
    aux dw ?,'$'
    aux2 db ?,'$'
    pos db ?,'$'
    pos2 db ',','$'
    c2 db 04h
    texto db 9 dup(),'$'
sdatos ENDS

scodigo SEGMENT 'CODE'
Assume ss:spila, ds:sdatos, cs:scodigo
    
    Princ PROC FAR
        PUSH DS 
            PUSH 0   
        MOV AX, sdatos 
        MOV ds,AX 
        mov es, ax

    ciclo:
        call limpia
        posicion 3,37
        write msgMenu
        posicion 4,34
        write msgSuma
        posicion 5,34
        write msgResta
        posicion 6,34
        write msgComparar
        posicion 7,34
        write msgEscanear
        posicion 8,34
        write msgSalir
        posicion 9,30
        write msgInsertarOp
        posicion 9,49
       
       
         mov ax, 00h     
        int 33h

        mov ax,01h      
        int 33h
        encienderaton:
        mov ax,03h      
        int 33h        

       cmp bx,1 
        je esuno
        jmp encienderaton

        esuno:
        fila dx  
        cmp al,4 
        je hsuma
        cmp al,5
        je hresta
        cmp al,6
        je hcompara
        cmp al,7
        je hescanea
        cmp al,8
        je fin2
        jmp encienderaton
                                            
        hsuma:
        columna cx 
        cmp al, 34
        jb encienderaton
        cmp al, 41
        ja encienderaton
        jmp sumar
        
        hresta:
        columna cx
        cmp al, 34
        jb encienderaton
        cmp al, 42
        ja encienderaton
        jmp restar
        
        hcompara:
        columna cx
        cmp al, 34
        jb encienderaton
        cmp al, 45
        ja encienderaton
        jmp cadenas
        
        hescanea:
        columna cx
        cmp al, 34
        jb encienderaton
        cmp al, 45
        ja encienderaton
        jmp escanea
        
      
        fin2:
        columna cx
        cmp al, 34
        jb encienderaton
        cmp al, 42
        ja encienderaton
        jmp salir
        
        jmp ciclo

        salir:

        call limpia

        MOV AX, 4C00h
        INT 21h
    
    sumar:
        call limpia
        posicion 10,20
        write msgInserteOper1
        call read
        sub al, 30h 
        mov operando1, al 
        posicion  11,20
        write msgInserteOper2
        call read
        sub al, 30h
        add operando1, al
        add operando1, 30h 
        jmp imprimi
        
        escaneasalto:
          jmp escanea
        
   comparar:
        call limpia
        jmp cadenas

    restar:
        call limpia
        posicion 10,20
        write msgInserteOper1
        call read
        mov operando1, al
        posicion 11,20
        write msgInserteOper2
        call read

        cmp al, operando1 
        jb invertir 

        sub al, operando1
        add al, 30h
        mov operando1, al
        jmp imprimi
        

        invertir:
        sub operando1, al
        add operando1, 30h 

        imprimi:
            posicion 12,20
            write msgResultado
            writeLetra operando1
            call read 
            jmp ciclo
        
      cadenas:
      call limpia
      
      posicion 10,20
        write msj1 
       
        capturar1 vec1,20
    posicion 11,20
    write msj2  
    capturar2 vec2,20
    
    compara: 
    lea si,vec1  
    lea di,vec2 
    repe cmpsb  
    Jne diferente 
    je iguales 
    
    iguales:
    posicion 12,20
    write msj3 
    call read
    jmp brinca
    diferente:
    posicion 12,20
    write msj4
    
    brinca:
    call read
    limpiarc1 vec1 
      limpiarc2 vec2 
            jmp ciclo
            
            ciclo1:
            jmp ciclo
            
      escanea:
      call limpia
      inicio:
        limpiarcade var1
        imprimir let
        posicionar2 00h,01h
        capturar var1,9
        posicionar2 00h,02h
        imprimir let7
        mov ah,01h
        int 21h
        mov letra,al
     
        jmp sca      
                    vali:
                    jmp validar
        sca:
        mov aux,offset var1
        mov tam,length var1
        posicionar 0568h
        ssc:
        mov di,aux     
        mov cx,tam;  [natali]
        mov al,letra
        repne scasb 
        JNE validar
        dec di
        mov ax,di
        mov auxc,al
        sub auxc,86
        txtclr2 01h,auxc,05h
        ; mov auxc,al
        ; sub auxc, 37
        inc di
        mov aux,di
        mov tam,cx
        mov al,var2
        jmp ssc
        validar:
        posicionar2 00h,01h
        imprimir var1
        posicionar2 26,02h
        call read
        jmp ciclo1
        
    Princ ENDP
scodigo ENDS
END Princ 