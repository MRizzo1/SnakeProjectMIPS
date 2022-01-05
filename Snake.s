################################################################################################################
#-------------------------------------------- Instrucciones ---------------------------------------------------#
#													       #
# Run speed de las instrucciones al máximo.								       #
#													       #
# Para jugar, hay que conectar el BitMap y el Keyboard and Display MMIO Simulator.			       #
#													       #
# Para mover la serpiente, se debe presionar la tecla mientra la misma no se dibuja, sino, el movimiento no se #
# leerá.												       #
#													       #
# Los valores recomendados para el BitMap son:								       #
#													       #
################################################################################################################
#													       #
# Altura y ancho de los pixeles: 16									       #
#													       #
# Altura y ancho del display: 512 (Alargar la ventana del BitMap para ver el display completo.		       #
#													       #
# Base address for display: 0x100080000. El motivo es que no puede estar en los datos estáticos ni globales,   # 
# tampoco en el heap porque ocupa el espacio de las estructuras dinámicas.				       #
# No puede mapearse al MMIO porque ocupa los espacios correspondientes al teclado para interrumpir.	       #
# 													       #
################################################################################################################


.data

#Screen 
screenDimensions: .word 32 #Display / dimensiones de los pixeles.
directionBitMap:  .word 0x10008000 # Dirección base para hacer display del BitMap

#Colors
snakeColor: 	.word	0x00c88a
headColor:	.word   0xaaebd7	 
borderColor:    .word	0x6782fb	 	
fruitColor: 	.word	0xfd71af
charColor: 	.word   0xffffff
backgroundColor: .word  0x000000

#Snake
snake:		.word   0 #Dirección de la lista asociada a la serpiente
snakeHead:	.word   18, 16, 0x64, 0x64, 0, 0 #Coordenada X, coordenada Y, dirección a la que se debe mover, dirección a la que se movía, puntuación, permiso para moverse. 
speed:		.word   0x150, 0x125, 0x100 # Rapidez de la serpiente para moverse en los tres niveles.

#Fruta en pantalla
fruit:	.word   0 

#Mensajes importantes
aumentoNivel: 	.asciiz   "Pasó de nivel. Su puntuación es de: "
finMensaje:	.asciiz   "Terminó el juego. Su puntuación fue de: "		 

.globl main, snakeHead, charColor, snakeColor, borderColor, fruitColor, backgroundColor, headColor, screenDimensions, speed
.include "TadLista.s"
.text

main:
	

######################################################
#---------------- Título del juego ------------------#
######################################################

####### Letra S
	lw $t0, screenDimensions
	bne $t0, 32, dibujarSerpiente

	lw $t0, directionBitMap	
	lw $t1, charColor
	
	addi $t2, $t0, 0x194
	sw $t1, 0($t2)
	addi $t2, $t0, 0x190
	sw $t1, 0($t2)
	addi $t2, $t0, 0x18c
	sw $t1, 0($t2)
	
	addi $t2, $t0, 0x208
	sw $t1, 0($t2)
	addi $t2, $t0, 0x288
	sw $t1, 0($t2)
	
	addi $t2, $t0, 0x30c
	sw $t1, 0($t2)
	addi $t2, $t0, 0x310
	sw $t1, 0($t2)
	addi $t2, $t0, 0x314
	sw $t1, 0($t2)
	
	addi $t2, $t0, 0x398
	sw $t1, 0($t2)
	addi $t2, $t0, 0x418
	sw $t1, 0($t2)
	
	addi $t2, $t0, 0x494
	sw $t1, 0($t2)
	addi $t2, $t0, 0x490
	sw $t1, 0($t2)
	addi $t2, $t0, 0x48c
	sw $t1, 0($t2)
	
