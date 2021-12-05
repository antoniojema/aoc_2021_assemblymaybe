nasm -f elf32 ./../../main.asm       -o ./../../objects/main.o
nasm -f elf32 ./../../fibonacci.asm  -o ./../../objects/fibonacci.o
nasm -f elf32 ./../../print.asm      -o ./../../objects/print.o
nasm -f elf32 ./../../cstr.asm       -o ./../../objects/cstr.o
nasm -f elf32 ./../../file.asm       -o ./../../objects/file.o
nasm -f elf32 ./../../utils.asm      -o ./../../objects/utils.o
nasm -f elf32 ./part1.asm            -o ./../../objects/aoc_day01_1.o
nasm -f elf32 ./part2.asm            -o ./../../objects/aoc_day01_2.o
ld -m elf_i386 \
    ./../../objects/main.o        \
    ./../../objects/print.o       \
    ./../../objects/fibonacci.o   \
    ./../../objects/cstr.o        \
    ./../../objects/file.o        \
    ./../../objects/utils.o       \
    ./../../objects/aoc_day01_1.o \
    ./../../objects/aoc_day01_2.o \
    -o ./main
./main
echo Exit value: $?
