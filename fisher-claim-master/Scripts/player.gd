class_name Player
extends CharacterBody2D

const WALK_SPEED = 50.0
var gravity = 600

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine = $AnimationTree["parameters/playback"]


# ------------------------
# Estados del Player
# ------------------------
enum PlayerState {
	IDLE,
	WALK,
	RUN,
	FISHING,
	IDLE_FISHING,
	CAST,
	REEL,
}

var current_state: PlayerState = PlayerState.IDLE


# ------------------------
# Mapear enums a nombres de animación en AnimationTree
# ------------------------
func _anim_name(state: PlayerState) -> String:
	match state:
		PlayerState.IDLE: return "idle"
		PlayerState.WALK: return "walk"
		PlayerState.RUN: return "run"
		PlayerState.FISHING: return "fishing"
		PlayerState.IDLE_FISHING: return "idle_fishing"
		PlayerState.CAST: return "cast"
		PlayerState.REEL: return "reel"
	# valor por defecto si algo falla
	return "idle"


# ------------------------
# Cambio de estado seguro
# ------------------------



func change_state(_new_state: PlayerState):
	if current_state==_new_state:
		return
	if can_auto_translate():
		current_state=_new_state
		var _name = _anim_name(current_state)
		state_machine.travel(_name)
		print("Estado actual:", _name)

# ------------------------
# Flip del sprite
# ------------------------
func flip_sprite(direction: float):
	if direction > 0:
		animation.flip_h = false
	elif direction < 0:
		animation.flip_h = true

# ------------------------
# Movimiento y física
# ------------------------
func _physics_process(delta):
	# Gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Dirección horizontal
	var direction := Input.get_axis("left", "right")

	if direction != 0 :
		velocity.x = direction * WALK_SPEED
		change_state(PlayerState.WALK)
		flip_sprite(direction)
	elif Input.is_action_pressed("reel") : #and pez=null:
		change_state(PlayerState.REEL)
	else:
		velocity.x = 0
		change_state(PlayerState.IDLE)
	move_and_slide()


# Cambia "anim_name" por "_anim_name"
func _on_animation_tree_animation_finished(anim_name: StringName):
	print("Termino el estado animado de ", state_machine.get_current_node())
	# Ya no saldrá el aviso de "UNUSED_PARAMETER"


func _on_animated_sprite_2d_animation_finished() -> void:
	print("Que pasa aqui")
	pass # Replace with function body.
