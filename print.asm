global printd, printlb, printcstr, printchar

extern cstr_seek_end, cstr_len

section .data
        linebreak      db      0xA
        digits         db      '0123456789'

section .text
;;--------------;;
;;   printlb    ;;
;;--------------;;
;; - Prints a line break
printlb:
        mov     eax, 4
        mov     ebx, 1
        mov     ecx, linebreak
        mov     edx, 1
        int     0x80
        ret

;;-------------;;
;;   printd    ;;
;;-------------;;
;; - Takes a uint32 through the stack
;; - Prints a 4-byte unsigned integer located in the top of the stack
printd:
        push    ebp
        mov     ebp, esp
        sub     esp, 4

        mov     eax, [ebp+8]
        mov     dword [ebp-4], 0

printd_divide10:
        ;; Divide by 10
        xor     edx, edx
        mov     ebx, 10
        div     ebx

        ;; Get digit char
        mov     ecx, digits
        add     ecx, edx
        
        sub     esp, 1
        mov     cl, byte [ecx]
        mov     byte [esp], cl
        
        add     dword [ebp-4], 1

        ;; Jump back
        cmp     eax, 0
        jne     printd_divide10

        ;; Write instruction
        mov     eax, 4
        mov     ebx, 1
        mov     ecx, esp 
        mov     edx, [ebp-4]
        int     0x80
        
        ;; Return
        mov     esp, ebp
        pop     ebp
        ret

;;----------------;;
;;   printcstr    ;;
;;----------------;;
;; - Takes a pointer to a cstr through the stack
;; - Prints it
printcstr:
        push    ebp
        mov     ebp, esp
        sub     esp, 4
        
        ;; Calculate string len
        mov     eax, [ebp+8]
        mov     [ebp-4], eax
        call    cstr_len

        ;; Write syscall
        mov     ebx, 1
        mov     ecx, [ebp+8]
        mov     edx, [ebp-4]
        mov     eax, 4
        int     0x80

        ;; Return
        add     esp, 4
        mov     esp, ebp
        pop     ebp
        ret

;;----------------;;
;;   printchar    ;;
;;----------------;;
;; - Takes a char through the stack
;; - Prints it
printchar:
        push    ebp
        mov     ebp, esp
        
        ;; Get char into ecx
        mov     ecx, ebp
        add     ecx, 8

        ;; Write syscall
        mov     ebx, 1
        mov     edx, 1
        mov     eax, 4
        int     0x80

        ;; Return
        mov     esp, ebp
        pop     ebp
        ret
