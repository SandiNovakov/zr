extends CharacterBody2D
class_name Actor2D

@export_category("Alignment")
@export var is_player: bool = false
@export var is_enemy: bool = false

@export_category("References")
@export var controller: ActorController
@export var state_machine: StateMachine
@export var weapon_handlers: Array[WeaponHandler]
@export var lock_on_radius: Area2D
@export var lock_on_ray: RayCast2D

@export_category("stats")
@export var max_health: int = 7500
@export var speed: int = 750

@export_group("Dash")
@export var dash_speed: int = 2500
@export var dash_duration: float = 0.3

@export_group("Boost")
@export var boost_speed: int = 1500
@export var boost_charge_time: float = 0.5
@export var boost_recovery_time: float = 0.5
@export var boost_charge_vfx: PackedScene
@export var boost_charge_vfx_anchor: Node2D

@onready var health: int = max_health
@onready var acceleration: int = speed / 0.1
var turn_speed: float = 2 * PI / 0.3 #300ms to make full circle
var boost_turn_speed: float = 2 * PI / 1 #half as fast as turn_speed.

var allow_shoot: bool = true
var charged_shot_recovery_time: float = 0.3
var invincible: bool = false

var lock_on: Node2D
var allow_lock_on: bool = true

signal charged_shot(handler: WeaponHandler)
signal boost_charge_started
signal boost_charge_ended
signal locked_on
signal locked_off

func _ready() -> void:
    if is_player:
        add_to_group("player")
        Syslog.info("Player spawned.")
        GlobalRef.register_ref(&"player", self)
    
    if is_enemy:
        add_to_group("enemies")
    
    for handler: WeaponHandler in weapon_handlers:
        handler.charged_shot.connect(func () -> void: charged_shot.emit(handler))   

func _physics_process(delta: float) -> void:
    move_and_slide()

func move(move_dir: Vector2, delta: float, p_speed: int = speed, accelerate: bool = true) -> void:
    if move_dir.length() > 1 + 0.000001:
        Syslog.warning(
            "Origin: %s, move_dir is not normalized! Length: %s, (x,y): (%s)" % [
                self.name,
                move_dir.length(),
                move_dir
            ])
            
        move_dir = move_dir.normalized()

    if accelerate:        
        velocity = velocity.move_toward(move_dir * p_speed, acceleration*delta)
    else:
        velocity = move_dir * p_speed

func turn(look_dir: Vector2, p_turn_speed: int, delta: float) -> void:
    if look_dir != Vector2.ZERO:
        rotation = Util.get_rotation_linear(rotation, look_dir.angle(), p_turn_speed, delta)
        
func enable_shooting() -> void:
    #Syslog.debug("%s enabled shooting!" % [self.name])
    for handler: WeaponHandler in weapon_handlers:
        handler.allow_shoot = true

func disable_shooting() -> void:
    #Syslog.debug("%s disabled shooting!" % [self.name])
    for handler: WeaponHandler in weapon_handlers:
        handler.allow_shoot = false

func enable_charging() -> void:
    for handler: WeaponHandler in weapon_handlers:
        handler.allow_charge = true

func disable_charging() -> void:
    for handler: WeaponHandler in weapon_handlers:
        handler.allow_charge = false

func invalidate_charges() -> void:
    #Syslog.debug("%s invalidated all charges!" % [self.name])
    for handler: WeaponHandler in weapon_handlers:
        handler.invalidate_charge.emit()

func take_damage(dmg: int) -> void:
    if not invincible:
        health = max(health - dmg, 0)
        Syslog.debug("%s took %s damage. HP: %000d/%000d" % [self.name, dmg, health, max_health])
    
func is_on_target() -> bool:
    if lock_on and lock_on_ray and lock_on_ray.is_colliding():
        if lock_on_ray.get_collider() == lock_on:
            return true
    return false
