extends Node3D

# Exported variables to allow setting these meshes in the editor
@export var meshes: Array[Mesh]

@export var camera: Camera3D 

# Reference to the MeshInstance3D node
var mesh_instance: MeshInstance3D

func _ready():
	# Get the MeshInstance3D node
	mesh_instance = get_child(0)
	
	# Example: Change to mesh1 at the start
	mesh_instance.mesh = meshes[0]
	print(mesh_instance.mesh)
	
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		#shoot ray here to get the mesh
		var space = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(camera.global_position,
			camera.global_position - camera.global_transform.basis.z * 100)
		var collision = space.intersect_ray(query)
		if collision.collider.mesh_instance:
			print(collision.collider.name)
			change_mesh(collision.collider.mesh_instance.mesh)
		else:
			print("ray missed")

# Function to change the mesh
func change_mesh(new_mesh: Mesh) -> void:
	if mesh_instance:
		meshes.append(new_mesh)
		mesh_instance.mesh = new_mesh
