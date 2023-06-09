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

cmp r0, #0 @ if we read zero bytes (we're done)
beq _exit  @ then branch to exit
mov r3,r0  @ remember how many characters we read

@ walk the buffer and lower any uppercase characters
ldr r1,=buffer
mov r2,#0 @ start at index zero

1:
ldrb r0,[r1,r2] @ just read one byte (because the buffer will be packed with chars)
@ confirm the character is within range
cmp r0,#'A'
blt 2f
cmp r0,#'Z'
bgt 2f
@ shift the character down
@ set the lowercase bit....
@ faster than subtracting and adding (or even just adding the offset)
orr r0,#0x20
strb r0,[r1,r2] @ just write one byte so we keep the char array righteous

2:
add r2,r2,#1 @ increment index
cmp r2,r3 @ check against upper bound (number of characters read)
blt 1b @ loop if not there yet

@ write one character to STDOUT from the buffer
mov r7, #4 @ __NR_write
mov r0, #1 @ STDOUT_FILENO
ldr r1, =buffer
mov r2, r3 @ buffer length (number of characters read)
swi 0

b _start

_exit:
mov r7, #1 @ __NR_exit
mov r0, #0 @ return code of 0
swi 0

.data

buffer: .space 256,0
buflen = . - buffer
