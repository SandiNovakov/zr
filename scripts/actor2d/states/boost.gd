extends ActorState

var trail_handle: Trail2D
var rumble_handle: String

func enter() -> void:
    trail_handle = Trail2D.new()

    trail_handle.color_start = Pallete.Colors.BULLET_BALLISTIC_2
    trail_handle.color_middle = Pallete.Colors.BULLET_BALLISTIC_2_TRAIL
    trail_handle.color_end = Pallete.Colors.BULLET_BALLISTIC_2_TRAIL_END
    trail_handle.use_gradient = true
    trail_handle.max_length = 20
    trail_handle.width = 15
    trail_handle.z_index = -4096
    
    master.add_child(trail_handle)
    
    rumble_handle = RumbleController.start(0.3, 0)

func update(delta: float) -> void:
    #Syslog.debug("SPEED: %s" % [master.velocity])
    
    var direction: Vector2
    
    if controller.is_boost():
        master.move(Vector2.from_angle(master.rotation).normalized(), delta, master.boost_speed, false)
        master.turn(controller.get_boost_dir().normalized(), master.boost_turn_speed, delta)
    
    else:
        state_machine.request_state_change($"../Idle")

func exit() -> void:
    master.enable_shooting()
    master.enable_charging()
    trail_handle.queue_free()
    RumbleController.end(rumble_handle)
