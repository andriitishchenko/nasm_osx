
[Part 1](README.md) | [Part 2](part2.md)
-----

# Registers and Types

|64-bit long |Notes|Type|32-bit int|16-bit short|8-bit char|
|-|-|-|-|-|-|
|rax| Values are returned from functions in this register. |scratch |	eax|	ax|	ah and al|
|rcx| Typical scratch register.  Some instructions also use it as a counter.|	scratch |	ecx|	cx|	ch and cl|
|rdx| Scratch register.|	scratch | edx|	dx|	dh and dl|
|rbx| Preserved register|   preserved|	ebx|	bx|	bh and bl|
|rsp| The stack pointer.  Points to the top of the stack |preserved|	esp|	sp|	spl|
|rbp| Preserved register.  Sometimes used to store the old value of the stack pointer, or the "base" |preserved|	ebp|	bp|	bpl|
|rsi|Scratch register used to pass function argument #2 in 64-bit Unix.  In 64-bit Windows, a preserved register.| scratch|esi|si|	sil|
|rdi | Scratch register and function argument #1 in 64-bit Unix.  In 64-bit Windows, a preserved register.| scratch|edi|	di|	dil|
|r8 | Scratch register.These were added in 64-bit mode, so they have numbers, not names. | scratch|r8d|	r8w|	r8b|
|r9 | Scratch register.|	scratch|r9d |	r9w |	r9b |
|r10| Scratch register.|	scratch|r10d|	r10w|	r10b|
|r11| Scratch register.|	scratch|r11d|	r11w|	r11b|
|r12| Preserved register.| preserved|r12d|	r12w|	r12b|
|r13| Preserved register.|	preserved|r13d|	r13w|	r13b|
|r14| Preserved register.|	preserved|	r14d|	r14w|	r14b|
|r15| Preserved register.|	preserved|	r15d|	r15w|	r15b|

>"Preserved" registers have to be put back ("save" the register) if you use them.

>"Scratch" is overwrite allowed


### Types
|Name|Size||
|-|-|-|
|Bit| 0 or 1| The smallest addressable form of memory|
|Nibble| 4 bits||
|Byte| 8 bits| In C/C++, you might be familiar with the term char|
|WORD| 16 bits| In C/C++, you might be more familiar with the term short|
|DWORD| 32 bits|Short for “double word”, this means 2 × 16 bit words, which means. In C/C++, you might be more familiar with the term int|
|oword| 128 bits|Short for “octa-word” this means 8 × 16 bit words, which totals. This term is used in NASM syntax|
|yword| 256 bits| Also used only in NASM syntax, this refers to 256 bits in terms of size (i.e. the size of ymm register.)|
|float| 32 bits| This means 32 bits for a single-precision floating point under the IEEE 754 standards|
|double|64 bits| This means 64 bits for a double-precision floating point under the IEEE 754 standard. This is also referred to as a quad word|
|Pointers|64 bits| On the x64 ISA, pointers are all 64-bit addresses|


### syscall on 64 bit machine, BUT **syscall is DEPRECATED!**
| c/c++ | nasm |
|-|-|
|#define	SYS_syscall        0||
|#define	SYS_exit           1|0x02000001|
|#define	SYS_fork           2|0x02000002|
|#define	SYS_read           3|0x02000003|
|#define	SYS_write          4|0x02000004|
|#define	SYS_open           5|0x02000005|
|#define	SYS_close          6|0x02000006|
|#define	SYS_wait4          7|0x02000007|
>The system call number need to add an offset 0x2000000, because OSX has 4 different class of system calls.


```
bits 64
SECTION .text
global _main            ; entry point

_main:
mov rax, 0x2000004      ; syscall 4: write (
mov rdi, 1              ;    fd,
mov rsi, Msg            ;    address of string to output,
mov rdx, Len            ;    size
syscall                 ; )

mov rax, 0x2000001      ; syscall 1: exit (
mov rdi, 0              ;    retcode
syscall                 ; )

SECTION .data
Msg db "Hello, world!", 10 ; DefineBytes "...", note the newline at the end -> [,10]
; Msg db "Hello,", "world!", 10 ; the same as above
Len: equ $-Msg
```

[NASM Tutorial](https://cs.lmu.edu/~ray/notes/nasmtutorial/)

[x64_cheatsheet.pdf](https://cs.brown.edu/courses/cs033/docs/guides/x64_cheatsheet.pdf)

[x64 NASM Samples](https://redirect.cs.umbc.edu/portal/help/nasm/sample_64.shtml)


-----
[Part 1](README.md) | [Part 2](part2.md)
-----
