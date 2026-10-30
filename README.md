# Journal for FFXI (Ashita v4)

-> **Lastest Version 0.1.14** · by **Kxteel**

A quest and mission Journal for Final Fantasy XI, built as an addon for Ashita v4, with a pinned on-screen tracker.

Based on an existing addon by **Lexia** and **Jintawk** (Windower), extended with new features and data by Kxteel (For Ashita)

<img width="1834" height="1138" alt="Captura2" src="https://github.com/user-attachments/assets/2736b00d-5019-4d2e-a387-355aeb9aa2a1" />



## Features

- **Real server state:** reads packet 0x056 to show whether each mission or quest is active, completed or not started.
- **Detailed entries:** steps, rank, number, type and reward for Windurst, San d'Oria and Bastok missions.
- **Pinned tracker:** up to 8 missions or quests, stacked or tabbed, transparent and right-aligned. Resizable from 0.6x to 2.0x (Journal buttons or `/journal pin size`), with auto-zone advance and cleanup on completion.
- **Rich step text:** real bold for zones, real italic for places, and colors for NPCs, monsters and items (Fira Sans and Carrois Gothic SC).
- **Editable name lists:** places, NPCs, monsters and items live in `data/`.
- **Auto-zone:** simple travel steps advance when you enter the target zone.
- **"Show not started" filter:** lists untouched content; quests without a tracking ID appear as *Not Tracked*.
- **Robust:** step text cleanup on load and a protected packet parser.

<img width="1087" height="769" alt="Captura5" src="https://github.com/user-attachments/assets/78152097-88da-4cba-9f22-5f788f1d3ba2" />


## Status

Work in progress... Verified outside the game (Lua via `lupa` with a mocked ImGui); . Fonts, tracker alignment, auto-zone and style colors are the first things to check in-game.

## Roadmap

- Quest **100%**
- Steps for Campaign, Assault and CoP missions. **100%**
- Rank, type and reward data for the remaining mission areas.
<img width="1184" height="734" alt="Captura3" src="https://github.com/user-attachments/assets/4d9051a7-d528-4777-86f4-cc1059f54fa4" />


## How to Start

### Requirements

- Final Fantasy XI with **Ashita v4**.
- A character logged in (the addon reads quest and mission state from the server).

### Installation

1. Download the latest release (`v0.1.14`) and unzip it.
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

### Notes

- Quest and mission state is read from the server, so it may take a moment to
  appear after logging in or changing zones.
- Quests marked **Not Tracked** have no tracking ID, so the addon cannot tell if they are done.
- This version has not been tested in the real FFXI client yet. If fonts, tracker
  alignment or auto-zone misbehave, please open an issue.

## Changelog

### 0.1.14

