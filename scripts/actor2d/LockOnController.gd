extends Node
class_name LockOnController

var master: Actor2D
var radius: Area2D

@export var lock_on_group: StringName

func _ready() -> void:
    master = get_parent() as Actor2D
    if not master.lock_on_radius:
        Syslog.error("LockOnController assigned to node %s but %s has no assigned lock_on_radius." % [master.name, master.name])
    else:
        radius = master.lock_on_radius

func _process(delta: float) -> void:
    if not radius:
        return

    if not master.allow_lock_on:
        master.lock_on = null
        return

    if not master.lock_on:
        if master.controller.is_lock_on():
            _acquire_target()
    else:
        if master.lock_on not in radius.get_overlapping_bodies():
            _lose_target(master.lock_on)

        if master.controller.is_lock_on():
            lock_off()

func _acquire_target(p_exclude: Node2D = null) -> void:
    var targets: Array[Node2D] = radius.get_overlapping_bodies()
    var closest: Node2D = null
    var closest_dist: float = INF

    if master.is_player:
        var reticle: Node2D = GlobalRef._get_ref("reticle") #TODO: replace this!
        var reticle_pos: Vector2 = reticle.get_global_transform_with_canvas().origin

        for target: Node2D in targets:
            if target == p_exclude:
                continue

            if not target.is_in_group(lock_on_group):
                continue

            var target_screen_pos: Vector2 = target.get_global_transform_with_canvas().origin

            # Off-screen targets are excluded even if close to the reticle in screen space.
            if not get_viewport().get_visible_rect().has_point(target_screen_pos):
                continue

            var dist := reticle_pos.distance_squared_to(target_screen_pos)

            if dist < closest_dist:
                closest = target
                closest_dist = dist
    else:
        for target: Node2D in targets:
            if target == p_exclude:
                continue

            if not target.is_in_group(lock_on_group):
                continue

            var dist := master.global_position.distance_squared_to(target.global_position)

            if dist < closest_dist:
                closest = target
                closest_dist = dist

    if closest:
        master.lock_on = closest
        master.locked_on.emit()

        closest.tree_exiting.connect(func() -> void:
            _on_target_exiting(closest), CONNECT_ONE_SHOT)

func _on_target_exiting(p_target: Node2D) -> void:
    if master.lock_on == p_target:
        _lose_target(p_target)

## Target died or left the lock-on radius: clear lock-on and immediately try to acquire a
## replacement, explicitly excluding the lost target in case it's still momentarily
## reporting as overlapping (its physics body may not be unregistered yet at this point).
func _lose_target(p_exclude: Node2D = null) -> void:
    lock_off()
    _acquire_target(p_exclude)

func lock_off() -> void:
    master.lock_on = null
    master.locked_off.emit()
