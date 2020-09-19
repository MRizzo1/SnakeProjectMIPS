# Autor: Joao Pinto 17-10490
#        Mariangela Rizzo 17-10538
	.data
	
	.text

# ------------------------------------------------------------ list_crear:

list_crear: 
	# Salida
	# $v0 -> direccion de la lista creada
	
	# ---------------- prologo ----------------- #
	
	# almacenamos $fp y $ra en la pila
	addi $sp, $sp, -12
	sw $fp, 12($sp)
	addi $fp, $sp, 12
	sw $ra, 8($sp)
	sw $s0, 4($sp)
	
	# ----------------- cuerpo ----------------- #
	
	# obtenemos un bloque de 8 bytes de memoria libre, la cabeza tiene la forma (dirección primer nodo, long)
	# guardamos la direccion del bloque en $s1
	li $v0, 9
	li $a0, 8
	syscall		
	# - la cabeza en null (la lista no tiene elementos)
	# - la longitud es cero (la lista no tiene elementos)
	
	# ---------------- epilogo ----------------- #
	lw $fp, 12($sp)
	lw $ra, 8($sp)
	lw $s0, 4($sp)
	addiu $sp, $sp, 12
	
	jr $ra # retornamos la dirección 
	

# ------------------------------------------------------------ list_insertar:

list_insertar:
	# Entrada 
	# $a0 -> direccion de la lista
	# $a1 -> elemento a insertar
	
	#-------- planificacion de registros --------#
	
	# $s0 -> dirección de la lista.
	# $s1 -> elemento a insertar.
	# $s2 -> dirección del nuevo nodo de la forma (elemento, prev). Prev señala a la dirección del nodo anterior.
	# $s3 -> contenido de la cabeza de la lista.
	# $s4 -> longitud de la lista. También almacena, dado un nodo, la dirección del siguiente (si hay)
	# $s5 -> contenido del $s4
	# $s6 -> dirección del último elemento.
	
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
	
	# ----------------- cuerpo ----------------- #

	addi $s0, $a0, 0 # movemos el argumento 1
	addi $s1, $a1, 0 # movemos el argumento 2
	
	# reservamos memoria para el nodo a insertar, el cual tiene la forma (elemento, next)
	# obtenemos un bloque de 12 bytes de memoria libre,
	# guardamos la direccion del nodo en $s2
	li $v0, 9
	li $a0, 8
	syscall
	addi $s2, $v0, 0
	
	# guardamos la dirección del elemento a insertar dentro 
	# del nodo
	sw $s1, 0($s2)
	
	# verificamos si la cabeza está vacia
	lw $s3, 0($s0)
	
	# saltamos dependiendo de si next es null o no
	bnez $s3, list_insertar_head_not_null
	
	# colocamos el nodo a insertar como cabeza de la lista
	sw $s2, 0($s0)
	
	# se aumenta la longitud
	lw $s4, 4($s0)
	addi $s4, $s4, 1
	sw $s4, 4($s0)
	
	j list_insertar_end

list_insertar_head_not_null:
	# la cabecera no es null
	
	# cargamos el elemento que sigue a la cabeza
	lw $s4, 0($s0)
	lw $s5, 4($s4)
	
list_loop:	
	beqz $s5, list_loop_end
	# cargo next del elemento considerado
	addi $s4, $s5, 0
	lw $s5, 4($s4)
	j list_loop
	
list_loop_end:	
	sw $s2, 4($s4)
	
	# se aumenta la longitud
	lw $s4, 4($s0)
	addi $s4, $s4, 1
	sw $s4, 4($s0)
	
	# ---------------- epilogo ----------------- #
list_insertar_end:

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
		
	jr $ra			# se regresa $v0
