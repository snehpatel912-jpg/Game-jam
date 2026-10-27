# DON'T LOOK BACK (Godot 4.6)

A 2D top-down horror game. You're trapped in an abandoned school at night: find three keys, avoid the monster and escape.

## Day 1: programmer tasks ✅

- [x] Create the Godot project and main scene
- [x] Player movement: WASD or arrow keys, Shift to sprint, smooth start and stop
- [x] Wall collisions: walls, desks and lockers block the player, who slides along them
- [x] Runs without errors (tested in Godot 4.6.1)

Extra setup to help the rest of the team:

- A test school map (`level_01.tscn`) to walk around in
- A tileset that already has collisions, so the level maker can start painting straight away
- A camera that follows the player and stops at the edge of the map
- Controls and collision layers already set up for Day 2 (keys and exit) and Day 3 (monster)

## Open and run it

1. Open **Godot 4.6** (any Godot 4.x should work; Godot 3 can't open it).
2. Click **Import**, choose `project.godot` from this folder, then **Import & Edit**.
3. Press **F5**, or the ▶ button at the top right, to play.

## What's where

| Path | What it is |
|---|---|
| `project.godot` | Project settings: window size, controls, collision layer names |
| `scenes/main.tscn` | The scene that runs when you press Play: level, player and HUD |
| `scenes/player.tscn` | The player: body, sprite, collision circle and camera |
| `scenes/levels/level_01.tscn` | Test school map with the spawn point, key spots and exit spot |
| `scripts/player.gd` | Player movement code |
| `scripts/main.gd` | Puts the player at the spawn point and fits the camera to the map |
| `resources/school_tileset.tres` | The tileset. Wall, desk and locker tiles have collision |
| `assets/sprites/` | Character art (`player.svg` is a placeholder) |
| `assets/tiles/` | Tile art (`school_tiles.svg` is a placeholder) |
| `assets/audio/`, `assets/ui/` | Empty for now: sound effects, music and menu art go here |

The `.uid` and `.import` files next to other files are made by Godot. Keep them, and share them with the project.

## Controls

These live in **Project → Project Settings → Input Map**. Code always uses the action name, never the key itself.

| Action | Keys | Used for |
|---|---|---|
| `move_up` / `move_down` / `move_left` / `move_right` | W A S D, arrow keys | Moving |
| `sprint` | Shift | Running faster |
| `interact` | E | Reserved for Day 2 (opening the exit door) |

## Collision layers

These are named in **Project Settings → Layer Names → 2D Physics**.

| Layer | Name | What's on it |
|---|---|---|
| 1 | world | Walls, desks, lockers (from the tileset) |
| 2 | player | The player |
| 3 | monster | Day 3 |
| 4 | pickups | Keys (Day 2) |
| 5 | interactables | Exit door (Day 2) |

## For the rest of the team

### Designer

- **Player sprite:** draw the player seen from above, **facing right**, about 24×24 px. The code turns the sprite to face the way the player walks. Put the image in `assets/sprites/`, open `scenes/player.tscn`, click `BodySprite`, then drag your image into **Texture**.
- **Tiles:** `assets/tiles/school_tiles.svg` is 5 tiles of 32×32 px in one row: classroom floor, hallway floor, wall, desk, locker. Make a PNG with the same layout. Then open `resources/school_tileset.tres`, select the atlas and drag your PNG into **Texture**. The collisions stay the same.
- Pixel art stays sharp because texture filtering is set to Nearest.

### Level maker

- Open `scenes/levels/level_01.tscn`. To make a new map instead, right-click it in the FileSystem panel and choose **Duplicate**.
- Click the **Floor** layer to paint floor tiles. Click **Walls** to paint walls, desks and lockers, which block the player automatically.
- Keep a Marker2D named exactly **`PlayerSpawn`**. The player starts there.
- Move **`KeySpots/KeySpot1-3`** and **`ExitSpot`** to where the keys and exit should go. On Day 2 the programmer turns them into real keys and a real exit.
- Make doorways **2 tiles wide**. The player is 18 px wide, so 1 tile works, but it's tight during a chase.
- To play a new map: open `scenes/main.tscn`, delete the `Level` node, drag your map scene onto `Main`, rename it **`Level`**, and move it above `Player`.

### Information and coordination

- Movement speeds can be tuned without code. Open `scenes/player.tscn`, click `Player`, and change **Walk Speed**, **Sprint Speed**, etc. in the Inspector.

## How the code works

**`player.gd`** runs 60 times a second:

1. `Input.get_vector()` reads the four move actions and turns them into a direction. It never gets longer than 1, so moving diagonally isn't faster.
2. If Shift is held, the target speed is `sprint_speed`; otherwise it's `walk_speed`.
3. `velocity.move_toward()` changes the speed a little each frame, so the player speeds up and slows down smoothly.
4. `move_and_slide()` moves the player and stops it at walls, sliding along them instead of sticking.
5. The sprite turns smoothly towards the direction of movement. `facing` and `is_sprinting` are saved so the flashlight and monster can use them later.

**`main.gd`** runs once at the start:

1. It finds the `PlayerSpawn` marker in the level and moves the player there.
2. It measures the size of the map and sets the camera's limits, so you never see the empty space outside the school.

## Sharing the project

- Share the whole folder, either as a zip or through Git. You don't need to share the hidden `.godot/` folder; it's a cache that Godot rebuilds.
- Only **one person edits a scene at a time**, or you'll overwrite each other's work. Send each other files and let the programmer put them into the project.
- This folder is in OneDrive. That's fine for backup, but two people shouldn't edit the same synced folder at the same time.

## Next: Day 2 (programmer)

- Key scene: an `Area2D` on layer 4 (pickups) that watches layer 2 (player). Place one at each `KeySpot`.
- A key counter in the HUD (`0/3 keys`).
- Exit: an `Area2D` on layer 5 at `ExitSpot` that only lets you win once you have all 3 keys.
