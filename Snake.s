.data

#Screen 
numberPixels:   .word   1024
screenDimensions: .word 32

#Colors
snakeColor: 	.word	0x00c88a	 
borderColor:    .word	0x6782fb	 	
fruitColor: 	.word	0xfd71af
charColor: 	.word   0xffffff
backgroundColor: .word  0x000000

#Snake
snakeHead:	.word   16, 16, 0x64, 0x64, 0 #Coordenada X, coordenada Y, dirección a la que se debe mover, dirección a la que se movia, puntuación
snakeTail:	.word   16, 16, 0x64 #Coordenada X, coordenada Y, dirección hacia la que se debe mover  

#Fruta en pantalla
fruit:	.word   1 	 

.globl main, snakeHead

.text

main:

######################################################
#---------------- Título del juego ------------------#
######################################################

####### Letra S
	lw $a0, charColor
	sw $a0, 0x10040194
	sw $a0, 0x10040190
	sw $a0, 0x1004018c
	
	sw $a0, 0x10040208
	sw $a0, 0x10040288
	
	sw $a0, 0x1004030c
	sw $a0, 0x10040310
	sw $a0, 0x10040314
	
	sw $a0, 0x10040398
	sw $a0, 0x10040418
	
	sw $a0, 0x10040494
	sw $a0, 0x10040490
	sw $a0, 0x1004048c
	
####### Letra N
	sw $a0, 0x100401a0
	sw $a0, 0x10040220
	sw $a0, 0x100402a0
	sw $a0, 0x10040320
	sw $a0, 0x100403a0
	sw $a0, 0x10040420
	sw $a0, 0x100404a0
	
	sw $a0, 0x100402a4
	sw $a0, 0x10040328
	sw $a0, 0x100403ac
	
	sw $a0, 0x100401b0
	sw $a0, 0x10040230
	sw $a0, 0x100402b0
	sw $a0, 0x10040330
	sw $a0, 0x100403b0
	sw $a0, 0x10040430
	sw $a0, 0x100404b0
	
####### Letra A
	sw $a0, 0x100401c4
	sw $a0, 0x10040240
	sw $a0, 0x100402c0
	sw $a0, 0x1004033c
	sw $a0, 0x100403bc
	sw $a0, 0x10040438
	sw $a0, 0x100404b8
	
	sw $a0, 0x10040248
	sw $a0, 0x100402c8
	sw $a0, 0x1004034c
	sw $a0, 0x100403cc
	sw $a0, 0x10040450
	sw $a0, 0x100404d0
	
	sw $a0, 0x100403c0
	sw $a0, 0x100403c4
	sw $a0, 0x100403c8
	
####### Letra K
	sw $a0, 0x100401d8
	sw $a0, 0x10040258
	sw $a0, 0x100402d8
	sw $a0, 0x10040358
	sw $a0, 0x100403d8
	sw $a0, 0x10040458
	sw $a0, 0x100404d8

	sw $a0, 0x100401e4
	sw $a0, 0x10040264
	sw $a0, 0x100402e0
	sw $a0, 0x1004035c
	sw $a0, 0x100403e0
	sw $a0, 0x10040464
	sw $a0, 0x100404e4
	
####### Letra E
	sw $a0, 0x100401ec
	sw $a0, 0x1004026c
	sw $a0, 0x100402ec
	sw $a0, 0x1004036c
	sw $a0, 0x100403ec
	sw $a0, 0x1004046c
	sw $a0, 0x100404ec
	
	sw $a0, 0x100401f0
	sw $a0, 0x100401f4
	
	sw $a0, 0x10040370
	sw $a0, 0x10040374
	
	sw $a0, 0x100404f0
	sw $a0, 0x100404f4
	

	
######################################################
#----------------- Dibujar serpiente ----------------#
######################################################
	lw $a0, screenDimensions
	lw $a1, snakeHead
	lw $a2, snakeHead + 4
	lw $a3, snakeColor
	jal coordinate
	sw $a3, 0($v0)

######################################################
#-------------------Dibujar bordes------------------#
######################################################
	li $a1, 0
	li $a2, 0
	lw $a3, borderColor
	jal coordinate
	sw $a3, 0($v0)
	
