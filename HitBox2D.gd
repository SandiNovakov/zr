@icon("res://assets/node-icons/blue/larger.png")
extends CharacterBody2D
class_name HitBox2D

signal collided(collision: KinematicCollision2D)
signal collisions_changed(preset: CollisionLibrary.Preset)

func _physics_process(delta: float) -> void:
    var collision: KinematicCollision2D = move_and_collide(Vector2.ZERO)
    
    if collision:
        collided.emit(collision)

func set_collisions(preset: CollisionLibrary.Preset) -> void:
    CollisionLibrary.set_collisions(self, preset)
    collisions_changed.emit(preset)
