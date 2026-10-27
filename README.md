# FFXI Journal + Tracker (By Kxteel)

FFXI Journal is an Ashita addon for **Final Fantasy XI** focused on providing a unified in-game journal for Quests & missions with an on-screen pinned tracker. Reads real server state, shows steps, rank, type and rewards, and styles step text (zones, places, NPCs, monsters, items). It includes mission and quest progression tracking, organized quest categories, objective lists, detailed quest information, Mission and Quest Logs, and controller/keyboard navigation.

<img width="1039" height="680" alt="Captura de pantalla 2026-10-27 153438" src="https://github.com/user-attachments/assets/e5855e21-c29d-4d69-899f-9d1d49710051" />


## Features

- **Real server state:** reads packet 0x056 to show whether each mission or quest is active, completed or not started.
- **Detailed entries:** steps, rank, number, type and reward for Windurst, San d'Oria and Bastok missions.
- **Pinned tracker:** up to 8 missions or quests, stacked or tabbed, transparent and right-aligned. Resizable from 0.6x to 2.0x (Journal buttons or `/journal pin size`), with auto-zone advance and cleanup on completion.
- **Rich step text:** real bold for zones, real italic for places, and colors for NPCs, monsters and items (Fira Sans and Carrois Gothic SC).
- **Editable name lists:** places, NPCs, monsters and items live in `data/`.
- **Auto-zone:** simple travel steps advance when you enter the target zone.
- **"Show not started" filter:** lists untouched content; quests without a tracking ID appear as *Not Tracked*.
- **Robust:** step text cleanup on load and a protected packet parser.

## How to Start

### Requirements

- Final Fantasy XI with **Ashita v4**.
- A character logged in (the addon reads quest and mission state from the server).

### Installation

1. Download the latest release (`v0.1.5`) and unzip it.
2. Copy the `journal` folder into your Ashita addons directory:
   `Ashita\addons\journal\`
3. Make sure the folder keeps its structure (`data/`, `assets/fonts/` and the `.lua` files together).

### Loading the addon

In the game chat, run:

    /addon load journal

To load it automatically on every login, add the same line to your Ashita
startup script (for example `scripts\default.txt`).

### First steps

1. Open the Journal window and browse your missions and quests.
2. Use the **Show not started** filter if you also want to see untouched content.
3. Pin the missions or quests you are working on (up to 8) to show them in the on-screen tracker.
4. Adjust the tracker size with the **-** and **+** buttons in the Journal, or with `/journal pin size`.
5. To unpin an entry, use the Journal or `/journal pin remove <n>`.


## Status
Work in progress. Verified outside the game (Lua via `lupa` with a mocked ImGui); **not yet tested in the real FFXI client**. Fonts, tracker alignment, auto-zone and style colors are the first things to check in-game.
All Windurst, SandOria and Bastok ready.

## Roadmap

- Quest steps (most are still empty).
- Steps for Campaign, Assault and CoP missions.
- Rank, type and reward data for the remaining mission areas.

## Credits and licenses

- Original addon: **Lexia** and **Jintawk**.
- Extended by **Kxteel**.
- Fonts under the SIL Open Font License (`assets/fonts/OFL-FiraSans.txt`).
- Data cross-checked with BG-Wiki and moghouse.cc ID tables.
