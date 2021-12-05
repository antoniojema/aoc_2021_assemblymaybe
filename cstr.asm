global cstr_to_uint32, cstr_seek_end, invert_cstr, cstr_len

section .text

;;---------------------;;
;;   cstr_to_uint32    ;;
;;---------------------;;
;; - Takes a pointer to a cstr through the stack
;; - Returns cstr converted to uint32 in the same stack position
cstr_to_uint32:
        push    ebp
        mov     ebp, esp

        ;; ebx will point to the begin-1 of the cstr
        ;; ecx will point to the end character (null)
        ;; [ebp-8] will store the value
        mov     ebx, [ebp+8]
        mov     dword [ebp+8], 0
        mov     ecx, ebx
        sub     ebx, 1

count_loop_begin:
        cmp     byte [ecx], 0
        je      count_loop_exit
        cmp     byte [ecx], '0' ; if not a number char
        jl      sum_loop_end    ; goto end of function
        cmp     byte [ecx], '9' ;
        jg      sum_loop_end    ;
        add     ecx, 1
        jmp     count_loop_begin

count_loop_exit:
        ;; edx will be the multiplier 1, 10, 100...
        mov     edx, 1            

        ;; If ebx == ecx return 0
        ; cmp     ebx, ecx
        ; je      cstr_to_int_end

        sub     ecx, 1
sum_loop_begin:
        cmp     ebx, ecx
        je      sum_loop_end

        movzx   eax, byte [ecx]
        sub     eax, '0'
        imul    eax, edx
        add     [ebp+8], eax
        sub     ecx, 1
        imul    edx, 10
        jmp     sum_loop_begin

sum_loop_end:
        pop     ebp
        ret

;;--------------------;;
;;   cstr_seek_end    ;;
;;--------------------;;
;; - Takes a pointer to a cstr through the stack
;; - Returns a pointer to the end character in same position
cstr_seek_end:
        push    ebp
        mov     ebp, esp

        mov     eax, [ebp+8]
seek_loop_begin:
        cmp     byte [eax], 0
        je      seek_loop_exit
        add     eax, 1
        jmp     seek_loop_begin

seek_loop_exit:
        mov     [ebp+8], eax
        pop     ebp
        ret

;;---------------;;
;;   cstr_len    ;;
;;---------------;;
;; - Takes a pointer to a cstr through the stack
;; - Returns a uint32 that stores the string length
cstr_len:
        push    ebp
        mov     ebp, esp
        sub     esp, 4
        
        mov     eax, [ebp+8]
        mov     [ebp-4], eax
        call    cstr_seek_end
        mov     eax, [ebp+8]
        mov     ebx, [ebp-4]
        sub     ebx, eax
        mov     [ebp+8], ebx

        add     esp, 4
        pop     ebp
        ret


;;------------------;;
;;   invert_cstr    ;;
;;------------------;;
;; - Takes a pointer to a cstr through the stack
;; - Inverts the character positions
invert_cstr:
        push    ebp
        mov     ebp, esp
        sub     esp, 4

        mov     eax, [ebp+8]
        mov     [ebp-4], eax
        ; call    printcstr

        ;; Seek end
        mov     eax, [ebp+8]
        mov     [ebp-4], eax
        call    cstr_seek_end
        
        ;; eax = begin, ebx = end
        mov     eax, [ebp+8]
        mov     ebx, [ebp-4]
        sub     ebx, 1

invert_loop_begin:
        cmp     eax, ebx
        jge     invert_loop_end
        mov     cl, byte [eax]
        mov     dl, byte [ebx]
        mov     byte [eax], dl
        mov     byte [ebx], cl
        add     eax, 1
        sub     ebx, 1
        jmp     invert_loop_begin

invert_loop_end:
        add     esp, 4
        pop     ebp
        ret
