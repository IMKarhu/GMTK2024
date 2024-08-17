extends CharacterBody3D
class_name Player

@onready var currentMesh = $Mesh.mesh
@export var mesh2: Mesh
var mesh_instance: MeshInstance3D

@onready var collision_shape = $Collision

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

func _input(event):
	if event.is_action_pressed("changeForm"):
		toggle_mesh()
		
	m_movementDirection.x = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	m_movementDirection.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backwards")
	#Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	print(m_movementDirection)

func toggle_mesh():
	if mesh_instance.mesh == currentMesh:
		change_mesh(mesh2)
	else:
		change_mesh(currentMesh)

# Function to change the mesh
func change_mesh(new_mesh: Mesh) -> void:
	mesh_instance.mesh = new_mesh
	update_collision_shape(new_mesh)

	# Function to change the mesh
func change_to_mesh(new_mesh: Mesh) -> void:
	mesh_instance.mesh = new_mesh
	mesh2 = new_mesh
	update_collision_shape(new_mesh)
	# @TODO: Add it so you can't change to the object you already posess
	#if new_mesh == currentMesh or new_mesh == mesh2:
	#	mesh_instance.mesh = new_mesh
	#	currentMesh = new_mesh
	#	update_collision_shape(new_mesh)
	#else:
	#	print("Can't change to mesh",new_mesh, "already possible")

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
		new_shape.radius = (new_mesh as CylinderMesh).radius
		new_shape.height = (new_mesh as CylinderMesh).height

	if new_shape:
		collision_shape.shape = new_shape
		
func is_movement() -> bool:
	return abs(m_movementDirection.x) > 0 or abs(m_movementDirection.z) > 0
