extends Node
#Variables de los obstaculos

var pedra1 = preload("res://Cenas/obstacles/pedra1.tscn")
var pedra2 = preload("res://Cenas/obstacles/pedra2.tscn")
var t_arvore1 = preload("res://Cenas/obstacles/Tronco_arvore_1.tscn")
var t_arvore2 = preload("res://Cenas/obstacles/Tronco_arvore2.tscn")
var barril1 = preload("res://Cenas/obstacles/barril1.tscn")
var plataform1 = preload("res://Cenas/plataform.tscn")
var obstacle_types := [pedra1, pedra2, t_arvore1, t_arvore2,barril1]
var obstacle : Array
#Variables De las ecenas
const DINO_START_POS := Vector2i(80,520)
const CAM_START_POS := Vector2i(576,320)
var difficulty
const MAX_DIFFICULTY : int = 3
var score : int
const SCORE_MODIFIRE : int = 15
var speed : float
const START_SPEED : float = 8.0
const MAX_SPEED : int = 14
var screen_size : Vector2i
var ground_height : int
var game_running : bool
var last_obs 
var high_score : int

func _ready():
	$GAMEOVER.get_node("Button").pressed.connect(new_game)
	screen_size = get_window().size # Obtiene el tamaño de la ventana
	new_game()

func new_game():
	last_obs = null
	obstacle.clear()
	#guarda las variables para cuando se reinicie el juego
	difficulty = 0
	score = 0
	show_score()
	#reinicia las ecenas
	get_tree().paused = false
	$Dinosaurio.position = DINO_START_POS
	$Dinosaurio.velocity = Vector2i(0,0)
	$Camera2D.position = CAM_START_POS
	$StaticBody2D.position = Vector2i(-130,560)
	#reinicia hud y reinicio
	$HUD.get_node("Començo").show()
	$GAMEOVER.get_node("Button").hide()


func _process(delta):
	if game_running:
		speed = START_SPEED + score / 7000
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		adjust_difficulty()
		generate_obs()
		#Mueve la camara y el dinosaurio hacia alfrente
		$Dinosaurio.position.x += speed
		$Camera2D.position.x += speed
		
		#actualiza valor de la puntuacion
		score += speed
		show_score()
		
		#Loop del Piso
		if $Camera2D.position.x - $StaticBody2D.position.x > screen_size.x * 1.5:
			$StaticBody2D.position.x += screen_size.x 
		#remueve los obstaculos despues que salieran de la pantalla
		for obs in obstacle:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("Començo").hide()
		
#Colision del dino
func hit_obs(body):
	if body.name == "Dinosaurio":
		game_over()
#Genera los Obstaculos
func generate_obs():
	if obstacle.is_empty() or last_obs.position.x < score:
		var obs_type = obstacle_types[randi() % obstacle_types.size()]
		var obs
		var max_obs = difficulty + 1
		for i in range(randi() % max_obs + 1):
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var obs_scale = obs.get_node("Sprite2D").scale
			var ground_y = $StaticBody2D.position.y
			var obs_x : int = $Camera2D.position.x + get_window().size.x + (i * 400)
			var obs_y : int = ground_y - (obs_height * obs_scale.y) / 2.3
			last_obs = obs
			add_obs(obs, obs_x, obs_y)
			print("Nuevo Obstaculo")
#Añade los obstaculos a la ecena
func add_obs(obs,x,y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacle.append(obs)
#muestra la puntuacion en la ecena
func show_score():
	$HUD.get_node("SCORE").text = "SCORE: " + str(score/SCORE_MODIFIRE)

#Funcion que remueve los obstaculos
func remove_obs(obs):
	obs.queue_free()
	obstacle.erase(obs)

#ajusta la dificultad 
func adjust_difficulty():
	difficulty = score / 1000
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY
		
#Muesta el mensaje de "Game Over" y guarda tu puntuacion alta
func game_over():
	check_high_score()
	$GAMEOVER.get_node("Button").show()
	game_running = false
	get_tree().paused = true
	print("####################" + "\n" )
	
#muestra tu puntuacion alta en pantalla
func check_high_score():
	if score > high_score:
		high_score = score
		$HUD.get_node("MAX_Score").text = "High Score: " + str(high_score/SCORE_MODIFIRE)
		
	
