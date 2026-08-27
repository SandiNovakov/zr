extends Node
class_name WeaponHandler

@onready var master: Actor2D = get_parent()
@export var shoot_action: StringName

@export var weapon: WeaponData
@export var shot_origin: Marker2D
@export var controller: ActorController

## Only used for player characters
var time_until_charging: float = 0.3
var last_shot_timestamp: int = 0

var allow_shoot: bool = true
var allow_charge: bool = true
signal invalidate_charge

signal charged_shot

func _process(delta: float) -> void:
    if master.lock_on:
        lock_on_origins()

func _ready() -> void:
    if weapon.fire_rate == 0:
        Syslog.warning("Fire rate for weapon: %s on Actor %s is 0!" % ["[replace with resource name]", master.name])
    if weapon.automatic and weapon.can_charge:
        Syslog.warning("%s's Weapon %s is both automatic and chargeable. Automatic will take precedence and charging will be disabled." % [master.name, self.name])

    master.locked_off.connect(_on_locked_off)

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

    var bullet: Bullet = weapon.bullet.instantiate()
    _spawn_bullet(bullet, weapon.damage)

func shoot_charged() -> void:
    Syslog.debug("shot CHARGED!")
    charged_shot.emit()
    var bullet: Bullet = weapon.charge_bullet.instantiate()
    _spawn_bullet(bullet, weapon.charge_damage)

func _spawn_bullet(bullet: Bullet, p_damage: int) -> void:
    bullet.global_position = shot_origin.global_position
    bullet.direction = Vector2.from_angle(shot_origin.global_rotation)
    bullet.speed = weapon.bullet_speed
    bullet.damage = p_damage
    
    bullet.collision_layer = 0
    bullet.collision_mask = 0
    
    if master.is_enemy:
        bullet.set_collision_layer_value(5, true)
        bullet.set_collision_mask_value(1, true)
        bullet.set_collision_mask_value(2, true)
        bullet.set_collision_mask_value(7, true)
    else:
        bullet.set_collision_layer_value(3, true)
        bullet.set_collision_mask_value(1, true)
        bullet.set_collision_mask_value(4, true)
        bullet.set_collision_mask_value(7, true)
    
    GlobalRef.get_main().add_child(bullet)
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

func lock_on_origins() -> void:
    if master.is_on_target():
        shot_origin.look_at(master.lock_on.global_position)
    else:
        shot_origin.rotation = 0

func _on_locked_off() -> void:
    shot_origin.rotation = 0
