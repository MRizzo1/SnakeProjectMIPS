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
#-------------------Dibujar bordes------------------#
######################################################
	lw $a0, screenDimensions
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
	beqz $a2, Init
	jal coordinate
	sw $a3, 0($v0)
	addi $a2, $a2, -1 #increment counter
	j border4Loop
	
Init:  
	j Init

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