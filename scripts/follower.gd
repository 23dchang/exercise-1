class_name Follower
extends Character

var idle_cmd: Command

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var cardinal_direction: Vector2 = Vector2.LEFT
var state: String = "idle"

func _physics_process(delta: float) -> void:
	if global_position.distance_to(Global.player_position) < 100:
		# Add gravity
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle movement towards the player
		var direction_to_player = global_position.direction_to(Global.player_position)
		velocity.x = direction_to_player.x * SPEED

		# Handle jump
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Flip the character based on movement direction
		if !is_zero_approx(velocity.x):
			flip_character(velocity.x)

		# Call set_state to determine if the state has changed
		if set_state():
			update_animation()  # Update animation only if the state changes

		move_and_slide()
	else:
		# If too far from the player, reset velocity and state to idle
		velocity.x = 0
		if state != "idle":
			state = "idle"
			update_animation()

func flip_character(direction: float) -> void:
	if direction > 0:
		$Sprite2D.scale.x = 2  # Face right
	elif direction < 0:
		$Sprite2D.scale.x = -2  # Face left

func set_state() -> bool:
	var new_state: String = "move" if !is_zero_approx(velocity.x) else "idle"  # Check if moving
	if new_state != state:
		state = new_state  # Update the state
		return true
	return false

func update_animation() -> void:
	animation_player.play(state) 