####### Letra N
	addi $t2, $t0, 0x1a0
	sw $t1, 0($t2)
	addi $t2, $t0, 0x220
	sw $t1, 0($t2)
	addi $t2, $t0, 0x2a0
	sw $t1, 0($t2)
	addi $t2, $t0, 0x320
	sw $t1, 0($t2)
	addi $t2, $t0, 0x3a0
	sw $t1, 0($t2)
	addi $t2, $t0, 0x420
	sw $t1, 0($t2)
	addi $t2, $t0, 0x4a0
	sw $t1, 0($t2)
	
	addi $t2, $t0, 0x2a4
	sw $t1, 0($t2)
	addi $t2, $t0, 0x328
	sw $t1, 0($t2)
	addi $t2, $t0, 0x3ac
	sw $t1, 0($t2)
	
	addi $t2, $t0, 0x1b0
	sw $t1, 0($t2)
	addi $t2, $t0, 0x230
	sw $t1, 0($t2)
	addi $t2, $t0, 0x2b0
	sw $t1, 0($t2)
	addi $t2, $t0, 0x330
	sw $t1, 0($t2)
	addi $t2, $t0, 0x3b0
	sw $t1, 0($t2)
	addi $t2, $t0, 0x430
	sw $t1, 0($t2)
	addi $t2, $t0, 0x4b0
	sw $t1, 0($t2)
	
####### Letra A

	addi $t2, $t0, 0x1c4
	sw $t1, 0($t2)
	addi $t2, $t0, 0x240
	sw $t1, 0($t2)
	addi $t2, $t0, 0x2c0
	sw $t1, 0($t2)
	addi $t2, $t0, 0x33c
	sw $t1, 0($t2)
	addi $t2, $t0, 0x3bc
	sw $t1, 0($t2)
	addi $t2, $t0, 0x438
	sw $t1, 0($t2)
	addi $t2, $t0, 0x4b8
	sw $t1, 0($t2)

	addi $t2, $t0, 0x248
	sw $t1, 0($t2)
	addi $t2, $t0, 0x2c8
	sw $t1, 0($t2)
	addi $t2, $t0, 0x34c
	sw $t1, 0($t2)
	addi $t2, $t0, 0x3cc
	sw $t1, 0($t2)
	addi $t2, $t0, 0x450
	sw $t1, 0($t2)
	addi $t2, $t0, 0x4d0
	sw $t1, 0($t2)
	
	addi $t2, $t0, 0x3c0
	sw $t1, 0($t2)
	addi $t2, $t0, 0x3c4
	sw $t1, 0($t2)
	addi $t2, $t0, 0x3c8
	sw $t1, 0($t2)
	
	
####### Letra K
	addi $t2, $t0, 0x1d8
	sw $t1, 0($t2)
	addi $t2, $t0, 0x258
	sw $t1, 0($t2)
	addi $t2, $t0, 0x2d8
	sw $t1, 0($t2)
	addi $t2, $t0, 0x358
	sw $t1, 0($t2)
	addi $t2, $t0, 0x3d8
	sw $t1, 0($t2)
	addi $t2, $t0, 0x458
	sw $t1, 0($t2)
	addi $t2, $t0, 0x4d8
	sw $t1, 0($t2)
	
	addi $t2, $t0, 0x1e4
	sw $t1, 0($t2)
	addi $t2, $t0, 0x264
	sw $t1, 0($t2)
	addi $t2, $t0, 0x2e0
	sw $t1, 0($t2)
	addi $t2, $t0, 0x35c
	sw $t1, 0($t2)
	addi $t2, $t0, 0x3e0
	sw $t1, 0($t2)
	addi $t2, $t0, 0x464
	sw $t1, 0($t2)
	addi $t2, $t0, 0x4e4
	sw $t1, 0($t2)
	
####### Letra E
	addi $t2, $t0, 0x1ec
	sw $t1, 0($t2)
	addi $t2, $t0, 0x26c
	sw $t1, 0($t2)
	addi $t2, $t0, 0x2ec
	sw $t1, 0($t2)
	addi $t2, $t0, 0x36c
	sw $t1, 0($t2)
	addi $t2, $t0, 0x3ec
	sw $t1, 0($t2)
	addi $t2, $t0, 0x46c
	sw $t1, 0($t2)
	addi $t2, $t0, 0x4ec
	sw $t1, 0($t2)
	
	addi $t2, $t0, 0x1f0
	sw $t1, 0($t2)
	addi $t2, $t0, 0x1f4
	sw $t1, 0($t2)
	
	addi $t2, $t0, 0x370
	sw $t1, 0($t2)
	addi $t2, $t0, 0x374
	sw $t1, 0($t2)
	
	addi $t2, $t0, 0x4f0
	sw $t1, 0($t2)
	addi $t2, $t0, 0x4f4
	sw $t1, 0($t2)
		
