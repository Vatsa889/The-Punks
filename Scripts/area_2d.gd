extends Area2D

@export var dialogue_resource: DialogueResource

var entered = false

func _process(delta: float) -> void:
	if entered and Input.is_action_just_pressed("interact"):
		if !State.in_dialogue and !State.finished_dialogue_1:
			DialogueManager.show_dialogue_balloon(dialogue_resource, "start")

func _on_body_entered(body: Node2D) -> void:
	if body.has_method('player'):
		entered = true
	
func _on_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		entered = false
