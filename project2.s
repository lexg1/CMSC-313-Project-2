.global _start

.section .data
input: .asciz "Enter a number:\n"
output: .asciz "The double is:\n"

.section .bss
buffer: .skip 16

.section .text

_writeInput:
    movq $1, %rax
    movq $1, %rdi
    leaq input(%rip), %rsi
    movq $16, %rdx
    syscall

_getNumber: 
    movq $0, %rax
    movq $0, %rdi
    leaq buffer(%rip), %rsi
    movq $16, %rdx
    syscall

_clearRegisters:
    xorq %rax, %rax
    xorq %rcx, %rcx

_convertToNumLoop:
    movzbq (%rsi), %rcx
    cmpb $10, %cl
    je _doubleNumber
    cmpb $0, %cl
    je _doubleNumber

    subq $48, %rcx
    imulq $10, %rax
    addq %rcx, %rax

    incq %rsi
    jmp _convertToNumLoop

_doubleNumber:
    imulq $2, %rax

_setUpRegisters:
    leaq buffer+15(%rip), %rsi
    movb $10, (%rsi)
    movq $10, %rbx

_convertToAsciiLoop:
    decq %rsi
    xorq %rdx, %rdx
    divq %rbx

    addq $48, %rdx
    movb %dl, (%rsi)

    cmpq $0, %rax
    jne _convertToAsciiLoop
    

_printResult:
    leaq buffer+16(%rip), %rdx
    subq %rsi, %rdx
    pushq %rsi
    pushq %rdx
    movq $1, %rax
    movq $1, %rdi
    leaq output(%rip),%rsi
    movq $15, %rdx
    syscall
    pop %rdx
    pop %rsi

    movq $1, %rax
    movq $1, %rdi
    syscall

_exitProgram:
    movq $60, %rax
    movq $0, %rdi
    syscall

_start:
    call _writeInput
    call _getNumber
    call _clearRegisters
    call _convertToNumLoop
    call _setUpRegisters
    call _convertToAsciiLoop
    call _printResult
    call _exitProgram
    