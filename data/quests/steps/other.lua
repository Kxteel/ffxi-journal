local Q = {}

Q.STEPS = {

    -- ========================================================
    -- MHAURA
    -- ========================================================

    oth_mha_potters_preference = {
        "Speak with Nereus in Mhaura (I-8), near the Proto-Waypoint, to begin the quest. You need Windurst fame level 5. Nereus seeks a dish of Gusgen clay from the depths of the Gusgen Mines.",
        "Obtain a Gusgen Clay from the Gusgen Mines.",
        "Bring the Gusgen Clay to Nereus for your reward, 2,160 gil. You can repeat the quest.",
    },

    oth_mha_expertise = {
        "Wait 8 Vana'diel days after completing His Name Is Valgeir to begin this quest. Speak with Take in Mhaura (I-8), inside the Sailor's Stay. She wants you to bring back one of Valgeir's dishes from Selbina.",
        "Speak with Valgeir in Selbina (I-9), inside the Shepherd's Muster.",
        "Obtain 1 Scream Fungus and 1 Land Crab Meat and trade them to Valgeir.",
        "Bring the dish back to Take for your reward, the Tableware Set, and the title Three-Star Purveyor.",
    },

    oth_mha_fishermans_heart = {
        'Steps not added yet.',
    },

    oth_mha_his_name_is_valgeir = {
        "You need to wait two, possibly three game days after completing Unending Chase before this quest is offered. Speak with Rycharde in Mhaura (I-8). He gives you an Aragoneu pizza to deliver to his father, Valgeir, in Selbina.",
        "Rycharde pays your fare for the next Ferry between Mhaura and Selbina if you choose to take it.",
        "Deliver the pizza to Valgeir in Selbina (I-9).",
        "Return to Rycharde for your reward, the Map of the Toraimarai Canal.",
    },

    oth_mha_raining_mannequins = {
        "Speak with Fyi Chalmwoh in the Goldsmithing shop in Mhaura (G-8) to begin the quest, then speak to her again. You need Windurst fame level 4. She wants to build a mannequin that rivals those of times past, and it is your job to gather information on how to make one.",
        "Speak with Ramona in Selbina (H-9) to receive the Mannequin joint diagrams.",
        "Gather all 5 Mannequin pieces and trade them to Fyi Chalmwoh. They can also be bought from player bazaars.",
        "Zone and speak with Fyi Chalmwoh again to receive your reward, a mannequin matching your race and gender.",
    },

    oth_mha_orlandos_antiques = {
        "Speak with Orlando in Mhaura (G-9) to begin the quest. Find where the Goblins bury their junk: he is interested in the items that Goblin Diggers tend to bury if left undisturbed.",
        "Trade Orlando eight of any one of the items to complete the quest and receive 100 to 900 gil, depending on the item. You can repeat the quest.",
    },

    oth_mha_recycling_rods = {
        "Speak with Keshab-Menjab at the lower level of Mhaura (H-9) to begin the quest. You need Other fame level 1. You have been asked to help bring in cleanly snapped rods for recycling; the recycled rods are supposedly sold somewhere around Bibiki Bay.",
        "Obtain a Clean Snap Rod. You can speak to Keshab-Menjab again for some additional dialogue.",
        "Return the rod to Keshab-Menjab to complete the quest and receive 1,500 gil.",
    },

    oth_mha_rycharde_the_chef = {
        "Speak with Rycharde in Mhaura (I-8) to begin the quest. He needs your help to find some dhalmel meat.",
        "Obtain 2 Dhalmel Meat and trade them to Rycharde to complete the quest. You receive 1,500 gil and the title Purveyor in Training.",
    },

    oth_mha_trial_by_lightning = {
        "Speak with Ripapa in Mhaura (I-9) to obtain the quest. You need Mhaura fame level 6. Warning: Trust Magic cannot be used in this battlefield. Once you have the key item Tuning fork of lightning, you can safely undertake the quest, and every party member needs their own.",
        "Ring the tuning fork upon the Lightning Protocrystal in the Boyahda Tree. Up to 6 party members can enter the arena, and the time limit is 30 minutes.",
        "Defeat Ramuh Prime to receive the key item Whisper of storms.",
        "Return to Ripapa with the whisper and she offers several reward options, including the ability to summon Ramuh. You can only select one of the rewards at any time, and you may repeat this quest once per Earth day.",
        "To save travel time to the Cloister, use the Mini Fork of Ltn. given by Trial-Size Trial by Lightning: be on Summoner as your main job, get the Mini Tuning Fork from Lacia, trade it back to her, and enter the Protocrystal normally.",
    },

    oth_mha_trial_size_lightning = {
        "You need to be a Summoner of level 20 or higher and have Other fame level 2. Speak with Lacia in Mhaura (I-9) to begin the quest and obtain a Mini Tuning Fork of Lightning.",
        "You may prepare for the upcoming battle and, whenever you are ready, trade Lacia the tuning fork to be transported to the arena.",
        "Trade the fork to the Lightning Protocrystal to enter the fighting arena.",
        "Defeat Ramuh Prime to complete the quest. Only Carbuncle may be used for this battle; Siren can also be used, but that seems unintended.",
        "You may re-obtain the Mini Tuning Fork from Lacia at any point if you want to repeat the fight, but she will no longer teleport you to the Cloister.",
    },

    oth_mha_the_basics = {
        "You need to wait 8 real-life hours after completing The Clue before this quest is offered. Speak with Rycharde in Mhaura (I-8), who asks you to take Mhauran couscous to Valgeir in Selbina.",
        "Rycharde offers to buy you a ticket for the next Ferry between Mhaura and Selbina, but you can travel to Selbina any way you choose.",
        "Deliver the dish to Valgeir in Selbina (I-9) and report back to Rycharde on how he liked it.",
    },

    oth_mha_the_clue = {
        "Speak with Rycharde in Mhaura (H-8). This quest follows Expertise. He seeks an ingredient known as Crawler's Eggs.",
        "Obtain Crawler's Eggs and bring them to Rycharde to complete the quest. You receive 3,000 gil and the title Four-Star Purveyor.",
    },

    oth_mha_the_old_lady = {
        "Speak with Vera in Mhaura (G-10). You need to be level 18 or higher. Fulfill her request if you want the promised rewards.",
        "Obtain a Bloody Robe, a Dhalmel Saliva and a Wild Rabbit Tail and bring them to Vera.",
        "Completing the quest unlocks your Support Job.",
    },

    oth_mha_the_sand_charm = {
        "Speak with Blandine in Mhaura (I-9) to begin the quest. You need Windurst fame level 4.",
        "Speak with Zexu.",
        "Exit the dock, then talk to Blandine again.",
        "Speak with Celestina in the nearby Goldsmithing Guild. The quest now shows in your log.",
        "Obtain a Sand Charm, which drops from Crossbones on the Ferry between Mhaura and Selbina. Crossbones appear on the ferry only when pirates attack, which is a rare occurrence.",
        "Trade the Sand Charm to Celestina to complete the quest and receive the Map of Bostaunieux Oubliette.",
    },

    oth_mha_unending_chase = {
        "You need to wait 8 real-life hours (8 game days) after completing Way of the Cook before this quest is offered. Speak with Rycharde in Mhaura (I-8). He wants you to get him an ingredient called a puffball.",
        "Obtain a Puffball and trade it to Rycharde to complete the quest. You receive 2,100 gil and the title Two-Star Purveyor.",
    },

    oth_mha_way_of_the_cook = {
        "You need to wait 8 real-life hours after completing Rycharde the Chef before this quest is offered. Speak with Rycharde in Mhaura to begin it. He needs your help finding some ingredients: a beehive chip and some dhalmel meat.",
        "Obtain a Beehive Chip and a Dhalmel Meat and trade them to Rycharde to complete the quest. You receive between 1,000 and 1,500 gil and the title One-Star Purveyor.",
    },

    -- ========================================================
    -- SELBINA
    -- ========================================================

    oth_sel_explorers_footsteps = {
        "Talk to Abelard in Selbina (G-9) to receive some Selbina Clay. You need to be level 15 or higher. The mayor wants you to find the stone monuments left by a certain adventurer and copy their writings to clay.",
        "Take the Selbina Clay to the Stone Monuments around the world and copy their writings. Repeat for the remaining Stone Monuments; the quest does not complete until you finish all the tablets.",
        "Return the tablets to Abelard. When you finish them all you receive the Map of the Crawlers' Nest. You can repeat the quest.",
        "Three more monuments exist in the Shadowreign: Vunkerl Inlet (S) at (E-12), Grauberg (S) at (F-5) and Fort Karugo-Narugo (S) at (E-7), outside the map. You can copy them with the Selbina Clay, but when you trade them there is no response from Abelard.",
    },

    oth_sel_cargo = {
        "Talk to Vuntar in Selbina (H-9). He will pay a premium price for rolanberries, but only for those that are thoroughly aged and can serve as food for long voyages.",
        "Purchase some Rolanberries.",
        "Proceed to the Crawlers' Nest to turn your Rolanberries into higher quality Rolanberries.",
        "Trade the aged Rolanberries to Vuntar to complete the quest. The payment depends on the Rolanberry you hand in. You can repeat the quest.",
    },

    oth_sel_donate_to_recycling = {
        "Speak with Romeo in Selbina (H-9). You need Other fame level 1. Donate five pieces of onion equipment to help new recruits everywhere; donors may receive an award.",
        "Trade him five pieces of the same type of onion equipment to complete the quest. You receive a Wastebasket and the title Ecologist.",
    },

    oth_sel_elder_memories = {
        "Speak with Isacio in Selbina (G-10). You need to be level 18 or higher. You must prove yourself worthy before you can learn his fighting techniques.",
        "Obtain a Damselfly Worm, a Magicked Skull and a Crab Apron and bring them to Isacio.",
        "Completing the quest unlocks your Support Job.",
    },

    oth_sel_inside_the_belly = {
        "Speak with Zaldon in Selbina (H-9). This quest follows The Real Gift. You need a Fishing skill of 30 or higher; you can use gear and Advanced Synthesis Image Support to reach it. Some fish in Vana'diel like to eat shiny objects, and Zaldon will cut open any you catch.",
        "Trade Zaldon certain fish and he will gut them for you. What you receive depends on the fish, and some of them earn a title. You can repeat the quest.",
    },

    oth_sel_only_the_best = {
        "Speak with Melyon in Selbina (I-9). You need Other fame level 1. He will pay premium prices for any of the following: five heads of La Theine Cabbage, three ears of Millioncorn, or one clump of Boyahda Moss.",
        "Trade Melyon any one of those sets to complete the quest and receive between 100 and 600 gil. If you have already completed the quest at least once, you do not need to speak to him again to start it; you can simply trade the items again.",
        "Repeating this quest several times is the easiest way to improve your reputation in Bastok, San d'Oria, Jeuno, Selbina and Rabao. You can repeat the quest.",
    },

    oth_sel_picture_perfect = {
        'Steps not added yet.',
    },

    oth_sel_the_gift = {
        "You need to have finished Under the Sea to get this quest. Speak with Oswald in Selbina (I-9). He wants to order something nutritious to cheer his girlfriend up a bit, and asks you for the special ingredient, a Danceshroom.",
        "Trade Oswald a Danceshroom to complete the quest and receive the Sleep Dagger. Danceshrooms can be bought at the Auction House under Food, Ingredients.",
    },

    oth_sel_the_real_gift = {
        "The Sand Charm must be completed before you are offered this quest. Speak with Oswald in Selbina (I-9) to begin it.",
        "Trade Oswald a Shall Shell to complete the quest. You receive the Glass Fiber Fishing Rod and the title The Love Doctor.",
    },

    oth_sel_the_rescue = {
        "Speak with Thunder Hawk in Selbina (G-9) to begin the quest. He wants you to rescue two merchants from captivity; they should be somewhere in the Quadav camp in Beadeaux.",
        "Head to Beadeaux and kill a De'Vyu Headhunter to obtain a Quadav Charm.",
        "Head to (I-8) and trade the Quadav Charm to the Jail Door, on the ground floor, for a cutscene and a Trader's sack.",
        "Return to Thunder Hawk for a storytelling scene and your reward, the Map of the Ranguemont Pass and 3,000 gil, and the title Honorary Citizen of Selbina.",
    },

    oth_sel_test_my_mettle = {
        "Speak with Devean in Selbina (I-8). He asks you to bet on how long it takes you to get a pair of Power Sandals from Davoi. Find the pair of Power Sandals hidden in a jar somewhere in Davoi and bring them back before time runs out for a cash prize.",
        "The quicker you return, the more money you get back. The time is measured in game hours, not Earth hours.",
        "Once in Davoi you need to locate a Jar that contains the Power Sandals. The jar can spawn at (I-8), (K-9), (J-8), (H-8), (F-6), (J-9), (F-9), (G-9), (H-9) and (F-7).",
        "Return the Power Sandals to Devean before time runs out. You can also choose to keep the Power Sandals for yourself, but that means you fail the quest.",
    },

    oth_sel_under_the_sea = {
        "Speak with Oswald in Selbina (I-9). This quest involves a Fat Greedie, a fish that can be caught in the sea at Selbina, and an Etched ring.",
        "Bring the ring back to Oswald for your reward, the Amber Earring.",
    },

    -- ========================================================
    -- TAVNAZIAN SAFEHOLD
    -- ========================================================

    oth_tvs_a_bitter_past = {
        "Talk to Frescheque in Tavnazian Safehold (H-8, 3rd floor) to start the quest.",
        "Talk to Raminey (J-7, 3rd floor).",
        "Talk to Equette (I-9, 2nd floor).",
        "Defeat the NMs and select the ??? again to obtain the Tiny wristlet.",
        "Return to the Tavnazian Safehold and talk to Frescheque for your reward, the Yinyang Lorgnette. Talk to Equette again for an additional cutscene.",
    },

    oth_tvs_hard_days_knight = {
        "Talk to Quelveuiat in Tavnazian Safehold (I-10, middle floor).",
        "Zone into Lufaise Meadows by taking the south exit at (I-6), then head to (H-10). Clear any nearby Orcs, as they will link.",
        "Click the ??? at the top of the platform to spawn Splinterspine Grukjuk, a Ranger Orc NM, and defeat it.",
        "Return to Tavnazian Safehold and speak with Quelveuiat to complete the quest and receive 2,100 gil.",
        "Optional: after completing the quest you may trade Quelveuiat a Sealion Crest Key and a Coral Crest Key to obtain a Temple Knight key, which lets you open the large door to the inner part of Sacrarium at (H-7) solo.",
    },

    oth_tvs_behind_the_smile = {
        "Talk to Enaremand in Tavnazian Safehold (J-7, Home Point #3), on the upper level. This quest follows It's Raining Mannequins and requires the Chains of Promathia pack. One last material is required to complete his final masterpiece, and the mannequin craftswoman in Mhaura may have clues.",
        "Go to Mhaura and talk with Fyi Chalmwoh at (G-8).",
        "Go to Carpenters' Landing, entering from Jugner Forest at (J-8), where you will fight an Orc NM. When you touch the ???, Bullheaded Grosvez spawns.",
        "After you have defeated Bullheaded Grosvez, touch the ??? again to receive the Red oil.",
        "Go back to the Tavnazian Safehold and talk to Enaremand again for your reward, the Mannequin Pumps.",
    },

    oth_tvs_elderly_pursuits = {
        "This quest follows Secrets of Ovens Lost and requires the Chains of Promathia pack. Speak with Despachiaire in Tavnazian Safehold (K-10). He has asked you to investigate the origin of his late wife's amulet.",
        "Investigate the amulet's origin and return to Despachiaire for your reward, the Elegant Ribbon.",
    },

    oth_tvs_fly_high = {
        "Speak with Ferchinne in Tavnazian Safehold (G-9) to begin the quest. You need to be on or past Promathia Mission 4-2 and have the Chains of Promathia pack.",
        "Obtain 2 Hippogryph Tailfeathers and trade them to Ferchinne for your reward, the Mistmelt. You can repeat the quest.",
    },

    oth_tvs_go_go_gobmuffin = {
        "To activate this quest you must be on or past Promathia Mission 4-2 and have zoned into Riverne - Site B01. You need the Chains of Promathia pack.",
        "Speak with Epinolle in Tavnazian Safehold (F-8) to begin the quest.",
        "Enter Riverne - Site B01 and defeat the goblin NMs Book Browser Bokabraq, Chemical Cook Chemachiq and Spell Spitter Spilospok.",
        "Return to Epinolle for your reward, the Map of Cape Riverne.",
    },

    oth_tvs_search_of_the_truth = {
        "Speak with Tressia in Tavnazian Safehold (J-6). You need to have completed Darkness Named and have the Chains of Promathia pack. Search for information regarding what happened on the day Wazozo's treasure was stolen.",
        "Return to Tressia with what you found for your reward, the Gramary Cape.",
    },

    oth_tvs_name_of_science = {
        "Start the quest by talking to Yurim in Tavnazian Safehold (J-8), on the top floor. This quest requires the Chains of Promathia pack.",
        "Choose a reward, then trade the appropriate base item and chip to Yurim. Be careful: you cannot cancel the quest after making your decision. You can repeat the quest.",
    },

    oth_tvs_forbidden_doors = {
        "Wait up to 1 minute after completing Behind the Smile. Talk with Enaremand in Tavnazian Safehold (J-7).",
        "Talk to Chemioue (J-6). If you have not done Petals for Parelbriaux and you are at Promathia Mission 3-5 or later, you may get that cutscene first.",
        "Go to Phomiuna Aqueducts, find a Wooden Ladder at (C-9) on the second map, and climb the ladder for a cutscene.",
        "Complete the rest of the quest to be able to pose your mannequin.",
    },

    oth_tvs_paradise_salvation = {
        "Speak with Nivorajean in Tavnazian Safehold (I-9), on the surface level. You need to be level 50 or higher, have the Chains of Promathia pack, and have Promathia Mission 4-3 flagged for Sacrarium access. To complete a map of the Sacrarium, she needs you to find a piece of the old floorplans.",
        "Find the piece of the old floorplans in the Sacrarium and bring it back to Nivorajean for your reward, the Map of the Sacrarium.",
    },

    oth_tvs_petals_for_parelbriaux = {
        "Speak with Chemioue on the top floor of Tavnazian Safehold (J-6), slightly north of Home Point #3, for a cutscene. You need to have completed Promathia Mission 3-5 and have the Chains of Promathia pack.",
        "If you get a cutscene about a Shikaree tracker, that is for Tango with a Tracker: go talk to Despachiaire at (K-10), behind a Walnut Door, then return to Parelbriaux and talk to him twice more for a cutscene with Chemioue.",
        "Speak with Ondieulix at (I-7) to receive your reward, the Powerful Rope.",
    },

    oth_tvs_secrets_of_ovens_lost = {
        "Talk to Despachiaire in Tavnazian Safehold (K-10), on the top floor. This quest follows Spice Gals and requires the Chains of Promathia pack.",
        "Talk to Jonette on the middle floor, near the stream at (G-9).",
        "Complete the rest of the quest to receive a page from Miratete's Memoirs.",
    },

    oth_tvs_requiem_of_sin = {
        "This quest follows Tango with a Tracker and requires the Chains of Promathia pack. Speak with Despachiaire in Tavnazian Safehold (K-10).",
        "Complete the quest to receive your reward, which varies, and the title Disciple of Justice. You can repeat the quest.",
    },

    oth_tvs_the_big_one = {
        'Steps not added yet.',
    },

    oth_tvs_call_of_the_sea = {
        "Speak with Leporaitceau in Tavnazian Safehold (J-8, 3rd floor).",
        "Speak with Equette (I-9, 2nd floor).",
        "Speak with Anteurephiaux (J-8, 3rd floor) to officially begin the quest.",
        "Travel to Misareaux Coast and look for a ??? at (K-12). Checking the ??? spawns the NM Bloody Coffin.",
        "Once the NM is defeated, check the ??? again to receive the key item Whispering conch.",
        "Return to Anteurephiaux. Finally, speak with Equette to complete the quest and receive the Memento Muffler.",
    },

    oth_tvs_unforgiven = {
        "Speak with Elysia on the first floor of Tavnazian Safehold (G-10) to begin the quest. She dropped her hairpin while doing her shopping.",
        "Head up to the second floor of the safehold and examine the ??? behind the pillar at (K-9), near the Walnut Door. You obtain the Alabaster hairpin.",
        "Return to Elysia for your reward, the Map of Tavnazia.",
    },

    oth_tvs_uninvited_guests = {
        "Speak with Justinius on the second floor of Tavnazian Safehold (J-6) to activate the quest and receive a Monarch Linn Patrol Permit. You need Other fame level 1, and the Chains of Promathia mission The Savage must be complete.",
        "Take the permit to Monarch Linn and complete the task there.",
        "Return to Justinius for your reward.",
    },

    oth_tvs_x_marks_the_spot = {
        "Talk to Despachiaire in Tavnazian Safehold (K-10, upper level), behind the Walnut Door at (K-9), to start the quest.",
        "Obtain a Tavnazian Liver and bring it to Despachiaire for your reward, 4,000 gil.",
    },

    oth_tvs_tango_with_a_tracker = {
        "Speak with Despachiaire in Tavnazian Safehold (K-10) to obtain the Letter from Shikaree X. The letter has arrived in the safehold, and she wants to gauge your battle prowess in Boneyard Gully.",
        "Head to Boneyard Gully and select \"Tango with a Tracker\" at the Dark Miasma to enter a battlefield.",
        "Win the battle to complete the quest and receive 10,000 gil.",
    },

    oth_tvs_vw_op_026 = {
        'Steps not added yet.',
    },

    -- ========================================================
    -- CARPENTERS' LANDING
    -- ========================================================

    oth_cpl_mithran_delicacies = {
        'Steps not added yet.',
    },

    -- ========================================================
    -- RIVERNE - SITE A01
    -- ========================================================

    oth_riv_confessions_bellmaker = {
        "Travel to Riverne - Site #A01 and check the Stone Monument at (C-7). You receive a cutscene and the Ornamented scroll.",
        "Speak with Reinberta in Bastok Markets (I-8).",
        "Speak with Mevreauche in Northern San d'Oria (E-6).",
        "Head back to the Stone Monument in Riverne - Site #A01 and check it for a cutscene. Examine it again to spawn the NM Arcane Phantasm.",
        "After defeating the NM, click the Stone Monument once more to complete the quest and receive the Minstrel's Dagger.",
    },

    oth_riv_vw_op_004 = {
        'Steps not added yet.',
    },

    -- ========================================================
    -- ULEGUERAND RANGE
    -- ========================================================

    oth_ule_bombs_away = {
        "You need to be on or past the Chains of Promathia mission Flames for the Dead. Speak with Buffalostalker Dodzbraz in Uleguerand Range (F-9), just southeast of the Unity warp level 128. He is an Orc who despises snolls.",
        "Obtain 2 Cluster Cores, a fairly common drop from Cluster-type monsters.",
        "Trade him the two Cluster Cores to receive your reward, the Shu'Meyo Salt. You can repeat the quest.",
    },

    -- ========================================================
    -- LA THEINE PLATEAU
    -- ========================================================

    oth_lat_waking_the_beast = {
        "Speak with Carbuncle at the ??? in La Theine Plateau (G-6). You must first have obtained spirit pacts with the 6 summonable Celestial avatars before you are presented with the Rainbow resonator.",
        "Use the Rainbow resonator to enter the battlefield.",
        "Once the three avatars are defeated, five Carbuncle Primes spawn at once. Defeat all five Carbuncle Primes to win the battle.",
        "Every player who participates in the final fight receives a Carbuncle's Pole. All other quest rewards are dropped at random at the end of the Carbuncle Prime battle.",
    },

    -- ========================================================
    -- OLDTON MOVALPOLOS
    -- ========================================================

    oth_old_generous_general = {
        'Steps not added yet.',
    },

    oth_old_missionary_moblin = {
        "Speak with Koblakiq in Oldton Movalpolos (H-11) to begin the quest. This quest requires the Chains of Promathia pack.",
        "Obtain a Soiled Letter and trade it to Koblakiq to complete the quest and receive 4,000 gil.",
    },

    oth_old_for_the_birds = {
        "After completing Missionary Moblin you need to zone out and back in to initiate this quest. Talk to Koblakiq in Oldton Movalpolos (H-11) to begin it. A letter has arrived from Zeelozok asking for an arnica root to be brought to Castle Oztroja, and Koblakiq entrusts the task to you. It is suggested that you have the three beastmen stronghold Survival Guides, as the quest requires traveling between the three strongholds, and that you bring Echo Drops, Holy Water or someone who can cast Cursna.",
        "Obtain an Arnica Root if you have not already.",
        "Head to Castle Oztroja and go to the Brass Door at (I-8).",
        "After the fight, talk to Ge'Fhu Yagudoeye again for a short cutscene.",
        "Head back to Oldton Movalpolos and speak with Koblakiq to complete the quest and receive your Jaguar Mantle.",
    },

    oth_old_better_the_demon = {
        "Speak with Koblakiq in Oldton Movalpolos (H-11) to begin the quest. Make sure you have zoned after completing For the Birds. To save time, you can bring a Demon Pen with you when you travel to start this quest.",
        "Head to Castle Zvahl Baileys and fight Blood Demons and Demon Generals until you obtain a Demon Pen.",
        "Trade the Demon Pen to Koblakiq to complete the quest and receive the Goblin Grenade.",
    },

    -- ========================================================
    -- MOG HOUSE
    -- ========================================================

    oth_mog_give_moogle_break = {
        "Place a Bronze Bed in your Mog House using the furniture Layout menu. You need Other fame level 3 (home nation fame). Wait one Earth minute, exit your Mog House, re-enter and speak to the Moogle. If you have enough fame, you receive a cutscene.",
        "Trade the Moogle the items he asks for: a Power Bow and a Beetle Ring. The Power Bow can be bought from a Records of Eminence NPC using Sparks (equip level 10 to 19). The Beetle Ring +1 does not count.",
        "When your Moogle returns from his trip after one Earth minute (without ever leaving your Mog House), he gives you a Mog Safe that holds 60 items and you receive the title Mog's Kind Master.",
    },

    oth_mog_moogles_in_the_wild = {
        "Place a bed in your Mog House using the furniture Layout menu, exit your Mog House, re-enter it and speak to your Moogle. You need to have completed The Moogle's Picnic! and have Other fame level 7 (home nation fame).",
        "Your moogle wants to take a raptor mantle and a wool hat to his friends in the Outlands. Trade him the items he requests.",
        "When he returns from his trip, your Mog Safe capacity is increased to 80 items.",
    },

    oth_mog_moogles_picnic = {
        "Place a Mahogany Bed in your Mog House, then speak to the Moogle. You need to have completed Give a Moogle a Break. Zone out of your Mog House and then come back.",
        "Your moogle wants to take a shrimp lure and some Selbina butter back home. He would be very happy if you found them for him; trade him the items.",
        "When he returns from his trip, your Mog Safe capacity is increased to 70 items.",
    },

    -- ========================================================
    -- DAVOI
    -- ========================================================

    oth_dav_understanding_overlord = {
        'Steps not added yet.',
    },

    -- ========================================================
    -- BEADEAUX
    -- ========================================================

    oth_bea_affable_adamantking = {
        'Steps not added yet.',
    },

    -- ========================================================
    -- PASHHOW MARSHLANDS
    -- ========================================================

    oth_pas_monstrosity = {
        'Steps not added yet.',
    },

    -- ========================================================
    -- XARCABARD
    -- ========================================================

    oth_xar_survival_of_wisest = {
        'Steps not added yet.',
    },

    -- ========================================================
    -- MULTI-NATION
    -- ========================================================

    oth_mul_moral_manifest = {
        "Enter the Altar Room, in Castle Oztroja, for a cutscene with Hooknox that starts the quest. You need to be level 60 or higher. You are given a choice to start the quest or not.",
        "Obtain a Yagudo Headgear. It is crafted with Clothcraft (skill 80).",
        "Return to the Altar Room while wearing your Yagudo Headgear for a cutscene. You receive the key item Vault quipus.",
        "Defeat the Yagudo Avatar. The other Yagudo NMs in the room are Duu Masa the Onecut, Fee Jugu the Ramfist, Goo Pake the Bloodhound, Kee Taw the Nightingale, Laa Yaku the Austere and Poo Yozo the Babbler.",
        "Trade your Yagudo Headgear to the Stone Lid for a cutscene; it is replaced by Tsoo's Headgear.",
        "Zone out to the south of the Altar Room and then back into the zone for a cutscene and a Gold Beastcoin. You receive the title Yagudo Initiate.",
    },

    oth_mul_records_of_eminence = {
        'Steps not added yet.',
    },

    oth_mul_unity_concord = {
        'Steps not added yet.',
    },

}

return Q