extends Area2D

@onready var anim: AnimationPlayer = $anim

@export var ammo: int

func _ready() -> void:
	anim.play("active")

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if player_data.ammo < player_data.max_ammo:
			if (player_data.ammo + ammo) > player_data.max_ammo:
				player_data.ammo = 10
			else:
				player_data.ammo += ammo
		queue_free()
