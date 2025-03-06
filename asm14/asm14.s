section .data
    message db "Hello Universe!", 10  
    msg_len equ $ - message           
    error_msg db "Usage: ./asm14 <filename>", 10
    error_len equ $ - error_msg

section .bss
    filename resb 128   

section .text
    global _start

_start:

    pop rax             
    cmp rax, 2
    jne print_usage     

    pop rdi             
    pop rdi             

    
    mov rax, 2          
    mov rsi, 0x241      
    mov rdx, 0o644      
    syscall

    
    cmp rax, 0
    jl exit_error

    
    mov rdi, rax

    
    mov rax, 1          
    mov rsi, message    
    mov rdx, msg_len    
    syscall

    
    mov rax, 3          
    syscall

    
    mov rax, 60         
    xor rdi, rdi        
    syscall

print_usage:
    
    mov rax, 1
    mov rdi, 1         
    mov rsi, error_msg
    mov rdx, error_len
    syscall

exit_error:
    mov rax, 60         
    mov rdi, 1         
    syscall
