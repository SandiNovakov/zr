@icon("res://assets/node-icons/white/larger.png")
extends CharacterBody2D
class_name HitBox2D

signal collided(collision: KinematicCollision2D)

func _physics_process(delta: float) -> void:
    var collision: KinematicCollision2D = move_and_collide(Vector2.ZERO)
    
    if collision:
        collided.emit(collision)
