global _start

section .data
    number db '1337', 0x0A

section .text

_start:
    mov rdi, [rsp]
    cmp rdi, 1
    je no_args

    mov rsi, [rsp + 16]

    mov al, [rsi]
    cmp al, 0x34
    jne not_42

    mov al, [rsi + 1]
    cmp al, 0x32
    jne not_42

    mov al, [rsi + 2]
    cmp al, 0x00
    jne not_42

    mov rax, 1
    mov rdi, 1
    mov rsi, number
    mov rdx, 5
    syscall


    mov rax, 60
    mov rdi, 0
    syscall

not_42:
    mov rax, 60
    mov rdi, 1
    syscall

no_args:
    mov rax, 60
    mov rdi, 1
    syscall