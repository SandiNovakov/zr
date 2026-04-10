extends ActorState

var dash_timer: Timer
var dash_dir: Vector2
var trail_handle: Trail2D

func enter() -> void:
    var dbg_flag: String
    
    dash_dir = controller.get_move_dir().normalized()
    dbg_flag = 'move_dir'
    
    if dash_dir == Vector2.ZERO:
        dbg_flag = 'look_dir'
        dash_dir = controller.get_look_dir().normalized()
          
    if dash_dir == Vector2.ZERO:
        dbg_flag = 'rotation'
        dash_dir = Vector2.from_angle(master.global_rotation).normalized()
    
    master.velocity = dash_dir * master.speed * 3

    Syslog.debug('%s dash_dir = %s, sourced from %s' % [master.name, dash_dir, dbg_flag])
    
    dash_timer = Timer.new()
    add_child(dash_timer)
    dash_timer.wait_time = master.dash_duration
    dash_timer.one_shot = true
    dash_timer.timeout.connect(_on_dash_timer_timeout)
    dash_timer.start()
    
    master.disable_shooting()
    
    #Input.start_joy_vibration(0, 0.5, 0, 0.1)
    RumbleController.add(0.5, 0, 0.1)
    
    trail_handle = Trail2D.new()

    trail_handle.color_start = Pallete.Colors.BOOST_MIDDLE
    trail_handle.color_middle = Pallete.Colors.BOOST_MIDDLE
    trail_handle.color_end = Pallete.Colors.BOOST_END
    trail_handle.use_gradient = true
    trail_handle.max_length = 7
    trail_handle.width = 15
    trail_handle.z_index = -4096
    
    master.add_child(trail_handle)
    
func update(delta: float) -> void:
    master.move(controller.get_move_dir(), delta)
    master.turn(controller.get_look_dir(), master.turn_speed, delta)

func _on_dash_timer_timeout() -> void:
    state_machine.request_state_change($"../Idle")

func exit() -> void:
    trail_handle.stop()
    master.enable_shooting()
