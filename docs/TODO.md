# New
- [x] Add asteroids the player can shoot for extra score.
- [ ] Add capsules containing health packs.
- [ ] Add a generic spawner for the three spawnable object types (enemies, asteroids, health capsules).
- [ ] Give enemies actual movement (currently stationary — only rotate to face/track and shoot).
- [ ] Add a manager for enemies/entities to track on-screen count, etc.
- [ ] Show the player's score after death.
- [ ] Add a highscore comparison screen after player death.

# Normal
## Core architecture / refactors
- [ ] Introduce a bind-variable system for states and state machine
  - See: StateMachine Bind Variable Spec
- [ ] Change order of arguments to `turn` so that `p_turn_speed` is optional.
- [ ] Implement dedicated hitboxes instead of relying on body-to-body collision for damage.

## Gameplay systems
- [ ] Add stagger state to Actor2D
- [ ] Implement a proper AI controller: a list of possible actions per state, randomly selected after random intervals. Current `dummy_controller` only turns toward the player and shoots on a timer.
- [ ] Add more unique weapon and bullet types.
