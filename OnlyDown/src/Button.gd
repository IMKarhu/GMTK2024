class_name Button3D extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("input_event", self, "_on_Button3D_input_event")
	$Viewport/Button.connect("toggled", self, "_on_Button_toggled")
	$Viewport/Button.connect("pressed", self, "_on_Button_pressed").


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_Button3D_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$Viewport/Button.emit_signal("pressed")
			$Viewport/Button.set_pressed(true)
		else:
			$Viewport/Button.set_pressed(false)

func _on_Button_pressed():
	print("pressed")

func _on_Button_toggled(button_pressed):
	print("toggled " + button_pressed )