######################################################
#----------------- Dibujar serpiente ----------------#
######################################################
dibujarSerpiente:
	lw $a0, screenDimensions
	lw $a1, directionBitMap
	lw $a2, snakeHead
	lw $a3, snakeHead + 4
	jal coordinate
	
	addi $t0, $v0, 0
	sw $s0, 0($t0)
	sw $s1, -4($t0)
	sw $s1, -8($t0)
	sw $s1, -12($t0)
	sw $s1, -16($t0)
	
	jal list_crear
	addi $t1, $v0, 0
	sw $t1, snake
	
	addi $a0, $t1, 0
	addi $a1, $t0, 0
	jal list_insertar
	
	addi $a0, $t1, 0
	addi $a1, $t0, -4
	jal list_insertar
	
	addi $a0, $t1, 0
	addi $a1, $t0, -8
	jal list_insertar
	
	addi $a0, $t1, 0
	addi $a1, $t0, -12
	jal list_insertar
	
	addi $a0, $t1, 0
	addi $a1, $t0, -16
	jal list_insertar

######################################################
#-------------------Dibujar bordes------------------#
######################################################
	lw $a0, screenDimensions
	lw $a1, directionBitMap
	li $a2, 0
	li $a3, 0

	lw $t0, borderColor
	addi $t1, $a0, -1	
border1Loop:
	beq $a2, $t1, border2Loop
	jal coordinate
	sw $t0, 0($v0)
	addiu $a2, $a2, 1 
	j border1Loop
	
border2Loop:
	beq $a3, $t1, border3Loop
	jal coordinate
	sw $t0, 0($v0)
	addiu $a3, $a3, 1 
	j border2Loop
	
border3Loop:
	beqz $a2, border4Loop
	jal coordinate
	sw $t0, 0($v0)
	addi $a2, $a2, -1 
	j border3Loop

border4Loop:
	beqz $a3, pantallaNegro
	jal coordinate
	sw $t0, 0($v0)
	addi $a3, $a3, -1 
	j border4Loop

######################################################
#-------------------Limpiar título------------------#
######################################################

pantallaNegro: 
	lw $t0, screenDimensions
	bne $t0, 32, init
	
	li $a2, 1
	div $t0, $a0, 2
	addi $t0, $t0, -5
	addi $t1, $a0, -1
	
negroLoop:
	li $a2, 1
	addi $a3, $a3, 1
	beq $a3, $t0, init
	
negroLoopi:
	beq $a2, $t1, negroLoop
	jal coordinate
	addi $t2, $v0, 0
	sw $s2, 0($t2)
	addi $a2, $a2, 1 
	j negroLoopi
	
######################################################
#----------------- Dibujar fruta ----------------#
######################################################

init:
	lw $a0, screenDimensions
	lw $a1, directionBitMap
	add $a2, $s3, 0
	la $a3, fruit
	jal generarFruta
	
	# ponemos el timer en cero
	li $t0, 0
	mtc0 $t0, $9
	
######################################################
#-------------------- Movimiento --------------------#
######################################################
  
movimiento:
	
	# Se pone en el registro compare un número para generar interrupción con el timer. 
	# Esta es la velocidad de la serpiente. Un movimiento cada vez que el timer llegue al número indicado.
	addi $t0, $s7, 0
	mtc0 $t0, $11
	
	# Se carga el contenido de la dirección que almacena si la serpiente puede moverse o no. 
	# Si es 1, puede; si no, sigue en el loop hasta que pueda.
	lw $t1, snakeHead + 20
	andi $t1, 0x1
	
	beq $t1, 0, movimiento
	
	li $t0, 0x0
	mtc0 $t0, $11
	
	lw $t0, snakeHead # posicion en x de la cabeza
	lw $t1, snakeHead + 4 # posicion en y de la cabeza
	lw $t2, snakeHead + 8 # dirección que llevaba la cabeza.
	lw $t3, snakeHead + 12 # nueva dirección.
	
	beq $t3, 0x61, izqMovimiento
	beq $t3, 0x77, abjMovimiento
	beq $t3 , 0x73, arrMovimiento
	beq $t3 , 0x71, gameOver
	
	# Si la direción de movimiento anterior era a la izquierda y la nueva es a la derecha, no se ejecuta el cambio de dirección.
	beq $t2, 0x61, noCambia
		
	# La cabeza se mueve un cuadro en x positivo.
	addi $t0, $t0, 1
	sw $t0, snakeHead
	
