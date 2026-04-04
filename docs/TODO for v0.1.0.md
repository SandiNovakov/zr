## <span style="color:red;">Important</span>
- [x] Fix bug with weapon charging.
  - Current behavior: When charging and dashing, time spent charging while dashing isn't counted.
  - Expected behavior: Charge time should count whether dashing or idling.
  - Possible fix: master.can_shoot() check in idle state returns prematurely. Fix this.
## Core architecture / refactors

- [ ] Introduce a bind-variable system for states and state machine  
  - See: StateMachine Bind Variable Spec

- [ ] Improve scene-to-scene referencing  
  - Introduce GlobalRef autoload  
  - Holds stable references: Main, Player, WorldEnvironment, etc.

- [ ] Split debug UI into dedicated structure  
  - Possible: create a dedicated scene for all debug UI layers  

- [ ] Create project-wide code style guide

- [ ] Organize project directories


## Debug console overhaul

- [ ] Refactor DebugConsoleGui to be input-transparent  
  - Must not mutate or interpret input  
  - Only forward raw input to DebugConsole

- [ ] Separate callable registry from DebugConsole  
  - Move callable definitions into a dedicated script/module

- [ ] Support callable argument introspection  
  - Automatically determine expected argument count

- [ ] Add strict argument validation for command execution  
  - Reject calls where provided arg count ≠ expected arg count

- [ ] Add structured argument binding system  
  - Programmatic mapping of inputs → typed arguments

- [ ] Add flexible boolean parsing for arguments  
  - Accept: on/off, true/false, 1/0


## Settings / display system

- [ ] Add common resolution scaling presets

- [ ] Centralize display settings logic  
  - Replace fragmented display calls across codebase  
  - Debug console and settings menu must use the same API

- [ ] Implement persistent user settings storage  
  - Stored in user directory  
  - Initially writable only via console

- [ ] Implement centralized API for controller vibration strength values  
  - Refactor all calls to RumbleController to use values from there instead

- [ ] Add rumble strength setting for users to reduce or increase rumble strength


## Gameplay systems

- [ ] Implement aim reticle in gameplay

- [ ] Implement lock-on mechanic

- [ ] Add stagger state to Actor2D

- [ ] Fix Boost state input handling (currently broken)

- [ ] Implement BoostRecover state

- [ ] Create new VFX for Actor2D actions

- [ ] Implement enemies  
  - Could reuse Actor2D with AI controller restrictions (no Boost/Dash usage)

- [ ] Implement simple AI controller  
  - Has list of possible actions per state  
  - Randomly selects actions after random intervals

- [ ] Refactor ActorController into abstract base class  
  - Separate PlayerController and AIController

- [ ] Implement damage system  
  - Player HP, enemy HP, bullet damage calculation

- [ ] Implement death logic  
  - Death state, VFX, queue_free handling

- [ ] Implement enemy spawner  
  - Spawns enemies at random or fixed intervals

- [ ] Implement score system  
  - Hook into enemy death signal and assign points to player

- [ ] Add ammo system  
  - Enemy weapons use infinite ammo

- [ ] Add more unique weapon and bullet types


## Input / cheats / controller systems

- [ ] Add cheat code system  
  - See Cheat Codes Spec

- [ ] Add controller support for cheat codes


## Code quality / consistency

- [ ] Enforce explicit type declarations everywhere  
  - Fix all inferred type definitions to adhere to project spec

- [ ] Remove redundant or unnecessary Syslog.debug() calls  
  - Free space for meaningful debug output


## UI / UX

- [ ] Create proper UI theme  
  - Debug UI theme as baseline

- [ ] Implement basic UI showing all player-important stats