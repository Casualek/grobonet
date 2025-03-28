extends Area2D



func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	global_position = get_global_mouse_position()
