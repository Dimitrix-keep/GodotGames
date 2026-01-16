extends AnimationTree

@onready var state_machine:AnimationNodeStateMachinePlayback = get("parameters/playback")

func _ready():
	active=true
	state_machine.travel("idle")
# Función para intentar cambiar estado
#I need here the logic to let permission to change state if where necesary, example:if player fishing ->cant walk(velocity=0)
func _process(_delta):
	pass
	
