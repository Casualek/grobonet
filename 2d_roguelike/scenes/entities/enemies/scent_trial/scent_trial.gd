extends Area2D

func _ready() -> void:
	pass 

func remove_trial() -> void:
	queue_free()

func _on_timer_timeout() -> void:
	remove_trial()
