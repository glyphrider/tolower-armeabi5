# tolower

a trivial implementation of a unix filter that translates all uppercase characters [A-Z] to lowercase
characters [a-z]. written in arm32 (eabi5) assembly language, using the GNU Assembler (`gas`) and the
GNU Linker (`ld`), both from the [GNU binutils](https://www.gnu.org/software/binutils/) package. There
is a `Makefile` included to assist with building, so you'd also need
[GNU make](https://www.gnu.org/software/make/) if you wanted to build.

In general, the code works like this:

1. Use the software interrupt with syscall 3 (read) to read _up to_ 16 bytes of data from `stdin`. The data consumed is stored in the buffer (defined as four zeroed out words at the bottom of the file).
1. Squirrel away the number of bytes read by the syscall.
1. Check to see if we read more than zero characters, otherwise jump to the `_exit:` label.
1. Walk through the buffer, reading one character at a time into r0.
1. Check to see if the character is out of the range of _interesting_ characters, branching forward to `2:` if so.
1. Toggle the lowercase bit.
1. Write the single byte back into the buffer (at the appropriate offset).
1. Increment the offset
1. Check the current offset against the number of bytes read, and branch backward to `1:` if appropriate.
1. Setup syscall 4 (write) to copy the in-memory buffer to `stdout` using the _number of character read_ to control the number of characters to write.
1. Loop back and read some more...
1. Setup syscall 1 (exit) to return to the OS with an exit code of 0.
