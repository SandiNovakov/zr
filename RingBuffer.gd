extends Node

var cheat_code: Array[String] = ["F7", "V", "A", "R", "I", "A", "B", "L", "E", "E", "Y", "E", "S"]
var castle_array: Array[String]  = ["C", "A", "S", "T", "L", "E", "I", "N", "T", "H", "E", "S", "K", "Y"]
var buddha_array: Array[String]  = ["B", "U", "D", "D", "H", "A"]
var caffeine_array: Array[String]  = ["U", "L", "T", "R", "A", "C", "A", "F", "F", "E", "I", "N", "E"]
var admin_array: Array[String]  = ["G", "I", "V", "E", "M", "E", "A", "D", "M", "I", "N"]
var ghost_array: Array[String]  = ["G", "H", "O", "S", "T", "Y", "G", "H", "O", "S", "T"]

var joypresses: Array #implement later

var keypresses: Array[String] = []

var timelimit: float = 5.0
var time_elapsed: float = 0.0

const MAX_LEN: int = 16

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo:
        time_elapsed = 0
        
        var key: String = OS.get_keycode_string(event.physical_keycode)

        keypresses.push_back(key)
        if keypresses.size() > MAX_LEN:
            keypresses.pop_front()
            
func _process(delta: float) -> void:
    time_elapsed += delta
    if time_elapsed >= timelimit:
        keypresses.clear()
        
func check_sequence(sequence: Array[String]) -> bool:
    var seq_length: int = sequence.size()
    
    if seq_length > keypresses.size():
        return false

    var slice: Array[String] = keypresses.slice(keypresses.size() - seq_length, keypresses.size())
    return slice == sequence
        
        
