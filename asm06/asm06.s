global _start

section .data
    message db 'Entrez un nombre: ', 0xA

section .bss
    nombre resb 32

section .text

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, 17
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, nombre
    mov rdx, 32
    syscall

    sub rax, 1
    mov rcx, rax
    lea rsi, [nombre]

    xor rdi, rdi

convert_decimal:
    xor rax, rax
    movzx rax, byte [rsi]
    sub rax, '0'
    cmp rax, 10
    jae est_premier
    imul rdi, rdi, 10
    add rdi, rax
    inc rsi
    loop convert_decimal

est_premier:
    cmp rdi, 2
    jb non_premier
    je premier
    mov rcx, rdi
    shr rcx, 1
    mov rsi, 2

test_prime:
    mov rax, rdi
    xor rdx, rdx
    div rsi
    cmp rdx, 0
    je non_premier
    inc rsi
    cmp rsi, rcx
    jbe test_prime

premier:
    mov rax, 60 
    mov rdi, 0
    syscall

non_premier:
    mov rax, 60
    mov rdi, 1
    syscall