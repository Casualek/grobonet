extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.hide()

func _process(delta: float) -> void:
	if Globals.score >= 20:
		sprite_2d.show()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		await Leaderboards.post_guest_score("dniotwarte-grobonet-OmBG", Globals.time_float, Globals.nickname)
		get_tree().change_scene_to_file("res://addons/quiver_leaderboards/leaderboard_ui.tscn")
