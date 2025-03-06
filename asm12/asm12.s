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

reverse:
    cmp rsi, rdi
    jge print_result    

    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al

    inc rsi
    dec rdi
    jmp reverse

print_result:
    
    mov rax, 1          
    mov rdi, 1          
    mov rsi, buffer     
    mov rdx, rcx        
    syscall

    
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall
