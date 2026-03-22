extends ActorState

var inactive_timer: Timer

func enter() -> void:
    master.disable_shooting()
    inactive_timer = Timer.new()
    inactive_timer.wait_time = master.weapon_handler.weapon.charge_recovery_time
    inactive_timer.one_shot = true
    inactive_timer.timeout.connect(on_inactive_timer_timeout)
    add_child(inactive_timer)
    inactive_timer.start()
    
    master.velocity = -Vector2.from_angle(master.rotation).normalized() * master.weapon_handler.weapon.charged_shot_recoil
    
func physics_update(delta: float) -> void:
    master.move(Vector2.ZERO)    

func on_inactive_timer_timeout() -> void:
    master.enable_shooting()
    state_machine.request_state_change($"../Idle")
    
func exit() -> void:
    master.enable_shooting()
