class_name Character
extends CharacterBody2D

signal CharacterDirectionChange(facing:Facing)

var character_type: CharacterType = CharacterType.PLAYER 


enum Facing { 
	LEFT,
	RIGHT,
}

enum CharacterType {
	PLAYER,
	BOSS,
	FOLLOWER,
}


const TERMINAL_VELOCITY = 700
const DEFAULT_JUMP_VELOCITY = -400
const DEFAULT_MOVE_VELOCITY = 300

var movement_speed = DEFAULT_MOVE_VELOCITY
var jump_velocity = DEFAULT_JUMP_VELOCITY

var right_cmd : Command
var left_cmd : Command
var up_cmd : Command
var fire1 : Command
var fire2 : Command
var idle : Command

var facing:Facing = Facing.RIGHT
var attacking : bool: 
	set(value): 
		attacking = value
	get():
		return attacking

var summoning : bool:
	set(value):
		summoning = value
	get():
		return summoning

var jumping:bool = false
var gravity: int = ProjectSettings.get("physics/2d/default_gravity")

var _horizontal_input : float

@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sprite:Sprite2D = $Sprite2D
@onready var dialogue_box:DialogueBox = %DialogueBox

func _ready() -> void:
	attacking = false
	summoning = false
	jumping = false
	change_facing(facing)


func _physics_process(delta: float) -> void: 
	_apply_gravity(delta)
	_apply_movement(delta)
	
	if is_on_floor():
		jumping = false


func _apply_movement(_delta: float):
	move_and_slide()


func _apply_gravity(delta : float) -> void:
	velocity.y = minf(TERMINAL_VELOCITY, velocity.y + gravity * delta)


func move(value: float) -> void:
	_horizontal_input = value


func change_facing(new_facing:Facing) -> void:
	facing = new_facing
	emit_signal("CharacterDirectionChange", facing)

#This function is meant to be called in the AnimationController after the each relevant anmiation has concluded.
func clear_action_state() -> void:
	attacking = false
	summoning = false

func command_callback(_name:String) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_select") or event.is_action_pressed("jump") or event.is_action_pressed("ui_up"):
		if character_type != CharacterType.BOSS:
			var jump_cmd = JumpCommand.new()
			jump_cmd.execute(self)
