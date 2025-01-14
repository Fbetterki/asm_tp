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
    add rdi, 10

dernier:
    cmp byte [rdi], 0x30
    jb verifier
    cmp byte [rdi], 0x39
    ja verifier
    jmp resultat            

verifier:
    dec rdi                       
    jmp dernier

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