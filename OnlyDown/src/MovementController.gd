extends Node

## EXPORTS ##
@export var m_player: CharacterBody3D
@export var m_mesh: MeshInstance3D
@export var m_rotationSpeed: float = 8

## COSNTANTS ##


## VARIABLES ##
var m_direction: Vector3
var m_velocity: Vector3
var m_acceleration: float
var m_speed: float
var m_cameraRotation: float = 0



func _physics_process(delta):
	m_velocity.x = m_speed * m_direction.normalized().x
	m_velocity.z = m_speed * m_direction.normalized().z
	
	m_player.velocity = m_player.velocity.lerp(m_velocity, delta)
	if not m_velocity.is_zero_approx():
		m_player.move_and_slide()
	else:
		m_player.velocity = Vector3.ZERO
	
	print(m_player.velocity)
	var targetRotation = atan2(m_direction.x, m_direction.z) - m_player.rotation.y
	m_mesh.rotation.y = lerp_angle(m_mesh.rotation.y, targetRotation, m_rotationSpeed * delta)
	

func _on_setMovementDirection(_m_movementDirection: Vector3):
	m_direction = _m_movementDirection.rotated(Vector3.UP, m_cameraRotation)

func _on_setVelocity(_m_velocity: Vector3):
	m_velocity = _m_velocity

func _on_setSpeed(_m_speed: float):
	m_speed = _m_speed

func _on_setAcceleration(_m_acceleration: float):
	m_acceleration = _m_acceleration

func _on_setCameraRotation(_m_cameraRotation: float):
	m_cameraRotation = _m_cameraRotation
