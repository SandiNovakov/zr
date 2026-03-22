extends WeaponState

var current_charge_time: float = 0

func enter() -> void:
    current_charge_time = 0
    master.invalidate_charge.connect(on_invalidate_charge)
    
func physics_update(delta: float) -> void:      
    if not controller.is_shoot():
        Syslog.info("%s stopped charging!" % [master.master.name])
        state_machine.request_state_change($"../Idle")
    
    current_charge_time += delta
    
    if current_charge_time >= master.weapon.charge_time:
        Syslog.info("%s fully charged up!" % [master.master.name])
        state_machine.request_state_change($"../Charged")

func on_invalidate_charge() -> void:
    state_machine.request_state_change($"../Idle")

func exit() -> void:
    master.invalidate_charge.disconnect(on_invalidate_charge)
