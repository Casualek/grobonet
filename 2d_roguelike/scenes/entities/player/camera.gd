extends Camera2D

@onready var camera_shake: Timer = $camera_shake

var start_shaking: bool = false
var shake_intensity: float = 0.0
var shake_dampening: float = 0.0

func _ready() -> void:
	Globals.camera = self

func _process(delta: float) -> void:
	if start_shaking == true:
		offset.x = randi_range(-1, 1) * shake_intensity
		offset.y = randi_range(-1, 1) * shake_intensity
		shake_intensity = lerp(shake_intensity, 0.0, shake_dampening)
	else:
		offset = Vector2(0, 0)

func screen_shake(intensity: float, duration: float, dampening: float) -> void:
	shake_intensity = intensity
	camera_shake.wait_time = duration
	shake_dampening = dampening
	start_shaking = true

func _on_camera_shake_timeout() -> void:
	start_shaking = false
