extends ActorController

func _is_ui_focused() -> bool:
    return get_viewport().gui_get_focus_owner() != null

func is_shoot_once(shoot_action: StringName) -> bool:
    if _is_ui_focused():
        return false #this is probably unnecessary since InputBuffer works using _unhandled_input in the first place.
    return InputBuffer.is_action_press_buffered(shoot_action)

func is_shoot(shoot_action: StringName) -> bool:
    if _is_ui_focused():
        return false
    return Input.is_action_pressed(shoot_action)

func is_dash() -> bool:
    if _is_ui_focused():
        return false
    return InputBuffer.is_action_press_buffered(&"dash")

func is_boost() -> bool:
    if _is_ui_focused():
        return false
    return Input.is_action_pressed(&"boost")
    
func get_action_buffered(action: StringName) -> bool:
    Syslog.warning('Used deprecated function ActorController.get_action_buffered()! See code for more details.')
    
    return InputBuffer.is_action_press_buffered(action)

func get_boost_dir() -> Vector2:
    if _is_ui_focused():
        return Vector2.ZERO

    return Util.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")

func get_move_dir() -> Vector2:
    if _is_ui_focused():
        return Vector2.ZERO
        
    var move_dir: Vector2 = Util.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
    if Input.is_action_pressed("slow"):
        move_dir *= 0.5
    
    return move_dir

func get_look_dir() -> Vector2:
    if master.lock_on:
        return (master.lock_on.global_position - master.global_position).normalized()

    if _is_ui_focused():
        return Vector2.ZERO

    return (master.get_global_mouse_position() - master.global_position).normalized()

func is_lock_on() -> bool:
    return Input.is_action_just_pressed(&"lock_on")
