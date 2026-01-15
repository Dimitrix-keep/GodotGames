extends CharacterBody2D

const SPEED = 50.0
var RUN_SPEED_BONUS = 40 # El extra de velocidad
var gravity = 600 # Nota: 60 suele ser muy poco para Godot 4, lo subí a 600
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
var on_fishing = false
var on_running=false

func _physics_process(_delta):
	# 1. Gravedad
	if not is_on_floor():
		velocity.y += gravity * _delta

	# 2. Detectar Dirección y si está corriendo
	var direction = Input.get_axis("left", "right")
	var esta_corriendo = Input.is_action_pressed("run") and direction != 0

	# 3. Calcular Velocidad
	if direction != 0:
		var velocidad_final = SPEED
		if esta_corriendo:
			velocidad_final += RUN_SPEED_BONUS
		velocity.x = direction * velocidad_final
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	animacion(direction)
	move_and_slide()
	
func animacion(direction):
	if direction != 0:
		animation.play("running") # Asegúrate de tener esta animación
	else:
		animation.play("walking")
		animation.flip_h = (direction < 0)
		

func pescar():
	if on_fishing :
		if Input.is_action_pressed("fishing"):
			animation.play("idle_fishing")
			on_fishing=false
	else:
		animation.play("idle")
	
	


		
