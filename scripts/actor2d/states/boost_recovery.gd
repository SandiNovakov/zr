extends ActorState

var time_elapsed: float = 0.0

func enter() -> void:
    time_elapsed = 0.0

func update(delta: float) -> void:
    master.move(Vector2.ZERO, delta)
    #master.turn(controller.get_look_dir(), master.turn_speed, delta)
    
    time_elapsed += delta
    if time_elapsed >= master.boost_recovery_time:
        state_machine.request_state_change($"../Idle")

func exit() -> void:
    master.enable_shooting()
    master.enable_charging()
