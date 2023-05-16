@ declare the global _start, which is looked for by the linker
.global _start

.text

_start:
@ read one character from STDIN into the buffer
mov r7, #3 @ __NR_read
mov r0, #0 @ STDIN_FILENO
ldr r1, =buffer
mov r2, #1 @ buffer length (one byte)
swi 0

cmp r0, #0
beq _exit

@ confirm the character is within range
ldr r1,=buffer
ldr r0,[r1]
cmp r0,#'A'
blt skip
cmp r0,#'Z'
bgt skip
@ shift the character down
@ flip the lowercase bit....
@ faster than subtracting and adding (or even just adding the offset)
eor r0,#0x20
str r0,[r1]
skip:

@ write one character to STDOUT from the buffer
mov r7, #4 @ __NR_write
mov r0, #1 @ STDOUT_FILENO
ldr r1, =buffer
mov r2, #1 @ buffer length (one byte)
swi 0

b _start

_exit:
mov r7, #1 @ __NR_exit
mov r0, #0 @ return code of 0
swi 0

.data

buffer: .word 0
