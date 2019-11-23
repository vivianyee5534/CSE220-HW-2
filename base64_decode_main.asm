.data
decoded_str: .ascii "This is random garbage! Notice that it is not null-terminated! You should not be seeing this text!"
encoded_str: .asciiz "MipF4izIuMxtcrcy4iwvcNkOANIg+S5/CUn="
base64_table: .ascii "VxZDRbN7s6T9om8lP5MXwkrS+cJC4AuKv2tYeIiW0/EG3LgyQfBOhFUjnzHdqpa1"
trash: .ascii "random garbage"

.text
.globl main
main:
la $a0, decoded_str
la $a1, encoded_str
la $a2, base64_table
jal base64_decode

move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, decoded_str
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

li $v0, 10
syscall

.include "proj2.asm"