border1Loop:
	beq $a1, 31, border2Loop
	jal coordinate
	sw $a3, 0($v0)
	addiu $a1, $a1, 1 #increment counter
	j border1Loop
	
border2Loop:
	beq $a2, 31, border3Loop
	jal coordinate
	sw $a3, 0($v0)
	addiu $a2, $a2, 1 #increment counter
	j border2Loop
	
border3Loop:
	beqz $a1, border4Loop
	jal coordinate
	sw $a3, 0($v0)
	addi $a1, $a1, -1 #increment counter
	j border3Loop

border4Loop:
	beqz $a2, pantallaNegro
	jal coordinate
	sw $a3, 0($v0)
	addi $a2, $a2, -1 #increment counter
	j border4Loop

######################################################
#-------------------Limpiar título------------------#
######################################################

pantallaNegro: 
	lw $t0, backgroundColor
	lw $a0, screenDimensions
	li $a1, 1
negroLoop:
	li $a2, 1
	addi $a1, $a1, 1
	beq $a1, 10, init
negroLoopi:
	beq $a2, 31, negroLoop
	jal coordinate
	addi $a3, $v0, 0
	sw $t0, 0($a3) #store color
	addi $a2, $a2, 1 #increment counter
	j negroLoopi
	
######################################################
#----------------- Dibujar fruta ----------------#
######################################################

init:
	li $v0, 42
	li $a0, 1
	li $a1, 31
	syscall
	addi $t0, $a0, 0 # posición en Y
	
	li $v0, 42
	li $a0, 1
	li $a1, 31
	syscall
	addi $t1, $a0, 0 # posición en X
	
	lw $a0, screenDimensions
	addi $a1, $t0, 0
	addi $a2, $t1, 0
	lw $a3, fruitColor
	jal coordinate
	sw $a3, 0($v0)
	
	
######################################################
#-------------------Movimiento------------------#
######################################################
  
	lw $t0, snakeHead
	lw $t1, snakeHead + 4
	lw $t3, snakeTail
	lw $t4, snakeTail + 4
	lw $a0, screenDimensions
	
movimiento:
	lw $t2, snakeHead + 8
	lw $t6, snakeHead + 12
	beq $t2, 0x61, izqMovimiento
	beq $t2, 0x77, abjMovimiento
	beq $t2, 0x73, arrMovimiento
	bne $t2, 0x64, movimiento
	
	beq $t6, 0x61, noCambia
	sw $t2, snakeHead + 12
		
	addi $t0, $t0, 1
	addi $a1, $t1, 0
	addi $a2, $t0, 0
	jal coordinate
	addi $t7, $v0, 0
	
	
	addi $a0, $v0, 0
	lw $a1, backgroundColor
	lw $a2, fruitColor
	jal choque
	
	beq $v0, 1, gameOver
	beq $v0, 2, punto
		
	lw $t5, snakeColor
	sw $t5, 0($t7)
	
	lw $a0, screenDimensions
	addi $a1, $t4, 0
	addi $a2, $t3, 0
	jal coordinate
	
	lw $t5, backgroundColor
	sw $t5, 0($v0)
	
	addi $t3, $t3, 1
	
	j movimiento
	
izqMovimiento: 
	beq $t6, 0x64, noCambia
	sw $t2, snakeHead + 12

	addi $t0, $t0, -1
	addi $a1, $t1, 0
	addi $a2, $t0, 0
	jal coordinate
	addi $t7, $v0, 0
	
	
	addi $a0, $v0, 0
	lw $a1, backgroundColor
	lw $a2, fruitColor
	jal choque
	
	beq $v0, 1, gameOver
	beq $v0, 2, punto
	
	lw $t5, snakeColor
	sw $t5, 0($t7)
	
	lw $a0, screenDimensions
	addi $a1, $t4, 0
	addi $a2, $t3, 0
	jal coordinate
	
	lw $t5, backgroundColor
	sw $t5, 0($v0)
	
	addi $t3, $t3, -1
	
	j movimiento

