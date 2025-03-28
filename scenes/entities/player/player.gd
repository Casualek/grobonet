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

@export var Speed: int
@export var cooldown_to_shoot: float

var current_state: player_states = player_states.MOVE
var is_dead: bool = false
var can_shoot: bool = true
var pos: Vector2
var rot
<<<<<<< HEAD
var can_take_damage: bool = true
var input_move: Vector2 = Vector2()
var last_entered_area: Area2D = null

func _ready() -> void:
	$AudioStreamPlayer2D.play()
	pass 

func _process(delta: float) -> void:
	
	
=======
var input_move: Vector2 = Vector2()


func _ready() -> void:
	pass 

func _process(delta: float) -> void:
>>>>>>> a56dadeea0936593713d7ef0f144ad3a777c09a9
	if player_data.health <= 0:
		current_state = player_states.DEAD
	
	target_mouse()
	
	match current_state:
		player_states.MOVE:
			movement(delta)
		player_states.DEAD:
			dead()

func movement(delta: float) -> void:
	animations()
	input_move = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_move != Vector2.ZERO:
		velocity = input_move * Speed
	if input_move == Vector2.ZERO:
		velocity = Vector2.ZERO
		
	if Input.is_action_just_pressed("shoot") or Input.is_action_pressed("shoot"):
		if player_data.ammo == 0:
			can_shoot = false
		if can_shoot:
			player_data.ammo -= 1
<<<<<<< HEAD
			$gun_handler/gunanim.play("Spin")
			$gunshot.play()
			instance_bullet()
			can_shoot = false
			$reload.play()
			$GunReload.start()
=======
			instance_bullet()
			can_shoot = false
			await get_tree().create_timer(cooldown_to_shoot).timeout
			can_shoot = true
>>>>>>> a56dadeea0936593713d7ef0f144ad3a777c09a9
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
<<<<<<< HEAD
	if area.is_in_group("Enemies") and can_take_damage:
		can_take_damage = false
		$hurt.play()
		$CheckIfIn.start()
		$IFrame.start()
		flash()
		player_data.health -= 1
		last_entered_area = area  # Store the area for later reference
=======
	if area.is_in_group("Enemies"):
		flash()
		player_data.health -= 1
>>>>>>> a56dadeea0936593713d7ef0f144ad3a777c09a9

func flash() -> void:
	sprite_2d.material.set_shader_parameter("flash_modifier", 0.75)
	await get_tree().create_timer(0.25).timeout
	sprite_2d.material.set_shader_parameter("flash_modifier", 0)
<<<<<<< HEAD


func _on_gun_reload_timeout() -> void:
	sprite_2d.material.set_shader_parameter("flash_modifier", 1)
	sprite_2d.material.set_shader_parameter("flash_color", Color(1, 1, 1))
	$donereload.play()
	await get_tree().create_timer(0.25).timeout
	sprite_2d.material.set_shader_parameter("flash_modifier", 0)
	can_shoot = true


func _on_i_frame_timeout() -> void:
	can_take_damage = true


func _on_check_if_in_timeout() -> void:
	if last_entered_area and last_entered_area.is_in_group("Enemies") and can_take_damage:
		can_take_damage = false
		$hurt.play()
		$IFrame.start()
		flash()
		player_data.health -= 1
=======
>>>>>>> a56dadeea0936593713d7ef0f144ad3a777c09a9
