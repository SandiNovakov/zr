extends WeaponState

var current_charge_time: float = 0
var vfx: Node2D

func enter() -> void:
    current_charge_time = 0
    master.invalidate_charge.connect(on_invalidate_charge)

    vfx = master.weapon.charging_vfx.instantiate()
    
    master.start_vfx(vfx)

    
func update(delta: float) -> void:  
    if not master.allow_charge:
        state_machine.request_state_change($"../Idle")
    
    if not get_controller().is_shoot(master.shoot_action):
        master.shoot()
        state_machine.request_state_change($"../Idle")
    
    current_charge_time += delta
    
    if current_charge_time >= master.weapon.charge_time:
        state_machine.request_state_change($"../Charged")

func on_invalidate_charge() -> void:
    state_machine.request_state_change($"../Idle")

func exit() -> void:
    master.invalidate_charge.disconnect(on_invalidate_charge)

    master.stop_vfx(vfx)
