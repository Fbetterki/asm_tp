section .data
    userMessage db 'Result: ', 0xA
    userMessageLen equ $ - userMessage
    resultBuffer times 20 db 0

section .text
    global _start

_start:
    ; Vérifier si deux arguments sont fournis
    mov rdi, [rsp + 16]  ; argv[1]
    test rdi, rdi
    jz exitFailure
    mov rsi, [rsp + 24]  ; argv[2]
    test rsi, rsi
    jz exitFailure

    ; Convertir le premier argument en entier
    call convertToInt
    mov r12, rax         ; Stocker le résultat
    mov rdi, rsi         ; Charger le deuxième argument dans rdi

    ; Convertir le deuxième argument en entier
    call convertToInt
    add rax, r12         ; Ajouter les deux entiers

    ; Convertir le résultat en chaîne de caractères
    mov rdi, rax
    mov rsi, resultBuffer
    call intToString

    ; Afficher "Result: "
    mov rdi, 1
    mov rax, 1
    mov rsi, userMessage
    mov rdx, userMessageLen
    syscall

    ; Afficher le résultat
    mov rdi, 1
    mov rax, 1
    mov rsi, resultBuffer
    mov rdx, 20
    syscall

    ; Sortir avec le code de statut 0
    mov eax, 60
    xor edi, edi
    syscall

exitFailure:
    ; Sortir avec le code de statut 1
    mov eax, 60
    mov edi, 1
    syscall

convertToInt:
    xor rbx, rbx
    xor rcx, rcx
    mov rdx, 0          ; rdx sera utilisé pour indiquer si le nombre est négatif
    mov al, [rdi]
    cmp al, '-'         ; Vérifier si le nombre est négatif
    jne .nextChar
    inc rdi             ; Passer le signe moins
    mov rdx, 1          ; Indiquer que le nombre est négatif

.nextChar:
    movzx rax, byte [rdi + rcx]
    test  rax, rax
    jz    .done
    sub   rax, '0'
    imul  rbx, rbx, 10
    add   rbx, rax
    inc   rcx
    jmp   .nextChar

.done:
    cmp rdx, 0
    je .positive
    neg rbx             ; Si le nombre est négatif, inverser le signe
.positive:
    mov rax, rbx
    ret

intToString:
    mov     rcx, 10
    mov     rdi, rsi
    add     rdi, 20
    mov     byte [rdi], 0
    mov     rbx, rdi    ; Sauvegarder la fin de la chaîne

    ; Gérer le cas où rax est 0
    test    rax, rax
    jnz     .not_zero
    dec     rdi
    mov     byte [rdi], '0'
    ret

.not_zero:
    test    rax, rax
    jns     .positiveNumber
    neg     rax         ; Si le nombre est négatif, inverser le signe

.positiveNumber:
.nextDigit:
    dec     rdi
    xor     rdx, rdx
    div     rcx
    add     dl, '0'
    mov     [rdi], dl
    test    rax, rax
    jnz     .nextDigit

    cmp     byte [rsi], '-' ; Si le nombre était négatif
    jns     .done
    dec     rdi
    mov     byte [rdi], '-'

.done:
    ret
