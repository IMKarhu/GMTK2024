extends Node

@onready var m_cameraHorizontal = $CameraHorizontal
@onready var m_cameraVertical = $CameraHorizontal/CameraVertical
@onready var m_camera = $CameraHorizontal/CameraVertical/MainCamera

var m_Horizontal: float = 0
var m_vertical: float = 0

var m_horizontalSensitivity: float = 0.05
var m_verticalSensitivity: float = 0.05

var m_horizontalAcceleration: float = 15
var m_verticalAcceleration: float = 15



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event: InputEvent):
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			m_Horizontal += -event.relative.x * m_horizontalSensitivity
			m_vertical += event.relative.y * m_verticalSensitivity
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	m_cameraHorizontal.rotation_degrees.x = lerp(m_cameraHorizontal.rotation_degrees.x, m_Horizontal, m_horizontalAcceleration * delta)
	m_cameraVertical.rotation_degrees.y = lerp(m_cameraVertical.rotation_degrees.y, m_vertical, m_verticalAcceleration * delta)
