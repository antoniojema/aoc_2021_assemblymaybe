global _start

extern aoc_day02_1, aoc_day02_2, printlb

section .text

;;------------------;;
;;   START POINT    ;;
;;------------------;;
_start:
        call aoc_day02_1
        call printlb
        call aoc_day02_2

        mov     eax, 1
        xor     ebx, ebx
        int     0x80