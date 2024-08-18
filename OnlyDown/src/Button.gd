class_name Button3D extends Node

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

enum Operation {ADD, SUBSTRACT}

@export var Default_Operation: Operation
@export var maxGrowth: Vector3
@export var minGrowth: Vector3 = Vector3(0.25,0.25,0.25)

var multiplier: float = 0.5
# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_on_Button_pressed")
	#interaction_area.interact = Callable(self, "_on_Button_pressed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		

func _on_Button_pressed():
	
	match Default_Operation:
		Operation.ADD:
			if player.scale == maxGrowth:
				return
			player.scale += Vector3(0.5*multiplier, 0.5*multiplier,0.5*multiplier)
		Operation.SUBSTRACT:
			if player.scale == minGrowth:
				return
			player.scale -= Vector3(0.5*multiplier, 0.5*multiplier,0.5*multiplier)

func _on_Button_toggled(button_pressed):
	print("toggled " + button_pressed )
