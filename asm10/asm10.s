section .data
    err_msg db "Usage: ./asm10 <num1> <num2> <num3>", 10, 0
    err_len equ $ - err_msg
    newline db 10

section .bss
    buffer resb 16   

section .text
    global _start

_start:
    pop rdi             
    cmp rdi, 4          
    jne error

    pop rsi             

    pop rsi             
    call atoi
    mov r8, rax         

    pop rsi             
    call atoi
    mov r9, rax         

    pop rsi             
    call atoi
    mov r10, rax        

    ; Trouver le maximum
    mov rax, r8         
    cmp r9, rax
    cmovg rax, r9       

    cmp r10, rax
    cmovg rax, r10      

print_max:
    mov rsi, buffer
    call itoa          

    mov rdx, rsi        
    sub rdx, buffer

    
    mov rax, 1          
    mov rdi, 1          
    mov rsi, buffer
    syscall

    
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    jmp exit_success

error:
    mov rax, 1          
    mov rdi, 1          
    mov rsi, err_msg
    mov rdx, err_len
    syscall
    mov rax, 60
    mov rdi, 1
    syscall

exit_success:
    mov rax, 60         
    xor rdi, rdi        
    syscall


atoi:
    xor rax, rax        
    xor rcx, rcx        
    mov rbx, 1          

    movzx rdx, byte [rsi]
    cmp dl, '-'
    jne atoi_loop
    mov rbx, -1         
    inc rsi             

atoi_loop:
    movzx rdx, byte [rsi]
    test dl, dl
    jz atoi_done

    cmp dl, '0'
    jb error
    cmp dl, '9'
    ja error

    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx

    inc rsi
    jmp atoi_loop

atoi_done:
    imul rax, rbx      
    ret


itoa:
    mov rbx, 0          
    test rax, rax
    jns itoa_loop


    mov byte [rsi], '-'
    inc rsi
    neg rax

itoa_loop:
    mov rdx, 0
    mov rcx, 10
    div rcx             

    add dl, '0'
    push rdx
    inc rbx

    test rax, rax
    jnz itoa_loop

itoa_pop:
    pop rax
    mov [rsi], al
    inc rsi
    dec rbx
    jnz itoa_pop

    ret
