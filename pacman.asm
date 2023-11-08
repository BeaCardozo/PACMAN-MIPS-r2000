.data

mensaje: .asciiz "hola"

.text

li $v0,4
la $a0,mensaje
syscall