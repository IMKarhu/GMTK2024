extends CharacterBody3D
class_name Player

@onready var currentMesh = $Mesh.mesh
@export var mesh2: Mesh
var mesh_instance: MeshInstance3D

@onready var collision_shape = $Collision

@onready var flagPacked = preload("res://scenes/OldObject.tscn")

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	mesh_instance = get_child(0)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	if event.is_action_pressed("changeForm"):
		toggle_mesh()

# Function to toggle between meshes
func toggle_mesh():
	if mesh2 == null:
		return

	# Check if currentMesh should be swapped with mesh2
	if mesh_instance.mesh == currentMesh:
		change_mesh(mesh2)
	else:
		change_mesh(currentMesh)

# Function to change the mesh
func change_mesh(new_mesh: Mesh) -> void:
	# Store current and new mesh before the change
	var previous_mesh = currentMesh
	mesh_instance.mesh = new_mesh
	mesh2 = previous_mesh  # Previous currentMesh becomes mesh2
	currentMesh = new_mesh  # The new mesh becomes currentMesh
	update_collision_shape(new_mesh)

func remove_numeric_suffix(name: String) -> String:
	# Find the position of the '#' character
	var index = name.find("#")
	# If found, return the substring before it; otherwise, return the original name
	if index != -1:
		return name.substr(0, index)
	return name

# Function to change to a specific mesh, avoiding duplicates
func change_to_mesh(new_mesh: Mesh) -> void:
	var new_name = remove_numeric_suffix(new_mesh.to_string())
	var current_name = remove_numeric_suffix(currentMesh.to_string())
	var mesh2_name = ''

	if mesh2 != null:
		mesh2_name = remove_numeric_suffix(mesh2.to_string())

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
	#print(collision_shape.shape)
