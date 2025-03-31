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
		time += delta
		msec = fmod(time,1) * 100
		seconds = fmod(time,60)
		minutes = fmod(time,3600) / 60
		$Minutes.text = "%02d:" % minutes
		$Seconds.text = "%02d:" % seconds
		$Msecs.text = "%03d" % msec
		Globals.time_float = float(seconds) + float(msec) / 1000.0
		
