extends CharacterBody3D
class_name Player

@onready var currentMesh = $Mesh.mesh
@export var mesh2: Mesh
var mesh_instance: MeshInstance3D

@onready var collision_shape = $Collision

@onready var flagPacked = preload("res://scenes/Inteactable.tscn")

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

signal setMovementDirection(_m_movementDirection: Vector3)
signal setVelocity(_m_velocity: Vector3)
signal setSpeed(_m_speed: float)
signal setAcceleration(_m_acceleration: float)

var m_movementDirection: Vector3
var m_speed: float = 10
var m_acceleration: float = 0.5


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
		
	if is_movement():
		setMovementDirection.emit(m_movementDirection)
		setSpeed.emit(m_speed)
		setAcceleration.emit(m_acceleration)
	else:
		setSpeed.emit(0)
		setAcceleration.emit(0)
		setVelocity.emit(Vector3(0,velocity.y,0))

func _input(event):
	if event.is_action_pressed("changeForm"):
		toggle_mesh()
		
	m_movementDirection.x = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	m_movementDirection.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backwards")

# Function to toggle between meshes
func toggle_mesh():
	if mesh2 == null:
		return

	# Check if currentMesh should be swapped with mesh2
	if mesh_instance.mesh == currentMesh:
		change_mesh(mesh2)
	else:
		change_mesh(currentMesh)

# Function to change the mesh and spawn the old one if necessary
func change_mesh(new_mesh: Mesh) -> void:	
	# Update mesh2 only if it is not the same as new_mesh
	if mesh2 != currentMesh:
		mesh2 = currentMesh  # Previous currentMesh becomes mesh2
	currentMesh = new_mesh  # The new mesh becomes currentMesh

	# Update the mesh instance and collision shape
	mesh_instance.mesh = new_mesh
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
		spawn_oldMesh(currentMesh)

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
		
func is_movement() -> bool:
	return abs(m_movementDirection.x) > 0 or abs(m_movementDirection.z) > 0
