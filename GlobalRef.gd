extends Node

var player: Actor2D

func register_player(p_player: Actor2D):    
    if player:
        Syslog.error("%s tried to register as Player but player already registered: %s!" % [p_player.name, player.name])
        return
    
    if not p_player.is_player:
        Syslog.error("%s tried register as Player but didn't have is_player = true." % [p_player.name])
        return

    player = p_player
    Syslog.info("New player registered: %s." % [p_player.name])
    
func clear_player() -> void:
    player = null
    Syslog.info("Player cleared.")
