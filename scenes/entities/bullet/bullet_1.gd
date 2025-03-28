extends Area2D

@export var speed: int

var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	translate(direction * speed * delta)

func _on_body_entered(body: Node2D) -> void:
	queue_free()

func _on_visible_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		queue_free()
