extends Node2D

const PLAYER = preload("res://scenes/entities/player/player.tscn")
const EXIT = preload("res://scenes/interactables/exit/exit.tscn")
const ENEMY_1 = preload("res://scenes/entities/enemies/enemy_1/enemy_1.tscn")

@onready var tile_map: TileMap = $TileMap

@export var borders: Rect2 = Rect2(1, 1, 90, 45)

var walker: Walker_room
var map
var ground_layer: int = 0 

func _ready() -> void:
	randomize()
	generate_lvl()

func generate_lvl() -> void:
	walker = Walker_room.new(Vector2(3, 5), borders)
	map = walker.walk(1000)
	#var end_room_pos = walker.get_end_room().position * 16
	var using_cells: Array = []
	var all_cells: Array = tile_map.get_used_cells(ground_layer)
	tile_map.clear()
	walker.queue_free()
	
	for tile in all_cells:
		if !map.has(Vector2(tile.x, tile.y)):
			using_cells.append(tile)
	
	tile_map.set_cells_terrain_connect(ground_layer, using_cells, ground_layer, ground_layer, false)
	tile_map.set_cells_terrain_path(ground_layer, using_cells, ground_layer, ground_layer, false)
	
	instance_player()
	instance_exit() 
	instance_enemy()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

func instance_player() -> void:
	var player = PLAYER.instantiate()
	add_child(player)
	player.position = map.pop_front() * 16

func instance_exit() -> void:
	var exit = EXIT.instantiate()
	add_child(exit)
	exit.position = walker.get_end_room().position * 16

func instance_enemy() -> void:
	for i in range(12):
		var enemy = ENEMY_1.instantiate()
		enemy.position = (map.pick_random() * borders.position) * 16
		add_child(enemy)

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
