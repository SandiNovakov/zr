extends WeaponState

var current_charge_time: float = 0
var vfx: Node2D
var rumble_handle: String

func enter() -> void:
    current_charge_time = 0
    master.invalidate_charge.connect(on_invalidate_charge)
    
    #Input.start_joy_vibration(0, 0.05, 0)
    rumble_handle = RumbleController.start(0.05, 0)
    
    vfx = master.weapon.charging_vfx.instantiate()
    
    master.start_vfx(vfx)

    
func physics_update(delta: float) -> void:      
    if not controller.is_shoot():
        Syslog.info("%s stopped charging!" % [master.master.name])
        master.shoot()
        state_machine.request_state_change($"../Idle")
    
    current_charge_time += delta
    
    if current_charge_time >= master.weapon.charge_time:
        Syslog.info("%s fully charged up!" % [master.master.name])
        state_machine.request_state_change($"../Charged")

func on_invalidate_charge() -> void:
    state_machine.request_state_change($"../Idle")

func exit() -> void:
    master.invalidate_charge.disconnect(on_invalidate_charge)
    
    #Input.stop_joy_vibration(0)
    RumbleController.end(rumble_handle)
    
    master.stop_vfx(vfx)
