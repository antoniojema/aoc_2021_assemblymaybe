global aoc_day02_1

extern printcstr, printlb, printd, file_read_uint32

section .data
        filename  db      'input1.txt', 0
        file_des  db      'File descriptor: ', 0
        lines     db      'Lines read:        ', 0
        horiz     db      'Part 1 horizontal: ', 0
        verti     db      'Part 1 depth:      ', 0
        multi     db      'Part 1 product:    ', 0

section .text
aoc_day02_1:
        push    ebp
        mov     ebp, esp
        sub     esp, 28

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

        ;; Set x & y
        mov     dword [ebp-8 ], 0
        mov     dword [ebp-12], 0
        ;; Set i
        mov     dword [ebp-24], 0
begin_read_file:
        ;; Read char w/ syscall
        mov     eax, 3
        mov     ebx, [ebp-4]
        lea     ecx, [ebp-16]
        mov     edx, 1
        int     0x80

        ;; Check read-error stored in eax
        cmp     eax, 0
        je      end_read_file

        ;; Read value
        mov     eax, [ebp-4]
        mov     [esp], eax
        call    file_read_uint32

        ; ;; Check read-error stored in eax
        ; cmp     eax, 0
        ; je      end_read_file

        ;; Store value
        mov     eax, [esp]
        mov     [ebp-20], eax

        ;; Check direction
        cmp     byte [ebp-16], 'u'
        jne     check_down
        mov     eax, [ebp-20]
        sub     [ebp-12], eax
        jmp     end_check_dir
check_down:
        cmp     byte[ebp-16], 'd'
        jne     check_forward
        mov     eax, [ebp-20]
        add     [ebp-12], eax
        jmp     end_check_dir
check_forward:
        mov     eax, [ebp-20]
        add     [ebp-8], eax
end_check_dir:

        ;; Add 1 to i
        mov     eax, [ebp-24]
        add     eax, 1
        mov     [ebp-24], eax
        jmp     begin_read_file

end_read_file:
        ;; Print lines read
        mov     dword [esp], lines
        call    printcstr
        mov     eax, [ebp-24]
        mov     [esp], eax
        call    printd
        call    printlb

        ;; Print horizontal
        mov     dword [esp], horiz
        call    printcstr
        mov     eax, [ebp-8]
        mov     [esp], eax
        call    printd
        call    printlb

        ;; Print vertical
        mov     dword [esp], verti
        call    printcstr
        mov     eax, [ebp-12]
        mov     [esp], eax
        call    printd
        call    printlb

        ;; Print product
        mov     dword [esp], multi
        call    printcstr
        mov     eax, [ebp-8]
        imul    eax, [ebp-12]
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
