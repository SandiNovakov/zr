extends Node
class_name ActorController

@onready var master: Actor2D = get_parent()

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
    #ActorController will eventually be replaced with a generic version of the controller that will allow us to
    #give instructionsssssad based on ai, not just player input, so any functions to do with input will have to be done away with for now.
    
    return InputBuffer.is_action_press_buffered(action)

func get_boost_dir() -> Vector2:
    if _is_ui_focused():
        return Vector2.ZERO
    
    match InputDeviceManager.current_input_device:
        InputDeviceManager.InputDevices.KEYBOARD_MOUSE:
            var dir: Vector2 = Vector2.from_angle(master.global_rotation)

            var rotated: Vector2 = dir

            if Input.is_action_pressed("move_left"):
                rotated = dir.rotated(-PI / 2)
            elif Input.is_action_pressed("move_right"):
                rotated = dir.rotated(PI / 2)
            
            return rotated
                                    
            
        InputDeviceManager.InputDevices.CONTROLLER:             
            return Vector2.from_angle(master.rotation).normalized()
        _:
            Syslog.error('Current input device is not in InputDevices enum!')
            return Vector2.ZERO

func get_move_dir() -> Vector2:
    if _is_ui_focused():
        return Vector2.ZERO
    
    var move_dir: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
    if Input.is_action_pressed("slow"):
        move_dir *= 0.5
    
    return move_dir

func get_look_dir() -> Vector2:
    if _is_ui_focused():
        return Vector2.ZERO
    
    match InputDeviceManager.current_input_device:
        InputDeviceManager.InputDevices.KEYBOARD_MOUSE:
            return (master.get_global_mouse_position() - master.global_position).normalized()
        InputDeviceManager.InputDevices.CONTROLLER:             
            var look_dir: Vector2 = Input.get_vector(&"look_left", &"look_right", &"look_up", &"look_down")
            if look_dir == Vector2.ZERO:
                return get_move_dir()
            else:
                return look_dir
        _:
            Syslog.error('Current input device is not in InputDevices enum!')
            return Vector2.ZERO
