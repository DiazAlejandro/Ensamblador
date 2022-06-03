TITLE MENU-MOUSE
.286


.MODEL SMALL
Include melvin.lib
.STACK

.DATA
    letreroMenu DB 'MENU','$'
    letreroPalabra DB 'Escribe una palabra: ','$'   
    letreroLetra DB 'Escribe una letra: ','$'
    letreroCadena DB '1.-LEER CADENA','$'
    letreroVocal DB '2.-ESCANEAR CADENA','$'
    letreroSalir DB '3.-SALIR','$'
    letreroContinuar DB 13,10, 'Presiona una tecla para continuar...','$'
    letreroNoMsj DB 'NO SE HA LEIDO LA CADENA ','$'
    letreroMensajeSeleccion DB 'Seleccione el caracter a escanerar:'
    letrero2 db 'Ingresa el caracter a buscar: $'  
    palabra1 DB 40 DUP (0),'$'
    letrero3 db 'Posicion: $'
    salto DB 0Ah, 0Dh, "$"
    letra DB ?  
    coX DB ?
    coY DB ?
    flag DB ? 
    contador db 0h
    ;cadena1 db 40 dup (''),'$'
    posicion db ?
    valor db ?

.CODE
    main PROC FAR
    PUSH DS
    PUSH 0
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX                                  
    
    inicio:                                      
        CALL mostrarMenu                        
        CALL iniciarMouse                       
        
    ciclo:
        MOV AX, 03H                             
        INT 33H
        CMP BX,1                                
        JE validarX
        JMP ciclo                                 
     validarX:                                 
    
     getLocationMouseX coX                   
        CMP coX, 37                          
        JAE validarY
        JMP ciclo

    validarY:   
        getLocationMouseY coY
        CMP coY, 15                                     
        JE validarRangoSalir
        CMP coY, 14                                     
        JE validarRangoBuscar
        CMP coY, 13                                     
        JE validarRangoLeer                 
        JMP ciclo
         
    validarRangoLeer:
        CMP coX, 47                                     
        JBE leerPalabra
        JMP ciclo 
    
    validarRangoBuscar:
    CMP coX,51                                                
        JBE validar_buscar
        JMP ciclo 

    out_not_string:    
        CALL ocultarMouse
        clean 
        setLocationCursor 0H, 0H
        imprimir letreroNoMsj                           
        JMP volver                                      

    validarRangoSalir:
        CMP coX,42                                     
        JBE finPrograma
        JMP ciclo       
    
    validar_buscar:
    CMP flag, 1                                     
    JE buscar
    JMP out_not_string                             
    
    selecion_car: 
        getLocationMouseY coY
        CMP coY, 15  
    leerPalabra:
        CALL Leer                                                                        
        jmp inicio 
    
    volver:
    imprimir letreroContinuar                       
        MOV AH, 01H                                 
        INT 21H
        JMP inicio                                  
    
    finPrograma:
        CALL ocultarMouse
    RET
    ENDP main

       
    Leer PROC NEAR
    CALL ocultarMouse                               
    clean 
    setLocationCursor 0Ch , 0Ch                  
    imprimir letreroPalabra                 
    ReadWord2 palabra1                      
    setLocationCursor 01H, 0H               
    MOV flag, 1                             
    RET
    ENDP
    
    buscar PROC 
    
    CALL ocultarMouse
    clean
    setLocationCursor 0Ch , 22h
    CALL iniciarMouse
    setLocationCursor 0Dh , 22h
    imprimir palabra1 
    setLocationCursor 0Eh , 20h 
    CALL iniciarMouse
    CALL obtener
    
    
   
    ;imprimir letrero2
    ;leer caracter desde teclado     
    ;Read_Char letra
    imprimir salto
    impcaracter palabra1,letra
    ;CALL iniciarMouse    
    jmp volver                               
    RET
    ENDP    
ENDP

END main