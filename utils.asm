global  set_8buffer_to

extern printchar

section .text
;;---------------------;;
;;   set_8buffer_to    ;;
;;---------------------;;
;; - Takes:
;;      - Pointer to a buffer
;;      - Number of elements of buffer
;;      - Value to fill
;; - Sets a 8-bit element buffer to a given value
set_8buffer_to:
        push    ebp
        mov     ebp, esp

        mov     eax, [ebp+8 ]
        mov     ebx, [ebp+12]
        add     ebx, eax
        mov     cl, byte [ebp+16]

_8buffer_loop_begin:
        cmp     eax, ebx
        jge     _8buffer_loop_end
        mov     byte [eax], cl
        add     eax, 1
        
        jmp     _8buffer_loop_begin

_8buffer_loop_end:
        pop     ebp
        ret