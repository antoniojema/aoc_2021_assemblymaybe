global aoc_day04_1

extern printd, printlb, printcstr, file_read_uint32, printchar

section .data
        tab_size dd 100
        lin_size dd 20
        filename db 'sample1.txt', 0
        
        part       db  'Part 1: ', 0
        file_descr db  '    File descriptor: ', 0
        result     db  '    Result:          ', 0

section .text

;;---------------------;;
;;    Read sequence    ;;
;;---------------------;;
;; Takes: - File descriptor
;;        - Pointer to sequence buffer
read_sequence:
        push    ebp
        mov     ebp, esp
        sub     esp, 12

        ;; 4 -> Separator
        ;; 8 -> Current buffer position

        ;; Set buffer position
        mov     eax, [ebp+12]
        mov     [ebp-8], eax

begin_read_seq:
        ;; Read value
        mov     eax, [ebp+8]
        mov     [esp], eax
        call    file_read_uint32
        cmp     eax, 0
        je      end_read_seq
        ;; Store separator
        mov     [ebp-4], bl

        ; ;; DEBUG
        ; call    printd
        ; mov     al, [ebp-4]
        ; mov     byte [esp], al
        ; call    printchar

        ;; Store value
        mov     eax, [ebp-8]
        mov     ebx, [esp]
        mov     [eax], ebx
        add     eax, 4
        mov     [ebp-8], eax

        ;; If separator is not a comma, exit loop
        cmp     byte [ebp-4], ','
        jne     end_read_seq
        jmp     begin_read_seq
end_read_seq:

        mov     esp, ebp
        pop     ebp
        ret

;;---------------------;;
;;    DAY 04 PART 1    ;;
;;---------------------;;
aoc_day04_1:
        push    ebp
        mov     ebp, esp
        sub     esp, 14344 ;; 14 KB

        ;;      4  -> file descriptor
        ;;      8  -> pointer to sequence buffer
        ;;      12 -> pointer to table buffer
        ;;      1024-1536  -> sequence buffer (len = 128*4)
        ;;      1536-14336 -> table buffer (len = 128*(5*5*4))
        ;;      +4 -> arg1
        ;;      +8 -> arg2

        ;; Set pointers
        lea     eax, [ebp-1536]
        mov     [ebp-8], eax
        lea     eax, [ebp-14336]
        mov     [ebp-12], eax

        ;; Open file and store file descriptor
        mov     eax, 5
        mov     ebx, filename
        mov     ecx, 0
        mov     edx, 0777
        int     0x80
        mov     [ebp-4], eax

        ;; Print file descriptor
        mov     dword [esp], file_descr
        call    printcstr
        mov     eax, [ebp-4]
        mov     [esp], eax
        call    printd
        call    printlb

        ;; Read sequence
        mov     eax, [ebp-4]
        mov     [esp  ], eax
        mov     eax, [ebp-8]
        mov     [esp+4], eax
        call    read_sequence

        ;; Close file
        mov     eax, 6
        mov     ebx, [ebp-4]
        int     0x80

        mov     esp, ebp
        pop     ebp
        ret