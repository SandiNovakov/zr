extends ActorController

@export var shoot: bool = false
@export_enum("Never", "Lock-on", "Always") var turn_toward_player: String = "Never"
@export var shoot_rate: int = 1

var last_shot_timestamp: int = 0
var last_shot_timestamps: Dictionary = {}

var default_heading: Vector2 = Vector2.ZERO

func is_shoot_once(shoot_action: StringName) -> bool:
    return _handle_shoot_logic(shoot_action)

func is_shoot(shoot_action: StringName) -> bool:
    return _handle_shoot_logic(shoot_action)

func _handle_shoot_logic(shoot_action: StringName) -> bool:
    if not shoot:
        return false
    
    if turn_toward_player == "Lock-on" and not master.lock_on:
        return false
    
    var current_time = Time.get_ticks_msec()
    # Get the last time this specific action fired, default to 0 if never fired
    var last_time = last_shot_timestamps.get(shoot_action, 0)
    
    if last_time == 0 or current_time - last_time >= Util.to_msec(1) / shoot_rate:
        last_shot_timestamps[shoot_action] = current_time
        return true
    
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
    match turn_toward_player:
        "Never":
            return Vector2.ZERO
        "Lock-on":
            if master.lock_on:
                return (master.lock_on.global_position - master.global_position).normalized()
            
            if default_heading == Vector2.ZERO:
                default_heading = Vector2.from_angle(master.rotation)   
            
            return default_heading
        "Always":
            var player: Actor2D = GlobalRef.get_player()
    
            if player == null:
               return Vector2.ZERO

            return (player.global_position - master.global_position).normalized() 
        _:
            return Vector2.ZERO
        
func is_lock_on() -> bool:
    if not master.lock_on and master.lock_on_radius and master.lock_on_radius.get_overlapping_bodies().size() > 0:
        return true
    return false
        
