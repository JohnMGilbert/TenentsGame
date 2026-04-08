# Tenents

Tenents is a game about managing the residents of an apartment building by entering their dreams and helping them resolve the problems haunting them.

The core gameplay loop centers on meeting tenants in the waking world, learning about their struggles, and diving into procedurally generated dream spaces to confront them directly. Inside dreams, players explore shifting environments, battle procedurally generated mobs, collect dream essence, and use that essence to upgrade and evolve their abilities both in dreams and back in the apartment building.

The project is currently focused on building a basic prototype of that loop:

- interact with tenants in the apartment hub
- enter a tenant's dream
- explore a procedural dream space
- fight dream-born enemies
- collect dream essence
- use rewards to drive player progression

The long-term goal is to combine tenant management, procedural generation, and action-oriented dream exploration into a single evolving simulation.

## Project Structure

- `main.tscn` remains the root entry scene for the current prototype.
- `scenes/` contains reusable scene assets grouped by feature, including player, interaction, UI, and NPC content.
- `scripts/game/` contains the main runtime gameplay code split into focused modules for the scene root, player, camera, interactions, tenants, and UI helpers.
- `scripts/terrain/` and `scripts/terrain-generator/` contain terrain experiments and generation systems that are still evolving alongside the main hub prototype.
- `scripts/mob-sprite-generator/` contains procedural mob sprite tooling and older exploratory implementations.
