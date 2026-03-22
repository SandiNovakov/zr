extends ActorState

func enter() -> void:
    Syslog.info('%s says: I\'m free~!' % [master.name])

func physics_update(delta: float) -> void:
    master.move(controller.get_move_dir())
    master.turn(controller.get_look_dir(), delta)
    
    if controller.get_action_buffered(&"dash"):
        state_machine.request_state_change($"../Dash")
