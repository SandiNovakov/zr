extends CharacterBody2D
class_name Actor2D

@export var controller: ActorController
@export var state_machine: StateMachine
@export var weapon_handler: WeaponHandler

var speed: int = 750
var acceleration: int = speed/6
var dash_duration: float = 0.3
var turn_speed := 2 * PI / 0.3 #roughly 300ms to make full circle

func move(move_dir: Vector2) -> void:
    if move_dir.length() > 1 + 0.000001:
        Syslog.warning(
            "Origin: %s, move_dir is not normalized! Length: %s, (x,y): (%s)" % [
                self.name,
                move_dir.length(),
                move_dir
            ])
            
        move_dir = move_dir.normalized()
        
    velocity = velocity.move_toward(move_dir * speed, acceleration) 
    move_and_slide()

func turn(look_dir: Vector2, delta: float) -> void:
    if look_dir != Vector2.ZERO:
        rotation = Util.get_rotation_linear(rotation, look_dir.angle(), turn_speed, delta)

func enable_weapons():
    weapon_handler.enabled.emit()

func disable_weapons():
    weapon_handler.disabled.emit()
