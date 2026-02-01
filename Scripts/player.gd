extends CharacterBody2D


const SPEED = 300.0

func player():
	pass

func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_axis("a", "d")
	input_vector.y = Input.get_axis("w", "s")
	
	input_vector = input_vector.normalized()
	
	velocity = input_vector * SPEED
	
	move_and_slide()
