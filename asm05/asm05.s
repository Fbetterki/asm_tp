section .text
global _start

_start:
    mov rax, [rsp]
    cmp rax, 1
    jle no_argument

    mov rsi, [rsp + 16]
    call string_length

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall

    xor rdi, rdi
    mov rax, 60
    syscall

no_argument:
    mov rdi, 1
    mov rax, 60
    syscall

string_length:
    xor rax, rax
find_end:
    cmp byte [rsi + rax], 0
    je end_found
    inc rax
    jmp find_end
end_found:
    ret