- Mission objectives written for all 52 Assault missions (Leujaoam Sanctum, Mamool Ja Training Grounds, Lebros Cavern, Periqia, Ilrusi Atoll and the two Nyzul Isle missions). Each one lists how to get the Imperial Army I.D. Tag and the Assault Orders, the Staging Point, the leader's Assault Armband, the time limit and the Rune of Release, plus the objective and notes of that assault. They come from BG-Wiki; for 18 assaults the page has no details, so the step only says to read the mission orders on entry. The mission sheet now shows the assault rank and area.
- Mission objectives written for all 246 Campaign Ops (84 operations for San d'Oria, Bastok and Windurst): the NPC and place of each nation, the campaign rank, the reward in experience and Allied Notes when known, the objective and the steps of its type (resource procurement, supply transport, security, supply manufacture, offensive, defensive, intel gathering and military training). They come from BG-Wiki; for operations whose objective the wiki does not give, the step says to check the mission menu.
- Removed: the objectives of 30 Chains of Promathia entries that 0.1.13 had added (chapter titles and the sub-missions of The Road Forks and Three Paths). The Tracker hides those entries on purpose, and The Road Forks and Three Paths already hold those steps. All the visible missions have objectives.
- All the new objectives are also translated to Spanish. The translation dictionary now has 4,834 entries.
- Name lists for NPCs, monsters and items extended for the new objectives.

### 0.1.13

- Removed: the Mission Log and the Quest Log windows. Only the Journal and the Tracker are left. This also removes the "Show in Mission Log / Quest Log" buttons, the commands `/journal log`, `/journal quest log` and `/journal text scale`, the log text scale, and the automatic jump of the log to the next mission. The old log settings are dropped from the saved settings file.
- Changed: `/journal pin add` now pins the mission or quest selected in the Journal (it pinned the items of the logs before). On a controller, the X button now pins or unpins the selected entry in the Tracker (it showed or hid the log before).
- Mission objectives written for the 30 Chains of Promathia missions that had none: the 8 chapter titles, the sub-missions of The Road Forks (San d'Oria and Windurst paths) and the sub-missions of Three Paths (Louverance, Tenzen and Ulmia). They come from BG-Wiki, and some pages are cut off in search results, so only the readable parts were written. All 64 CoP missions now have objectives.
- The new objectives are also translated to Spanish. The translation dictionary now has 4,461 entries.
- Name lists for NPCs, monsters and items extended for the new objectives.

### 0.1.12

- Quest objectives written for 54 quests of the Other areas: Mhaura (15), Selbina (11), Tavnazian Safehold (18) and the rest (Confessions of a Bellmaker, Bombs Away!, Waking the Beast, the three Koblakiq quests, the three Moogle quests and A Moral Manifest?). They come from BG-Wiki; several pages are cut off in search results, so for those only the parts that could be read were written. 13 quests that are not implemented on this server were left without objectives.
- All the new objectives are also translated to Spanish. The translation dictionary now has 4,407 entries.
- Name lists for NPCs, monsters and items extended for the new objectives, and a few names that coloured other steps wrongly were removed.

### 0.1.11

- New: the Journal shows how many missions and quests are completed in each area, for example `(30% 26/85)`. It appears on the questline / region selector button and next to every entry of its list, with a total line at the bottom of the list. Missions hidden by the tracker are not counted, and a quest without tracking data counts as not done.
- New: the whole Journal can be shown in Spanish, not only the objectives. The **Language** button in the Journal details panel (before: *Steps language*) and `/journal lang [en|es]` switch the buttons, lists, filters, details, window titles, help, Tracker and chat messages. The choice is saved. Names of quests, missions, zones, NPCs and rewards stay in English.
- The Spanish chat messages are plain ASCII (no accents), because the game chat does not show them reliably.
- New file: `data/ui_es.lua` (the Spanish texts of the Journal itself, loaded only when Spanish is selected).

### 0.1.10

- Quest objectives written for 46 Outlands quests: all of Kazham, Norg and Rabao, plus Open Sesame, Wrath of the Opo-opos, Wandering Souls, Soul Searching and Divine Might. They come from BG-Wiki. Ten Outlands quests that are not implemented on this server were left without objectives.
- Several BG-Wiki pages are cut off in search results (for example The Opo-opo and I, Forge Your Destiny and Chasing Dreams); for those only the parts that could be read were written.
- All the new objectives are also translated to Spanish. The translation dictionary now has 4,231 entries.
- Name lists for NPCs, monsters and items extended for the new objectives, and a few names that coloured other steps wrongly were removed.

### 0.1.9

- Fixed: the Mission Log and the Quest Log no longer open by themselves when you change zone. They only open when you open them from the Journal, and they are no longer restored when the game starts. The Journal window and the Tracker are restored only once, when the saved settings are first loaded, so a later settings reload (for example on a zone change) never opens or closes them.
- Quest objectives written for all 37 Jeuno quests (Path of the Bard, the Brutus quests, the 15 Borghertz's Hands, The Circle of Time, the Maat level cap quests, Storms of Fate, Apocalypse Nigh and more) and for all 54 Whitegate quests (Blue Mage, Corsair and Puppetmaster quests, the Wildcat Promotions, the Serpent Generals, Al Zahbi, Nashmau and more). Most come from BG-Wiki; a few partial pages were completed from other wikis.
- All the new objectives are also translated to Spanish. The translation dictionary now has 4,020 entries.
- Name lists for NPCs, monsters and items extended for the new objectives.

### 0.1.8

- New option to read the objectives in Spanish. Use the **Steps language** button in the Journal details panel, or `/journal lang [en|es]` (without an argument it switches between the two). The choice is saved.
- All the objective texts of missions and quests (4,020 steps) are translated. Names of zones, places, NPCs, monsters and items, and game terms such as Home Point, Auction House or key item, stay in English so they match what the game shows. Coordinates, numbers and quoted game dialogue are kept as they are.
- The Spanish text is used in the details panel, the Mission / Quest Sheet, the Mission and Quest Logs and the Tracker. A step without a translation is shown in English.
- The interface of the addon, rewards and requirements stay in English.
- New files: `i18n.lua` and `data/translations_es.lua` (loaded only when Spanish is selected).

### 0.1.7

Data only: there are no code changes in this version.

- Quest objectives written from BG-Wiki for 91 of the 92 Bastok quests, covering Port Bastok, Bastok Mines, Bastok Markets, Metalworks and the Bastok quests that start elsewhere. Rewards and repeatable marks are filled in where BG-Wiki states them. The only Bastok quest still without objectives is Chips.
- Corrected the reward of Welcome to Bastok, which was listed as a Shell Shield (the item you need to bring) instead of the Spatha you receive.
- Where BG-Wiki gave only part of a page, the objective list is shorter and nothing was filled in from memory.
- Name lists for NPCs, monsters and items extended for the new objectives, so more names are coloured in the steps.

### 0.1.6

First numbered version. It collects everything added on top of the original addon.

**Journal window**
- New look: navy striped panel, a single toolbar with the Missions / Quests buttons and the area selector, and nation colours (San d'Oria, Bastok and Windurst) on the toolbar button and the area popup.
- Status dots in the lists: not started, active, completed and not tracked.
- Search box that filters the current area or category.
- Mission / Quest sheet: clicking a row opens a window with the full record (name, status, rank, number, type, reward and objectives). Steps before the step pinned in the Tracker are marked as done, the current step is highlighted, and a completed mission or quest shows all its steps as done.
- The nation image in the details panel is 60% smaller, so the objectives are easier to read, and the space reserved for the buttons below the objectives now follows the controls shown.
- "Show not started" filter; quests without a tracking ID appear as Not Tracked.
- New objective text styles: zones in bold, other places in italics, and colours for NPCs, monsters and items, with editable name lists. Fira Sans is used for the steps and Carrois Gothic SC for titles and buttons.
- "Auto step on zone change" is now a checkbox in the Journal details panel.
- Controller: A opens the sheet, X shows or hides the selected entry in its Mission / Quest Log, and B closes the sheet first and then the Journal. The keyboard Enter key opens the sheet and Esc closes it first.


## Credits and licenses

- Original addon: **Lexia** and **Jintawk** (For Windower).
- Extended and development for Ashita by **Kxteel**.
- Fonts under the SIL Open Font License (`assets/fonts/OFL-FiraSans.txt`).
- Data cross-checked with BG-Wiki and moghouse.cc ID tables.
