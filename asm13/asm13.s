section .bss
    buffer resb 128    

section .data
    newline db 10      

section .text
    global _start

_start:
    
    mov rax, 0          
    mov rdi, 0          
    mov rsi, buffer     
    mov rdx, 128        
    syscall

    
    cmp rax, 1
    jle exit_success    

    dec rax             
    mov rcx, rax        
    mov rsi, buffer     
    lea rdi, [buffer + rcx - 1]  

check_palindrome:
    cmp rsi, rdi
    jge palindrome      

    mov al, [rsi]
    mov bl, [rdi]
    cmp al, bl
    jne not_palindrome  

    inc rsi
    dec rdi
    jmp check_palindrome

palindrome:
    
    mov rax, 60
    xor rdi, rdi        
    syscall

not_palindrome:
    
    mov rax, 60
    mov rdi, 1          
    syscall

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall
