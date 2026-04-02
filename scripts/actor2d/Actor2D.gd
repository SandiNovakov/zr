extends CharacterBody2D
class_name Actor2D

@export var controller: ActorController
@export var state_machine: StateMachine
@export var weapon_handler: WeaponHandler

@export var speed: int = 750
@export var acceleration: int = speed/6
@export var dash_duration: float = 0.3
@export var boost_speed: int = 1500

@export var boost_charge_time: float = 0.5

var turn_speed: float = 2 * PI / 0.3 #300ms to make full circle
var boost_turn_speed: float = 2 * PI / 0.1 #half as fast as turn_speed.

func move(move_dir: Vector2, p_speed: int = speed) -> void:
    if move_dir.length() > 1 + 0.000001:
        Syslog.warning(
            "Origin: %s, move_dir is not normalized! Length: %s, (x,y): (%s)" % [
                self.name,
                move_dir.length(),
                move_dir
            ])
            
        move_dir = move_dir.normalized()
        
    velocity = velocity.move_toward(move_dir * p_speed, acceleration) 
    move_and_slide()

func turn(look_dir: Vector2, p_turn_speed: int, delta: float) -> void:
    if look_dir != Vector2.ZERO:
        rotation = Util.get_rotation_linear(rotation, look_dir.angle(), p_turn_speed, delta)
        
func enable_shooting() -> void:
    Syslog.debug("%s enabled shooting!" % [self.name])
    weapon_handler.allow_shoot = true

func disable_shooting() -> void:
    Syslog.debug("%s disabled shooting!" % [self.name])
    weapon_handler.allow_shoot = false

func invalidate_charges() -> void:
    Syslog.debug("%s invalidated all charges!" % [self.name])
    weapon_handler.invalidate_charge.emit()
