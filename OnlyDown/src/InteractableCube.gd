extends Node3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

@onready var cube = $Cube

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

# TODO: make it so it falls on the ground and loses ability to interact??
func _on_interact():
	player.change_to_mesh(cube.mesh)
	cube.scale = Vector3(0.5, 0.5, 0.5)
