#Conversion de un numero almacenado en un registro a decimal, binario, hexadecimal y octal
     

#MACROS


.macro exit #Macro para finalizar el programa
li $v0 10
syscall
.end_macro

.macro print_string(%dir_memoria) #Macro para imprimir cadena
la $a0 %dir_memoria
li $v0 4
syscall
.end_macro

.macro read_int(%register) #Macro para leer entero
li $v0 5
syscall
move %register $v0
.end_macro

.macro print_int(%int)
li $v0 1
move $a0 %int
syscall
.end_macro

#FIN MACROS
       
        
         
.data
mensajeGanador: .asciiz "	YOU WIN!	"
puntuacionFinal: .asciiz "Puntuacion Final:"
resultadoDecimal: .asciiz "* Representacion Decimal: "
resultadoOctal: .asciiz "* Representacion Octal: "
espacioOctal: .space 33	
resultadoHexadecimal: .asciiz "* Representacion Hexadecimal: "
espacioHexadecimal: .space 33
resultadoBinario: .asciiz "* Representacion Binario: "
espacioBinario: .space 33
saltoDeLinea: .asciiz "\n"

result: .asciiz "The number in octal is: "



.text
print_string(saltoDeLinea)
print_string(mensajeGanador)
print_string(saltoDeLinea)
print_string(saltoDeLinea)
print_string(puntuacionFinal)
print_string(saltoDeLinea)

li $t0 1500 #Numero a convertir guardado en $t0


#------------- DECIMAL ---------------		
print_string(resultadoDecimal)
print_int($t0)

				
#------------- CONVERSION HEXADECIMAL ---------------
li $s0 0x0F # En $s0 tenemos una Mascara

li $t1 28 # En $t1 tenemos el desplazamiento en bits a realizar
li $t9 0 # Vamos a usar $t9 para recorrer numeroHexaDec 
loopConversion:
bltz $t1 fin_loopConversion

	srlv $t2 $t0 $t1 # En los ultimos 4 bits de $t2 quedaria aislado el digito a convertir
	and $t2 $t2 $s0 # Aplicamos la mascara para solo dejar los ultimos 4 bits

	# Ya en este punto el valor de $t2 es el número que queremos
	
	# Ahora guardamos el digito en Hexadecimal como una cadena
	
	bge $t2 0xA esLetra
	
	esDigito:
	addi $t2 $t2 0x30 #0x30 es la suma para llevar de numero entero a 
		         #Caracter de la representacion Hexadecimal
	
	b fin_categorizacion
	
	esLetra:
	addi $t2 $t2 55 #55 es la suma para llevar de numero entero a 
		       #Caracter de la representacion Hexadecimal
	
	b fin_categorizacion
	
	fin_categorizacion:
	
	# Guardamos el Numero como su valor en Hexadecimal
	sb $t2 espacioHexadecimal($t9)
	addi $t9 $t9 1
	addi $t1 $t1 -4
b loopConversion
fin_loopConversion:

print_string(saltoDeLinea)
print_string(resultadoHexadecimal)
print_string(espacioHexadecimal)


#------------- CONVERSION BINARIA ---------------

li $t1 31 #Contador de shifts
li $t9 0 #Contador demtro de espacioNumero
li $s0 0x1 #MASCARA

loopBinario:
	bltz $t1 fin_loopBinario
	srlv $t3 $t0 $t1
	and $t3 $t3 $s0
	addi $t3 $t3 0x30 #48 en decimal para convertir 0 a "0" y 1 a "1"
	sb $t3 espacioBinario($t9)
	addi $t1 $t1 -1 
	addi $t9 $t9 1

b loopBinario

fin_loopBinario:

print_string(saltoDeLinea)
print_string(resultadoBinario)
print_string(espacioBinario)



#------------- CONVERSION OCTAL ---------------

    li $s0, 8          #Cargamos el divisor 
    li $t1, 0          #Inicializamos contador 

loop:
    div $t0, $s0       #Dividir $t0 entre 8
    mfhi $t2  
    mflo $t0           #Guardar el cociente de vuelta en $t0

    addi $t2, $t2, 48  #representación ASCII
    sb $t2, ($sp)      #Almacenar el carácter
    addi $sp, $sp, -1 

    addi $t1, $t1, 1   #Incrementar el contador del bucle

    bnez $t0, loop     #Volver al inicio del bucle si $t0 no es cero

print_string(saltoDeLinea)
print_string(resultadoOctal)
print_string(espacioOctal)

print_loop:
    addi $sp, $sp, 1   # Ajustar la pila 
    lb $a0, ($sp)      #Cargar el carácter de la pila para imprimir
    li $v0, 11         #syscall para imprimir un carácter
    syscall            
    addi $t1, $t1, -1 
    bnez $t1, print_loop  #si el contador no es cero

exit #Fin del programa
	
	
	


