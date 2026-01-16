extends AnimationTree

@onready var state_machine:AnimationNodeStateMachinePlayback = get("parameters/playback")

func _ready():
	active=true
	state_machine.travel("idle")
# Función para intentar cambiar estado

func _process(_delta):
	pass
	
