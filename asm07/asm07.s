section .data
    prompt db "Veuillez entrer un nombre: ", 0
    prompt_len equ $ - prompt
    error_msg db "Erreur: veuillez entrer un nombre entier positif", 10
    error_len equ $ - error_msg

section .bss
    num resb 20
    len resb 8

section .text
    global _start

_start:
    
    mov rax, 1         
    mov rdi, 1          
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    
    mov rax, 0          
    mov rdi, 0          
    mov rsi, num
    mov rdx, 20
    syscall

    
    mov [len], rax

    
    mov rdi, num
    call atoi
    
    
    cmp rax, -1
    je exit_format_error

    
    mov rdi, rax
    call is_prime
    
    
    test rax, rax
    jz exit_not_prime   
    jmp exit_prime      

atoi:
    xor rax, rax        
    xor rcx, rcx        
    
.process_char:
    movzx rdx, byte [rdi + rcx]  
    
    
    cmp dl, 10
    je .done
    test dl, dl
    jz .done
    
    
    cmp dl, '0'
    jb .error
    cmp dl, '9'
    ja .error
    
    
    sub dl, '0'
    imul rax, 10
    add rax, rdx
    
    inc rcx
    cmp rcx, [len]
    jb .process_char
    
.done:
    ret

.error:
    mov rax, -1
    ret

is_prime:
    
    cmp rdi, 2
    je .is_prime
    
    cmp rdi, 2
    jl .not_prime
    
    test rdi, 1
    jz .not_prime   
    
    mov rcx, 3      
    mov rax, rdi
    mov rbx, rax
    shr rbx, 1      
    
.check_loop:
    cmp rcx, rbx
    ja .is_prime
    
    mov rax, rdi
    xor rdx, rdx
    div rcx
    test rdx, rdx
    jz .not_prime   
    
    add rcx, 2      
    jmp .check_loop
    
.not_prime:
    xor rax, rax    
    ret
    
.is_prime:
    mov rax, 1      
    ret

exit_format_error:
    
    mov rax, 1
    mov rdi, 1
    mov rsi, error_msg
    mov rdx, error_len
    syscall
    
    mov rax, 60     
    mov rdi, 2      
    syscall

exit_not_prime:
    mov rax, 60     
    mov rdi, 1      
    syscall

exit_prime:
    mov rax, 60     
    xor rdi, rdi    
    syscall
