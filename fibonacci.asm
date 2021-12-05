global print_fibonacci

extern printd, printlb

section .data
        fmt     db      '%d', 0xA, 0xD, 0x0

;; Takes: unsigned int32 indicating the number of elements to print
print_fibonacci:
        push    ebp
        mov     ebp, esp
        sub     esp, 16
        
        ;; i   = [ebp-4 ]
        ;; i0  = [ebp-8 ]
        ;; i1  = [ebp-12] ;; Si dejamos i1 y fmt en el stack top
        ;; fmt = [ebp-16] ;; printf es automatico
        
        ;; Values for the for loop
        mov     dword [ebp-4 ], 0
        mov     dword [ebp-8 ], 0
        mov     dword [ebp-12], 1
        mov     dword [ebp-16], fmt
        
        ;; printf first value
        push    dword [ebp-12]
        call    printd
        add     esp, 4
        call    printlb
        
fibonacci_loop_begin:
        mov     eax, [ebp+8]
        cmp     dword [ebp-4], eax
        jge     fibonacci_loop_exit
        
        ;; Fibonacci sum
        mov     eax     , [ebp-12]
        mov     ebx     , [ebp-8]
        add     ebx     , eax
        mov     [ebp-8] , eax
        mov     [ebp-12], ebx 
        
        ;; printf
        push    dword [ebp-12]
        call    printd
        add     esp, 4
        call    printlb
        
        add     dword [ebp-4 ], 1
        jmp     fibonacci_loop_begin
               
fibonacci_loop_exit:
        ;; Return
        add     esp, 16
        pop     ebp
        ret
