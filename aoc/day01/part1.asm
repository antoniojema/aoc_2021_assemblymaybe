global aoc_day01_1

extern printcstr, printlb, printd, file_read_uint32

section .data
        filename  db      'input1.txt', 0
        string1   db      'File descriptor: ', 0
        string2   db      'Part 1: ', 0

section .text
aoc_day01_1:
        push    ebp
        mov     ebp, esp
        sub     esp, 20

        ;; Open file and store file descriptor
        mov     eax, 5
        mov     ebx, filename
        mov     ecx, 0
        mov     edx, 0777
        int     0x80
        mov     [ebp-4], eax

        ; ;; Print file descriptor
        ; mov     dword [esp], string1
        ; call    printcstr
        ; mov     eax, [ebp-4]
        ; mov     [esp], eax
        ; call    printd
        ; call    printlb

        mov     dword [ebp-8], 0
        mov     dword [ebp-12], 0
        mov     dword [ebp-16], 0
begin_read_file:
        ;; Read value
        mov     eax, [ebp-4]
        mov     [esp], eax
        call    file_read_uint32

        ;; Check read-error stored in eax
        cmp     eax, 0
        je      end_read_file

        ;; If first iteration, dont compare
        cmp     dword [ebp-8], 0
        je      continue
        ;; Compare values, if increment add 1 to counter
        mov     eax, [ebp-16]
        cmp     eax, [esp]
        jg      continue
        mov     eax, [ebp-12]
        add     eax, 1
        mov     [ebp-12], eax

continue:
        mov     eax, [esp]
        mov     [ebp-16], eax

        mov     eax, [ebp-8]
        add     eax, 1
        mov     [ebp-8], eax
        jmp     begin_read_file

end_read_file:

        ;; Print number of increments
        mov     dword [esp], string2
        call    printcstr
        mov     eax, [ebp-12]
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
