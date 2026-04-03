extends ActorState

func enter() -> void:
    master.charged_shot.connect(on_charged_shot)

func physics_update(delta: float) -> void:
    master.move(controller.get_move_dir())
    master.turn(controller.get_look_dir(), master.turn_speed, delta)
    
    if controller.is_dash():
        state_machine.request_state_change($"../Dash")
    
    if controller.is_boost():
        state_machine.request_state_change($"../BoostCharge")

    
func on_charged_shot(handler: WeaponHandler) -> void:
    $"../ChargedShotRecoil".handler = handler
    state_machine.request_state_change($"../ChargedShotRecoil")
    

func exit() -> void:
    master.charged_shot.disconnect(on_charged_shot)
