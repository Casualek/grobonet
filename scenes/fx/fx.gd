extends Node2D

@onready var anim: AnimationPlayer = $anim

func _ready() -> void:
	anim.play("Active")
	await  get_tree().create_timer(0.6).timeout
	queue_free()

func _process(delta: float) -> void:
	pass
