extends WeaponState

var time_shoot_is_held: float = 0

func enter() -> void:
    time_shoot_is_held = 0

func physics_update(delta: float) -> void:
    if not master.allow_shoot:
        return
    
    if master.automatic and controller.is_shoot():
        master.shoot()
        
    if not master.automatic and controller.is_shoot_once():
        master.shoot()
        
    if master.can_charge and not master.automatic:
        if controller.is_shoot():
            time_shoot_is_held += delta
        else:
            time_shoot_is_held = 0
        
        if time_shoot_is_held >= master.time_until_charging:
            Syslog.info("%s began charging weapon!" % [master.master.name])
            state_machine.request_state_change($"../Charging") #will generate warning, ignore for now.
