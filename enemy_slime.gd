extends CharacterBody2D

var speed = 500
var player_chase = false
var player = null

func _physics_process(delta: float) -> void:
	if player_chase == true:
		position += (player.position - position)/speed
		
	
func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	player = null
	player_chase = false
