extends Node3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

# TODO: make it so it falls on the ground and loses ability to interact??
func _on_interact():
	player.set_mesh.emit($Mesh.mesh)
