extends Area2D
class_name Bullet

var damage: int
var speed: int
var direction: Vector2

var lifetime: float = 10

func _ready() -> void:
    if damage == null:
        Syslog.warning("Origin: %s, damage isn't initialized." % [self])
    if speed == null:
        Syslog.warning("Origin: %s, speed isn't initialized." % [self])
    if direction == null:
        Syslog.warning("Origin: %s, direction isn't initialized." % [self])
    
    rotation = direction.angle()
    body_entered.connect(on_body_entered)

func _physics_process(delta: float) -> void:
    position += direction * speed * delta

    lifetime -= delta
    if lifetime <= 0:
        Syslog.debug("bullet %s lifetime expired." % [self])
        queue_free()

func on_body_entered(body: Node2D) -> void:
    Syslog.debug("bullet %s collided with body: %s" % [self, body.name])
    queue_free()
