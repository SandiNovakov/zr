extends ActorState

var vfx: Node2D

func enter() -> void:
    master.disable_shooting()
    master.invalidate_charges()
    master.disable_charging()
    
    master.is_dying = true;

    vfx = load("res://scenes/vfx/bullet/explosion.tscn").instantiate()
    vfx.global_position = master.global_position
    GlobalRef.get_main().add_child(vfx)    

func update(delta: float) -> void:
    pass

func exit() -> void:
    pass
