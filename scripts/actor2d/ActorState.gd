extends State
class_name ActorState

var master: Actor2D
var controller: ActorController

func set_master(new_master: Node) -> void:
    if new_master is not Actor2D:
        Syslog.error("Invalid master type for State: %s, expected Actor2D!" % [self])
    master = new_master as Actor2D
    controller = master.controller

func enter() -> void:
    pass
    
func update(delta: float) -> void:
    pass

func physics_update(delta: float) -> void:
    pass

func exit() -> void:
    pass
