extends ActorState

var time_boost_is_held: float = 0
var next: ActorState
var vfx: Node2D


func enter() -> void:
    master.disable_shooting()
    master.invalidate_charges()
    master.disable_charging()
    time_boost_is_held = 0
    
    if master.boost_charge_vfx and master.boost_charge_vfx_anchor:
        vfx = master.boost_charge_vfx.instantiate()
        master.boost_charge_vfx_anchor.add_child(vfx)

    master.boost_charge_started.emit()

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
    master.boost_charge_ended.emit()
    
    if vfx:
        vfx.queue_free()

    if next == $"../Idle":
        master.enable_shooting()
        master.enable_charging()
