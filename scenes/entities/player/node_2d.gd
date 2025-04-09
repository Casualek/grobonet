extends Node2D

@export var player: Node2D
@onready var enemies_group = "Enemies"

func _process(delta):
	var closest_enemy = get_closest_enemy()

	# Debugging: Check if the closest_enemy is correctly assigned
	if closest_enemy != null:
		print("Closest enemy found at position: ", closest_enemy.global_position)
		look_at(closest_enemy.global_position)
		visible = true
	else:
		print("No enemy found.")
		visible = false

func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group(enemies_group)
	if enemies.is_empty():
		print("No enemies in the group.")
		return null
	
	var closest = null
	var closest_dist = INF

	for enemy in enemies:
		# Adding a check for invalid or null enemies
		if enemy == null:
			print("Found a null enemy in the group.")
			continue
		
		var dist = player.global_position.distance_to(enemy.global_position)
		if dist < closest_dist:
			closest = enemy
			closest_dist = dist
	
	# Debugging: Print the closest enemy's position
	if closest != null:
		print("Closest enemy position: ", closest.global_position)
	else:
		print("No valid closest enemy found.")

	return closest  # Returns the nearest enemy or null if none exist
