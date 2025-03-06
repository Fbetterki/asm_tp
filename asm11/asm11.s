section .bss
    buffer resb 128   ; Buffer pour stocker l'entrée

section .data
    vowels db "aeiouyAEIOUY", 0  ; Ajout de 'y' et 'Y' comme voyelles
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
    jle print_zero     

    
    xor rcx, rcx        
    mov rsi, buffer     

count_vowels:
    movzx rax, byte [rsi]
    test al, al
    jz print_result     

    push rsi            
    mov rdi, vowels     

check_vowel:
    movzx rdx, byte [rdi]
    test dl, dl
    jz no_match

    cmp al, dl
    je is_vowel

    inc rdi
    jmp check_vowel

is_vowel:
    inc rcx             

no_match:
    pop rsi             
    inc rsi             
    jmp count_vowels

print_zero:
    mov rcx, 0          

print_result:
    mov rax, rcx        
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

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall


itoa:
    mov rbx, 0          
    test rax, rax
    jns itoa_loop

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
