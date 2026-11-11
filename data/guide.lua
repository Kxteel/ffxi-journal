-- New Player Guide for the first hours in Vana'diel.
-- The text follows the "New Player Guide" of the Phoenix Wiki
-- (wiki.phoenix-xi.com/New_Player_Guide). It is shown in the guide window of
-- the Journal, in English or in Spanish (see data/translations_es.lua).
--
-- A section has an id, a title, a level (1 = chapter, 2 = part of the chapter
-- above) and blocks. A block is one of:
--   p       a paragraph          h       a small heading
--   note    a highlighted line   bullets a list of lines
--   pairs   label and text rows  (links = true: the quests named in the text
--           become links to the Journal)
--   quests  a table of quests (name, start, what, reward, repeatable)

return {
    source = "Phoenix Wiki: New Player Guide",
    url = "wiki.phoenix-xi.com/New_Player_Guide",

    sections = {
        {
            id = 'welcome',
            title = "Welcome",
            level = 1,
            blocks = {
                { p = "Welcome to Phoenix! This guide covers your first hours in Vana'diel: what to do in town, where to level, how to make your first gil, and the milestones along the way to level 75." },
                { p = "See Game Terms for common abbreviations such as AF and RSE. Fame explains quest reputation and where to check it, and Inventory lists Phoenix's Mog Wardrobe unlocks." },
                { p = "Phoenix is a level-75 server. Rise of the Zilart, Chains of Promathia, and Treasures of Aht Urhgan are available. Wings of the Goddess and later expansions are not. See How Phoenix differs from retail for systems that aren't here yet." },
            },
        },
        {
            id = 'nation',
            title = "Choosing a nation",
            level = 1,
            blocks = {
                { p = "You begin in one of the three starting nations: San d'Oria, Bastok, or Windurst. Your nation decides which city you start in, which storyline missions you follow, and which gate guards give you Signet. The fields around each city are similar in difficulty, so pick the city and story you like best." },
                { p = "Your race has a home nation: Humes and Galka come from Bastok, Elvaan from San d'Oria, and Tarutaru and Mithra from Windurst. If you start in your race's home nation you also receive its nation ring. You start with extra fame in your chosen nation and some in your race's home nation." },
                { p = "Each nation page lists its city areas, guilds, and a table of nearby areas by monster level." },
            },
        },
        {
            id = 'town',
            title = "Your first steps in town",
            level = 1,
            blocks = {
                { p = "You start with your race's starting clothes, a weapon for your job, a map of your nation, and 10 gil. Before you head out:" },
                { h = "Trade in your Adventurer Coupon" },
                { p = "The opening cutscene gives you an Adventurer Coupon. Trade it to one of these NPCs for 50 gil. It can't be replaced if you lose it, so don't drop or sell it." },
                {
                    pairs = {
                        { "San d'Oria", "Teilsa (Port San d'Oria), Matildie (Northern San d'Oria), Ailevia (Southern San d'Oria)" },
                        { "Bastok", "Arva (Bastok Mines), Reet (Bastok Markets), Dulsie (Port Bastok)" },
                        { "Windurst", "Jack of Hearts (Windurst Waters), Jack of Clubs (Port Windurst), Jack of Spades (Windurst Woods), Jack of Diamonds (Windurst Walls)" },
                    },
                },
                { h = "Get Signet from a gate guard" },
                { p = "Talk to one of your nation's gate guards at the city exits. Their names end in T.K. in San d'Oria, I.M. in Bastok, and W.W. in Windurst. Signet lets monsters drop crystals and earns you conquest points while you fight in the regions around the nations and Jeuno. It lasts a few hours at low rank, so renew it whenever you pass a guard." },
                { h = "Set your home point" },
                { p = "Your first home point is your starting city. If you're knocked out, you can return to the last home point you set. Home points can't teleport you between cities." },
            },
        },
        {
            id = 'levels1',
            title = "Levels 1-10: the fields outside town",
            level = 1,
            blocks = {
                { p = "Solo in the areas right outside your city. The table on your nation page lists nearby areas from easiest to hardest, with the typical level of the monsters in each:" },
                {
                    bullets = {
                        "Leveling near San d'Oria: West Ronfaure and East Ronfaure",
                        "Leveling near Bastok: North Gustaberg and South Gustaberg",
                        "Leveling near Windurst: West Sarutabaruta and East Sarutabaruta",
                    },
                },
                { p = "Use the /check command before you fight. Monsters that check as \"easy prey\" or \"decent challenge\" are good targets at low levels. Watch for aggressive monsters (marked on each zone page) and beastmen camps." },
                { note = "Death costs experience from level 5. Be careful once you pass level 4." },
            },
        },
        {
            id = 'levels2',
            title = "Levels 10-20: your first parties",
            level = 1,
            blocks = {
                { p = "From around level 10, most players leave their home region and group up. Common places to go:" },
                {
                    bullets = {
                        "Valkurm Dunes, near the port of Selbina, reached through La Theine Plateau or Konschtat Highlands.",
                        "Buburimu Peninsula, near the port of Mhaura, reached through Tahrongi Canyon.",
                        "Jugner Forest, Pashhow Marshlands, and Meriphataud Mountains in the mid-teens.",
                        "Qufim Island, off the coast of Jeuno, around level 20.",
                    },
                },
                { p = "Each zone page lists its monsters, their levels, and whether they're aggressive." },
                { h = "Party tips" },
                {
                    bullets = {
                        "Look for a group with /sea all or put up your seeking-party flag.",
                        "A typical experience party has a tank, a healer, damage dealers, and someone to pull monsters back to camp.",
                        "Check monsters, stay at camp, and ask before pulling extra monsters.",
                        "Level Sync is available, so a higher-level player can sync down to join your party. Syncing down more than 10 levels can cost some experience when the server is busy.",
                        "Power-leveling is limited. If a monster keeps attacking a character five or more levels above it, that character counts toward the fight, which cuts the experience the monster gives.",
                    },
                },
            },
        },
        {
            id = 'milestones',
            title = "Milestones",
            level = 1,
            blocks = {
                {
                    links = true,
                    pairs = {
                        { "Level 10", "Outpost warps to the regions around your nation can be used, once you've unlocked them with a supply run." },
                        { "Level 15", "You can rent a chocobo in Southern San d'Oria, Bastok Mines, and Windurst Woods, once you have a license." },
                        { "Level 18", "Unlock your support job with The Old Lady (Vera in Mhaura) or Elder Memories (Isacio in Selbina). You can only do one of the two." },
                        { "Level 20", "Get your chocobo license with Chocobo's Wounds (Brutus in Upper Jeuno). You feed a wounded chocobo Gausebit Grass. Each feeding has to wait one Vana'diel day. Chocobos can then be rented at level 20 anywhere." },
                        { "Level 30", "Advanced jobs unlock. See Jobs for each job's unlock quest." },
                        { "Level 50", "Your level is capped at 50 until you complete Limit Break quests, starting with In Defiant Challenge. Each one raises the cap on the way to 75." },
                    },
                },
            },
        },
        {
            id = 'supportitems',
            title = "Support job quest items",
            level = 2,
            blocks = {
                {
                    bullets = {
                        "The Old Lady: Wild Rabbit Tail, Dhalmel Saliva, and Bloody Robe.",
                        "Elder Memories: Magicked Skull, Damselfly Worm, and Crab Apron.",
                    },
                },
            },
        },
        {
            id = 'gil',
            title = "Your first gil",
            level = 1,
            blocks = {
                { p = "Repeatable quests are the steadiest early income. You can turn them in as often as you have the items. Each one also raises your fame with that nation, which unlocks more quests. The rewards below are from Phoenix's game data." },
            },
        },
        {
            id = 'gil_sandoria',
            title = "San d'Oria",
            level = 2,
            blocks = {
                {
                    quests = {
                        {
                            name = "Starting a Flame",
                            start = "Legata, Southern San d'Oria",
                            what = "Trade 4 Flint Stones",
                            reward = "100 gil",
                            repeatable = true,
                        },
                        {
                            name = "The Sweetest Things",
                            start = "Raimbroy, Southern San d'Oria",
                            what = "Trade 5 pots of honey (needs fame level 2)",
                            reward = "400 gil",
                            repeatable = true,
                        },
                        {
                            name = "Warding Vampires",
                            start = "Maloquedil, Northern San d'Oria",
                            what = "Trade 2 Shaman Garlic (needs fame level 3)",
                            reward = "900 gil",
                            repeatable = true,
                        },
                        {
                            name = "Flyers for Regine",
                            start = "Regine, Port San d'Oria",
                            what = "Hand out 15 flyers to NPCs around the city",
                            reward = "440 gil and a title",
                            repeatable = false,
                        },
                        {
                            name = "Grave Concerns",
                            start = "Andecia, Southern San d'Oria",
                            what = "Change the water at a tombstone in King Ranperre's Tomb (needs fame level 1)",
                            reward = "560 gil",
                            repeatable = false,
                        },
                        {
                            name = "Lufet's Lake Salt",
                            start = "Nogelle, Port San d'Oria",
                            what = "Trade 3 Lufet Salt",
                            reward = "600 gil",
                            repeatable = false,
                        },
                    },
                },
            },
        },
        {
            id = 'gil_bastok',
            title = "Bastok",
            level = 2,
            blocks = {
                {
                    quests = {
                        {
                            name = "The Siren's Tear",
                            start = "Wahid, Bastok Mines",
                            what = "Pick up the tear from the ??? in North Gustaberg (it moves between spots) with no weapon equipped, then trade it to Wahid",
                            reward = "150 gil",
                            repeatable = true,
                        },
                        {
                            name = "Minesweeper",
                            start = "Gerbaum, Bastok Mines",
                            what = "Trade 3 Zeruhn Soot",
                            reward = "150 gil",
                            repeatable = true,
                        },
                        {
                            name = "Smoke on the Mountain",
                            start = "Hungry Wolf, Metalworks",
                            what = "Trade a Galkan Sausage",
                            reward = "300 gil",
                            repeatable = true,
                        },
                        {
                            name = "Buckets of Gold",
                            start = "Foss, Bastok Markets",
                            what = "Trade 5 Rusty Buckets, a common fishing catch",
                            reward = "300 gil",
                            repeatable = true,
                        },
                        {
                            name = "Mom, the Adventurer?",
                            start = "Nbu Latteh, Bastok Markets",
                            what = "Trade a Copper Ring to Roh Latteh in Bastok Mines and bring back the letter unopened",
                            reward = "200 gil (100 if you read it)",
                            repeatable = "Only at fame level 1",
                        },
                        {
                            name = "Stamp Hunt",
                            start = "Arawn, Bastok Markets",
                            what = "Collect stamps from seven NPCs around Bastok",
                            reward = "A Leather Gorget",
                            repeatable = false,
                        },
                    },
                },
            },
        },
        {
            id = 'gil_windurst',
            title = "Windurst",
            level = 2,
            blocks = {
                {
                    quests = {
                        {
                            name = "Teacher's Pet",
                            start = "Moreno-Toeno, Windurst Waters",
                            what = "Trade a Bird Feather and a Two-Leaf Mandragora Bud",
                            reward = "250 gil",
                            repeatable = true,
                        },
                        {
                            name = "Paying Lip Service",
                            start = "Tapoh Lihzeh, Windurst Woods",
                            what = "Trade 3 Beehive Chips (150 gil) or 2 Remi Shells (200 gil)",
                            reward = "Up to 200 gil",
                            repeatable = true,
                        },
                        {
                            name = "Mihgo's Amigo",
                            start = "Nanaa Mihgo, Windurst Woods",
                            what = "Trade 4 Yagudo Necklaces from the Yagudo in Giddeus",
                            reward = "200 gil and Norg fame",
                            repeatable = true,
                        },
                        {
                            name = "Food for Thought",
                            start = "Kenapa-Keppa, Kerutoto, and Ohbiru-Dohbiru, Windurst Waters",
                            what = "Deliver a Hard-boiled Egg, a Grilled Hare, and a Windurstian Tea with a Tortilla and Pamtam Kelp",
                            reward = "1,000 gil in total",
                            repeatable = false,
                        },
                        {
                            name = "Making Headlines",
                            start = "Naiko-Paneiko, Windurst Waters",
                            what = "Collect news scoops from reporters across Windurst",
                            reward = "560 gil and a title",
                            repeatable = false,
                        },
                    },
                },
            },
        },
        {
            id = 'gil_other',
            title = "Other ways to make gil",
            level = 2,
            blocks = {
                {
                    bullets = {
                        "Crystals. With Signet, monsters drop elemental crystals. Crafters buy them in stacks at the auction house.",
                        "Monster drops. Sell the materials you collect. Each item page shows where it drops and who sells or buys it.",
                        "Fishing. The fishing page lists what bites where and the skill each catch needs.",
                        "Gathering. Harvesting, Logging, Mining, and Excavation points appear throughout the early zones. You need the matching tool.",
                        "Chocobo digging, once you can ride. Dig fatigue is shared across your whole account.",
                        "Crafting. Every city has guilds (see the guild tables on the nation pages), and crafting turns materials into more valuable goods.",
                    },
                },
            },
        },
        {
            id = 'around',
            title = "Getting around",
            level = 1,
            blocks = {
            },
        },
        {
            id = 'outposts',
            title = "Outpost warps",
            level = 2,
            blocks = {
                { p = "Each region has a conquest outpost. To unlock a warp, ask your nation's gate guard for a supply run and deliver the supplies to that region's outpost. Once it's unlocked and you meet its level requirement (level 10 for the regions around the starting cities), you can warp there from your nation's city for a gil fee. The fee triples if another nation holds the region. Outpost warps cost gil only, not conquest points." },
            },
        },
        {
            id = 'chocobos',
            title = "Chocobos",
            level = 2,
            blocks = {
                { p = "After Chocobo's Wounds, you can rent chocobos at stables. In the starter cities rentals open at level 15 and cost 50 gil plus your level. Elsewhere they open at level 20 and cost more. Chocobo digging and chocobo raising are both available." },
            },
        },
        {
            id = 'moghouse',
            title = "Your Mog House",
            level = 2,
            blocks = {
                {
                    links = true,
                    pairs = {
                        { "Mog House", "Your Mog House is in your home city. Each nation has a quest that lets your Mog House exit into a different part of the city: Growing Flowers (San d'Oria), A Lady's Heart (Bastok), and Flower Child (Windurst). Complete all three to unlock the second floor of your Mog House." },
                    },
                },
            },
        },
        {
            id = 'differs',
            title = "How Phoenix differs from retail",
            level = 1,
            blocks = {
                { p = "Phoenix follows the level-75 era, so several later systems are not available:" },
                {
                    bullets = {
                        "No Trusts. Fighting alongside other players is how you progress.",
                        "No Records of Eminence, Fields of Valor, Grounds of Valor, or Survival Guides.",
                        "Home points only set where you return after being knocked out. They don't teleport you.",
                        "No Wings of the Goddess or later content, including Dancer, Scholar, Geomancer, and Rune Fencer.",
                        "Death costs experience from level 5.",
                        "Only one character can be logged in per IP address. Households that share a connection can ask staff for an exception.",
                    },
                },
            },
        },
        {
            id = 'next',
            title = "Where to go next",
            level = 1,
            blocks = {
                {
                    bullets = {
                        "Nations: city areas, guilds, and leveling areas for each nation.",
                        "Jobs: every job, its unlock quest, and its abilities.",
                        "Zones: every area, with monsters, levels, shops, and fishing.",
                        "Quests and Missions: every quest and storyline mission.",
                    },
                },
            },
        },
    },
}
