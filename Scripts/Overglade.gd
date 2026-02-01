extends Node2D


var _player:  CharacterBody2D
var _camera:  Camera2D

# life cycle
func _ready() -> void:
	_player = $Player
	_camera = $Camera2D

	# camers setup
	_camera.global_position = _player.global_position
	_camera.make_current()
	# process_callback defaults to IDLE already; no need to set it manually
	# since we lerp the camera position ourselves in _process()
	_camera.zoom = Vector2(4, 4)

	# area2d trigger
	for trigger in $Triggers.get_children():
		if trigger is Area2D:
			trigger.area_entered.connect(_on_trigger_entered.bind(trigger))

# camera follow
func _process(delta: float) -> void:
	# direct camera towards the player
	var weight = clampf(8.0 * delta, 0.0, 1.0)
	_camera.global_position = _camera.global_position.lerp(
		_player.global_position, weight
	)

# door handling
func _on_trigger_entered(trigger: Area2D) -> void:
	var scene_path  = trigger.get_meta("scene_path",  "")
	var spawn_point = trigger.get_meta("spawn_point", "")

	if scene_path == "":
		print("Trigger '%s' has no scene_path metadata set." % trigger.name)
		return

	# transition scene in between
	_transition_to_scene(scene_path, spawn_point)

# actual scene transition
func _transition_to_scene(scene_path: String, spawn_point: String) -> void:
	# blocks player input while transitioning
	_player.set_process(false)
	_player.set_physics_process(false)

	# fade out (still nned to implement TODO and also get a colour rect)
	var next_scene = load(scene_path).instantiate()
	get_tree().root.add_child(next_scene)

	# put player at specific spot on new scene
	if spawn_point != "":
		var marker = next_scene.find_child(spawn_point)
		if marker:
			# move the player node into the new scene
			var player_copy = _player
			remove_child(player_copy)
			next_scene.add_child(player_copy)
			player_copy.position = marker.position
			player_copy.set_process(true)
			player_copy.set_physics_process(true)

	# remove the old scene
	queue_free()
