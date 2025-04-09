extends Panel

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0
var canplay = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		await get_tree().create_timer(0.5).timeout
		time += delta
		msec = fmod(time,1) * 100
		seconds = fmod(time,60)
		minutes = fmod(time,3600) / 60
		$Minutes.text = "%02d:" % minutes
		$Seconds.text = "%02d:" % seconds
		$Msecs.text = "%03d" % msec
		Globals.time_float = float("%02d.%02d.%03d" % [minutes, seconds, msec])
		
