# Chrono Access

Accessibility layer for **Chrono Trigger** (SNES) that lets blind and low-vision players
play the game with spoken feedback from NVDA.

The reader runs as a Lua script inside Snes9x through **Prism**, the emulator's Lua API.
Every frame it inspects the game's RAM and translates world state into speech.

## What it speaks

- Position, facing and walking route to a chosen target
- People, doors, stairs, chests, shops, save points and vehicles nearby
- Menus: inventory, techs, party, config, save/load, shops
- Battle menu, enemy state and turn timing
- Dialogue text and mini-games (bike, bell, race, soda, Ioka, dance, horrors)
- Spatial audio cues that point toward landmarks around the player

## Requirements

- Windows
- Snes9x with Prism/Lua scripting support
- NVDA screen reader
- A ROM whose menu routine matches the supported signature. It is checked at load time
  and the reader stops with an explicit message if it does not match.

## Quick start

| Script | Purpose |
| --- | --- |
| `iniciar-lector.cmd` | Starts the emulator with the reader loaded |
| `recargar-lector.cmd` | Reloads the reader in an already running emulator |
| `preparar-controles.ps1` | Configures the Nintendo controller layout |
| `prepare-sounds.ps1` | Regenerates the cue audio in `runtime/sounds` |

Main keys: `Control+F1` learns the sound cues, `Control+F5` orients toward the selected
target, `Control+F6` selects a target, `Control+F7` computes a route.

## Layout

| Path | Purpose |
| --- | --- |
| `lector-snes9x.lua` | Entry point: verifies the ROM, initializes voice, wires every reader |
| `*-reader.lua` | Read game state and speak it |
| `*-model.lua` | Data models for the described entities |
| `rooms/` | Per-area profiles: landmarks, obstacles, distances and cue sounds |
| `runtime/` | Native modules and cue audio |
| `*.cpp`, `*.h` | Native sources for the voice and audio modules |
| `continuar chrono.md` | Working notes, delivery by delivery (Spanish) |
| `documentación/` | Per-delivery documentation (Spanish) |

## Native modules

- `chrono_prism.cpp` — SAPI voice bridge exposed to Lua as `chrono_prism_v2.dll`
- `chrono_audio.cpp` — spatial cue mixer used by `rooms/audio-config.lua`
- `prism.dll` — Prism runtime provided by Snes9x

## Status

Work in progress, delivered iteratively. Progress notes and pending areas live in
`continuar chrono.md`.
