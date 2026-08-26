extends RigidBody2D
class_name Asteroid

@export var sprite: Sprite2D
@export var death_vfx: PackedScene

@export_category("Movement")
@export var min_speed: float = 0.0
@export var max_speed: float = 200.0
@export var min_angular_speed: float = 0.0
@export var max_angular_speed: float = 1.0

@export_category("Stats")
@export var max_health: int = 100
@export var score: int = 100

@onready var health: int = max_health

var is_dying: bool = false

const DESPAWN_PADDING: float = 256.0
const VIEWPORT_SIZE: Vector2 = Vector2(3840, 2160)

func _ready() -> void:
    add_to_group("lockable")

    var direction: Vector2 = Vector2.from_angle(randf_range(0, TAU))
    var speed: float = randf_range(min_speed, max_speed)
    linear_velocity = direction * speed

    var angular_direction: float = [-1.0, 1.0].pick_random()
    angular_velocity = angular_direction * randf_range(min_angular_speed, max_angular_speed)

    Syslog.debug("%s heading: %s, speed: %s, angular_velocity: %s" % [name, direction, speed, angular_velocity])

func _physics_process(delta: float) -> void:
    var out_of_bounds: bool = (
        global_position.x < -DESPAWN_PADDING
        or global_position.y < -DESPAWN_PADDING
        or global_position.x > VIEWPORT_SIZE.x + DESPAWN_PADDING
        or global_position.y > VIEWPORT_SIZE.y + DESPAWN_PADDING
    )

    if out_of_bounds:
        queue_free()

func take_damage(p_dmg: int, p_from_player: bool = false) -> void:
    if is_dying:
        return

    health = max(health - p_dmg, 0)

    sprite.modulate = Color.from_rgba8(255, 127, 127, 255)
    var tween: Tween = create_tween()
    tween.set_ease(Tween.EASE_OUT)
    tween.tween_property(sprite, "modulate", Color.WHITE, 0.08)

    if health <= 0:
        die(p_from_player)

func die(p_from_player: bool) -> void:
    is_dying = true

    if p_from_player:
        GlobalRef.get_main().update_score(score)

    if death_vfx:
        var vfx: Node2D = death_vfx.instantiate()
        vfx.global_position = global_position
        GlobalRef.get_main().add_child(vfx)

    queue_free()
