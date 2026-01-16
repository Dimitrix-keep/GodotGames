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
var LOCKED_STATES = [PlayerState.FISHING, PlayerState.IDLE_FISHING, PlayerState.CAST, PlayerState.REEL]

# ------------------------
# Mapear enums a nombres de animación en AnimationTree
# ------------------------
func anim_name(state: PlayerState) -> String:
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
func can_change_state(_new_state: PlayerState) -> bool:
	if current_state in LOCKED_STATES:
		return false
	return true

func change_state(_new_state: PlayerState):
	if current_state == _new_state:
		return
	if can_change_state(_new_state):
		current_state = _new_state
		var name = anim_name(current_state)
		state_machine.travel(name)
		print("Estado actual:", name)

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

	if direction != 0 and can_change_state(PlayerState.WALK):
		velocity.x = direction * WALK_SPEED
		change_state(PlayerState.WALK)
		flip_sprite(direction)
	else:
		velocity.x = 0
		change_state(PlayerState.IDLE)

	move_and_slide()
