extends CharacterBody2D

# settings
@export var dialogue_lines: Array[String] = ["Hello!", "Nice to meet you."]

# enums/state
enum Direction { DOWN, LEFT, RIGHT, UP }
var facing: int = Direction.DOWN

# variables
var _sprite: Sprite2D
var _zone:   Area2D
var _player: CharacterBody2D

# life cycle pls kill me 
func _ready() -> void:
	_sprite = $Tongyu
	_zone   = $InteractZone

	# connects the interact zone so we know when the player is nearby
	_zone.area_entered.connect(_on_player_near)
	_zone.area_exited.connect(_on_player_far)

func _process(_delta: float) -> void:
	# look at the player if they are close enough
	if _player:
		_face_toward(_player.global_position)

# zone callbacks
func _on_player_near(body: Node2D) -> void:
	if body.is_in_group("Player"):
		_player = body as CharacterBody2D

func _on_player_far(body: Node2D) -> void:
	if body == _player:
		_player = null
		# reset to default when the player leaves
		facing = Direction.DOWN
		_update_sprite()

# interactions (TODO)
func interact() -> void:
	if _player == null:
		return
	_face_toward(_player.global_position)   # face them one more time
	_show_dialogue()

# facing logic
func _face_toward(target_pos: Vector2) -> void:
	var diff = target_pos - global_position
	# pick different dominant azis
	if abs(diff.x) > abs(diff.y):
		facing = Direction.RIGHT if diff.x > 0 else Direction.LEFT
	else:
		facing = Direction.DOWN if diff.y > 0 else Direction.UP
	_update_sprite()

func _update_sprite() -> void:
	if _sprite == null:
		return
	# frame ofset direction stuff too lazy to explain pls dont ask me
	_sprite.frame = facing

# dialogue TODO
func _show_dialogue() -> void:
	# printing to output for now still need to add the dialogue boxes TODO
	for line in dialogue_lines:
		print("[NPC %s]: %s" % [name, line])
