# Journal for FFXI (Ashita v4)

<img width="3168" height="1344" alt="journalffxi" src="https://github.com/user-attachments/assets/9a04c1db-f4d0-40b4-80e3-8eb0494ea265" />


-> **Lastest Version 0.4.0** · by **Kxteel**
https://github.com/Kxteel/ffxi-journal/releases/tag/V0.4.0

-> **Nexusmod Community:** https://www.nexusmods.com/finalfantasy11/mods/44


A mission and quest minimalist journal addon for Final Fantasy XI, with progression tracking, quest categories, auto-pin quest. Available languages: English & Spanish.
Based on addon by AndreWesleyPS. Extended with new features and more by Kxteel. Only for Vanadiel users :P

Minimalist FFXI skin
<img width="1411" height="990" alt="captura1" src="https://github.com/user-attachments/assets/f144a8c6-cab5-4f15-afa6-8dade077c3d9" />

Legacy Skin
<img width="1255" height="765" alt="newtheme" src="https://github.com/user-attachments/assets/924af07f-90ed-4d03-830b-a7e68e26dfe3" />

REMEMBER ZONE 1 TIME TO UPDATE ALL THE JOURNAL YOUR FIRST TIME!!!!!!


## Features

- **Missions and Quest Journal:** Browse by storyline, region, or category. Each entry shows its status, requirements, rewards, and objectives. Search the entire journal by name, NPC, zone, reward, or objective text.
<img width="1344" height="984" alt="inicio2" src="https://github.com/user-attachments/assets/749ad11b-9a4b-46a3-ba3a-5d3d9fa28282" />
  
- **Objective tracking.** Check off steps as you complete them, and the journal saves your progress. Pin up to 8 missions or quests to the on-screen Tracker to see the next unfinished step. You can also view active entries, favorites, and completion totals by category.
<img width="952" height="647" alt="Captura5" src="https://github.com/user-attachments/assets/0e45dab0-6e1b-4755-8d37-fc42ea9b4862" />


**Compass & zone routes**
Point the compass at the NPC for your current step, or select a destination to see which zones to travel through. The compass automatically picks up nearby NPCs with available or active quests. Optional in-world NPC markers are available as a prototype.
<img width="756" height="478" alt="Captura4" src="https://github.com/user-attachments/assets/934f42ba-88b2-40f2-8f51-2ef8876e6324" />


**Alerts. Quest starte, complete & Quest Nearby (near an NPC)**
lists the quests you can start there. "Quest In Progress" (when you enter a zone) lists the quests you have in progress that belong to that zone, stays a little longer, and its quests open in the Journal with a click. A quest can be started when your main job has the level it needs and the quests it follows are completed; this is read from the requirements and from the text of the first step. Fame, skill, job, mission and expansion pack requirements are not checked.
<img width="2014" height="978" alt="questcomplete" src="https://github.com/user-attachments/assets/1bf0466d-7cbd-4a0e-93a7-1cc7c8c080a4" />


- **Alerts and inventory checks.**
Get alerts for nearby quests, active quests in a zone you enter, and newly obtained quest items. Objectives show how many required items you already have, including key items.
<img width="1152" height="248" alt="item" src="https://github.com/user-attachments/assets/ef3ed0f1-36af-4c93-8d6d-84f83bfb8299" />


- **Arrows in the game world**. /journal mark [on|off|debug] (or the checkbox in Settings > Compass) draws arrows over the NPCs of the compass in the game, found with the camera of Direct3D. It is off by default.
brujula4
<img width="1135" height="542" alt="1" src="https://github.com/user-attachments/assets/59de1938-eea0-4e88-bb5a-85e948b09489" />
<img width="1462" height="641" alt="2" src="https://github.com/user-attachments/assets/ecf33f0c-f6c4-4221-ab1e-c682769710a7" />
<img width="1553" height="813" alt="Captura2" src="https://github.com/user-attachments/assets/cca11204-bf84-4699-b9b4-ed7983eb09a2" />
<img width="1093" height="616" alt="quest1" src="https://github.com/user-attachments/assets/c96227ca-aa6e-4e59-8817-c7b5a33a6db3" />

