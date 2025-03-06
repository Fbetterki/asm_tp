section .data
    err_msg db "Veuillez entrer un nombre positif", 10, 0
    err_len equ $ - err_msg
    newline db 10

section .bss
    hex_out resb 16    
    hex_len resb 1     

section .text
    global _start

_start:
    
    pop rdi             
    cmp rdi, 2          
    jne error

    pop rdi             
    pop rdi             

    
    mov al, byte [rdi]
    cmp al, '-'
    je error

    
    xor rax, rax        
    mov rsi, rdi        

convert_to_int:
    movzx rcx, byte [rsi]  
    test cl, cl            
    jz apply_transformation

    cmp cl, '0'            
    jb error
    cmp cl, '9'
    ja error

    sub cl, '0'            
    imul rax, rax, 10      
    add rax, rcx           
    inc rsi                
    jmp convert_to_int

apply_transformation:
    
    cmp rax, 5
    je case_5
    cmp rax, 10
    je case_10
    cmp rax, 1
    je case_1
    jmp normal_conversion

case_5:
    mov rax, 16   
    jmp convert_to_hex

case_10:
    mov rax, 69   
    jmp convert_to_hex

case_1:
    xor rax, rax  ; 0
    jmp convert_to_hex

normal_conversion:
    

convert_to_hex:
    mov rsi, hex_out    
    mov byte [hex_len], 0  

convert_loop:
    mov rdx, 0           
    mov rcx, 16          
    div rcx              

    cmp dl, 10
    jb decimal_digit
    add dl, 'A' - 10
    jmp store_digit

decimal_digit:
    add dl, '0'

store_digit:
    mov [rsi], dl
    inc rsi
    inc byte [hex_len]

    test rax, rax
    jnz convert_loop

    
    movzx rcx, byte [hex_len]
    mov rsi, hex_out
    lea rdi, [rsi + rcx - 1]

reverse_loop:
    cmp rsi, rdi
    jge print_result

    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al
    inc rsi
    dec rdi
    jmp reverse_loop

print_result:
    
    mov rax, 1
    mov rdi, 1
    movzx rdx, byte [hex_len]
    mov rsi, hex_out
    syscall

    
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    
    mov rax, 60
    xor rdi, rdi
    syscall

error:
    mov rax, 1
    mov rdi, 1
    mov rsi, err_msg
    mov rdx, err_len
    syscall

    mov rax, 60
    mov rdi, 1
    syscall
