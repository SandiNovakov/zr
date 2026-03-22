extends WeaponState

func enter() -> void:
    master.enabled.connect(go_to_idle)
    
func go_to_idle() -> void:
    state_machine.request_state_change($"../Idle")

func exit() -> void:
    master.enabled.disconnect(go_to_idle)
