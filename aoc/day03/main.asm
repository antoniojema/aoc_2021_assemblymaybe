global _start

extern aoc_day03_1, aoc_day03_2

section .text

;;------------------;;
;;   START POINT    ;;
;;------------------;;
_start:
        call aoc_day03_1
        call aoc_day03_2

        mov     eax, 1
        xor     ebx, ebx
        int     0x80