extends SubViewport

@onready var camera_2d: Camera2D = $Camera2D
@onready var player: CharacterBody2D = $"res://scenes/entities/player/player.tscn"  # Adjust the path to your player

func _ready() -> void:
	# Set world_2d if needed (usually only if you need to work with world transformations)
	world_2d = get_tree().root.world_2d

func _physics_process(delta: float) -> void:
	# Update the minimap camera position based on the player's position
	$Camera2D.position = player.position