dibujarCabeza:
	lw $a0, snake # dirección de la lista
	jal moverCuerpo
	addi $s4, $v0, 0 #Se guarda la dirección de memoria en la que estaba la cola
		
	# La nueva dirección es almacenada en la antigua.
	sw $t3, snakeHead + 8
	
	# Se calcula la nueva posición de la cabeza como dirección de memoria y se almacena como primer elemento de la lista.
	lw $a0, screenDimensions
	lw $a1, directionBitMap
	addi $a2, $t0, 0
	addi $a3, $t1, 0
	jal coordinate
	
	lw $t4, snake # dirección cabeza de la lista
	lw $t5, 0($t4) # ditrección primer elemento
	addi $t6, $v0, 0 # nueva dirección en memoria de la cabeza.
	lw $t7, 0($t5) # antigua dirección de la cabeza
	sw $t6, 0($t5) # se actualiza en la lista la ubicación de la cabeza
	
	# Se comprueba que en la nueva dirección no ocurra un choque (ya sea contra la misma serpiente, contra un borde 
	# o contra una fruta)
	addi $a0, $v0, 0
	addi $a1, $s2, 0
	addi $a2, $s3, 0
	jal choque
	
	# Si se chocó con un borde o una serpiente, se acabó el juego.
	# Si se chocó contra una fruta, aumenta el puntaje, se elimina la fruta en pantalla, crece la serpiente
	# y se spawnea una nueva fruta.
	beq $v0, 1, gameOver
	beq $v0, 2, punto
				
	# Si no hubo choque, se pinta la cabeza de la serpiente en la nueva posición.
	sw $s0, 0($t6)
	sw $s1, 0($t7)
	
	sw $s2, 0($s4) #Se borra la cola anterior
	
	# Ya no se puede mover.
	li $t0, 0x0
	sw $t0, snakeHead + 20
	
	# El timer vuelve a 0.
	mtc0 $t0, $9
	
	# Se permiten de nuevo las interrupciones de teclado.
	li $t0, 0x10
	sw $t0, 0xffff0000
	
	j movimiento
	
izqMovimiento: 
	# Si la direción de movimiento anterior era a la derecha y la nueva es a la izquierda, no se ejecuta el cambio de dirección.
	beq $t2, 0x64, noCambia
		
	# La cabeza se mueve un cuadro en x negativo.
	addi $t0, $t0, -1
	sw $t0, snakeHead
	
	j dibujarCabeza

abjMovimiento: 
	# Si la direción de movimiento anterior era a la arriba y la nueva es hacia abajo, no se ejecuta el cambio de dirección.
	beq $t2, 0x73, noCambia
	
	# La cabeza se mueve un cuadro en y negativo.
	addi $t1, $t1, -1
	sw $t1, snakeHead + 4
	
	j dibujarCabeza	

arrMovimiento: 
	# Si la direción de movimiento anterior era a hacia abajo y la nueva es hacia arriba, no se ejecuta el cambio de dirección.
	beq $t2, 0x77, noCambia
	
	# La cabeza se mueve un cuadro en y positivo.
	addi $t1, $t1, 1
	sw $t1, snakeHead + 4
	
	j dibujarCabeza					

######################################################
#------------- Condiciones de Movimiento ------------#
######################################################

noCambia: 
	sw $t2, snakeHead + 12
	j movimiento

######################################################
#------------------- Game over ----------------------#
######################################################

gameOver: 
	li $v0, 4
	la $a0, finMensaje
	syscall
	
	li $v0, 1
	lw $a0, snakeHead + 16
	syscall

	li $v0, 10
	syscall
	
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
	
	addi $sp, $sp, -28
	sw $fp, 28($sp)
	addi $fp, $sp, 28
	sw $ra, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	sw $s4, 4($sp)
	
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
	lw $fp, 28($sp)
	lw $ra, 24($sp)
	lw $s0, 20($sp)
	lw $s1, 16($sp)
	lw $s2, 12($sp)
	lw $s3, 8($sp)
	lw $s4, 4($sp)
	addiu $sp, $sp, 28
		
	jr $ra			# return $v0

######################################################
#--------------- Generar la fruta ------------------#
######################################################	

