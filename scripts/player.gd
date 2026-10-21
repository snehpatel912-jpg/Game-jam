class_name Player
extends CharacterBody2D
## The player: top-down movement (walk + sprint) that slides along walls.
##
## The keys come from Project > Project Settings > Input Map:
## move_up / move_down / move_left / move_right (WASD and arrow keys) and sprint (Shift).
## Change the numbers below in the Inspector to tune how movement feels.

## Walking speed in pixels per second. One tile is 32 pixels.
@export var walk_speed: float = 90.0
## Sprinting speed in pixels per second (while holding Shift).
@export var sprint_speed: float = 150.0
## How quickly the player reaches full speed. Higher feels snappier.
@export var acceleration: float = 1000.0
## How quickly the player stops after letting go of the keys.
@export var friction: float = 1200.0
## How quickly the sprite turns to face the way the player is moving.
@export var turn_speed: float = 18.0

## The direction the player is facing. The flashlight (Day 4) can point this way.
var facing: Vector2 = Vector2.DOWN
## True while the player is sprinting. The monster can "hear" this later (Day 3).
var is_sprinting: bool = false

@onready var body_sprite: Sprite2D = $BodySprite


func _ready() -> void:
	# The sprite is drawn facing right, so turn it to match the starting direction.
	body_sprite.rotation = facing.angle()


func _physics_process(delta: float) -> void:
	# Read the movement keys. get_vector() returns a direction no longer than 1,
	# so moving diagonally is not faster than moving straight.
	var input_direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	is_sprinting = Input.is_action_pressed("sprint") and input_direction != Vector2.ZERO

	if input_direction != Vector2.ZERO:
		facing = input_direction.normalized()
		var target_speed := sprint_speed if is_sprinting else walk_speed
		# Speed up smoothly towards full speed instead of jumping to it instantly.
		velocity = velocity.move_toward(input_direction * target_speed, acceleration * delta)
	else:
		# No keys pressed: slow down smoothly to a stop.
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	# Move, and slide along walls instead of stopping dead when touching one.
	move_and_slide()

	# Turn the sprite smoothly towards the direction we are facing.
	body_sprite.rotation = lerp_angle(body_sprite.rotation, facing.angle(), minf(turn_speed * delta, 1.0))
