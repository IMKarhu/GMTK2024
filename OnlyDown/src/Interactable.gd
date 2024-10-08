extends Node3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("player")
@onready var mesh_instace = $Mesh

@export var mesh: Mesh

var amplitude = 0.5  # The height of the wave
var frequency = 1.0   # The speed of the wave
var initial_y = 1.5
var time_passed = 0.0
var min_y = 1.5

func _process(delta):
	time_passed += delta
	var y = initial_y + amplitude * (sin(frequency * time_passed)+1)
	y = max(y, min_y)
	position.y = y

func _ready():
	$Mesh.mesh = mesh
	interaction_area.interact = Callable(self, "_on_interact")

# TODO: make it so it falls on the ground and loses ability to interact??
func _on_interact():
	var player_mesh_instance = player.get_child(0)
	var player_mesh = player_mesh_instance.mesh
	player_mesh_instance.change_mesh(mesh)
	mesh_instace.mesh = player_mesh
	mesh = player_mesh
