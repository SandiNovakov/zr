extends CharacterBody2D
class_name Bullet

var damage: int
var speed: int
var direction: Vector2

var lifetime: float = 10

@export var collide_vfx: PackedScene

@onready var main := get_node("/root/Main")

func _ready() -> void:
    direction = direction.normalized()
    rotation = direction.angle()

func _physics_process(delta: float) -> void:
    lifetime -= delta
    if lifetime <= 0:
        queue_free()
        return

    var motion := direction * speed * delta
    var collision := move_and_collide(motion)

    if collision:
        var r: Vector2 = direction.bounce(collision.get_normal())

        if collide_vfx:
            var c: Node2D = collide_vfx.instantiate()
            c.global_position = collision.get_position()
            c.global_rotation = r.angle()
            main.add_child(c)
 
        queue_free()
