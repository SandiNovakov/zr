@icon("res://assets/node-icons/plenticons/arrow-blue.png")
extends CharacterBody2D
class_name Bullet

var damage: int
var speed: int
var direction: Vector2

var lifetime: float = 10

@export var collide_vfx: PackedScene
@onready var main: Node = GlobalRef.get_main()

func die() -> void:        
    set_collision_layer(0)
    set_collision_mask(0)
    
    speed = 0
    
    var t: Tween = create_tween()
    var t2: Tween = create_tween()

    t.tween_property(self, "scale", Vector2.ZERO, 0.3)

    t2.tween_property(self, "modulate:a", 0.0, 0.3) 

    t.tween_callback(queue_free)

func _ready() -> void:
    direction = direction.normalized()
    rotation = direction.angle()

func _physics_process(delta: float) -> void:
    lifetime -= delta
    if lifetime <= 0:
        die()
        return

    var motion: Vector2 = direction * speed * delta
    var collision: KinematicCollision2D = move_and_collide(motion)

    if collision:
        var normal: Vector2 = collision.get_normal()
        
       # Syslog.debug(collision.get_collider())
        
        if collision.get_collider() is Actor2D:
            var collider: Actor2D = collision.get_collider() as Actor2D
            collider.take_damage(damage)
        
        if collide_vfx:
            var c: Node2D = collide_vfx.instantiate()
            c.global_position = collision.get_position()
            c.global_rotation = normal.angle()
            main.add_child(c)
 
        die()