abjMovimiento: 
	beq $t6, 0x73, noCambia
	sw $t2, snakeHead + 12

	addi $t1, $t1, -1
	addi $a1, $t1, 0
	addi $a2, $t0, 0
	jal coordinate
	addi $t7, $v0, 0
	
	
	addi $a0, $v0, 0
	lw $a1, backgroundColor
	lw $a2, fruitColor
	jal choque
	
	beq $v0, 1, gameOver
	beq $v0, 2, punto
	
	lw $t5, snakeColor
	sw $t5, 0($t7)
	
	lw $a0, screenDimensions
	addi $a1, $t4, 0
	addi $a2, $t3, 0
	jal coordinate
	
	lw $t5, backgroundColor
	sw $t5, 0($v0)
	
	addi $t4, $t4, -1
	
	j movimiento		

arrMovimiento: 
	beq $t6, 0x77, noCambia
	sw $t2, snakeHead + 12

	addi $t1, $t1, 1
	addi $a1, $t1, 0
	addi $a2, $t0, 0
	jal coordinate
	addi $t7, $v0, 0
	
	
	addi $a0, $v0, 0
	lw $a1, backgroundColor
	lw $a2, fruitColor
	jal choque
	
	beq $v0, 1, gameOver
	beq $v0, 2, punto
	
	lw $t5, snakeColor
	sw $t5, 0($t7)
	
	lw $a0, screenDimensions
	addi $a1, $t4, 0
	addi $a2, $t3, 0
	jal coordinate
	
	lw $t5, backgroundColor
	sw $t5, 0($v0)
	
	addi $t4, $t4, 1
	
	j movimiento			

######################################################
#------------- Condiciones de Movimiento ------------#
######################################################

noCambia: 
	sw $t6, snakeHead + 8
	j movimiento


######################################################
#------------------- Game over ----------------------#
######################################################

gameOver: 
	j gameOver
######################################################
#------------- Condiciones de Choque ----------------#
######################################################

choque:
	# Entrada
	# $a0 -> dirección de memoria de la coordenada a la que se moverá la serpiente.
	# $a1 -> color del fondo.
	# $a2 -> color de la fruta.
	# $a3 -> dirección que almacena cuantas frutas hay en pantalla.
	# Salida 
	# $v0 -> 0 si no hay choque, 1 si choca consigo misma o un borde, 2 si choca con una fruta.
	
	#-------- planificacion de registros --------#
	
	# $s0 -> dirección de memoria de la coordenada a la que se moverá la serpiente. Luego, 0 para indicar que no hay fruta si es el caso.
	# $s1 -> color del fondo.
	# $s2 -> color de la fruta.
	# $s3 -> dirección que almacena cuantas frutas hay en pantalla.
	# $s4 -> el contenido de la dirección de memoria de la coordenada a la que se moverá la serpiente.
	
	# ---------------- prologo ----------------- #
	
	# almacenamos $fp, $ra y los registros $s usados en la pila. 
	
	addiu $sp, $sp, -24
	sw $fp, 24($sp)
	addiu $fp, $sp, 24
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	
	# ----------------- cuerpo ----------------- #
	
	addi $s0, $a0, 0 # movemos el argumento 1
	addi $s1, $a1, 0 # movemos el argumento 2 
	addi $s2, $a2, 0 # movemos el argumento 3
	addi $s3, $a3, 0 # movemos el argumento 4
	
	lw $s4, 0($a0)
	li $v0, 0
	
	beq $s1, $s4, epilogoChoque
	beq $s2, $s4, frutaChoque
	
	li $v0, 1
	j epilogoChoque

frutaChoque: 
	li $s0, 0
	sw $s0, 0($s0)
	li $v0, 2	
			
	# ---------------- epilogo ----------------- #

epilogoChoque:	
	lw $fp, 24($sp)
	lw $ra, 20($sp)
	lw $s0, 16($sp)
	lw $s1, 12($sp)
	lw $s2, 8($sp)
	lw $s3, 4($sp)
	addiu $sp, $sp, 24
		
	jr $ra			# return $v0

######################################################
#--------------- Generar la fruta ------------------#
######################################################	

