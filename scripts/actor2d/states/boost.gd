extends ActorState

func physics_update(delta: float) -> void:
    var direction: Vector2
    
    if controller.is_boost():
        master.move(controller.get_boost_dir(), master.boost_speed)
        master.turn(controller.get_move_dir().normalized(), master.boost_turn_speed, delta)
    
    else:
        state_machine.request_state_change($"../Idle")

func exit() -> void:
    master.enable_shooting()
