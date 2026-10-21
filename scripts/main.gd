extends Node2D
## The main game scene. It holds the level, the player and the HUD.
##
## When the game starts it:
## 1. moves the player to the level's "PlayerSpawn" marker, and
## 2. stops the camera from showing the empty space outside the map.

@onready var level: Node2D = $Level
@onready var player: Player = $Player
@onready var camera: Camera2D = $Player/Camera2D


func _ready() -> void:
	_place_player_at_spawn()
	_fit_camera_to_level()


func _place_player_at_spawn() -> void:
	var spawn := level.get_node_or_null("PlayerSpawn") as Marker2D
	if spawn == null:
		push_warning("The level has no Marker2D called 'PlayerSpawn', so the player starts where it is in main.tscn.")
		return
	player.global_position = spawn.global_position
	# Jump the camera straight to the player instead of sliding over from the old position.
	camera.reset_smoothing()


func _fit_camera_to_level() -> void:
	# Work out the area covered by all the tile layers in the level.
	var bounds := Rect2()
	var found_tiles := false
	for child in level.get_children():
		var layer := child as TileMapLayer
		if layer == null or layer.tile_set == null:
			continue
		var used_cells := layer.get_used_rect()
		if not used_cells.has_area():
			continue
		var tile_size := Vector2(layer.tile_set.tile_size)
		var layer_rect := Rect2(layer.global_position + Vector2(used_cells.position) * tile_size, Vector2(used_cells.size) * tile_size)
		bounds = bounds.merge(layer_rect) if found_tiles else layer_rect
		found_tiles = true

	if not found_tiles:
		return
	camera.limit_left = floori(bounds.position.x)
	camera.limit_top = floori(bounds.position.y)
	camera.limit_right = ceili(bounds.end.x)
	camera.limit_bottom = ceili(bounds.end.y)
