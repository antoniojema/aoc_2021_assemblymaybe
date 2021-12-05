global file_create, file_close, file_open, file_read_uint32

extern cstr_to_uint32, printd, printlb

section .text
;;------------------;;
;;   file_create    ;;
;;------------------;;
;; - Takes:
;;      - Pointer to string with filename
;;      - Permissions
;; - Creates a file
;; - Returns:
;;      - File descriptor / error code
file_create:
        push    ebp
        mov     ebp, esp

        ;; syscall
        mov     eax, 8
        mov     ebx, [ebp+8]  ;; filename
        mov     ecx, [ebp+12] ;; permissions
        int     0x80

        ;; Return file descriptor
        mov     [ebp+12], eax

        pop     ebp
        ret

;;-----------------;;
;;   file_close    ;;
;;-----------------;;
;; - Takes:
;;      - File descriptor
;; - Closes a file
;; - Returns:
;;      - Error code
file_close:
        push    ebp
        mov     ebp, esp

        ;; syscall
        mov     eax, 6
        mov     ebx, [ebp+8]  ;; descriptor
        int     0x80

        ;; Return file descriptor
        mov     [ebp+8], eax

        pop     ebp
        ret

;;----------------;;
;;   file_open    ;;
;;----------------;;
;; - Takes:
;;      - Pointer to string with filename
;;      - Access mode
;;      - Permissions
;; - Creates a file
;; - Returns:
;;      - File descriptor / error code
file_open:
        push    ebp
        mov     ebp, esp

        ;; syscall
        mov     eax, 5
        mov     ebx, [ebp+8 ] ;; filename
        mov     ecx, [ebp+12] ;; access mode (0 (read-only), 1(write-only), 2(read-write))
        mov     edx, [ebp+16] ;; permissions
        int     0x80

        ;; Return file descriptor
        mov     [ebp+16], eax

        pop     ebp
        ret

;;-----------------------;;
;;   file_read_uint32    ;;
;;-----------------------;;
;; - Takes:
;;      - File descriptor
;; - Returns:
;;      - Next digit read by any separator
file_read_uint32:
        push    ebp
        mov     ebp, esp
        sub     esp, 144

        ;;      4   -> File descriptor
        ;;      8   -> Last read digit
        ;;      136 -> Digits buffer
        ;;      140 -> Pointer to next digit in buffer
        ;;      144 -> argument

        mov     eax, [ebp+8]
        mov     [ebp-4], eax
        lea     eax, [ebp-136]
        mov     [ebp-140], eax

        ;; Read chars until find a digit
check_digit:
        ;; Read syscall
        mov     eax, 3
        mov     ebx, [ebp-4]
        lea     ecx, [ebp-8]
        mov     edx, 1
        int     0x80

        ;; If read-error, exit
        cmp     eax, 1
        jne     end_read_uint32

        mov     al, [ebp-8]
        cmp     al, '0'
        jl      check_digit
        cmp     al, '9'
        jg      check_digit
        jmp     middle_read_uint32

begin_read_uint32:
        ;; Read syscall
        mov     eax, 3
        mov     ebx, [ebp-4]
        lea     ecx, [ebp-8]
        mov     edx, 1
        int     0x80

        ;; If read-error, exit
        cmp     eax, 1
        jne     end_read_uint32

middle_read_uint32:
        ;; If not a digit, exit
        mov     al, [ebp-8]
        cmp     al, '0'
        jl      end_read_uint32
        cmp     al, '9'
        jg      end_read_uint32

        ;; Store in buffer
        mov     ebx, [ebp-140]
        mov     byte [ebx], al
        add     ebx, 1
        mov     [ebp-140], ebx

        jmp     begin_read_uint32

end_read_uint32:
        ;; Store a null char (0) in buffer and reset pointer to beginning
        mov     eax, [ebp-140]
        mov     byte [eax], 0
        lea     eax, [ebp-136]
        mov     [esp], eax
        call    cstr_to_uint32

        ;; Return uint32
        mov     eax, [esp]
        mov     [ebp+8], eax
        lea     eax, [ebp-136]
        sub     eax, [ebp-140]
        
        ;; Return
        mov     esp, ebp
        pop     ebp
        ret
