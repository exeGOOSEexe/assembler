section .data
    num1: dq 5
    num2: dq 6
    print: db "%u + % u = %u"
global main
section .text
extern printf

main:
    push rax
    mov rdi, print
    mov rsi, [num1]
    mov rdx, [num2]
    mov rcx, rdx
    add rcx, rsi
    xor rax, rax
    call printf
    pop rax

    ret
