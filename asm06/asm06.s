section .data
    buffer db 20 dup(0)

section .text
    global _start

_start:

    pop rcx         
    cmp rcx, 3      
    jne exit_error

    pop rcx
    
    
    pop rcx
    mov rdi, rcx
    call atoi       
    mov r12, rax    
    
   
    pop rcx
    mov rdi, rcx
    call atoi       
    
    
    add rax, r12
    

    mov rdi, rax
    mov rsi, buffer
    call itoa
    

    mov rdi, buffer
    call strlen
    

    mov rdx, rax    
    mov rax, 1      
    mov rdi, 1      
    mov rsi, buffer
    syscall
    
    mov [buffer], byte 0xA
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, 1
    syscall
    
    jmp exit_success


atoi:
    push rbx
    mov rsi, rdi        
    xor rax, rax        
    mov rbx, 1          

    
    cmp byte [rsi], '-'
    jne .process_digits
    inc rsi             
    neg rbx             

.process_digits:
    movzx rcx, byte [rsi]
    test rcx, rcx
    jz .done
    
    cmp rcx, '0'
    jb .done
    cmp rcx, '9'
    ja .done
    
    sub rcx, '0'
    imul rax, 10
    add rax, rcx
    
    inc rsi
    jmp .process_digits

.done:
    imul rax, rbx       
    pop rbx
    ret


itoa:
    push rbp
    mov rbp, rsp
    push rbx
    
    
    test rdi, rdi
    jns .positive
    neg rdi
    mov byte [rsi], '-'
    inc rsi
    
.positive:
    mov rax, rdi
    mov rbx, 10
    mov rcx, 0          
    
.divide_loop:
    xor rdx, rdx
    div rbx
    push rdx            
    inc rcx
    test rax, rax
    jnz .divide_loop
    
.build_string:
    pop rax
    add al, '0'
    mov [rsi], al
    inc rsi
    dec rcx
    jnz .build_string
    
    mov byte [rsi], 0   
    
    pop rbx
    mov rsp, rbp
    pop rbp
    ret


strlen:
    xor rax, rax
.loop:
    cmp byte [rdi + rax], 0
    je .done
    inc rax
    jmp .loop
.done:
    ret

exit_success:
    mov rax, 60         
    xor rdi, rdi       
    syscall

exit_error:
    mov rax, 60         
    mov rdi, 1          
    syscall
