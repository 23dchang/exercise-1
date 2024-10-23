class_name JumpCommand
extends Command


func execute(character: Character) -> Status:
	if not character.jumping and character.character_type == Character.CharacterType.PLAYER:
		character.velocity.y = character.jump_velocity
		character.jumping = true
		character.command_callback("jump")
		return Status.ACTIVE
	return Status.DONE
		
