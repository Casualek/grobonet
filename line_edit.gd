extends LineEdit 
# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_text_submitted(new_text):
	if(new_text != ""):
		Globals.nickname = new_text.to_upper()
		get_tree().change_scene_to_file("res://tutorial.tscn")
