extends WeaponState

var time_shoot_is_held: float = 0

func enter() -> void:
    time_shoot_is_held = 0

func update(delta: float) -> void:
    check_shoot()
    check_charge(delta)
    
    if master.weapon.can_charge and time_shoot_is_held >= master.time_until_charging:
            state_machine.request_state_change($"../Charging")

func check_charge(delta: float) -> void:
    if not master.can_shoot():
        time_shoot_is_held = 0
        return
    
    if not master.allow_charge:
        time_shoot_is_held = 0
        return
    
    if master.weapon.can_charge and not master.weapon.automatic:
        if get_controller().is_shoot(master.shoot_action):
            time_shoot_is_held += delta
        else:
            time_shoot_is_held = 0
        


func check_shoot() -> void:
    if not master.can_shoot():
        return
    
    if master.weapon.automatic and get_controller().is_shoot(master.shoot_action):
        master.shoot()
        
    if not master.weapon.automatic and get_controller().is_shoot_once(master.shoot_action):
        master.shoot()
