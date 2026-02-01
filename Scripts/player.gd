extends CharacterBody2D


@export var tile_size:      int   = 16
@export var move_speed:     float = 128.0
@export var input_map:      bool  = true

# state im going to kms
enum Direction { DOWN, LEFT, RIGHT, UP }

var facing:       int  = Direction.DOWN
var is_moving:    bool = false
var move_target:  Vector2
var move_origin:  Vector2

# references
var _sprite:     Sprite2D
var _anim:       AnimationPlayer

#lifecycle
func _ready() -> void:
	_sprite = $Sprite
	_anim   = $AnimationPlayer
	move_target = position # start by npt moving
	move_origin = position

func _physics_process(delta: float) -> void:
	if is_moving:
		_continue_move(delta)
	else:
		_check_input()

# input
func _check_input() -> void:
	var dir = Vector2.ZERO

	if Input.is_action_pressed("ui_down"):
		dir.y =  1
		facing = Direction.DOWN
	elif Input.is_action_pressed("ui_up"):
		dir.y = -1
		facing = Direction.UP
	elif Input.is_action_pressed("ui_right"):
		dir.x =  1
		facing = Direction.RIGHT
	elif Input.is_action_pressed("ui_left"):
		dir.x = -1
		facing = Direction.LEFT

	if dir != Vector2.ZERO:
		_start_move(dir)
	else:
		_play_anim("idle")

func _start_move(dir: Vector2) -> void:
	var target = position + dir * tile_size

# collisiomn check uses raycast TODO
	var space  = get_viewport().get_world_2d().get_direct_space_state()
	var query  = PhysicsRayQueryParameters2D.create(
			position + Vector2(0, 4), 
			target   + Vector2(0, 4),
			0xFFFFFFFF,
			[ get_rid() ]
	)
	var result = space.raycast(query)

	if result:
		# hit smth
		_play_anim("idle")
		return

	move_origin = position
	move_target = target
	is_moving   = true
	_play_anim("walk")

func _continue_move(delta: float) -> void:
	var dir    = (move_target - move_origin).normalized()
	var dist   = move_speed * delta
	var remain = move_target.distance_to(position)

	if dist >= remain:
		position  = move_target 
		#snaps to grid ^^
		is_moving = false
		_play_anim("idle")
	else:
		position += dir * dist

# animation stuff
func _play_anim(action: String) -> void:
	var dir_name = ["down","left","right","up"][facing]
	var anim     = "%s_%s" % [action, dir_name]

	if _anim and _anim.has_animation(anim):
		if _anim.current_animation != anim:
			_anim.play(anim)
	# if there isn't any animationhelper you can flip the animation manually
	elif _sprite:
		_sprite.flip_h = (facing == Direction.LEFT)

# making animations TODO
