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

func is_movement() -> bool:
	return abs(m_movementDirection.x) > 0 or abs(m_movementDirection.z) > 0
