extends WeaponState

func enter() -> void:
    master.invalidate_charge.connect(on_invalidate_charge)
    Input.start_joy_vibration(0, 0.1, 0.1)


func physics_update(delta: float) -> void:   
    if not controller.is_shoot() and master.allow_shoot:
        master.shoot_charged()
        
        # just in case something goes wrong in the pipeline, weapons will stay disabled.
        # otherwise, this will await player's charged_shot_recoil state to end.
        #state_machine.request_state_change($"../Disabled")
        state_machine.request_state_change($"../Idle")

func on_invalidate_charge() -> void:
    state_machine.request_state_change($"../Idle")

func exit() -> void:
    master.invalidate_charge.disconnect(on_invalidate_charge)
    Input.stop_joy_vibration(0)
    Input.start_joy_vibration(0, 1, 1, 0.25)
