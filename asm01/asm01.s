global _start

section .data
    number dd '1337'

section .text

_start:
    mov rax,1
    mov rdi,1
    mov rsi, number
    mov rdx, 4
    syscall

    mov rax,60
    xor rdi,rdi
    syscall