extends WeaponState

func enter() -> void:
    master.disabled.connect(disable)

func physics_update(delta: float) -> void:
    if not controller.is_shoot():
        master.shoot_charged()
        
        # just in case something goes wrong in the pipeline, weapons will stay disabled.
        # otherwise, this will await player's charged_shot_recoil state to end.
        #state_machine.request_state_change($"../Disabled")
    
func disable() -> void:
    state_machine.request_state_change($"../Disabled")

func exit() -> void:
    master.disabled.disconnect(disable)
