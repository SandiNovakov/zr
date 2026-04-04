extends ActorState

var inactive_timer: Timer
var handler: WeaponHandler

func enter() -> void:
    master.disable_shooting()
    inactive_timer = Timer.new()
    inactive_timer.wait_time = handler.weapon.charge_recovery_time
    inactive_timer.one_shot = true
    inactive_timer.timeout.connect(on_inactive_timer_timeout)
    add_child(inactive_timer)
    inactive_timer.start()
    
    master.velocity = -Vector2.from_angle(master.rotation).normalized() * handler.weapon.charged_shot_recoil
    
func update(delta: float) -> void:
    master.move(Vector2.ZERO, delta)

func on_inactive_timer_timeout() -> void:
    state_machine.request_state_change($"../Idle")
    
func exit() -> void:
    handler = null
    master.enable_shooting()
