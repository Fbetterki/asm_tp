section .bss
    num1 resq 1
    num2 resq 1
    result resb 21

section .text
    global _start

_start:
    mov rdi, [rsp]
    cmp rdi, 3
    jl insufficient_args

    mov rsi, [rsp+16]
    call atoi
    mov [num1], rax

    mov rsi, [rsp+24]
    call atoi
    mov [num2], rax

    mov rax, [num1]
    add rax, [num2]

    mov rdi, result
    call itoa

    lea rsi, [result]
    mov rax, 1
    mov rdi, 1
    mov rdx, 21
    syscall

    xor rdi, rdi
    mov rax, 60
    syscall

insufficient_args:
    mov rdi, 1
    mov rax, 60
    syscall

atoi:
    xor rax, rax
    xor rbx, rbx
    mov rcx, rsi
    cmp byte [rcx], '-'
    jne .loop
    inc rsi
    mov bl, 1
.loop:
    movzx rcx, byte [rsi]
    test rcx, rcx
    jz .done
    sub rcx, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rsi
    jmp .loop
.done:
    test bl, bl
    jz .positive
    neg rax
.positive:
    ret

itoa:
    mov rbx, 10
    xor rcx, rcx
    test rax, rax
    jns .positive_number
    neg rax
    mov cl, '-'
.positive_number:
    lea rdi, [rdi + 20]
    mov byte [rdi], 0
.convert:
    dec rdi
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rdi], dl
    test rax, rax
    jnz .convert
    test rcx, rcx
    jz .done
    dec rdi
    mov [rdi], cl
.done:
    ret
