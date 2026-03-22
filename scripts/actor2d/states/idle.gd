extends ActorState

func enter() -> void:
    Syslog.info('%s says: I\'m free~!' % [master.name])
    master.weapon_handler.charged_shot.connect(on_charged_shot)

func physics_update(delta: float) -> void:
    master.move(controller.get_move_dir())
    master.turn(controller.get_look_dir(), delta)
    
    if controller.is_dash():
        state_machine.request_state_change($"../Dash")

func on_charged_shot() -> void:
    state_machine.request_state_change($"../ChargedShotRecoil")

func exit() -> void:
    master.weapon_handler.charged_shot.disconnect(on_charged_shot)
