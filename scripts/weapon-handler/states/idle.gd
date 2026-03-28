extends WeaponState

var time_shoot_is_held: float = 0

func enter() -> void:
    time_shoot_is_held = 0

func physics_update(delta: float) -> void:
    if not master.allow_shoot:
        return
    
    if master.weapon.automatic and controller.is_shoot():
        master.shoot()
        
    if not master.weapon.automatic and controller.is_shoot_once():
        master.shoot()
        
    if master.weapon.can_charge and not master.weapon.automatic:
        if controller.is_shoot():
            time_shoot_is_held += delta
        else:
            time_shoot_is_held = 0
        
        if time_shoot_is_held >= master.time_until_charging:
            state_machine.request_state_change($"../Charging") #will generate warning, ignore for now.
