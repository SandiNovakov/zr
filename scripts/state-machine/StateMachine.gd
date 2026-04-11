extends Node
class_name StateMachine

@onready var master: Node = get_parent()
@export var default_state: State
var current_state: State
var initialized_states: Array[State] = []

var lock: bool = false # lock to prevent switching state before exit and enter have been done.

func _initialize_state(state: State) -> void:
    if state not in initialized_states:
        #Syslog.debug('Attempt to init state: %s' % [state.name])
        state.set_master(master)
        initialized_states.append(state)
        
func _ready() -> void:
    if not default_state:
        Syslog.error("%s's State Machine has no set default state!" % [master.name])

    current_state = default_state
    _initialize_state(current_state)
    current_state.enter()

func _process(delta: float) -> void:
    if current_state == null:
        Syslog.error("Node %s has no active state this process frame!" % [master.name])
    
    current_state.update(delta)

func _physics_process(delta: float) -> void:
    if current_state == null:
        Syslog.error("Node %s has no active state this physics tick!" % [master.name])
    
    current_state.physics_update(delta)
    
func request_state_change(new_state: State) -> void:
    if lock == true:
        Syslog.warning("Node %s tried to change from state %s to %s, but couldn't because of lock." % [
            master.name,
            current_state.name,
            new_state.name
        ])
        return
        
    lock = true
    
    if current_state == null:
        Syslog.error("Node %s has no active state on state change!" % [master.name])
    
    current_state.exit()
    
    if new_state not in get_children():
        Syslog.warning("State %s on Node %s requested change to State %s but such state not in StateMachine children!" % [
            current_state.name,
            master.name,
            new_state.name
            ])
    
    var old_state: State = current_state
    current_state = new_state
    
    if old_state.name == current_state.name:
        Syslog.warning("Node %s switched from state %s to %s. Possible race condition!" % [
            master.name,
            old_state.name,
            current_state.name
        ])
        
    #Syslog.debug("Node %s changed states from %s to %s." % [
        #master.name,
        #old_state.name,
        #current_state.name
    #])
    
    _initialize_state(current_state)
    current_state.enter()
    
    lock = false
