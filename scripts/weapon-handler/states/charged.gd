extends WeaponState

var vfx: Node2D

func enter() -> void:
    master.invalidate_charge.connect(on_invalidate_charge)

    vfx = master.weapon.charged_vfx.instantiate()
    master.start_vfx(vfx)

func update(delta: float) -> void:   
    if not master.allow_charge:
        state_machine.request_state_change($"../Idle")
    
    if not get_controller().is_shoot(master.shoot_action) and master.allow_shoot:
        master.shoot_charged()
        
        # just in case something goes wrong in the pipeline, weapons will stay disabled.
        # otherwise, this will await player's charged_shot_recoil state to end.
        #state_machine.request_state_change($"../Disabled")
        state_machine.request_state_change($"../Idle")

func on_invalidate_charge() -> void:
    state_machine.request_state_change($"../Idle")

func exit() -> void:
    master.invalidate_charge.disconnect(on_invalidate_charge)

    master.stop_vfx(vfx)
