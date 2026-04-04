extends ActorState

var time_boost_is_held: float = 0
var next: ActorState

func enter() -> void:
    master.disable_shooting()
    master.invalidate_charges()
    time_boost_is_held = 0

func update(delta: float) -> void:
    master.move(Vector2.ZERO, delta)
    master.turn(controller.get_look_dir(), master.boost_turn_speed, delta)
    
    if controller.is_boost():
        time_boost_is_held += delta
    else:
        time_boost_is_held = 0
        next = $"../Idle"
        state_machine.request_state_change($"../Idle")
    
    if time_boost_is_held >= master.boost_charge_time:
        next = $"../Boost"
        state_machine.request_state_change($"../Boost")

func exit() -> void:
    if next == $"../Idle":
        master.enable_shooting()