- **Fame, guides, and notes.**
The journal records your character’s fame when you speak to a **Fame Checker**. It also includes a new player guide, recommended leveling camps, and personal notes you can organize into folders.
<img width="1048" height="587" alt="notes" src="https://github.com/user-attachments/assets/3aca8e5e-71df-4f00-a10d-badd706e1362" />

- **And muuuuuch more!**

## Status

**Work in progress...**

## Roadmap

- Quest & Missions **100%**
- Compass & autoCompass NPC **100%**
- Steps for Campaign, Assault and CoP missions. **100%**
- Rank, type and reward data for the remaining mission areas. **100%**
- Newguide **100%**
- Fame cheker **100%**
- Themes **100%**
- ...


## How to Start

### Requirements

- Final Fantasy XI with **Ashita v4**.
- A character logged in (the addon reads quest and mission state from the server).

### Installation

1. Download the latest release (`v0.4.0`) and unzip it.
2. Copy the `journal` folder into your Ashita addons directory:
   `Ashita\addons\journal\`

### Loading the addon

In the game chat, run:

    /addon load journal
    and for open /journal

To load it automatically on every login, add the same line to your Ashita
startup Default script (for example `scripts\default.txt`). Like all rest addons.

REMEMBER ZONE 1 TIME TO UPDATE THE JOURNAL


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



<img width="3872" height="1088" alt="paypal" src="https://github.com/user-attachments/assets/0fa88c06-87a2-474e-8b20-b4d5f19ba2ad" />
Thanks for your donation to keep growing: https://www.paypal.com/paypalme/kxteel


## Changelog

### 0.4.0

- **Themes.** Settings > Theme chooses the look of the windows: **Original** (the navy look the addon always had) or **Legacy** (an aged open book). In Legacy the Journal is a two-page book: a leather bar on top with the selectors, buttons and settings, the list of missions or quests on the left page and the details of the sheet on the right page, in dark ink with darker status colors so they read on paper; the selected row gets a burgundy mark. The book keeps a 3:2 shape and scales with the window, and its pages have no scroll bar (the mouse wheel still scrolls). The sheet, Progress, Active Now, General notes, Fame, Zones, Settings, the guide, the camps and the help window use a single parchment page with the same style; the Tracker, the compass and the alerts keep their own look. The choice is shared by all the characters and is saved in `shared_theme.lua` (in `config\addons\journal`, or in the addon folder when that cannot be written). The pictures are `assets/theme/legacy_book.png` (1450 x 948) and `assets/theme/legacy_page.png` (880 x 860); without them Legacy still works with plain parchment colors. The code is in `theme.lua` (margins `TEXT_*`, page scale `PAGE_SCALE`, size limits `DS_MIN`/`DS_MAX`): it changes the values of the color table of `ui.lua` in place, so Original is unchanged. In Legacy the names of NPCs, monsters and items inside the steps take dark colors too.
<img width="1255" height="765" alt="newtheme" src="https://github.com/user-attachments/assets/924af07f-90ed-4d03-830b-a7e68e26dfe3" />

- **Journal window.** No title bar. The bar with the selectors, buttons and search box starts **hidden** every time the Journal opens; two small buttons at the right corner (a triangle and an **X**) show or hide the bar and close the Journal. The search is cleared whenever the bar is hidden or the Journal is closed.
<img width="549" height="153" alt="notittle" src="https://github.com/user-attachments/assets/62dae038-9d81-4ced-a613-87b0741ee69a" />

- **Windows without a title bar.** Settings, General notes, Fame, Zones by region, Camps and the new adventurer guide have no title bar; each one has a small **X** in its first row. Zones by region and the guide open twice as big, and the camps twice as tall (never more than 90% of the screen).
- **New adventurer guide.** In the contents on the left, the first level titles that hold points are headings: yellow letters, a triangle (down for the open group) and the number of points; the points are indented further.
- **Settings.** The controls fit the window with any theme: long check box texts wrap, the buttons of a stepper go on the next line when the name leaves no room, the color squares and the alert test buttons wrap, and no button is wider than the window.
- **Route map + Compass.** New feature called Route map to show your route to zone you pinned. The yellow border around the zone pinned in the compass is thinner.
<img width="1225" height="576" alt="routetomap" src="https://github.com/user-attachments/assets/b10b27ec-6d04-403c-acc8-a7ae5abe19f3" />

- **Zone name banner.** About two seconds after you arrive in a zone, its name fades in in the upper part of the screen, big, in fantasy letters , with a thin line under them, and the region of the zone smaller below (the regions of the list of zones). It stays about three seconds and fades out; it has no background and takes no clicks. While it is on the screen the alerts wait, so the alert of the quests of the zone comes after it. It also shows when the addon is loaded inside a zone (a reload or a login). Without the font file the title font of the Journal is used. In Settings (Alerts) you can change the size and the color of its letters and press *Test: Zone Name* to see it again. There is no setting to turn it off yet.
<img width="1242" height="345" alt="zone alert" src="https://github.com/user-attachments/assets/d1636d8b-abe2-4ff3-a5e1-b2d9697a9fe0" />

- **Items you have**: when a step of a quest or mission asks for an item ("Obtain Honey x5", "Trade the Black Tiger Fang x3 to ..."), a green V is drawn after the name if you have enough of it, and a counter such as (2/5) while you have some but not enough. It is shown in the steps of the Journal, in the quest sheet and in the Tracker. The count includes everything you own that the game lets the addon read: bag, mog safe, storage, locker, satchel, sack, case and the wardrobes (not the temporary items). Key items named by a step get the green V too when you have them. Items named as a reward ("... and receive X") are not marked. The names are read from the game resources in the first moments after the Journal is drawn, so the marks appear a second later. 
<img width="827" height="446" alt="update items" src="https://github.com/user-attachments/assets/7c7076d8-11aa-4554-9fb8-3aff9d51657d" />

- **Alert: item obtained for a quest.** When you get an item that a quest in progress asks for (the `items` field of the quest), a banner says *Item Obtained* with the item (and how many you have of how many it needs) and the quest; a click on the quest line opens its sheet. When you have every item of the quest, a different banner says *Items Complete*. Only what you carry counts (bag, satchel, sack, case and wardrobes): taking an item out of the safe or moving it between bags does not trigger it, and neither do the first seconds after logging in or zoning, nor an amount that comes back after dropping (for example the containers read late after a zone change): it only warns at the moment you get something new. Key items asked by the quest count too. Sounds (yours, optional): `assets/sounds/item_found.wav` and `assets/sounds/item_complete.wav` (without the second one the first plays). It has a checkbox and two test buttons in Settings > Alerts; the look is the one of the new / completed alerts.
<img width="1152" height="248" alt="item" src="https://github.com/user-attachments/assets/329030a3-024e-422a-90aa-943c842336c8" />
<img width="1036" height="228" alt="itemcomplete" src="https://github.com/user-attachments/assets/fbf27f50-b8e5-4c6c-b7e8-acca0f7373b1" />

- **Quests locked by fame.** A quest that needs more Fame than you have (the `Fame N` requirement of the data, for San d'Oria, Bastok, Windurst and Jeuno) now shows the locked icon in the Journal and the sheet, and counts as locked for the compass arrows and the alerts. It only applies after you have read the Fame of that nation; with "Unknown" fame nothing is locked.

- New **menu** button (three lines) to the left of Settings. It opens a list with one row for each function (icon and name). It groups the new adventurer guide and the camps, whose own buttons are gone from the bar; the functions to come go in this list too.

- General notes: a folder can have a color. Select the folder and pick one of the eight colors (or none) in the Color row; the folder and its notes get a bar of that color in the list.

- **Gate Guards:** the missions of the three nations name their Gate Guards (San d'Oria: Ambrotien, Endracion, Grilau; Bastok: Argus, Cleades, Malduc, Rashid; Windurst: Mokyokyo, Janshura-Rashura, Rakoh Buuma, Zokima-Rokima). They go to the automatic compass when you are close and carry the mission icon (available, in progress or not available).

### 0.2.0

Release that groups every change made since 0.1.21 (listed below as steps, newest first): Quest Nearby alert, mission area types, numbered chapters and data for Zilart, Chains of Promathia, Treasures, Adoulin and Rhapsodies, quests grouped by zone, nation and expansion banners, ranks for the nation missions with the completed check, and the Jeuno banner....

### 0.1.21

**Alerts**
- New: **alert of a new quest or mission**. When the game gives you a new quest or mission, a banner fades in at the center of the screen ("New Quest!" or "New Mission!") with the name of the item, a sound, and the question "Pin it to the Tracker?" with the buttons *Pin to Tracker* and *No thanks*. With no answer in 14 seconds it counts as *No*. If the item is already in the Tracker (for example with the automatic pins on) it does not ask and says so. If several things arrive together they are shown one after the other.
- New: **alert of a completed quest or mission** ("Quest Completed" or "Mission Completed"), with a green check mark that draws itself beside the title and its own sound. It does not ask anything.
- The alerts do not fire for what the character already had when logging in, during the first seconds after the addon loads, or when the game sends a reload of the data with many changes at once. An item that stops being active without being completed does not give a completed alert.
- New: the sounds are your own `.wav` files in `assets/sounds`: `new_quest.wav`, `new_mission.wav`, `complete_quest.wav` and `complete_mission.wav`. If one is missing that alert is silent and the chat says so once.
- New: an **Alerts** section in the settings window: turn the alerts, the sound and the question about pinning on or off. The new-item alerts and the completed alerts each have their own **background opacity** (0% to 100%), **text size** (60% to 160%) and **color** (the default of the alert or one of 8 colors). Four **test** buttons show each alert on the screen and keep it there while the settings window is open, so the look can be changed in front of it; pressing the button again, or closing the settings, hides it. Clicking the value of a setting resets it.
- New: `/journal alert [quest|mission] [done]` shows an alert for the item selected in the Journal.
- New file: `announce.lua` (the banners and the sounds). The check mark and the thumbtack are drawn in `icons.lua`.
<img width="2006" height="1007" alt="newquest" src="https://github.com/user-attachments/assets/c4d16b71-a00d-4ed7-85fd-eb6e282f17b7" />
<img width="2014" height="978" alt="questcomplete" src="https://github.com/user-attachments/assets/eb5b612a-dd44-453f-bfbf-6a88e1ed1ec3" />



**Journal**
- New: **All** is the first entry of the area selector (missions) and of the category selector (quests). It lists everything together, with the total progress, and the details show the cover of the area of the selected mission. The arrows and the keyboard and controller shortcuts go through it too. A link between quests made from "All" stays in "All". The choice is saved.
- Changed: the **active** missions and quests are always at the top of the lists, in an area or in "All". The rest keep their order.
- Changed: a **completed** mission or quest cannot be edited: its steps are shown all done, the boxes do not react, the counter shows `(N/N)` and the Reset steps button is not shown.
- Removed: the **Progress** button of the Journal toolbar. The progress of each area and the total are still shown in the area selector and its list.
- Changed: the camps button is now a red question mark drawn with lines, so it no longer depends on an image. The loading of `assets/camps.png` and its message in the chat are gone, and the file is not used any more.
- New: the setting **Show Journal button on close**. The small Journal button that stayed on the screen when the Journal was closed is now hidden by default; turn it on in the settings to get it back.

**Tracker**
- Removed: the **Mode** and **Close** buttons at the bottom of the Tracker. The layout and the visibility are still set in the settings window and with `/journal pin mode` and `/journal pin`.
- New: a small **thumbtack** on every pinned item. Pressing it unpins the item, which stays in gray with an empty thumbtack for 20 seconds so that pressing it again pins it back (with its steps as they were). After that it disappears. In the tabs layout the gray item is shown under the active one.

**Fixes and technical**
- Fixed: the addon did not load when the settings code used more than 60 values from outside a function, which LuaJIT does not allow ("function has more than 60 upvalues"). The alert and "All" settings are kept in tables and `apply_config` is split in two.
- All the new texts are translated to Spanish (`data/ui_es.lua`). The chat messages are plain ASCII.

### 0.1.20

- Fixed: in the guide for new adventurers the titles of the contents (Welcome, Choosing a nation and the rest) were cut. The panel is now as wide as the titles need, within limits (it follows the width of the window and the text size), and a title that is still too long goes on more than one line. Clicking any line of a title selects it.
- Changed: in the mission and quest lists, one click only selects a row and a double click opens its sheet. The keyboard and the controller keep opening the sheet when you confirm.
- Fixed: the button of the camps. The icon is now loaded again while the Journal is drawn if it could not be loaded at the start (a few tries), the button uses the same call as the button of the mini Journal, it also reacts when that call does not report the click, and if the icon cannot be loaded the chat says so once and the button becomes a plain button with the word Camps. `/journal camps` still opens the window.
- Fixed: in the camps, the names of the monsters are shown in the color of the monsters (red), also those that are not in the list of names.
- All the new texts are translated to Spanish.
<img width="1129" height="713" alt="guide new adventurer" src="https://github.com/user-attachments/assets/b51cac88-4505-42e1-882e-26fee4b08945" />


### 0.1.19

- Fixed: a mission or quest that you unpin from the Tracker and pin again started on step 1 and ignored the steps already marked as done in the Journal. Now it starts on the first step that is not done. It also applies to the pin that replaces a completed mission with the next one, to the pins made with `/journal pin add` and to the automatic pins. Unpinning never forgets the marked steps.
- New: **Camps**, a guide to where to gain experience at each level. A button with its own icon in the Journal toolbar (next to the sprout of the guide), or `/journal camps`, opens a window of its own. It lists the standard and alternate camps with the level range they are good for, the monsters, the area, the map coordinates and a note when there is one. Two ways to read it: *For your level* (the camps of every range that suit the level) and *By level range* (tabs 10 to 70, with the camps that suit the level highlighted). The level is the one of the character when the game gives it, or it is set with - and +. Below level 10 it points to the guide for new adventurers. A checkbox hides the areas marked (S), which belong to Wings of the Goddess. The lists are in `data/camps.lua` (125 camps) and the icon in `assets/camps.png`.
- New: **Text size** in the settings (80% to 140%). The font of the Journal and of its windows, the height of the buttons and the bars, and the default size of the windows change together, so the text always fits. The Tracker keeps its own size.
- All the new texts are translated to Spanish. The translation dictionary now has 4,983 entries.
<img width="1318" height="906" alt="inicio5" src="https://github.com/user-attachments/assets/0d9578b6-9667-4e33-ab47-9bd0e3df4610" />


### 0.1.18

- New: a guide for new adventurers. A button with a green sprout in the Journal toolbar (next to Progress and Settings), or `/journal guide`, opens a window of its own: the contents on the left and the text on the right, in English or in Spanish. It follows the "New Player Guide" of the Phoenix Wiki without changing its content: choosing a nation, the first steps in town, levels 1-10 and 10-20, the milestones, the first gil (the repeatable quests of San d'Oria, Bastok and Windurst), getting around, how Phoenix differs from retail and where to go next. It remembers the section you read last. The window works even when the Journal is closed.
- The quests named in the guide (the tables of the first gil, the milestones and the Mog House quests) are links: they open that quest in the Journal. Repeatable ones carry the infinity sign. Every page ends with the source.
- The guide still mentions pages of the Phoenix Wiki (Game Terms, Fame, Jobs and others); they were kept as they are in the original text.
- New files: `data/guide.lua` (the text of the guide). The sprout is drawn in `icons.lua`, with lines and triangles, so it does not depend on a font.
- All the texts are translated to Spanish. The translation dictionary now has 4,972 entries.
- Name list for NPCs extended with the ones of the guide.
<img width="869" height="824" alt="guide new adventurer" src="https://github.com/user-attachments/assets/55fbc4c9-376c-4da4-bff7-fc0b74498227" />


### 0.1.17

- New: step checklist with memory. Each step in the details of a quest or mission has a box. The steps you mark are shown dimmed, the title shows how many are done, for example `(3/10)`, and a **Reset steps** button starts over. The marks are saved per quest or mission, and a mark only counts while the step keeps its text, so a rewritten objective never gets a wrong mark. When a quest or mission is completed its marks are forgotten, so a repeatable quest starts clean the next time.
- Changed: the Tracker shares the checklist. The current step of a pinned item is always its first step not done. `>` marks the current step as done and skips the ones already done, `<` goes back one step and unmarks it, the automatic step change on zone change marks the step as done, `/journal pin <n>` marks the steps before n as done, and `/journal pin reset` clears the checklist. Pins made before this version keep their progress: the steps before the current one count as done.
- New: a button with the infinity sign in the header of the quest lists (the right end of the first row, next to "Hide complete quests") that shows only the repeatable quests. It lights up while it is on, it has a tooltip, it combines with the search and the other filters, and it is saved. A jump from a quest link to a quest that is not repeatable turns it off so the jump always arrives. The progress counters do not change with it.
- The Spanish texts of the above are in `data/ui_es.lua`.
<img width="1442" height="1081" alt="Captura 2" src="https://github.com/user-attachments/assets/7ec5ea74-dbfb-438a-ba8e-337c722a3e21" />


### 0.1.16

- New: repeatable quests are marked with an infinity sign. It appears after the name in the Journal list, next to the title in the details panel, and to the right of the name of every pinned repeatable quest in the Tracker (in the stacked and in the tabs layouts, with its shadow). The sign is drawn with lines, so it does not depend on a font. It uses the new file `icons.lua`.
- New: automatic pins of the active quests. When it is on, the quests the game reports as active are pinned by themselves (up to the 8 pins of the Tracker, with no message when it is full), and the automatic pins go away when the quest is completed. Pins you made by hand are never removed. A quest you unpin by hand (or that you clear with all the pins) is not pinned again while it stays active. It is off by default. Turn it on in the Settings window ("Pin active quests automatically") or with `/journal pin auto [on|off]`. Turning it off keeps the pins as normal pins. This is for quests only.
- The Spanish texts of the above are in `data/ui_es.lua`.
<img width="1443" height="626" alt="Captura3" src="https://github.com/user-attachments/assets/ff0fd01d-27e6-4313-9ac2-b2c2fa54c6fb" />


### 0.1.15

- New: links between quests. In the details of a quest (and in its sheet), each quest named in "Prereq" is a line you can click to jump to it, including prereqs with several quests such as "The Fighting Fourth / Snake on the Plains / Steamed Rams". A "Next" list shows the quests that have this one as their prereq (up to 6, with "+N more"), and a "< Back" line returns to the quest you came from (up to 20 jumps; picking a quest from the list starts a new trail). Each link shows [x] if the quest is completed, [>] if active and [ ] if not. If the quest is hidden by the search, "Hide complete" or "Show not started", those are relaxed so the jump always arrives.
- New: a **Progress** window (button in the Journal toolbar). It lists every mission area and quest category with a bar and "30%  26/85", with the totals of missions and quests at the top. Clicking a row opens that area in the Journal.
- New: a **Settings** window (button in the Journal toolbar, or `/journal settings`). Language; Journal background opacity (35% to 100%; only the backgrounds fade, the text stays sharp); the four list filters; and for the Tracker: show, layout (stacked or tabs), size, text opacity (35% to 100%), background (0% to 80%, transparent by default), show the next step and auto step on zone change. It also has "Reset window positions", for a window that ended up off the screen. All of it is saved.
- Changed: the tracker size, next step, auto step and language controls moved from the details panel to the Settings window. The details panel keeps only the Pin to Tracker button.
- Changed: Esc (or B on a controller) closes the Sheet, the Progress and the Settings windows before it closes the Journal.
- New file content: the Spanish texts of all of the above are in `data/ui_es.lua`.
<img width="1432" height="508" alt="Captura4" src="https://github.com/user-attachments/assets/7623db0b-7a61-4b21-80bb-b7987c86ab47" />


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

- Original base addon: AndreWesleyPS
- Extended and development for Ashita by **Kxteel**.
- Fonts under the SIL Open Font License (`assets/fonts/OFL-FiraSans.txt`).
- Data cross-checked with BG-Wiki and moghouse.cc ID tables.
