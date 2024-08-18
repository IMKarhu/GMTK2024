extends Node3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var mesh_controller = get_tree().get_first_node_in_group("meshcontroller")

@export var mesh: Mesh

func _ready():
	$Mesh.mesh = mesh
	interaction_area.interact = Callable(self, "_on_interact")

# TODO: make it so it falls on the ground and loses ability to interact??
func _on_interact():
	mesh_controller.addMeshToDic(mesh.to_string(), mesh)
