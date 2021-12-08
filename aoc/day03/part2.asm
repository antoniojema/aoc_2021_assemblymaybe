global aoc_day03_2

extern printcstr, printlb, printd, file_read_line, cstr_read_bits

section .data
        filename  db      'input2.txt', 0
        part      db      'Part 2:', 0
        file_des  db      '    File descriptor: ', 0
        lines     db      '    Lines read:      ', 0
        oxige     db      '    Oxigen:          ', 0
        co2       db      '    CO2:             ', 0
        multi     db      '    Product:         ', 0
        no_bits   dd      12

section .text
aoc_day03_2:
        push    ebp
        mov     ebp, esp
        sub     esp, 4096
        
        ;; 4   -> File descriptor
        ;; 132 -> Char buffer begin (len=128)
        ;; 136 -> Counter of 0s and 1s (oxygen)
        ;; 140 -> Bit counter
        ;; 144 -> Oxygen
        ;; 148 -> CO2
        ;; 152 -> Bitmask
        ;; 156 -> Number
        ;; 160 -> Counter of 0s and 1s (co2)
        ;; 164 -> Counter of co2 lines read
        ;; 168 -> Last co2 line read as integer
        ;; 172 -> Product
        ;;  +4 -> argument 2
        ;;  +8 -> argument 1

        ;; Print part
        mov     dword [esp], part
        call    printcstr
        call    printlb

        ;; Set bit counter to number of bits
        mov     eax, [no_bits]
        mov     dword [ebp-140], eax
        ;; Set oxygen & co2 & bitmask to 0
        mov     dword [ebp-144], 0
        mov     dword [ebp-148], 0
        mov     dword [ebp-152], 0

        ;; Read file as many times as necessary
begin_read_file:

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

        ;; Decrease bit counter
        sub     dword [ebp-140], 1

        ;; Set 0s-1s counter to 0 (oxyg and co2)
        mov     dword [ebp-136], 0
        mov     dword [ebp-160], 0
        ;; Counter of co2 lines read
        mov     dword [ebp-164], 0
begin_get_line:
        ;; Get line
        mov     eax, [ebp-4]
        mov     [esp], eax
        lea     eax, [ebp-132]
        mov     [esp+4], eax
        call    file_read_line

        cmp     eax, 0
        je      end_get_line

        ;; Convert to number
        lea     eax, [ebp-132]
        mov     [esp], eax
        call    cstr_read_bits
        mov     eax, [esp]
        mov     [ebp-156], eax

        ;; Compare with oxygen value
        mov     eax, [ebp-144] ;; oxygen
        and     eax, [ebp-152]
        mov     ebx, [ebp-156] ;; current read val
        and     ebx, [ebp-152]
        cmp     eax, ebx
        jne     dont_compare_oxygen
        ;; If they're equal, add or sub to 1s-0s counter
        mov     cl,  [ebp-140] ;; Bit counter
        mov     ebx, [ebp-136] ;; 1s-0s counter
        mov     eax, 1
        shl     eax, cl
        and     eax, [ebp-156]
        shr     eax, cl
        imul    eax, 2
        sub     eax, 1
        add     ebx, eax
        mov     [ebp-136], ebx
dont_compare_oxygen:

        ;; Compare with co2 value
        mov     eax, [ebp-148] ;; co2
        and     eax, [ebp-152]
        mov     ebx, [ebp-156] ;; current read val
        and     ebx, [ebp-152]
        cmp     eax, ebx
        jne     dont_compare_co2
        ;; If they're equal, add or sub to 1s-0s counter
        mov     cl,  [ebp-140] ;; Bit counter
        mov     ebx, [ebp-160] ;; 1s-0s counter
        mov     eax, 1
        shl     eax, cl
        and     eax, [ebp-156]
        shr     eax, cl
        imul    eax, 2
        sub     eax, 1
        add     ebx, eax
        mov     [ebp-160], ebx
        ;; Get the last line read
        mov     eax, [ebp-156]
        mov     [ebp-168], eax

dont_compare_co2:

        ;; Read another line
        jmp     begin_get_line

end_get_line:

        ;; Get next bit of oxygen value
        mov     eax, [ebp-144] ;; oxyg
        mov     ebx, [ebp-136] ;; 0s-1s counter
        mov     cl,  [ebp-140] ;; bit counter
        cmp     ebx, 0
        jl      more_0_ox
more_1_ox:
        mov     edx, 1
        shl     edx, cl
        or      eax, edx
        mov     [ebp-144], eax
more_0_ox:

        ;; Get next bit of co2 value
        mov     eax, [ebp-148] ;; co2
        mov     ebx, [ebp-160] ;; 0s-1s counter
        mov     cl,  [ebp-140] ;; bit counter
        cmp     ebx, 0
        jge     more_1_co2
more_0_co2:
        mov     edx, 1
        shl     edx, cl
        or      eax, edx
        mov     [ebp-148], eax
more_1_co2:

        ;; Close file
        mov     eax, 6
        mov     ebx, [ebp-4]
        int     0x80

        ;; Increase bitmask
        mov     eax, [ebp-152]
        mov     cl,  [ebp-140]
        mov     ebx, 1
        shl     ebx, cl
        or      eax, ebx
        mov     [ebp-152], eax

        cmp     dword [ebp-140], 0
        jg      begin_read_file
end_read_file:

        ;; Actual co2 value is the last read value
        mov     eax, [ebp-168]
        mov     [ebp-148], eax

        ;; Calculate product
        mov     eax, [ebp-144]
        imul    eax, [ebp-148]
        mov     [ebp-172], eax

        ;; Print oxygen
        mov     dword [esp], oxige
        call    printcstr
        mov     eax, [ebp-144]
        mov     [esp], eax
        call    printd
        call    printlb

        ;; Print co2
        mov     dword [esp], co2
        call    printcstr
        mov     eax, [ebp-148]
        mov     [esp], eax
        call    printd
        call    printlb

        ;; Print product
        mov     dword [esp], multi
        call    printcstr
        mov     eax, [ebp-172]
        mov     [esp], eax
        call    printd
        call    printlb

        mov     esp, ebp
        pop     ebp
        ret
