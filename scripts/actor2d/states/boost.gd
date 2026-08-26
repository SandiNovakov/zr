extends ActorState

var trail_handle: Trail2D

func enter() -> void:
    trail_handle = Trail2D.new()

    trail_handle.color_start = Pallete.Colors.BOOST_START
    trail_handle.color_middle = Pallete.Colors.BOOST_MIDDLE
    trail_handle.color_end = Pallete.Colors.BOOST_END
    trail_handle.use_gradient = true
    trail_handle.max_length = 20
    trail_handle.width = 12
    trail_handle.z_index = -4096
    
    #master.add_child(trail_handle)
    master.add_child(trail_handle)

    master.is_boosting = true

func update(delta: float) -> void:
    #Syslog.debug("SPEED: %s" % [master.velocity])
    
    var direction: Vector2
    
    if controller.is_boost():
        master.move(Vector2.from_angle(master.rotation).normalized(), delta, master.boost_speed, false)
        master.turn(controller.get_boost_dir().normalized(), master.boost_turn_speed, delta)
    
    else:
        state_machine.request_state_change($"../BoostRecovery")

func exit() -> void:
    master.is_boosting = false
    trail_handle.stop()
