extends ActorController

@export var min_action_interval: float = 1.0
@export var max_action_interval: float = 3.0
@export_range(0.0, 1.0) var dodge_chance: float = 0.15
@export var shoot_rate: int = 3

@export_range(0.0, 1.0) var min_move_speed: float = 0.0
@export_range(0.0, 1.0) var max_move_speed: float = 1.0

enum Action { SHOOT, DODGE }

var current_action: Action = Action.SHOOT
var move_dir: Vector2 = Vector2.ZERO
var time_until_next_action: float = 0.0
var pending_dash: bool = false

var last_shot_timestamps: Dictionary = {}
var default_heading: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
    time_until_next_action -= delta

    if time_until_next_action <= 0.0:
        _choose_action()

func _choose_action() -> void:
    time_until_next_action = randf_range(min_action_interval, max_action_interval)
    move_dir = Vector2.from_angle(randf_range(0, TAU)) * randf_range(min_move_speed, max_move_speed)

    if randf() < dodge_chance:
        current_action = Action.DODGE
        pending_dash = true
    else:
        current_action = Action.SHOOT

func is_shoot_once(shoot_action: StringName) -> bool:
    return _handle_shoot_logic(shoot_action)

func is_shoot(shoot_action: StringName) -> bool:
    return _handle_shoot_logic(shoot_action)

func _handle_shoot_logic(shoot_action: StringName) -> bool:
    if current_action != Action.SHOOT or not master.lock_on:
        return false

    var current_time: int = Time.get_ticks_msec()
    var last_time: int = last_shot_timestamps.get(shoot_action, 0)

    if last_time == 0 or current_time - last_time >= Util.to_msec(1) / shoot_rate:
        last_shot_timestamps[shoot_action] = current_time
        return true

    return false

func is_dash() -> bool:
    if pending_dash:
        pending_dash = false
        return true

    return false

func is_boost() -> bool:
    return false

func get_action_buffered(action: StringName) -> bool:
    Syslog.warning('Used deprecated function ActorController.get_action_buffered()! See code for more details.')
    return false

func get_boost_dir() -> Vector2:
    return Vector2.ZERO

func get_move_dir() -> Vector2:
    return move_dir

func get_look_dir() -> Vector2:
    if master.lock_on:
        return (master.lock_on.global_position - master.global_position).normalized()

    if default_heading == Vector2.ZERO:
        default_heading = Vector2.from_angle(master.rotation)

    return default_heading

func is_lock_on() -> bool:
    if not master.lock_on and master.lock_on_radius and master.lock_on_radius.get_overlapping_bodies().size() > 0:
        return true

    return false
