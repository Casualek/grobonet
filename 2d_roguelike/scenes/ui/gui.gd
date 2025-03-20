extends CanvasLayer

@onready var heart: Sprite2D = $heart
@onready var ammo_amount: Label = $ammo_amount
@onready var timer_countdown: Label = $timer_countdown
@onready var timer: Timer = $"../Timer"

const HEART_ROW_SIZE: int = 8
const HEART_OFFSET: int = 16

func _ready() -> void:
	for i in player_data.health:
		var new_heart: Sprite2D = Sprite2D.new()
		new_heart.texture = heart.texture
		new_heart.hframes = heart.hframes
		heart.add_child(new_heart)

func _process(delta: float) -> void:
	ammo_amount.text = var_to_str(player_data.ammo)
	timer_countdown.text = "TIME LEFT: "+var_to_str(timer.time_left).pad_decimals(0)

	for hp in heart.get_children():
		var index = hp.get_index() 
		var x = (index % HEART_ROW_SIZE) * HEART_OFFSET
		var y = (index / HEART_ROW_SIZE) * HEART_OFFSET
		hp.position = Vector2(x, y)
		
		var last_heart = floor(player_data.health)
		if index > last_heart:
			hp.frame = 0
		if index == last_heart:
			hp.frame = (player_data.health - last_heart) * 4
		if index < last_heart:
			hp.frame = 4
