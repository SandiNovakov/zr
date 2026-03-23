# WeaponData.gd
extends Resource
class_name WeaponData

@export_category("Weapon")
@export var bullet: PackedScene
@export var charge_bullet: PackedScene
@export var fire_rate: int # shots/sec
@export var damage: int
@export var automatic: bool

@export_subgroup("Charging")
@export var can_charge: bool
@export_range(0, 10, 0.1) var charge_time: float
@export var charge_damage: int
@export_range(0, 10, 0.1)var charge_recovery_time: float
@export var charged_shot_recoil: int

@export var charging_vfx: PackedScene
@export var charged_vfx: PackedScene
