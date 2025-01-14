global _start

section .data
nombre dd '1337',0

section .bss
input resb 3

section .text

_start:
mov eax, 0
mov edi, 0
mov rsi, input
mov edx, 3
syscall

mov al, [input]
cmp al, 0x34
jne n_e

mov al, [input + 1]
cmp al, 0x32
jne n_e


mov al, [input + 2]
cmp al, 0x0A
jne n_e

mov rax, 1
mov rdi, 1
mov rsi, nombre
mov rdx, 4
syscall

mov rax, 60
mov rdi, 0
syscall

n_e:
mov rax, 60
mov rdi, 1
syscall