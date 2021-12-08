global aoc_day03_2

extern printcstr, printlb, printd, file_read_line

section .data
        filename  db      'sample2.txt', 0
        part1     db      'Part 2:', 0
        file_des  db      '    File descriptor: ', 0
        lines     db      '    Lines read:      ', 0
        epsil     db      '    epsilon:         ', 0
        gamma     db      '    gamma:           ', 0
        multi     db      '    Product:         ', 0
        no_bits   dd      12

section .text
aoc_day03_2:
        push    ebp
        mov     ebp, esp
        sub     esp, 212
        
        ;; 4   -> File descriptor
        ;; 132 -> Char buffer begin (len=128)
        ;; 180 -> Int buffer for comparison
        ;; 184 -> Pointer to int buffer current position
        ;; 188 -> Counter of int buffer
        ;; 192 -> Pointer to char buffer current position
        ;; 196 -> Epsilon
        ;; 200 -> Gamma
        ;; 204 -> Product
        ;;  +4 -> argument 2
        ;;  +8 -> argument 1

        ;; Print part1
        mov     dword [esp], part1
        call    printcstr
        call    printlb

        ;; Open file and store file descriptor
        mov     eax, 5
        mov     ebx, filename
        mov     ecx, 0
        mov     edx, 0777
        int     0x80
        mov     [ebp-4], eax

        ; ;; Print file descriptor
        ; mov     dword [esp], file_des
        ; call    printcstr
        ; mov     eax, [ebp-4]
        ; mov     [esp], eax
        ; call    printd
        ; call    printlb

        ;; Set int buffet to zero
        lea     eax, [ebp-180]
        lea     ebx, [ebp-132]
begin_set_zero:
        mov     dword [eax], 0
        add     eax, 4
        cmp     eax, ebx
        jge     end_set_zero
        jmp     begin_set_zero
end_set_zero:

begin_get_lines:
        ;; Get line
        mov     eax, [ebp-4]
        mov     [esp], eax
        lea     eax, [ebp-132]
        mov     [esp+4], eax
        call    file_read_line

        cmp     eax, 0
        je      end_get_lines

        ; ;; Print line
        ; lea     eax, [ebp-132]
        ; mov     [esp], eax
        ; call    printcstr

        ;; Set pointers and counter of int buffer
        lea     eax, [ebp-180]
        mov     [ebp-184], eax
        
        lea     eax, [ebp-132]
        mov     [ebp-192], eax

        mov     dword [ebp-188], 0
begin_append:
        ;; If '0' sub 1, if '1' add 1, else exit all loops
        mov     eax, [ebp-192]
        mov     al, [eax]
        cmp     al, '0'
        jne     try_1
        
        mov     eax, [ebp-184]
        mov     ebx, [eax]
        sub     ebx, 1
        mov     [eax], ebx

        jmp     exit_try
try_1:
        cmp     al, '1'
        jne     try_none
        
        mov     eax, [ebp-184]
        mov     ebx, [eax]
        add     ebx, 1
        mov     [eax], ebx

        jmp     exit_try
try_none:
        jmp     end_get_lines
exit_try:

        ; Add to pointers and 1 to counter
        mov     eax, [ebp-184]
        add     eax, 4
        mov     [ebp-184], eax

        mov     eax, [ebp-192]
        add     eax, 1
        mov     [ebp-192], eax

        mov     eax, [ebp-188]
        add     eax, 1
        mov     [ebp-188], eax

        ; ;; If counter is equal to number of bits, exit append loop
        mov     eax, [ebp-188]
        cmp     eax, [no_bits]
        jge     end_append
        
        ;; Else, go back to begin
        jmp     begin_append  

end_append:

        jmp     begin_get_lines

end_get_lines:
        ; call    printlb

        ;; Read int buffer
        mov     dword [ebp-196], 0 ;; epsilon
        mov     dword [ebp-200], 0 ;; gamma
        lea     eax, [ebp-180]
        mov     cl, [no_bits]
begin_read_int:
        sub     cl, 1
        cmp     dword [eax], 0
        jl      more_0
more_1:
        mov     ebx, 1
        shl     ebx, cl
        or      [ebp-196], ebx
        jmp     end_comp
more_0:
        mov     ebx, 1
        shl     ebx, cl
        or      [ebp-200], ebx
        jmp     end_comp
end_comp:
        add     eax, 4
        cmp     cl, 0
        jle     end_read_int
        jmp     begin_read_int
end_read_int:

        ;; Close file
        mov     eax, 6
        mov     ebx, [ebp-4]
        int     0x80

        ;; Calculate product
        mov     eax, [ebp-196]
        imul    eax, [ebp-200]
        mov     [ebp-204], eax

        ;; Print epsilon
        mov     dword [esp], epsil
        call    printcstr
        mov     eax, [ebp-196]
        mov     [esp], eax
        call    printd
        call    printlb

        ;; Print gamma
        mov     dword [esp], gamma
        call    printcstr
        mov     eax, [ebp-200]
        mov     [esp], eax
        call    printd
        call    printlb

        ;; Print product
        mov     dword [esp], multi
        call    printcstr
        mov     eax, [ebp-204]
        mov     [esp], eax
        call    printd
        call    printlb

        mov     esp, ebp
        pop     ebp
        ret