punto:  
	# Se aumenta el puntaje
	lw $t0, snakeHead + 16
	addi $t0, $t0, 1
	sw $t0, snakeHead + 16
	
	# Se revisa el puntaje. Si es 10, entonces se pasa de nivel del 1 al 2.
	# Si es 20, se pasa del nivel 2 al nivel 3.
	beq $t0, 10, nivel2
	beq $t0, 20, nivel3
	
crecimiento:	
	# Se dibuja la cabeza donde debería estar
	sw $s0, 0($t6)
	sw $s1, 0($t7)
	
	# Se añade un nuevo elemento a la lista
	lw $a0, snake
	addi $a1, $s4, 0
	jal list_insertar
	
	lw $a0, screenDimensions
	lw $a1, directionBitMap
	addi $a2, $s3, 0 
	la $a3, fruit
	jal generarFruta
		
	j movimiento
	
nivel2: 
	# Se aumenta la velocidad.
	lw $t0, speed + 4
	sw $t0, speed
	
	# Se imprime el mensaje de aumento de nivel y la puntuación.
	li $v0, 4
	la $a0, aumentoNivel
	syscall
	
	li $v0, 1
	lw $a0, snakeHead + 16
	syscall
	
	j crecimiento
	
nivel3: 
	# Se aumenta la velocidad.
	lw $t0, speed + 8
	sw $t0, speed
	
	# Se imprime el mensaje de aumento de nivel y la puntuación.
	li $v0, 4
	la $a0, aumentoNivel
	syscall
	
	li $v0, 1
	lw $a0, snakeHead + 16
	syscall
	
	j crecimiento
	
generarFruta:
	# Entrada
	# $a0 -> ancho de la pantalla que el mismo alto (screenDimensions).
	# $a1 -> dirección en la que se mapea el BitMap
	# $a2 -> color de la fruta.
	# $a3 -> dirección que almacena cuantas frutas hay en pantalla.
	
	#-------- planificacion de registros --------#
	
	# $s0 -> ancho de la pantalla que el mismo alto (screenDimensions). Luego comprueba que la fruta no caiga sobre la serpiente.
	#	Al final, almacena la cuantas frutas hay en pantalla.
	# $s1 -> dirección en la que se mapea el BitMap
	# $s2 -> color de la fruta. Cantidad de fruta nueva: 1.
	# $s3 -> dirección que almacena cuantas frutas hay en pantalla.
	# $s4 -> posición X generada de manera random.
	# $s5 -> El tamaño de la pantalla menos uno para que no caiga en el borde. Luego, posición Y generada de manera random.
	# $s6 -> El contenido de la dirección dada por las coordenadas X y Y.
			
	# ---------------- prologo ----------------- #
	
	# almacenamos $fp, $ra y los registros $s usados en la pila. 
	
	addi $sp, $sp, -36
	sw $fp, 36($sp)
	addi $fp, $sp, 36
	sw $ra, 32($sp)
	sw $s0, 28($sp)
	sw $s1, 24($sp)
	sw $s2, 20($sp)
	sw $s3, 16($sp)
	sw $s4, 12($sp)
	sw $s5, 8($sp)
	sw $s6, 4($sp)
	
	# ----------------- cuerpo ----------------- #
	addi $s0, $a0, 0 # movemos el argumento 1
	addi $s1, $a1, 0 # movemos el argumento 2 
	addi $s2, $a2, 0 # movemos el argumento 3 
	addi $s3, $a3, 0 # movemos el argumento 4
	
generarUbicacion:
	addi $s5, $s0, -1
			
	li $v0, 42
	li $a0, 1
	add $a1, $s5, 0
	syscall
	addi $s4, $a0, 0 # posición en X
	
	li $v0, 42
	li $a0, 1
	syscall
	addi $s5, $a0, 0 # posición en Y
	
	addi $a0, $s0, 0
	addi $a1, $s1, 0
	addi $a2, $s4, 0
	addi $a3, $s5, 0
	jal coordinate # Se transforman las coordenadas en dirección de memoria.
	
	lw $s6, 0($v0)
	bnez $s6, generarUbicacion # Si no está cayendo en el fondo, sino sobre la serpiente, se vuelve a generar otra ubicación.
	
	sw $s2, 0($v0) # Se dibuja la fruta.
	
	li $s6, 1 
	sw $s6, 0($s3) # Se indica que hay una fruta en pantalla.
	
	# ---------------- epilogo ----------------- #

	lw $fp, 36($sp)
	lw $ra, 32($sp)
	lw $s0, 28($sp)
	lw $s1, 24($sp)
	lw $s2, 20($sp)
	lw $s3, 16($sp)
	lw $s4, 12($sp)
	lw $s5, 8($sp)
	lw $s6, 4($sp)
	addiu $sp, $sp, 36
		
	jr $ra			# no retorna nada. 
	
									
