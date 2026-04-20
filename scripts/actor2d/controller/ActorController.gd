@abstract
extends Node
class_name ActorController

@onready var master: Actor2D = get_parent()

@abstract func _is_ui_focused() -> bool

@abstract func is_shoot_once(shoot_action: StringName) -> bool

@abstract func is_shoot(shoot_action: StringName) -> bool

@abstract func is_dash() -> bool

@abstract func is_boost() -> bool
    
@abstract func get_action_buffered(action: StringName) -> bool

@abstract func get_boost_dir() -> Vector2

@abstract func get_move_dir() -> Vector2

@abstract func get_look_dir() -> Vector2
