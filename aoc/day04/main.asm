global _start

extern aoc_day04_1, aoc_day04_2

section .text

;;------------------;;
;;   START POINT    ;;
;;------------------;;
_start:
        call aoc_day04_1
        ; call aoc_day04_2

        mov     eax, 1
        xor     ebx, ebx
        int     0x80