global aoc_day03_2

extern printcstr, printlb, printd

section .data
        filename  db      'sample2.txt', 0
        part1     db      'Part 2:', 0
        file_des  db      '    File descriptor: ', 0
        lines     db      '    Lines read:      ', 0
        epsil     db      '    epsilon:         ', 0
        gamma     db      '    gamma:           ', 0
        multi     db      '    Product:         ', 0

section .text
aoc_day03_2:
        push    ebp
        mov     ebp, esp
        sub     esp, 8
        
        ;; 4  -> File descriptor
        ;; 8  -> argument

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

        ;; Print file descriptor
        mov     dword [esp], file_des
        call    printcstr
        mov     eax, [ebp-4]
        mov     [esp], eax
        call    printd
        call    printlb

        ;; Close file
        mov     eax, 6
        mov     ebx, [ebp-4]
        int     0x80

        mov     esp, ebp
        pop     ebp
        ret