######################################################
#--------------------- Funciones --------------------#
######################################################	

coordinate:
	# Entrada
	# $a0 -> ancho de la pantalla que el mismo alto (screenDimensions).
	# $a1 -> dirección en la que se mapea el bitmap.
	# $a2 -> posición en x.
	# $a3 -> posición en y.
	# Salida 
	# $v0 -> coordenada convertida en dirección de memoria.
	
	#-------- planificacion de registros --------#
	
	# $s0 -> ancho de la pantalla que el mismo alto (screenDimensions). Luego, almacena la coordenada como dirección de memoria.
	# $s1 -> dirección en la que se mapea el bitmap
	# $s2 -> posición en x
	# $s3 -> posición en y
	
	# ---------------- prologo ----------------- #
	
	# almacenamos $fp, $ra y los registros $s usados en la pila. 
	
	addi $sp, $sp, -24
	sw $fp, 24($sp)
	addi $fp, $sp, 24
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
	
	mul $s0, $s0, $s3	# multiplicamos por y
	add $s0, $s0, $s2	# sumamos x
	mul $s0, $s0, 4		# multiplicamos por 4
	addu $v0, $s0, $s1	# sumamos la dirección de inicio de mapeo del BitMap
	
	# ---------------- epilogo ----------------- #

	lw $fp, 24($sp)
	lw $ra, 20($sp)
	lw $s0, 16($sp)
	lw $s1, 12($sp)
	lw $s2, 8($sp)
	lw $s3, 4($sp)
	addi $sp, $sp, 24
		
	jr $ra			# se regresa $v0
	
######################################################
#-------------------Mover Cuerpo --------------------#
######################################################		
moverCuerpo:
	# Entrada 
	# $a0 -> direccion de la lista
	# Salida
	# $v0 -> antigua dirección de la cola

	#-------- planificacion de registros --------#
	
	# $s0 -> dirección de la lista.
	# $s1 -> longitud de la serpiente.
	# $s2 -> dirección a la que apunta la cabeza de la lista.
	# $s3 -> elemento del nodo.
	# $s4 -> longitud de la lista. También almacena, dado un nodo, la dirección del siguiente (si hay)
	# $s5 -> contenido del $s4
	# $s6 -> dirección del último elemento.
	
	# ---------------- prologo ----------------- #
	
	# almacenamos $fp, $ra y los registros $s usados en la pila. 
	
	addi $sp, $sp, -32
	sw $fp, 32($sp)
	addi $fp, $sp, 32
	sw $ra, 28($sp)
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $s2, 16($sp)
	sw $s3, 12($sp)
	sw $s4, 8($sp)
	sw $s5, 4($sp)
	
	# ---------------- cuerpo ----------------- #
	
	addi $s0, $a0, 0 # movemos el argumento 1
	
	# consideramos la longitud menos 1
	lw $s1, 4($s0)
	addi $s1, $s1, -1
	lw $s2, 0($s0) 
	lw $s3, 0($s2) 
	
moverCuerpo_loop:
	beqz $s1, moverCuerpo_end	
	lw $s4, 4($s2) # dirección del siguiente nodo.
	lw $s5, 0($s4) # elemento del siguiente nodo
	sw $s3, 0($s4) # pasar el elemento del nodo anterior al siguiente
	
	addi $s2, $s4, 0
	addi $s3, $s5, 0
	addi $s1, $s1, -1
	j moverCuerpo_loop
	
moverCuerpo_end:	
	addi $v0, $s3, 0 

	lw $fp, 32($sp)
	lw $ra, 28($sp)
	lw $s0, 24($sp)
	lw $s1, 20($sp)
	lw $s2, 16($sp)
	lw $s3, 12($sp)
	lw $s4, 8($sp)
	lw $s5, 4($sp)
	addiu $sp, $sp, 32
		
	jr $ra			# se retorna $v0
	
