extends CharacterBody2D

enum enemy_direction {RIGHT, LEFT, UP, DOWN, CHASE}

const FX = preload("res://scenes/fx/fx.tscn")
const AMMO_1 = preload("res://scenes/interactables/ammo/ammo_1.tscn")

@onready var anim: AnimationPlayer = $anim
@onready var timer: Timer = $Timer

@export var speed: int

var new_direction: enemy_direction = enemy_direction.RIGHT
var change_directiom
@onready var target = get_node("../Player")

func _ready() -> void:
	choose_direction()

func _process(delta: float) -> void:
	match new_direction:
		enemy_direction.RIGHT:
			move_right()
		enemy_direction.LEFT:
			move_left()
		enemy_direction.UP:
			move_up()
		enemy_direction.DOWN:
			move_down()
		enemy_direction.CHASE:
			chase_state()

func move_right() -> void:
	velocity = Vector2.RIGHT * speed
	anim.play("move_right")
	move_and_slide()

func move_left() -> void:
	velocity = Vector2.LEFT * speed
	anim.play("move_left")
	move_and_slide()

func move_up() -> void:
	velocity = Vector2.UP * speed
	anim.play("move_up")
	move_and_slide()

func move_down() -> void:
	velocity = Vector2.DOWN * speed
	anim.play("move_down")
	move_and_slide()

func choose_direction() -> void:
	change_directiom = randi() % 4
	random_direction()

func random_direction() -> void:
	match change_directiom:
		0:
			new_direction = enemy_direction.RIGHT
		1:
			new_direction = enemy_direction.LEFT
		2:
			new_direction = enemy_direction.UP
		3:
			new_direction = enemy_direction.DOWN

func _on_timer_timeout() -> void:
	choose_direction()
	timer.start()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		Globals.camera.screen_shake(3, 3, 0.05)
		Globals.score += 1
		instance_fx()
		instance_ammo()
		queue_free()

func instance_fx() -> void:
	var fx = FX.instantiate()
	fx.global_position = global_position
	get_tree().root.add_child(fx)

func instance_ammo() -> void:
	var ammo = AMMO_1.instantiate()
	ammo.global_position = global_position
	get_tree().root.add_child(ammo)

func chase_state() -> void:
	var chase_speed = 60
	velocity = position.direction_to(target.global_position) * chase_speed
	animation()
	move_and_slide()

func _on_chase_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Scent"):
		new_direction = enemy_direction.CHASE

func animation() -> void:
	if velocity > Vector2.ZERO:
		anim.play("move_right")
	if velocity < Vector2.ZERO:
		anim.play("move_left")
