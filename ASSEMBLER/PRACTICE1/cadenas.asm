read macro cadena 
    local rellenar
    MOV si, 0
    rellenar:     
            MOV ah, 01h
            INT 21h 
            MOV cadena[si], al
            INC si 
            CMP si, 4
            JBE rellenar
endm 

read_char macro char 
        MOV ah, 01h
        INT 21H
        SUB al, 48
        MOV char, al 
endm    

print macro cadena  
    MOV ah, 09h
    LEA dx, cadena
    INT 21h
endm   

exit macro
    MOV ax, 4c00h
    INT 21h
endm

.286 
.model small
.stack
.data
    letrero1 db 10, 13, 'Introduce la cadena1: ', '$'
    letrero2 db 10, 13, 'Introduce la cadena2: ', '$'
    letrero3 db 10,13, 'Son iguales', '$'
    letrero4 db 10,13, 'No son iguales', '$' 
    salir db 10,13, 'Desea continuar? (s/n): ', '$'    
    si_r db 'n', '$'
    res db (?), '$'
    cadena1 db 5 dup(?), '?' 
    cadena2 db 5 dup(?), '?'
.code 
    main proc far

        MOV ax, @data
        MOV ds, ax
        MOV es, ax
        
        continuar: 

            print letrero1
            read cadena1
            
            print letrero2
            read cadena2
            
            LEA si, cadena1
            LEA di, cadena2
            MOV cx, 5
            REP CMPSB
            JE iguales      
            JNE no_iguales  

        iguales:
            print letrero3
            JMP preguntar

        no_iguales:
            print letrero4
            JMP preguntar 

        preguntar: 
            print salir
            read_char res
            ADD res, 48
            MOV ah, res
            CMP ah, si_r 
            JE fin      
                JNE continuar  

        fin:
            .exit
            
    main endp
end main