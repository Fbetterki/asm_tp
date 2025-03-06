section .data
    elf_magic db 0x7F, "ELF"    
    elf_len equ 4               
    error_msg db "Usage: ./asm15 <filename>", 10
    error_len equ $ - error_msg

section .bss
    buffer resb 4  

section .text
    global _start

_start:
    
    pop rax             
    cmp rax, 2
    jne print_usage     

    pop rdi             
    pop rdi             

    
    mov rax, 2          
    xor rsi, rsi      
    syscall

    
    cmp rax, 0
    jl exit_error


    mov rdi, rax

    
    mov rax, 0          
    mov rsi, buffer     
    mov rdx, elf_len    
    syscall

    
    mov rax, 3          
    syscall

    
    mov rsi, buffer
    mov rdi, elf_magic
    mov rcx, elf_len

compare_loop:
    mov al, [rsi]
    cmp al, [rdi]
    jne not_elf
    inc rsi
    inc rdi
    loop compare_loop

    
    mov rax, 60         
    xor rdi, rdi        
    syscall

not_elf:
    ; Sinon, retourner 1
    mov rax, 60
    mov rdi, 1         
    syscall

print_usage:
    
    mov rax, 1
    mov rdi, 1         
    mov rsi, error_msg
    mov rdx, error_len
    syscall
    jmp not_elf         

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall
