extern printf
extern scanf
extern exit

section .bss
%define SIZE 8                ; Макрос     
number resq SIZE

section .text ; код корректно вычисляет значение до 16! (включительно), после до 20 идет переполение и дальше вычисления
global main

main:
    push rax                    ; открытие стека
    mov rdi,message             ; первый параметр функции printf - строка форматирования
    xor rax,rax                 ; конец передачи аргументов
    call printf                 ; вызов функции
    pop rax                     ; восстановление стека

    push rax                    ; открытие стека 
    mov rdi,num                 ; первый параметр функции scanf
    mov rsi, number             ; запись аргумента в number
    xor rax,rax                 ; конец передачи аргументов
    call scanf                  ; вызов функции
    pop rax                     ; восстановление стека

    mov rax, [number]           ; запись в регистр rax значнения из number
    mov rdi, ziro_check         ; запись в регистр rdi значение из ziro
    cmp rax, rdi                ; проверка и последующая установление флагов (rdi - rax (0 - number))
    jz factroial_zero           ; флаг в случае если при сравнении числа оказались равны
    jg factroial_error          ; флаг в случае если при сравнении числа оказалось что оно отрицательно
    jne factorial               ; флак в случае если при сравнении чисел все ок

    jmp exit_function           ; переход на завершение программы

factroial_error:
    mov rax, 0                  ; запись в регистр rax значения 0

    push rax                    ; открытие стека
    mov rdi, message_error      ; первый параметр функции printf - строка форматирования
    xor rax, rax                ; конец передачи аргументов
    call printf                 ; вызов функции
    pop rax                     ; восстановление стека

    jmp exit_function           ; переход на завершение программы

factroial_zero:
    mov rax, 0                  ; запись в регистр rax значения 0
    mov rsi, 0                  ; запись в регистр rsi значения 0
    mov rdi, 0                  ; запись в регистр rdi значения 0
    mov rdx, 1

    push rax                    ; открытие стека
    mov rdi, message_result     ; первый параметр функции printf - строка форматирования
    mov rsi, 0                  ; первый аргумент для строки форматирования
    mov rcx, rdx                ; второй аргумент для строки форматирования
    xor rax, rax                ; конец передачи аргументов
    call printf                 ; вызов функции
    pop rax                     ; восстановление стека

    jmp exit_function
factorial:
    mov rax, 1                  ; приравнивание регистра rax к 1 
    mov rcx, [number]           ; передача регистру rcx значения number (хранение счетчика цикла)
    cmp rcx, 0
    je factroial_zero
factroial_loop:
    mul rcx                     ; беззнаковое умножение регистра rcx на значение регистра rax (действие цикла(rax = rax * rcx))
    loop factroial_loop         ; цикл (уменьшает значение rcx на 1 переходим к метке factorial_loop если rcx не равен 0)
    mov rdx, rax                ; rdx = rax = n
print:
    mov rax, 0                  ; обнуление
    mov rdi, 0                  ; обнуление
    mov rsi, 0                  ; обнуление
    push rax                    ; открытие стека
    mov rdi, message_result     ; первый параметр функции printf - строка форматирование
    mov rsi, [number]           ; первый аргумент для строки форматирования
    mov rcx, rdx                ; второй аргумент для строки форматирования
    xor rax, rax                ; конец передачи аргументов
    call printf                 ; вызов функции
    pop rax                     ; восстановление стека
    jmp exit_function
exit_function:
    push 0
    call exit                   ; вызов функции

section .data
message: db "Введите число: ", 0
message_result: db "%d! = %d", 10, 0
message_error: db "Ошибка, число не может быть отрицательным", 10, 0
num: db "%d"
ziro_check: dq 0

; Максимальное число 33
; При значении 0 уходит в цикл; с 1 - 16 все ок; с 17 - 22 переполнение; все что дальше уже