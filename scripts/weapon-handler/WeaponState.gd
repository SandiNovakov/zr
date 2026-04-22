extends State
class_name WeaponState

var master: WeaponHandler

func get_controller() -> ActorController:
    if master:
        return master.master.controller
    else:
        return null

func set_master(new_master: Node) -> void:
    if new_master is not WeaponHandler:
        Syslog.error("Invalid master type for State: %s, expected Actor2D!" % [self])
    master = new_master as WeaponHandler

func enter() -> void:
    pass
    
func update(delta: float) -> void:
    pass

func physics_update(delta: float) -> void:
    pass

func exit() -> void:
    pass
