global _start

section .bss
input resb 3

section .text
_start:
    ; Lire l'entrée
    mov eax, 0
    mov edi, 0
    mov rsi, input
    mov edx, 3
    syscall

    ; Convertir l'entrée en nombre
    mov rax, 0
    mov rbx, input
    sub byte [rbx], '0'  ; Convertir ASCII en nombre

    ; Vérifier si pair
    xor rdx, rdx
    mov rdi, 2
    div rdi
    test rdx, rdx
    jne _error

    xor eax, eax
    ret

_error:
    mov eax, 1
    ret
