extends Node3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")

@onready var sphere = $Sphere

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	player.change_to_mesh(sphere.mesh)
	sphere.scale = Vector3(0.5, 0.5, 0.5)
