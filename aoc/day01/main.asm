global _start

extern aoc_day01_1, aoc_day01_2

section .text

;;------------------;;
;;   START POINT    ;;
;;------------------;;
_start:
        call aoc_day01_1
        call aoc_day01_2

        mov     eax, 1
        xor     ebx, ebx
        int     0x80