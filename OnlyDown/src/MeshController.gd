extends Node
class_name MeshController

@export var collision_shape: CollisionShape3D

@export var mesh_instance: MeshInstance3D
@onready var flagPacked = preload("res://scenes/Inteactable.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
var meshes: Array[Mesh]
var mesh_dict = {}
var dummy_dict = {}
var mesh_name: Variant

func _input(event):
	if event.is_action_pressed("changeForm"):
		pass
		toggle_mesh()

func _ready():
	var name = remove_numeric_suffix(player.get_child(0).mesh.to_string())
	mesh_dict[name] = player.get_child(0).mesh
	#print("mesh1", mesh_dict[name])
	#print("meshinstance", mesh_instance.mesh)
	meshes.push_back(player.get_child(0).mesh)

func _process(delta):
	pass
	#print("current_mesh_name: ", mesh_instance.mesh)
#currentMesh = meshes[0]
#mesh2 = meshes[1]
# Function to toggle between meshes
func toggle_mesh():
	if mesh_dict.size() == 1:
		return
	# Check if currentMesh should be swapped with mesh2
	var keys = mesh_dict.keys()
	for key in mesh_dict:
		if remove_numeric_suffix(mesh_instance.mesh.to_string()) == key:
			ChangeMesh(key)
			return
	#else:
		#change_mesh(name, mesh_dict[name])

# Function to change the mesh and spawn the old one if necessary
func change_mesh(name: Variant, mesh: Mesh) -> void:
	if mesh_dict.size() == 1:
		mesh_dict[name] = mesh
		return
	
	#me haetaan käytössä olevan meshin indeksi
	if mesh_dict.has(name):
		mesh_instance.mesh = mesh
		#print("meshInstance in change_mesh", mesh_instance.mesh)
		#print("size of dict",mesh_dict.size())
		update_collision_shape(mesh)
	# Update the mesh instance and collision shape
	

func remove_numeric_suffix(mesh_name: String) -> String:
	# Find the position of the '#' character
	var index = mesh_name.find("#")
	# If found, return the substring before it; otherwise, return the original name
	if index != -1:
		return mesh_name.substr(0, index)
	return mesh_name

# Function to change to a specific mesh, avoiding duplicates
func change_to_mesh(name: Variant, new_mesh: Mesh) -> void:
	mesh_name = remove_numeric_suffix(name)
	var new_name = remove_numeric_suffix(name)
	var current_name = remove_numeric_suffix(mesh_instance.mesh.to_string())
	var m
	var mesh2_name = ''
	print(name)
	print(mesh_instance.mesh)
	if mesh_dict.size() > 1:
		var keys = mesh_dict.keys()
		m = mesh_dict.get(keys[1])
		mesh2_name = remove_numeric_suffix(m.to_string())
	
	if new_name == current_name or m != null && new_name == m.to_string():
		print("Trying to change to the same mesh")
		return
		
	change_mesh(mesh_name, new_mesh)
	#print("current", current_name)
	#var mesh2_name = ''
	#if mesh_dict.size() > 1:
		#mesh2_name = remove_numeric_suffix(meshes[1].to_string())
		
		#spawn_oldMesh(meshes[0])
	# Avoid changing to the same mesh
	#if new_name == current_name or new_name == mesh2_name:
	#	print("Trying to change to the same mesh")
	#	return
	# Perform the mesh change, update states correctly
	#change_mesh(name, new_mesh)

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

func addMeshToDic(name:Variant, mesh: Mesh) -> void:
	dummy_dict[remove_numeric_suffix(name)] = mesh
	print(dummy_dict)
	mesh_dict.merge(dummy_dict)
	dummy_dict.clear()
	print(mesh_dict)
	print(dummy_dict)
	print(mesh_instance.mesh)

func ChangeMesh(key: Variant) -> void:
	dummy_dict[key] = mesh_dict.get(key)
	print(dummy_dict)
	mesh_dict.erase(key)
	var key1 = mesh_dict.keys()
	var mesh = mesh_dict.get(key1)
	mesh_instance.mesh = mesh
	update_collision_shape(mesh)
	dummy_dict.clear()
