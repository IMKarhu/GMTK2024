extends Node
class_name MeshController

@export var collision_shape: CollisionShape3D

@export var mesh_instance: MeshInstance3D
@onready var flagPacked = preload("res://scenes/Inteactable.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
var meshes: Array[Mesh]

func _input(event):
	if event.is_action_pressed("changeForm"):
		toggle_mesh()

func _ready():
	meshes.push_back(player.get_child(0).mesh)

#currentMesh = meshes[0]
#mesh2 = meshes[1]
# Function to toggle between meshes
func toggle_mesh():
	if meshes.size() == 1:
		return
	# Check if currentMesh should be swapped with mesh2
	if mesh_instance.mesh == meshes[0]:
		change_mesh(meshes[1])
	else:
		change_mesh(meshes[0])

# Function to change the mesh and spawn the old one if necessary
func change_mesh(new_mesh: Mesh) -> void:
	if meshes.size() == 1:
		meshes.push_back(new_mesh)
		return

	# Update the mesh instance and collision shape
	mesh_instance.mesh = new_mesh
	update_collision_shape(new_mesh)

func remove_numeric_suffix(mesh_name: String) -> String:
	# Find the position of the '#' character
	var index = mesh_name.find("#")
	# If found, return the substring before it; otherwise, return the original name
	if index != -1:
		return mesh_name.substr(0, index)
	return mesh_name

# Function to change to a specific mesh, avoiding duplicates
func change_to_mesh(new_mesh: Mesh) -> void:
	var new_name = remove_numeric_suffix(new_mesh.to_string())
	var current_name = remove_numeric_suffix(meshes[0].to_string())
	var mesh2_name = ''
	if meshes.size() > 1:
		mesh2_name = remove_numeric_suffix(meshes[1].to_string())
		#spawn_oldMesh(meshes[0])
	# Avoid changing to the same mesh
	if new_name == current_name or new_name == mesh2_name:
		print("Trying to change to the same mesh")
		return
	# Perform the mesh change, update states correctly
	change_mesh(new_mesh)

# @TODO: Make it so it spawns the old mesh to the scene
func spawn_oldMesh(oldMesh: Mesh) -> void:
	var flag = flagPacked.instantiate()
	flag.mesh = oldMesh
	var newPos = Vector3(self.global_position.x, self.global_position.y, self.global_position.z - 1)
	flag.set_position(newPos)
	flag.scale = Vector3(0.5, 0.5, 0.5)
	get_tree().get_root().add_child(flag)

# @TODO: For now this only works with simple shapes need to modify this later if time
func update_collision_shape(new_mesh: Mesh) -> void:
	var new_shape: Shape3D = null
	if new_mesh is BoxMesh:
		new_shape = BoxShape3D.new()
		new_shape.extents = (new_mesh as BoxMesh).size / 2.0
	elif new_mesh is SphereMesh:
		new_shape = SphereShape3D.new()
		new_shape.radius = (new_mesh as SphereMesh).radius
	elif new_mesh is CapsuleMesh:
		new_shape = CapsuleShape3D.new()
		new_shape.radius = (new_mesh as CapsuleMesh).radius
		new_shape.height = (new_mesh as CapsuleMesh).height
	elif new_mesh is CylinderMesh:
		new_shape = CylinderShape3D.new()
		new_shape.radius = (new_mesh as CylinderMesh).bottom_radius
		new_shape.height = (new_mesh as CylinderMesh).height
	if new_shape:
		collision_shape.shape = new_shape
	#print(collision_shape.shape)extends Node
