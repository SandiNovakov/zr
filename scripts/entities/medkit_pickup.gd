extends Area2D

@export var heal_amount: int = 25
@export var death_vfx: PackedScene

@export var tint_color: Color = Color.GREEN
@export var tint_speed: float = 1.0

func _ready() -> void:
    body_entered.connect(_on_body_entered)

    var tween: Tween = create_tween()
    tween.set_trans(Tween.TRANS_EXPO)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.set_loops()
    tween.tween_property(self, "modulate", tint_color, tint_speed)
    tween.tween_property(self, "modulate", Color.AQUAMARINE, tint_speed)

func _on_body_entered(body: Node2D) -> void:
    var player: Actor2D = body as Actor2D

    if not player:
        return

    player.health = min(player.health + heal_amount, player.max_health)

    Syslog.debug("Picked up medkit: healed %s for %s HP (now %s/%s)." % [player.name, heal_amount, player.health, player.max_health])

    if death_vfx:
        var vfx: Node2D = death_vfx.instantiate()
        vfx.global_position = global_position
        GlobalRef.get_main().add_child(vfx)

    queue_free()
