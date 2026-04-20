extends ActorController

func is_shoot_once(shoot_action: StringName) -> bool:
    return false

func is_shoot(shoot_action: StringName) -> bool:
    return false

func is_dash() -> bool:
    return false


func is_boost() -> bool:
    return false
    
func get_action_buffered(action: StringName) -> bool:
    Syslog.warning('Used deprecated function ActorController.get_action_buffered()! See code for more details.')
    #ActorController will eventually be replaced with a generic version of the controller that will allow us to
    #give instructionsssssad based on ai, not just player input, so any functions to do with input will have to be done away with for now.
    
    return false

func get_boost_dir() -> Vector2:
    return Vector2.ZERO

func get_move_dir() -> Vector2:
    return Vector2.ZERO

func get_look_dir() -> Vector2:
    return Vector2.ZERO
