@abstract
extends Node
class_name State

@onready var state_machine: Node = get_parent()

@abstract func set_master(master: Node) -> void

@abstract func enter() -> void
    
@abstract func update(delta: float = get_process_delta_time()) -> void

@abstract func physics_update(delta: float = get_physics_process_delta_time()) -> void

@abstract func exit() -> void
