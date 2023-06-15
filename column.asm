section .data
    ; Declaración de variables de prueba
    state db 0xde, 0x50, 0x10, 0x66
          db 0x6f, 0x9e, 0xb8, 0xf7
          db 0xe4, 0xfb, 0xbd, 0x9b
          db 0x45, 0x4e, 0x3f, 0x57
          db 0xb7, 0x55, 0x40, 0xd3
          db 0x43, 0xe9, 0x3a, 0x4c
          db 0x3a, 0x6f, 0x2a, 0xa0
          db 0x72, 0x6d, 0x6b, 0x36
          db 0x92, 0x43, 0xf4, 0x84
          db 0x91, 0x45, 0xd1, 0xe8
          db 0x4f, 0xa9, 0xd2, 0x47
          db 0xdc, 0x8d, 0xee, 0x11
          db 0x05, 0x4b, 0xf5, 0x45
          db 0x25, 0x4d, 0xd6, 0x53
          db 0xd9, 0x42, 0x1b, 0x6d
          db 0x67, 0xb2, 0x76, 0xc1

section .text
    global main

main:
    ; Llamada a la función DoubleRound
    mov esi, state
    call DoubleRound

    break:; Imprimir el estado actualizado
    mov ecx, 64  ; Número de elementos en state (16 bytes * 4 filas)
    mov edi, 0   ; Índice de inicio
    mov edx, 0   ; Valor temporal

print_loop:
    mov dl, [esi + edi]  ; Obtener el byte actual
    push edx            ; Empujar el valor para imprimirlo
    call print_hex      ; Llamar a la función de impresión en hexadecimal
    add edi, 1          ; Incrementar el índice
    loop print_loop     ; Repetir hasta que todos los elementos se impriman

    ; Salida del programa
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Definición de la función DoubleRound
DoubleRound:
    ; Guardar los registros que se van a utilizar
    pusha

    ; Realizar dos rondas de operaciones
    mov ecx, 2 ; Contador de rondas
double_round_loop:
    ; Llamada a la función RowRound
    call RowRound

    ; Llamada a la función ColumnRound
    call ColumnRound

    ; Decrementar el contador de rondas
    loop double_round_loop

    ; Restaurar los registros
    popa

    ret

; Definición de la función RowRound
RowRound:
    ; Guardar los registros que se van a utilizar
    pusha

    ; Cálculo de las filas
    mov ecx, 4 ; Número de filas
    xor edi, edi ; Índice de fila (inicializado en 0)
row_round_loop:
    ; Cálculo de la fila actual
    mov al, [esi + edi]
    add al, [esi + edi + 4]
    xor al, [esi + edi + 8]
    xor al, [esi + edi + 12]
    mov [esi + edi], al
    mov [esi + edi + 4], al
    mov [esi + edi + 8], al
    mov [esi + edi + 12], al

    ; Incrementar el índice de fila
    add edi, 16

    ; Decrementar el contador de filas
    loop row_round_loop

    ; Restaurar los registros
    popa

    ret

; Definición de la función ColumnRound
ColumnRound:
    ; Guardar los registros que se van a utilizar
    pusha

    ; Cálculo de las columnas
    mov ecx, 4 ; Número de columnas
    xor edi, edi ; Índice de columna (inicializado en 0)
column_round_loop:
    ; Cálculo de la columna actual
    mov al, [esi + edi]
    add al, [esi + edi + 16]
    xor al, [esi + edi + 32]
    xor al, [esi + edi + 48]
    mov [esi + edi], al
    add edi, 1

    ; Decrementar el contador de columnas
    loop column_round_loop

    ; Restaurar los registros
    popa

    ret

; Función para imprimir un byte en hexadecimal
print_hex:
    ; Guardar los registros que se van a utilizar
    pusha

    ; Imprimir el byte en hexadecimal
    mov eax, 4           ; Número de función del sistema para escribir
    mov ebx, 1           ; Descriptor de archivo estándar de salida (STDOUT)
    mov ecx, esp         ; Puntero al byte que se va a imprimir
    mov edx, 1           ; Longitud del byte a imprimir (1 byte)
    int 0x80             ; Llamada al sistema

    ; Restaurar los registros
    popa

    ret