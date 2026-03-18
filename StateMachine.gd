extends Node
class_name StateMachine

@onready var master: Node = get_parent()
@export var default_state: State
var current_state: State
var initialized_states: Array[State] = []

#var states: Array[State]
#func _ready() -> void:
    #var children: Array[Node] = get_children()
    #for child: Node in children:
        #if child.is_class('State'):
            #states.append(child)
    #if states.is_empty():
        #Syslog.error("StateMachine in node %s has no State children!" % [master.name])

func _initialize_state(state: State) -> void:
    if state not in initialized_states:
        state.set_master(master)
        initialized_states.append(state)
        
    state.enter()

func _ready() -> void:
    current_state = default_state
    _initialize_state(current_state)

func _process(delta: float) -> void:
    if current_state == null:
        Syslog.error("Node %s has no active state this process frame!" % [master.name])
    
    current_state.update(delta)

func _physics_process(delta: float) -> void:
    if current_state == null:
        Syslog.error("Node %s has no active state this physics tick!" % [master.name])
    
    current_state.physics_update(delta)
    
func request_state_change(new_state: State) -> void:
    if current_state == null:
        Syslog.error("Node %s has no active state on state change!" % [master.name])
    
    await current_state.exit()
    
    if new_state not in get_children():
        Syslog.warning("State %s on Node %s requested change to State %s but such state not in StateMachine children!" % [
            current_state.name,
            master.name,
            new_state.name
            ])
    
    current_state = new_state
    Syslog.debug("Node %s changed states from %s to %s." % [
        master.name,
        current_state.name,
        new_state.name
    ])
    
    _initialize_state(current_state)
    current_state.enter()
