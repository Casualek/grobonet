extends CharacterBody2D

enum player_states {MOVE, DEAD}

const BULLET_1 = preload("res://scenes/entities/bullet/bullet_1.tscn")
const SCENT_TRIAL = preload("res://scenes/entities/enemies/scent_trial/scent_trial.tscn")

@onready var anim: AnimationPlayer = $anim
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var gun_handler: Node2D = $gun_handler
@onready var gun_sprite: Sprite2D = $gun_handler/gun_sprite
@onready var bullet_point: Marker2D = $gun_handler/bullet_point
@onready var trial_timer: Timer = $trial_timer
@onready var dash_timer: Timer = $dash_timer 

@export var Speed: int
@export var cooldown_to_shoot: float
@export var dash_speed: int = 300
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 1.0 

var current_state: player_states = player_states.MOVE
var is_dead: bool = false
var can_shoot: bool = true
var pos: Vector2
var rot
var can_take_damage: bool = true
var input_move: Vector2 = Vector2()
var last_entered_area: Area2D = null
var is_dashing: bool = false
var can_dash: bool = true
var has_been_played: bool = false

func _ready() -> void:
	$AudioStreamPlayer2D.play()
	pass 

func _process(delta: float) -> void:
	if player_data.health <= 0:
		current_state = player_states.DEAD
	
	target_mouse()
	
	match current_state:
		player_states.MOVE:
			movement(delta)
		player_states.DEAD:
			dead()
			
	if Globals.score >= 5 and has_been_played == false:
		has_been_played = true
		$Opened.play()
		$DoorOpen.play("DoorOpen")

func movement(delta: float) -> void:
	animations()
	input_move = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if Input.is_action_just_pressed("Dash") and can_dash and velocity != Vector2.ZERO:
		dash()
		return
	
	if !is_dashing:
		if input_move != Vector2.ZERO:
			velocity = input_move * Speed
		else:
			velocity = Vector2.ZERO
			
	if Input.is_action_just_pressed("shoot") or Input.is_action_pressed("shoot"):
		if player_data.ammo == 0:
			can_shoot = false
		if can_shoot:
			player_data.ammo -= 1
			$gun_handler/gunanim.play("Spin")
			$gunshot.play()
			instance_bullet()
			can_shoot = false
			$reload.play()
			$GunReload.start()
	move_and_slide()

func animations() -> void:
	if input_move != Vector2.ZERO:
		anim.play("move")
		#obracanie postaci bez podążania za myszką
		#if input_move.x > 0  or input_move.y > 0:
			#sprite_2d.flip_h = false
			#anim.play("move")
		#if input_move.x < 0 or input_move.y < 0:
			#sprite_2d.flip_h = true
			#anim.play("move")
	if input_move == Vector2.ZERO:
		anim.play("idle")

func target_mouse() -> void:
	if is_dead == false:
		var mouse_move = get_global_mouse_position()
		pos = global_position
		gun_handler.look_at(mouse_move)
		rot = rad_to_deg((mouse_move - pos).angle())
		
		if rot >= -90 and rot <=90:
			gun_sprite.flip_v = false
			sprite_2d.flip_h = false
		else:
			gun_sprite.flip_v = true
			sprite_2d.flip_h = true
	else:
		return

func instance_bullet() -> void:
	var bullet = BULLET_1.instantiate()
	bullet.direction = bullet_point.global_position - global_position
	bullet.global_position = bullet_point.global_position
	get_tree().root.add_child(bullet)

func dead() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	gun_handler.visible = false
	anim.play("death")
	await get_tree().create_timer(2).timeout
	if get_tree():
		get_tree().reload_current_scene()
		player_data.health += 4
		is_dead = false

func reset_states() -> void:
	current_state = player_states.MOVE

func instance_trial() -> void:
	var trial = SCENT_TRIAL.instantiate()
	trial.global_position = global_position
	get_tree().root.add_child(trial)

func _on_trial_timer_timeout() -> void:
	instance_trial()
	trial_timer.start()


func _on_hotbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		if(can_take_damage == true): 
			player_data.health -= 1 
			can_take_damage = false
			$hurt.play()
			flash()
			$IFrame.start()
		last_entered_area = area
		$CheckIfIn.start()

func _on_hotbox_area_exited(area: Area2D) -> void:
	if area == last_entered_area:
		last_entered_area = null
		$CheckIfIn.stop()
		
func flash() -> void:
	sprite_2d.material.set_shader_parameter("flash_modifier", 0.75)
	sprite_2d.material.set_shader_parameter("flash_color", Color(1, 0, 0))
	await get_tree().create_timer(0.25).timeout
	sprite_2d.material.set_shader_parameter("flash_modifier", 0)


func _on_gun_reload_timeout() -> void:
	sprite_2d.material.set_shader_parameter("flash_modifier", 1)
	sprite_2d.material.set_shader_parameter("flash_color", Color(1, 1, 1))
	$donereload.play()
	can_shoot = true
	$Popupreload.play("reloadpop")
	await get_tree().create_timer(0.25).timeout
	sprite_2d.material.set_shader_parameter("flash_modifier", 0)


func _on_i_frame_timeout() -> void:
	can_take_damage = true


func _on_check_if_in_timeout() -> void:
	if last_entered_area and last_entered_area.is_in_group("Enemies"):
		player_data.health -= 1 
		$hurt.play()
		flash()
		$IFrame.start()

func dash() -> void:
	is_dashing = true
	can_dash = false
	can_take_damage = false
	$IFrame.start()
	velocity = input_move.normalized() * dash_speed
	$DashTimer.start()
	$DashCooldown.start()
	
func _on_dash_timer_timeout() -> void:
	is_dashing = false
	velocity = Vector2.ZERO
	
func _on_dash_cooldown_timeout() -> void:
	$Popupani.play("dashcooldown")
	$dashon.play()
	can_dash = true
	sprite_2d.material.set_shader_parameter("flash_modifier", 1)
	sprite_2d.material.set_shader_parameter("flash_color", Color(1, 1, 1))
	await get_tree().create_timer(0.25).timeout
	sprite_2d.material.set_shader_parameter("flash_modifier", 0)
	
