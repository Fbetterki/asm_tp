section .data
    
    server_addr:
        dw 2                    
        dw 0x3905              
        dd 0x0100007f          
        dq 0                   

    
    msg_request    db "Hello, client!", 0
    msg_len        equ $ - msg_request
    msg_response   db 256 dup(0)      
    
    
    sockfd_error   db "Error: socket creation failed", 10
    sockfd_len     equ $ - sockfd_error
    connect_error  db "Error: connection failed", 10
    connect_len    equ $ - connect_error
    timeout_msg    db "Timeout: no response from server", 10
    timeout_len    equ $ - timeout_msg

    
    timeval:
        dq 1                    
        dq 0                    

section .bss
    sockfd         resq 1              
    addr_len       resq 1              

section .text
    global _start

_start:
    ; Création du socket UDP
    mov rax, 41                  
    mov rdi, 2                   
    mov rsi, 2                   
    xor rdx, rdx                 
    syscall
    
    test rax, rax
    js error_socket            
    mov [sockfd], rax          
    
    
    mov rax, 54                
    mov rdi, [sockfd]          
    mov rsi, 1                 
    mov rdx, 20                
    lea r10, [timeval]         
    mov r8, 16                 
    syscall
    
    test rax, rax
    js error_socket
    
    
    mov rax, 44                
    mov rdi, [sockfd]          
    lea rsi, [msg_request]     
    mov rdx, msg_len           
    xor r10, r10              
    lea r8, [server_addr]     
    mov r9, 16                
    syscall
    
    test rax, rax
    js error_connect
    
    
    mov rax, 45               
    mov rdi, [sockfd]         
    lea rsi, [msg_response]   
    mov rdx, 256              
    xor r10, r10              
    lea r8, [server_addr]     
    lea r9, [addr_len]        
    syscall
    
    test rax, rax
    jle error_timeout         
    
    
    mov rdx, rax              
    mov rax, 1                
    mov rdi, 1                
    lea rsi, [msg_response]   
    syscall
    
    
    mov rax, 3                 
    mov rdi, [sockfd]
    syscall
    
    mov rax, 60                
    xor rdi, rdi              
    syscall

error_socket:
    mov rdx, sockfd_len        
    lea rsi, [sockfd_error]    
    jmp print_error

error_connect:
    mov rdx, connect_len       
    lea rsi, [connect_error]   
    jmp print_error

error_timeout:
    mov rdx, timeout_len       
    lea rsi, [timeout_msg]     
    jmp print_error

print_error:
    mov rax, 1                 
    mov rdi, 2                 
    syscall
    
    mov rax, 60                
    mov rdi, 1                 
    syscall
