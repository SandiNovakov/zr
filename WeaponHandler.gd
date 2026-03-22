extends Node
class_name WeaponHandler

@onready var master: Actor2D = get_parent()
@export var controller: ActorController

@export_category("Handler")
@export var weapon: Resource #not yet implemented
@export var shot_origin: Marker2D

@export_category("Weapon")
@export var bullet: Node2D
@export var charge_bullet: Node2D
@export var fire_rate: int #shots/sec
@export var damage: int
@export var automatic: bool #otherwise semi-auto

@export_subgroup("Charging")
@export var can_charge: bool
@export_range(0, 10, 0.1) var charge_time: float
@export var charge_damage: int
@export_range(0, 10, 0.1) var charge_recovery_time: float
@export var charged_shot_recoil: int
    
var time_until_charging: float = 0.1
var last_shot_timestamp: int = 0

signal disabled
signal enabled

signal charged_shot

func _ready() -> void:
    if fire_rate == 0:
        Syslog.warning("Fire rate for weapon: %s on Actor %s is 0!" % ["[replace with resource name]", master.name])

func _can_shoot() -> bool:  
    var shot_delay: float = 1.0 / max(fire_rate, 1) #in seconds. max for divide by zero safety
    var shot_delay_usec: int = Util.to_usec(shot_delay)
    
    if Time.get_ticks_usec() - last_shot_timestamp >= shot_delay_usec:
        return true

    return false
    
func shoot() -> void:
    if not _can_shoot():
        return
    
    last_shot_timestamp = Time.get_ticks_usec()
    Syslog.info("%s says: I shot my weapon!" % [master.name])
    
func shoot_charged() -> void:
    Syslog.info("%s says: I performed a charged shot!" % [master.name])
    charged_shot.emit()
