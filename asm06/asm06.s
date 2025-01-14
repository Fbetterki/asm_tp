global _start

section .data
    input_msg db 'Entrez un nombre: ', 0xA
section .bss
    input_buffer resb 32

section .text

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, input_msg
    mov rdx, 17
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, input_buffer
    mov rdx, 32
    syscall

    cmp byte [rsi], 'A'
    je handle_letter_a

    sub rax, 1
    mov rcx, rax
    lea rsi, [input_buffer]

    xor rdi, rdi

convert_to_decimal:
    xor rax, rax
    movzx rax, byte [rsi]
    sub rax, '0'
    cmp rax, 10
    jae check_prime
    imul rdi, rdi, 10
    add rdi, rax
    inc rsi
    loop convert_to_decimal

check_prime:
    cmp rdi, 2
    jb not_prime
    je is_prime
    mov rcx, rdi
    shr rcx, 1
    mov rsi, 2

test_divisors:
    mov rax, rdi
    xor rdx, rdx
    div rsi
    cmp rdx, 0
    je not_prime
    inc rsi
    cmp rsi, rcx
    jbe test_divisors

is_prime:
    mov rax, 60
    mov rdi, 0
    syscall

not_prime:
    mov rax, 60
    mov rdi, 1
    syscall

handle_letter_a:
    mov rax, 60
    mov rdi, 2
    syscall