@ declare the global _start, which is looked for by the linker
.global _start

.text

_start:
@ read one character from STDIN into the buffer
mov r7, #3 @ __NR_read
mov r0, #0 @ STDIN_FILENO
ldr r1, =buffer
mov r2, #buflen @ buffer length (one byte)
swi 0

mov r3,r0
cmp r3, #0
beq _exit

@ confirm the character is within range
ldr r1,=buffer
mov r2,#0 @ start at index zero
_loop:
ldrb r0,[r1,r2] @ just read one byte (because the buffer will be packed with chars)
cmp r0,#'A'
blt skip
cmp r0,#'Z'
bgt skip
@ shift the character down
@ flip the lowercase bit....
@ faster than subtracting and adding (or even just adding the offset)
eor r0,#0x20
strb r0,[r1,r2] @ just write one byte so we keep the char array righteous
skip:
add r2,r2,#1 @ increment index
cmp r2,r3 @ check against upper bound
blt _loop @ loop if not there yet

@ write one character to STDOUT from the buffer
mov r7, #4 @ __NR_write
mov r0, #1 @ STDOUT_FILENO
ldr r1, =buffer
mov r2, r3 @ buffer length (from read)
swi 0

b _start

_exit:
mov r7, #1 @ __NR_exit
mov r0, #0 @ return code of 0
swi 0

.data

buffer: .word 0,0,0,0
buflen = . - buffer