punto: 
	lw $s0, snakeHead + 16
	addi $s0, $s0, 1
	sw $s0, snakeHead + 16
	
	lw $t5, snakeColor
	sw $t5, 0($t7)
	
	lw $a0, screenDimensions
	lw $a1, fruitColor
	la $a2, fruit
	jal generarFruta
		
	j movimiento
	

generarFruta:
	# Entrada
	# $a0 -> ancho de la pantalla que el mismo alto (screenDimensions).
	# $a1 -> color de la fruta.
	# $a2 -> dirección que almacena cuantas frutas hay en pantalla.
	
	#-------- planificacion de registros --------#
	
	# $s0 -> ancho de la pantalla que el mismo alto (screenDimensions). Luego comprueba que la fruta no caiga sobre la serpiente.
	#	Al final, almacena la cuantas frutas hay en pantalla.
	# $s1 -> color de la fruta.
	# $s2 -> dirección que almacena cuantas frutas hay en pantalla.
	# $s3 -> posición Y generada de manera random.
	# $s4 -> posición X generada de manera random.
	
	# ---------------- prologo ----------------- #
	
	# almacenamos $fp, $ra y los registros $s usados en la pila. 
	
	addiu $sp, $sp, -20
	sw $fp, 20($sp)
	addiu $fp, $sp, 20
	sw $ra, 16($sp)
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	
	# ----------------- cuerpo ----------------- #
	
	addi $s0, $a0, 0 # movemos el argumento 1
	addi $s1, $a1, 0 # movemos el argumento 2 
	addi $s2, $a2, 0 # movemos el argumento 3 
	
generarUbicacion:	
	
	li $v0, 42
	li $a0, 1
	li $a1, 31
	syscall
	addi $s3, $a0, 0 # posición en Y
	
	li $v0, 42
	li $a0, 1
	li $a1, 31
	syscall
	addi $s4, $a0, 0 # posición en X
	
	addi $a0, $s0, 0
	addi $a1, $s3, 0
	addi $a2, $s4, 0
	jal coordinate
	
	lw $s0, 0($v0)
	bnez $s0, generarUbicacion
	
	sw $s1, 0($v0)
	
	li $s0, 1
	sw $s0, 0($s2) 
	
	# ---------------- epilogo ----------------- #

	lw $fp, 20($sp)
	lw $ra, 16($sp)
	lw $s0, 12($sp)
	lw $s1, 8($sp)
	lw $s2, 4($sp)
	addiu $sp, $sp, 20
		
	jr $ra			# return $v0
	
									
######################################################
#--------------------- Funciones --------------------#
######################################################	

coordinate:
	# Entrada
	# $a0 -> ancho de la pantalla que el mismo alto (screenDimensions).
	# $a1 -> posición en y.
	# $a2 -> posición en x.
	# Salida 
	# $v0 -> coordenada convertida en dirección de memoria.
	
	#-------- planificacion de registros --------#
	
	# $s0 -> ancho de la pantalla que el mismo alto (screenDimensions). Luego, almacena la coordenada como dirección de memoria.
	# $s1 -> posición en y
	# $s2 -> posición en x.
	
	# ---------------- prologo ----------------- #
	
	# almacenamos $fp, $ra y los registros $s usados en la pila. 
	
	addiu $sp, $sp, -20
	sw $fp, 20($sp)
	addiu $fp, $sp, 20
	sw $ra, 16($sp)
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	
	# ----------------- cuerpo ----------------- #
	
	addi $s0, $a0, 0 # movemos el argumento 1
	addi $s1, $a1, 0 # movemos el argumento 2 
	addi $s2, $a2, 0 # movemos el argumento 3 
	
	mul $s0, $s0, $s1	#multiply by y position
	add $s0, $s0, $s2	#add the x position
	mul $s0, $s0, 4		#multiply by 4
	addi $v0, $s0, 0x10040000	#add global pointerfrom bitmap display
	
	# ---------------- epilogo ----------------- #

	lw $fp, 20($sp)
	lw $ra, 16($sp)
	lw $s0, 12($sp)
	lw $s1, 8($sp)
	lw $s2, 4($sp)
	addiu $sp, $sp, 20
		
	jr $ra			# return $v0
