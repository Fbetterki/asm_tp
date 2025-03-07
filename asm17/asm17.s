section .bss
    buffer resb 1024  ; Buffer pour lire l'entrée standard

section .data
    error_msg db "Usage: ./asm17 <shift>", 10
    error_len equ $ - error_msg

section .text
    global _start

_start:
    
    pop rax
    cmp rax, 2
    jne print_usage

    
    pop rdi             
    pop rdi             
    call atoi           
    mov r8, rax         

    
    mov rax, 0          
    mov rdi, 0          
    mov rsi, buffer
    mov rdx, 1024
    syscall

    cmp rax, 0
    jle exit_error      

    
    mov rbx, buffer
    add rbx, rax
    dec rbx
    cmp byte [rbx], 10  
    jne encrypt_loop
    mov byte [rbx], 0   

encrypt_loop:
    mov rsi, buffer
encrypt_char:
    mov al, [rsi]
    test al, al
    jz print_result     

    cmp al, 'a'
    jb check_uppercase
    cmp al, 'z'
    ja check_uppercase

    
    sub al, 'a'
    add al, r8b
    cmp al, 26
    jb store_char
    sub al, 26

store_char:
    add al, 'a'
    mov [rsi], al
    jmp next_char

check_uppercase:
    cmp al, 'A'
    jb next_char
    cmp al, 'Z'
    ja next_char

    
    sub al, 'A'
    add al, r8b
    cmp al, 26
    jb store_upper
    sub al, 26

store_upper:
    add al, 'A'
    mov [rsi], al

next_char:
    inc rsi
    jmp encrypt_char

print_result:
    
    mov rax, 1          
    mov rdi, 1          
    mov rsi, buffer
    mov rdx, 1024
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
    jmp exit_error

exit_error:
    mov rax, 60
    mov rdi, 1
    syscall


atoi:
    xor rax, rax
    xor rcx, rcx
    xor rdx, rdx

atoi_loop:
    movzx rdx, byte [rdi+rcx]
    test rdx, rdx
    jz atoi_done
    sub rdx, '0'
    cmp rdx, 9
    ja atoi_done
    imul rax, rax, 10
    add rax, rdx
    inc rcx
    jmp atoi_loop

atoi_done:
    ret
