section .data
    msgErreur db "Erreur: veuillez entrer un nombre entier positif.", 0
    inviteUtilisateur db "Veuillez entrer un nombre: ", 0
    msgZero db "0", 0

section .bss
    userInput resb 5
    outputBuffer resb 20

section .text
    global start

start:
    pop rax                  
    pop rsi                  

    cmp rax, 2               
    je paramFourni          
    cmp rax, 1               
    je aucunParamFourni     

    jmp erreur               

paramFourni:
    pop rsi                  
    jmp convertirParametre   

aucunParamFourni:
    mov rax, 1               
    mov rdi, 1               
    mov rsi, inviteUtilisateur  
    mov rdx, 27              
    syscall

    mov rax, 0               
    mov rdi, 0              
    mov rsi, userInput    
    mov rdx, 5               
    syscall

    cmp rax, 0
    je erreur               

    dec rax
    cmp byte [rsi+rax], 10
    jne verifierEntreeVide
    mov byte [rsi+rax], 0

verifierEntreeVide:
    cmp byte [rsi], 0
    je erreur               

    mov rsi, userInput    

convertirParametre:
    xor rax, rax            
    xor rcx, rcx            
    xor rdx, rdx            
    mov r9, 10             

conversionAsciiVersInt:
    movzx rbx, byte [rsi + rcx]
    cmp rbx, 0               
    je conversionTerminee   
    sub rbx, '0'
    cmp rbx, 0
    jb erreur                
    cmp rbx, 9
    ja erreur                

    imul rax, r9             
    add rax, rbx             
    inc rcx                  
    jmp conversionAsciiVersInt  

conversionTerminee:
    cmp rax, 0
    je imprimerZero         

    mov r11, rax             
    xor rax, rax             
    xor rcx, rcx             

calculerSomme:
    inc rcx                  
    cmp rcx, r11
    jge sommeCalculee        
    add rax, rcx             
    jmp calculerSomme        

sommeCalculee:
    lea rsi, [outputBuffer + 20]
    mov byte [rsi], 0
    mov rbx, 10

conversionIntVersChaine:
    dec rsi
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rsi], dl
    test rax, rax
    jnz conversionIntVersChaine

imprimerResultat:
    mov rax, 1              
    mov rdi, 1              
    lea rdx, [outputBuffer + 20]
    sub rdx, rsi
    mov rsi, rsi
    syscall

    mov rax, 60              
    xor rdi, rdi
    syscall

imprimerZero:
    mov rax, 1              
    mov rdi, 1               
    mov rsi, msgZero
    mov rdx, 1              
    syscall

    mov rax, 60             
    xor rdi, rdi
    syscall

erreur:
    mov rax, 1              
    mov rdi, 1               
    mov rsi, msgErreur
    mov rdx, 48             
    syscall

    mov rax, 60             
    mov rdi, 1
    syscall
