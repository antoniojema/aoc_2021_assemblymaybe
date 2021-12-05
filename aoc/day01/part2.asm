global aoc_day01_2

extern printcstr, printlb, printd, file_read_uint32, printchar

section .data
        filename  db      'input2.txt', 0
        string1   db      'File descriptor: ', 0
        string2   db      'Number of increments: ', 0

section .text
aoc_day01_2:
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
        mov     dword [esp], string1
        call    printcstr
        mov     eax, [ebp-4]
        mov     [esp], eax
        call    printd
        call    printlb

        mov     dword [ebp-8], 0
        mov     dword [ebp-12], 0
        mov     dword [ebp-16], 0
        mov     dword [ebp-20], 0
        mov     dword [ebp-24], 0
begin_read_file:
        ;; Read value
        mov     eax, [ebp-4]
        mov     [esp], eax
        call    file_read_uint32

        ;; Check read-error stored in eax
        cmp     eax, 0
        je      end_read_file

        ;; If first two iterations, dont compare
        cmp     dword [ebp-8], 2
        jle     continue

        ;; Compare values, if increment add 1 to counter
        mov     eax, [ebp-16] ;; a + b + c
        add     eax, [ebp-20] ;; 
        add     eax, [ebp-24] ;; 
        
        mov     ebx, [ebp-20] ;; b + c + d
        add     ebx, [ebp-24] ;;
        add     ebx, [esp]    ;;
        
        cmp     eax, ebx
        jge     continue

        ;; Increment 1 to the "no. of increments" counter
        mov     eax, [ebp-12]
        add     eax, 1
        mov     [ebp-12], eax

continue:
        mov     eax, [ebp-20]
        mov     [ebp-16], eax
        mov     eax, [ebp-24]
        mov     [ebp-20], eax
        mov     eax, [esp]
        mov     [ebp-24], eax

        ;; Add 1 to the general counter
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
