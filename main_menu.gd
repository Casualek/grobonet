extends Control


var typed_text := ""
var banned_words := ["Nigger", "nigger", "nIGGER", "NIGGER"] 

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.unicode > 0:  
			typed_text += char(event.unicode)
		elif event.keycode == KEY_BACKSPACE and typed_text.length() > 0:
			typed_text = typed_text.left(-1)  
		for word in banned_words:
			if word in typed_text.to_lower():
				trigger_response(word)
				typed_text = "" 

func trigger_response(word):
	$Label2.text = "NIGGER"
	
func _on_button_pressed() -> void:
	Globals.nickname = "";
	get_tree().change_scene_to_file("res://name.tscn")


func _on_button_2_pressed() -> void:
	$AnimationPlayer.play("MOVE")


func _on_button_3_pressed() -> void:
	Globals.nickname = "";
	get_tree().change_scene_to_file("res://addons/quiver_leaderboards/leaderboard_ui.tscn")


func _on_button_4_pressed() -> void:
	$AnimationPlayer.play_backwards("MOVE")
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("Main")
