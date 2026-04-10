extends Node
class_name WeaponHandler

@onready var master: Actor2D = get_parent()
@export var controller: ActorController
@export var shoot_action: StringName

@export var weapon: WeaponData
@export var shot_origin: Marker2D

## Only used for player characters    
var time_until_charging: float = 0.3
var last_shot_timestamp: int = 0

var allow_shoot: bool = true
var allow_charge: bool = true
signal invalidate_charge

signal charged_shot

func _ready() -> void:
    if weapon.fire_rate == 0:
        Syslog.warning("Fire rate for weapon: %s on Actor %s is 0!" % ["[replace with resource name]", master.name])
    if weapon.automatic and weapon.can_charge:
        Syslog.warning("%s's Weapon %s is both automatic and chargeable. Automatic will take precedence and charging will be disabled." % [master.name, self.name])

func can_shoot() -> bool:  
    if not allow_shoot:
        return false
    
    var shot_delay: float = 1.0 / max(weapon.fire_rate, 1) #in seconds. max for divide by zero safety
    @warning_ignore("narrowing_conversion")
    var shot_delay_usec: int = Util.to_usec(shot_delay)
    
    if Time.get_ticks_usec() - last_shot_timestamp >= shot_delay_usec:
        return true

    return false
    
func shoot() -> void:
    
    last_shot_timestamp = Time.get_ticks_usec()
    
    #Input.start_joy_vibration(0, 1, 0, 0.1)
    RumbleController.add(0.5, 0, 0.1)
    
    var bullet: Bullet = weapon.bullet.instantiate()
    _spawn_bullet(bullet)
    
func shoot_charged() -> void:
    charged_shot.emit()
    var bullet: Bullet = weapon.charge_bullet.instantiate()
    _spawn_bullet(bullet)

func _spawn_bullet(bullet: Bullet) -> void:
    bullet.global_position = shot_origin.global_position
    bullet.direction = Vector2.from_angle(shot_origin.global_rotation)
    bullet.speed = weapon.bullet_speed
    bullet.damage = weapon.damage
    
    get_node("/root/Main").add_child(bullet)
    #bullet.set_as_top_level(true)
    
    var vfx: Node2D = weapon.bullet_vfx.instantiate()
    vfx.z_index = 1
    add_vfx(vfx)

## Same as start_vfx but better communicates that this for vfx which free themselves.
func add_vfx(vfx: Node2D) -> void:
    shot_origin.add_child(vfx)

func start_vfx(vfx: Node2D) -> void:
    shot_origin.add_child(vfx)

func stop_vfx(vfx: Node2D) -> void:
    if vfx is GPUParticles2D or vfx is CPUParticles2D:
        vfx.emitting = false
        await vfx.finished
        vfx.queue_free()
    else:
        vfx.queue_free()
