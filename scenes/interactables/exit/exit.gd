extends Area2D

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if Globals.score >= 5:
		if body.name == "Player":
			await Leaderboards.post_guest_score("dniotwarte-grobonet-OmBG", Globals.time_float, Globals.nickname)
			get_tree().change_scene_to_file("res://addons/quiver_leaderboards/leaderboard_ui.tscn")
