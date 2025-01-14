section .bss
    nombre resb 10
    binary resb 33

section .text
    global _start

_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, nombre
    mov edx, 10
    int 0x80

    mov ecx, nombre
    xor eax, eax

convert_decimal:
    mov dl, byte [ecx]
    sub dl, '0'
    cmp dl, 10
    jae done_conversion
    imul eax, 10
    add eax, edx
    inc ecx
    jmp convert_decimal

done_conversion:
    mov ecx, 32
    lea edi, [binary+31]

convert_binary:
    xor edx, edx
    mov ebx, 2
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    dec ecx
    test eax, eax
    jnz convert_binary

    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    lea edx, [binary+32]
    sub edx, edi
    int 0x80

    mov eax, 1
    mov rdi, 0
    int 0x80