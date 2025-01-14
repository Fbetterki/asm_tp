global _start

section .data

section .bss
    input resb 11

section .text
_start:
    mov eax, 0
    mov edi, 0
    mov rsi, input
    mov edx, 11
    syscall

    mov rdi, input
    xor rcx, rcx

verifier_input:
    mov al, byte [rdi + rcx]
    cmp al, 0
    je dernier
    cmp al, 0x30
    jb bad_input
    cmp al, 0x39
    ja bad_input
    inc rcx
    jmp verifier_input

bad_input:
    mov rax, 60
    mov rdi, 2
    syscall

dernier:
    mov rdi, input
    add rdi, 10

retour_dernier:
    cmp byte [rdi], 0x30
    jb verifier
    cmp byte [rdi], 0x39
    ja verifier
    jmp resultat

verifier:
    dec rdi
    jmp retour_dernier

resultat:
    movzx eax, byte [rdi]
    sub eax, '0'
    and eax, 1
    jnz impair

    mov rax, 60
    mov rdi, 0
    syscall

impair:
    mov rax, 60
    mov rdi, 1
    syscall
