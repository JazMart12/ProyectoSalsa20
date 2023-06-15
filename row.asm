section .data
    
    state db 0x01, 0x23, 0x45, 0x67
          db 0x89, 0xAB, 0xCD, 0xEF
          db 0xFE, 0xDC, 0xBA, 0x98
          db 0x76, 0x54, 0x32, 0x10
         

section .text
    global main

main:
   
    mov esi, state
    call RowRound

    break:
    mov eax, 1
    xor ebx, ebx
    int 0x80


RowRound:
   
    pusha

     
    mov al, [esi]
    add al, [esi + 4]
    xor al, [esi + 8]
    xor al, [esi + 12]
    mov [esi], al
    mov [esi + 4], al
    mov [esi + 8], al
    mov [esi + 12], al

    ; Cálculo de la fila 1
    mov al, [esi + 1]
    add al, [esi + 5]
    xor al, [esi + 9]
    xor al, [esi + 13]
    mov [esi + 1], al
    mov [esi + 5], al
    mov [esi + 9], al
    mov [esi + 13], al

    ; Cálculo de la fila 2
    mov al, [esi + 2]
    add al, [esi + 6]
    xor al, [esi + 10]
    xor al, [esi + 14]
    mov [esi + 2], al
    mov [esi + 6], al
    mov [esi + 10], al
    mov [esi + 14], al

    ; Cálculo de la fila 3
    mov al, [esi + 3]
    add al, [esi + 7]
    xor al, [esi + 11]
    xor al, [esi + 15]
    mov [esi + 3], al
    mov [esi + 7], al
    mov [esi + 11], al
    mov [esi + 15], al

    ; Restaurar los registros
    popa

    ret
