section .data
    ; Declaración de variables de prueba
    y dd 0x00000001, 0x00000000, 0x00000000, 0x00000000  ; y = (0x00000000, 0x00000000, 0x00000000, 0x00000000)
    z dd 0x00000000, 0x00000000, 0x00000000, 0x00000000  ; z = (0x00000000, 0x00000000, 0x00000000, 0x00000000)

section .text
    global main

main:
    ; Llamada a la función QuarterRound
    lea esi, [y]
    call QuarterRound

    ; Mostrar los valores de z
    mov eax, [z]
    mov ebx, [z + 4]
    mov ecx, [z + 8]
    mov edx, [z + 12]

    ; Salida del programa
    jmp end

; Definición de la función QuarterRound
QuarterRound:
    ; Guardar los registros que se van a utilizar
    push eax
    push ebx
    push ecx
    push edx

    ; Cálculo de z1 = y1 ⊕ ((y0 + y3) <<< 7)
    mov eax, [esi + 4]
    mov ebx, [esi]
    mov edx, [esi + 12]
    add ebx, edx
    rol ebx, 7
    xor [esi + 4], ebx
    mov [z + 4], ebx  ; Almacenar z1 en la posición correspondiente de z

    ; Cálculo de z2 = y2 ⊕ ((z1 + y0) <<< 9)
    mov eax, [esi + 8]
    mov edx, [esi]
    add edx, [esi + 4]
    rol edx, 9
    xor [esi + 8], edx
    mov [z + 8], edx  ; Almacenar z2 en la posición correspondiente de z

    ; Cálculo de z3 = y3 ⊕ ((z2 + z1) <<< 13)
    mov eax, [esi + 12]
    mov edx, [esi + 4]
    add edx, [esi + 8]
    rol edx, 13
    xor [esi + 12], edx
    mov [z + 12], edx  ; Almacenar z3 en la posición correspondiente de z

    ; Cálculo de z0 = y0 ⊕ ((z3 + z2) <<< 18)
    mov eax, [esi]
    mov edx, [esi + 12]
    add edx, [esi + 8]
    rol edx, 18
    xor [esi], edx
    mov [z], edx  ; Almacenar z0 en la posición correspondiente de z

    ; Restaurar los registros
    pop edx
    pop ecx
    pop ebx
    pop eax

    ret

    end:
        mov eax, 1
        int 0x80
    ; Fin del programa