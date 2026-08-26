extends StaticBody2D
class_name ItemContainer

@export var sprite: Sprite2D
@export var death_vfx: PackedScene
@export var drop_scene: PackedScene

@export_category("Stats")
@export var max_health: int = 50

@onready var health: int = max_health

var is_dying: bool = false

func _ready() -> void:
    add_to_group("lockable")

func take_damage(p_dmg: int) -> void:
    if is_dying:
        return

    health = max(health - p_dmg, 0)

    sprite.modulate = Color.from_rgba8(255, 127, 127, 255)
    var tween: Tween = create_tween()
    tween.set_ease(Tween.EASE_OUT)
    tween.tween_property(sprite, "modulate", Color.WHITE, 0.08)

    if health <= 0:
        die()

func die() -> void:
    is_dying = true

    if death_vfx:
        var vfx: Node2D = death_vfx.instantiate()
        vfx.global_position = global_position
        GlobalRef.get_main().add_child(vfx)

    if drop_scene:
        var drop: Node2D = drop_scene.instantiate()
        var target_scale: Vector2 = drop.scale
        drop.global_position = global_position
        drop.scale = Vector2.ZERO
        GlobalRef.get_main().add_child(drop)

        var drop_tween: Tween = drop.create_tween()
        drop_tween.set_trans(Tween.TRANS_BOUNCE)
        drop_tween.set_ease(Tween.EASE_OUT)
        drop_tween.tween_property(drop, "scale", target_scale, 0.3)

    queue_free()
