extends CharacterBody2D

# variáveis ​​​​básicas de dinossauros
const GRAVITY: int = 3900
const JUMP_SPEED: int = -1150
const SMASH: int = 2150

func _physics_process(delta): #chama delta mais a fisicas de godot
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y = JUMP_SPEED / 10

	if not is_on_floor() and Input.is_action_pressed("ui_down"):
		velocity.y = SMASH
	if is_on_floor(): #Se estiver nó chão 
		if not get_parent().game_running:
			$AnimatedSprite2D.play("parado")
		else:
			$col_correndo.disabled = false
			if Input.is_action_just_pressed("ui_accept"):#si a tecla espaço foi pressionando 
				velocity.y = JUMP_SPEED # a velocidade Y sera igual a jump_speed
				$JumpSound.play()
			elif Input.is_action_pressed("ui_down"): #si a tecla abaixo estiver apertada
				$AnimatedSprite2D.play("agachado_correndo") #reproduze barulho de pulo
				$col_correndo.disabled = true # desliga a colisão de correr e trocs por deitado
			else :
				$AnimatedSprite2D.play("correndo") # do contrario simplesmente voltara pra a animação de correr
	else:
			$AnimatedSprite2D.play("pulando") # si não estiver no chão reproduzira a animação de pular
		
	
	move_and_slide()
