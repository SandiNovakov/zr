@abstract
extends Node
class_name State

@onready var state_machine: StateMachine = get_parent()

@abstract func set_master(new_master: Node) -> void

@abstract func enter() -> void
    
@abstract func update(delta: float) -> void

@abstract func physics_update(delta: float) -> void

@abstract func exit() -> void
