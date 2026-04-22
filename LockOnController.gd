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
            Syslog.debug("Attempting to lock on...")
            if master.is_player:
                var reticle: Node2D = GlobalRef._get_ref("reticle") #TODO: replace this!
                
                var targets: Array[Node2D] = radius.get_overlapping_bodies()

                Syslog.debug(targets)

                var reticle_pos: Vector2 = reticle.get_global_transform_with_canvas().origin

                var closest: Node2D = null
                var closest_dist: float = INF

                for target: Node2D in targets:
                    if not target.is_in_group(lock_on_group):
                        continue

                    var dist := reticle_pos.distance_squared_to(target.get_global_transform_with_canvas().origin)

                    if dist < closest_dist:
                        closest = target
                        closest_dist = dist

                if closest:
                    Syslog.debug("Target found: %s" % [closest.name])
                    master.lock_on = closest
                    master.locked_on.emit()
                else:
                    Syslog.debug("No targets found.")
            else:
                var targets: Array[Node2D] = radius.get_overlapping_bodies()
                Syslog.debug(targets)
                var closest: Node2D = null
                var closest_dist: float = INF

                for target: Node2D in targets:
                    if not target.is_in_group(lock_on_group):
                        continue

                    var dist := master.global_position.distance_squared_to(target.global_position)

                    if dist < closest_dist:
                        closest = target
                        closest_dist = dist

                if closest:
                    Syslog.debug("Target found: %s" % [closest.name])
                    master.lock_on = closest
                    master.locked_on.emit()
    else:
        if master.lock_on not in radius.get_overlapping_bodies():
            lock_off()
        
        if master.controller.is_lock_on():
            lock_off()

func lock_off():
    Syslog.debug("Lock on cleared.")
    master.lock_on = null        
    master.locked_off.emit()  
