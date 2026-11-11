local Q = {}

Q.STEPS = {

    -- ========================================================
    -- JEUNO
    -- ========================================================

    jeu_lj_path_of_the_bard = {
        "You need to be level 30 or higher. Speak with Bki Tbujhja in Lower Jeuno (H-8), inside the Merry Minstrel.",
        "Travel through the tunnel in Valkurm Dunes (C-6) to the Secret Beach and examine the Song Runes (B-7) for a last cutscene.",
        "A quick way to reach the destination is to take the Survival Guide to Gustav Tunnel, then exit to Valkurm Dunes.",
        "This quest does not appear in your quest list until it is completed.",
    },

    jeu_lj_save_my_son = {
        "You need to be level 30 or higher. Examine the Door: Merchant's House on the second floor in Lower Jeuno (G-11), above the chocobo stables.",
        "Speak with Shalott in Upper Jeuno (G-7), outside the Chocobo Stables, for a cutscene.",
        "Examine the Door: Merchant's House in Lower Jeuno (G-11) again for another cutscene.",
        "Examine the Night Flowers down the ramp in Qufim Island (F-8) between 21:30 and 4:00 for a cutscene.",
        "A Kraken (level 37-38) may spawn above the Night Flowers.",
        "Examine the Door: Merchant's House in Lower Jeuno for a cutscene and your rewards.",
    },

    jeu_uj_axe_the_competition = {
        "You cannot start this quest if you have another Weapon Skill quest active; return to the person who gave it and quit it first. You need Axe skill 240 or higher and level 71.",
        "Speak with Brutus in Upper Jeuno (G-7) to receive the key item Weapons Training Guide and the Pick of Trials. You need to break the latent on the Pick of Trials before completing the rest of the quest.",
        "Trade the Pick of Trials back to Brutus.",
        "The page gives these directions for the next part: follow the path to the T-intersection and head north, follow the path and exit the Temple, and once inside follow the path south to the ???.",
        "Go back and speak with Brutus to receive your reward, the Decimation weapon skill.",
    },

    jeu_uj_chocobo_on_the_loose = {
        "Head to Upper Jeuno and speak with Brutus at (G-7). This quest starts the first time you speak to him, together with Chocobo's Wounds.",
        "Help the chocobo leave when prompted.",
        "Head to La Theine Plateau and check the Chocobo Tracks at the far northwest corner of (E-5), just south of the sliver of map in (E-4).",
        "Return to Upper Jeuno and speak to Brutus (G-7) again.",
        "Return to Brutus (G-7) in Upper Jeuno one last time to complete the quest.",
        "Speak to Brutus (G-7) after one game day to receive a chocobo egg. You must change zones and return to Upper Jeuno after the day change.",
        "Trade the egg to one of the VCS Trainers located in Bastok Mines, Southern San d'Oria or Windurst Woods to begin raising a chocobo.",
    },

    jeu_uj_chocobos_wounds = {
        "To begin, speak with Brutus in Upper Jeuno (G-7) on any job at level 20 or higher. This starts the quest Chocobo on the Loose! first, and this quest follows it.",
        "Speak to him two more times to start the correct quest, and choose \"Nope, never!\".",
        "Obtain Gausebit Grass x4. It drops from Wadi Hare enemies in Dangruf Wadi and Crane Fly enemies in Meriphataud Mountains.",
        "Feed the chocobo standing next to Osker by trading it one Gausebit Grass. You can feed it once every real life minute.",
        "It takes 6 feeding attempts to complete the quest. The first 2 attempts automatically fail and do not consume a grass.",
        "Once the chocobo has eaten the Gausebit Grass x4, you are presented with a Chocobo license.",
    },

    jeu_uj_path_of_the_beastmaster = {
        "Complete the prior quests Chocobo's Wounds and Save My Son. You need to be level 30 or higher.",
        "Speak with Brutus in Upper Jeuno (G-7) for a cutscene. You may have to talk to him multiple times to get the cutscene.",
        "This quest does not show up in your quest log until it is completed.",
    },

    jeu_uj_wings_of_gold = {
        "Speak with Brutus in Upper Jeuno (G-7) as a Beastmaster of level 40 or higher. From this point on you can complete the quest on any job.",
        "Kill monsters on the 7th to 10th floors of Upper Delkfutt's Tower until you get a Delkfutt Chest Key. Alternatively, you can buy one from the Curio Vendor Moogle.",
        "Use the key to open a chest in the zone to receive a Guiding bell.",
        "Return to Brutus to receive your reward, the Barbaroi Axe.",
    },

    jeu_uj_scattered_into_shadow = {
        "Speak with Brutus in Upper Jeuno (G-7) as a Beastmaster of level 50 or higher; he gives you three Aquaflora key items. From here on you can be on any job.",
        "Examine the pools on map 2 of Fei'Yin, located at (H-8), (H-5) and lastly (F-5). They are the little green marks on the map. Home Point #2, just outside the Cloister of Frost, is the closest warp.",
        "When the pool at (F-5) is examined, the NM Dabotz's Ghost spawns. It uses Curse often.",
        "Return to Brutus for a cutscene.",
        "Next, head to Castle Oztroja and kill the monsters to find an Oztroja Chest Key.",
        "Use the key to open a chest inside the castle to receive a Beast Collar.",
        "Return to Brutus for your reward.",
    },

    jeu_uj_borghertz_calling_hands = {
        "If you have any other Borghertz's Hands quest active, you must complete that one before you can start this quest.",
        "Travel to the Durable Shields shop and speak with Guslam in Upper Jeuno (H-8) as a Summoner of level 50 or higher to begin the quest. You need the Rise of the Zilart pack.",
        "You do not need to be on Summoner when opening the coffer, only when accepting the quest. A Grotto Coffer Key and a Mythril Beastcoin (if you do not have access to the Proto-Waypoints) are required for this quest.",
        "Return to Upper Jeuno and speak with Guslam. After the cutscene, the quest is complete.",
        "Guslam mentions that there is still armor scattered about Vana'diel. These coffers are not required to complete the quest: once you receive your hands the quest is completed, but it must be either active or completed for you to receive those attire pieces.",
    },

    jeu_uj_borghertz_chasing_hands = {
        "If you have any other Borghertz's Hands quest active, you must complete that one before you can start this quest.",
        "Travel to the Durable Shields shop and speak with Guslam in Upper Jeuno (H-8) as a Ranger of level 50 or higher to begin the quest. This quest follows Fire and Brimstone.",
        "Go to Garlaige Citadel. Either obtain a Garlaige Coffer Key or pick the lock as a Thief.",
        "Return to Upper Jeuno and speak with Guslam. After the cutscene, the quest is complete.",
        "Guslam mentions that there is still armor scattered about Vana'diel. These coffers are not required to complete the quest: once you receive your hands the quest is completed, but it must be either active or completed for you to receive those attire pieces.",
    },

    jeu_uj_borghertz_dragon_hands = {
        "If you have any other Borghertz's Hands quest active, you must complete that one before you can start this quest.",
        "Travel to the Durable Shields shop in Upper Jeuno and speak with Guslam at (H-8) as a Dragoon of level 50 or higher to begin the quest. This quest requires the Rise of the Zilart pack and follows Chasing Quotas.",
        "Go to The Boyahda Tree. Either obtain a Boyahda Coffer Key or pick the lock as a Thief.",
        "Return to Upper Jeuno and speak with Guslam. After the cutscene, the quest is complete.",
        "Guslam mentions that there is still armor scattered about Vana'diel. These coffers are not required to complete the quest: once you receive your hands the quest is completed, but it must be either active or completed for you to receive those attire pieces.",
    },

    jeu_uj_borghertz_harmonious_hands = {
        "If you have any other Borghertz's Hands quest active, you must complete that one before you can start this quest.",
        "Travel to the Durable Shields shop and speak with Guslam in Upper Jeuno (H-8) as a Bard of level 50 or higher to begin the quest.",
        "Obtain a Zvahl Coffer Key. The Curio Vendor Moogle sells it; alternatively you can farm the key or pick the lock as a Thief.",
        "You do not need to be on Bard when opening the coffer. You receive the key item Old gauntlets from the coffer.",
        "Return to Upper Jeuno and speak with Guslam.",
        "You must be on Bard for the next step.",
        "Guslam mentions that there is still armor scattered about Vana'diel. You can find two more pieces of armor by opening coffers in other zones with the corresponding coffer key. These coffers are not required to complete the quest: once you receive your hands the quest is completed.",
    },

    jeu_uj_borghertz_healing_hands = {
        "If you have any other Borghertz's Hands quest active, you must complete that one before you can start this quest.",
        "Travel to the Durable Shields shop and speak with Guslam in Upper Jeuno (H-8) as a White Mage to begin the quest. Once you have started it as a White Mage you may complete the other steps on a different job, even finishing the quest and receiving the Healer's Mitts.",
        "Go to Beadeaux and find a Treasure Coffer. Either obtain a Beadeaux Coffer Key or pick the lock as a Thief. The key is sold for 5,000 gil by the Curio Vendor Moogle.",
        "You receive the key item Old gauntlets from the coffer.",
        "Return to Upper Jeuno and speak with Guslam.",
        "Once Dark Spark is defeated, examine one of the torches to receive the key item Shadow flames.",
        "Guslam mentions that there is still armor scattered about Vana'diel. You can find two more pieces of armor by opening coffers in other zones with the corresponding coffer key. These coffers are not required to complete the quest: once you receive your hands the quest is completed.",
    },

    jeu_uj_borghertz_loyal_hands = {
        "If you have any other Borghertz's Hands quest active, you must complete that one before you can start this quest.",
        "Travel to the Durable Shields shop and speak with Guslam in Upper Jeuno (H-8) as a Samurai of level 50 or higher to begin the quest. This quest requires the Rise of the Zilart pack.",
        "Either obtain a Kuftal Coffer Key or pick the lock as a Thief. You do not need to be on Samurai when opening the coffer.",
        "You receive the key item Old gauntlets from the coffer.",
        "Return to Upper Jeuno and speak with Guslam.",
        "Once Dark Spark is defeated, examine one of the torches to receive the key item Shadow flames.",
        "Guslam mentions that there is still armor scattered about Vana'diel. You can find two more pieces of armor by opening coffers in other zones with the corresponding coffer key. These coffers are not required to complete the quest: once you receive your hands the quest is completed.",
    },

    jeu_uj_borghertz_lurking_hands = {
        "If you have any other Borghertz's Hands quest active, you must complete that one before you can start this quest.",
        "Travel to Durable Shields in Upper Jeuno and speak with Guslam at (H-8) as a Ninja of level 50 or higher to begin the quest. This quest requires the Rise of the Zilart pack and follows 20 in Pirate Years.",
        "Go to Ifrit's Cauldron. A quick route is the Unity Warp (level 122) to Yhoator Jungle, then hug the right wall; it is a short ride.",
        "Return to Upper Jeuno and speak with Guslam. If you have completed the AF hands quest on another job, you do not need to view this cutscene or pay gil.",
        "Guslam mentions that there is still armor scattered about Vana'diel. These coffers are not required to complete the quest: once you receive your hands the quest is completed.",
    },

    jeu_uj_borghertz_shadowy_hands = {
        "If you have any other Borghertz's Hands quest active, you must complete that one before you can start this quest.",
        "Travel to the Durable Shields shop and speak with Guslam in Upper Jeuno (H-8) as a Dark Knight of level 50 or higher to begin the quest. This quest follows Dark Puppet.",
        "Go to The Eldieme Necropolis. You can buy the permanent key item Magicked astrolabe for 10,000 gil from Churano-Shurano in Windurst Waters (F-8).",
        "Return to Upper Jeuno and speak with Guslam. If this is your first time completing a Borghertz's Hands quest for any job, there are additional steps first.",
        "Guslam mentions that there is still armor scattered about Vana'diel. These coffers are not required to complete the quest: once you receive your hands the quest is completed.",
    },

    jeu_uj_borghertz_sneaky_hands = {
        "If you have any other Borghertz's Hands quest active, you must complete that one before you can start this quest.",
        "Travel to the Durable Shields shop in Upper Jeuno and speak with Guslam at (H-8) as a Thief of level 50 or higher to begin the quest. This quest follows As Thick as Thieves.",
        "Go to Davoi, then travel to Monastic Cavern and locate a Treasure Coffer. Either obtain a Davoi Coffer Key to open it, or pick the lock. You do not need to be on Thief when opening the coffer.",
        "Return to Upper Jeuno and speak with Guslam inside the Durable Shields shop.",
        "Guslam mentions that there is still armor scattered about Vana'diel. These coffers are not required to complete the quest: once you receive your hands the quest is completed.",
    },

    jeu_uj_borghertz_sorcerous_hands = {
        "If you have any other Borghertz's Hands quest active, you must complete that one before you can start this quest.",
        "Travel to the Durable Shields shop in Upper Jeuno and speak with Guslam at (H-8) as a Black Mage of level 50 or higher to begin the quest. This quest follows The Three Magi.",
        "Go to Garlaige Citadel and find a Treasure Coffer. Either obtain a Garlaige Coffer Key or pick the lock as a Thief. The Curio Vendor Moogle sells the key for 5,000 gil.",
        "Return to Upper Jeuno and speak with Guslam.",
        "Guslam mentions that there is still armor scattered about Vana'diel. These coffers are not required to complete the quest: once you receive your hands the quest is completed.",
    },

    jeu_uj_borghertz_stalwart_hands = {
        "If you have any other Borghertz's Hands quest active, you must complete that one before you can start this quest.",
        "Travel to the Durable Shields shop and speak with Guslam in Upper Jeuno (H-8) as a Paladin of level 50 or higher to begin the quest. This quest requires the Rise of the Zilart pack and follows A Boy's Dream.",
        "Go to The Eldieme Necropolis. You can buy the permanent key item Magicked astrolabe for 10,000 gil from Churano-Shurano in Windurst Waters (F-8); it lets you open the doors in The Eldieme Necropolis by yourself.",
        "Return to Upper Jeuno and speak with Guslam. Then head to Lower Jeuno, inside the Tenshodo area.",
        "Guslam mentions that there is still armor scattered about Vana'diel. These coffers are not required to complete the quest: once you receive your hands the quest is completed.",
    },

    jeu_uj_borghertz_striking_hands = {
        "If you have any other Borghertz's Hands quest active, you must complete that one before you can start this quest.",
        "Travel to the Durable Shields shop and speak with Guslam in Upper Jeuno (H-8) as a Monk of level 50 or higher to begin the quest.",
        "You do not need to be on Monk when opening the coffer. You receive the key item Old gauntlets from the coffer.",
        "Return to Upper Jeuno and speak with Guslam. He informs you that he is unable to repair the gauntlets.",
        "If this is your first AF, do the following steps; otherwise skip them. Go to Port Jeuno and head to the crates near the Auction House and the Jeuno Duty-Free Shop at (H-8), and click on the ??? for a cutscene.",
        "Travel to Castle Zvahl Baileys and go to (F-8) on the first map. Click on one of the torches to spawn Dark Spark.",
        "Once Dark Spark is defeated, examine one of the torches to receive the key item Shadow flames.",
        "Return to Port Jeuno and examine the ???.",
        "Guslam mentions that there is still armor scattered about Vana'diel. These coffers are not required to complete the quest: once you receive your hands the quest is completed.",
    },

    jeu_uj_borghertz_vermillion_hands = {
        "If you have any other Borghertz's Hands quest active, you must complete that one before you can start this quest.",
        "Travel to the Durable Shields shop and speak with Guslam in Upper Jeuno (H-8) as a Red Mage of level 50 or higher to begin the quest. This quest follows The Crimson Trial.",
        "Go to The Eldieme Necropolis and find a Treasure Coffer.",
        "Return to Upper Jeuno and speak with Guslam. Then click on the ???.",
        "Guslam mentions that there is still armor scattered about Vana'diel. These coffers are not required to complete the quest: once you receive your hands the quest is completed.",
    },

    jeu_uj_borghertz_warring_hands = {
        "If you have any other Borghertz's Hands quest active, you must complete that one before you can start this quest.",
        "Travel to the Durable Shields shop and speak with Guslam in Upper Jeuno (H-8) as a Warrior of level 50 or higher to begin the quest. This quest follows The Talekeeper's Truth.",
        "Return to Upper Jeuno and speak with Guslam. If this is your first time completing a Borghertz's Hands quest for any job, there are additional steps first.",
        "Guslam mentions that there is still armor scattered about Vana'diel. These coffers are not required to complete the quest: once you receive your hands the quest is completed. Borghertz's Warring Hands must either be active or completed for you to receive those attire pieces.",
    },

    jeu_uj_borghertz_wild_hands = {
        "If you have any other Borghertz's Hands quest active, you must complete that one before you can start this quest.",
        "Travel to the Durable Shields shop and speak with Guslam in Upper Jeuno (H-8) as a Beastmaster of level 50 or higher to begin the quest. This quest follows Scattered Into Shadow.",
        "Go to Crawlers' Nest. Either obtain a Nest Coffer Key or pick the lock as a Thief. You do not need to be on Beastmaster when opening the coffer.",
        "You receive the key item Old gauntlets from the coffer.",
        "Return to Upper Jeuno and speak with Guslam. If this is your first AF, there are additional steps first.",
        "Guslam mentions that there is still armor scattered about Vana'diel. These coffers are not required to complete the quest: once you receive your hands the quest is completed.",
    },

    jeu_pj_circle_of_time = {
        "Speak with Mertaire in Lower Jeuno, who tells you to take the Star ring (tarnished) to an antique collector. You must be a Bard of level 50 or higher, and the quest does not appear in your log yet. This quest requires the Rise of the Zilart pack and follows The Requiem.",
        "Speak with Imasuke in Port Jeuno (E-6). You must have your current job set to Bard to receive the cutscene; after speaking with him you may change to any job.",
        "Travel to (I-10) in Xarcabard and examine the Perennial Snow at the end of the short tunnel. You must now wait one Earth minute before you can retrieve the ring.",
        "Retrieve the Star ring (indecipherable) by examining the Perennial Snow.",
        "Go back to Imasuke, who tells you to find someone who can translate the ring.",
        "Head to Chateau d'Oraguille and speak with Chalvatot at (F-7) to receive the Moon ring.",
        "Listen to his instructions and travel to Monastic Cavern via Davoi (H-11).",
        "Walk to the small circular room at (I-8) with the altar in it. After clearing the Orcs, examine the altar to spawn Bugaboo.",
        "Defeat Bugaboo, then examine the altar again for a cutscene.",
        "Return and speak with Chalvatot for your reward, the Choral Justaucorps, and to complete the quest.",
    },

    jeu_pj_antique_collector = {
        "Speak with Imasuke in Port Jeuno (E-6) to begin the quest. You need Jeuno fame level 2.",
        "Head to Qufim Island and kill Dancing Weapon enemies until you obtain a Kaiser Sword. Kaiser Swords can also sometimes be found at the Auction House.",
        "Trade the Kaiser Sword to Imasuke to complete the quest and receive the Map of Delkfutt's Tower.",
    },

    jeu_rg_northward = {
        "Speak with Radeivepart in Ru'Lude Gardens (H-9). He requests that you bring him a Flame Degen. You need Jeuno fame level 4.",
        "Obtain a Flame Degen. It can be purchased at the Auction House, purchased with Sparks of Eminence, crafted, or it rarely drops from Napalm enemies.",
        "Trade the Flame Degen to Radeivepart to complete the quest and receive the Map of Castle Zvahl.",
    },

    jeu_rg_defiant_challenge = {
        "Speak with Maat in Ru'Lude Gardens (H-5) on a level 50 job. You need Jeuno fame level 1.",
        "Maat asks for three items. Three key items combine into each required item. Be wary of Explosure's Self-Destruct and Exoray's conal Breath damage attacks.",
        "Bomb Coal drops from Explosure enemies, or you can receive it after obtaining three Bomb coal fragments from ??? spots.",
        "Exoray Mold drops from Exoray enemies (uncommon), or you can receive it after obtaining three Exoray mold crumbs from ??? spots.",
        "Ancient Papyrus drops from Lich enemies (common), or you can receive it after obtaining three Ancient papyrus shreds from ??? spots. Do not walk over the graves throughout the zone, as you may fall through them to a lower level.",
        "Take care while triggering the lever, as the single bomb that wanders nearby is aggressive by sight and by magic.",
        "Trade the items to Maat to complete the quest, which raises your level cap to 55.",
    },

    jeu_rg_highest_mountains = {
        "Speak with Maat in Ru'Lude Gardens (H-5) on a level 51 job. You need Jeuno fame level 1. He asks you for three key items guarded by monsters in Xarcabard.",
        "If this is your first time heading to Xarcabard, you may use the Unity level 125 warp to Xarcabard.",
        "The key items are: Round frigicite from Boreal Tiger at (I-5), Square frigicite from Boreal Coeurl at (J-6) and Triangular frigicite from Boreal Hound at (G-10).",
        "The Notorious Monsters stand guard in caves, have a fairly large aggro range, and respawn within about 5 minutes after being defeated.",
        "The ??? spot is always present at the far end of the cave, and you receive the key item once you touch it, so you do not need to defeat the Notorious Monsters: you can simply hold them while examining the spots. They no longer use draw-in according to the page, although a note says the Coeurl did use it several times when tested in 2024.",
        "Speak with Maat once you have all three key items to complete the quest, which raises your level cap to 60.",
    },

    jeu_rg_whence_blows_wind = {
        "Speak with Maat in Ru'Lude Gardens on a level 56 or higher job. You need Jeuno fame level 1. He asks for three crests, each found in a different place.",
        "The key items are: Orcish crest in Monastic Cavern (J-6), Quadav crest in Qulun Dome (J-7) and Yagudo crest in Castle Oztroja (H-6). A ??? spot appears in each of these areas, close to True-Sight or True-Sound Notorious Monsters.",
        "For the Orcish crest, either you or a player assisting you must possess the Crimson orb key item from the mini-quest. Exit Monastic Cavern at (I-8) and proceed to the (J-9) entrance of Monastic Cavern; you or a partner need a Crimson orb from Sedal-Godjal to enter. Once inside, click the ???.",
        "Lower level players may want to bring and use a Reraise item. You will need to run to the Brass Door before it closes, and after that door monsters become more challenging for low level players and dangerous by the fourth floor.",
        "Speak with Maat once you have all three key items to complete the quest, which raises your level cap to 65.",
    },

    jeu_rg_riding_on_clouds = {
        "Speak with Maat in Ru'Lude Gardens (H-5) on a level 61 or higher job. You need Jeuno fame level 1. He gives you four clues and wants you to trade a Kindred's Seal to each of the people described in the clues.",
        "You are not provided with the Kindred's Seals and need to get them yourself. Check your inventory and the Port Jeuno NPCs Shemo and Shami (Status, Currencies, Kindred's Seals Stored), as you may already have enough seals.",
        "Kindred's Seals can be acquired from any normal monster of level 50-69 that checks as Easy Prey or higher, or exchanged 3 for 1 (or 2 for 1 during certain campaigns) for other seal types from Shemo.",
        "In return for a seal you receive either a Smiling stone, Scowling stone, Somber stone or Spirited stone.",
        "Speak with Maat once you have all four stones to complete the quest, which raises your level cap to 70.",
    },

    jeu_rg_shattering_stars = {
        "Speak with Maat in Ru'Lude Gardens (H-5) on any level 66-70 job. You need Jeuno fame level 1. This limit break applies to the jobs that existed before the Treasures of Aht Urhgan expansion, and it needs the Testimony item for the job you want to fight Maat with.",
        "Once you trade the Testimony to Maat, he asks if you are ready.",
        "Trade the Testimony to the Burning Circle to enter a one-on-one battle against Maat. The time limit is 10 minutes, and after about 5 minutes from engaging Maat, he begins to use Asuran Fists. Maat has all the relevant abilities and spells of your main job.",
        "A White Mage may instead pull Maat and stay alive for 5 minutes, causing Maat to give up. A Thief may try to steal a Scroll of Instant Warp from Maat; once you steal it, Maat gives up.",
        "When Maat gives up, you receive the title Maat Masher and a Scroll of Instant Warp.",
        "Return to Ru'Lude Gardens and speak with Maat to complete the quest, which raises your level cap to 75.",
        "If you have not yet gained access to Aht Urhgan Whitegate through the quest The Road to Aht Urhgan, you may trade your Testimony afterwards under the advanced path option and complete the quest.",
    },

    jeu_rg_beyond_the_sun = {
        "This quest requires the Rise of the Zilart pack. Talk to Maat at (H-5) in Ru'Lude Gardens on each of the 15 jobs that existed before Treasures of Aht Urhgan, and defeat him with each one.",
        "The level required to fight Maat is at least level 66.",
        "To check which jobs you have beaten Maat with, enter the Feretory and speak with Teyrnon. Instincts associated with the jobs on which you have defeated Maat cost 5,000 Infamy instead of 10,000.",
        "Upon defeating Maat for the last time, speak with him to receive the cutscene and your new Maat's Cap.",
    },

    jeu_rg_storms_of_fate = {
        "After finishing all of the cutscenes after Dawn, including Blueblade Fell, walk towards the Palace in Ru'Lude Gardens to begin the cutscene with Esha'ntarl.",
        "Examine the Dilapidated Gate in Misareaux Coast (F-7) for a cutscene. The Unity warp puts you right in front of this gate.",
        "Examine the green Unstable Displacement in the northwest section of Riverne - Site #B01 (E-7) for a cutscene. You can warp and use the Home Point to get there, or farm one Giant Scale to get to (E-7) the long way.",
        "Click the green Unstable Displacement again to enter the battlefield Storms of Fate against Bahamut.",
        "Kill Bahamut for a cutscene.",
        "Return to the Palace in Ru'Lude Gardens for a cutscene that completes the quest and gives you the key item Whisper of the Wyrmking.",
    },

    jeu_rg_shadows_of_the_departed = {
        "You must complete Storms of Fate to trigger this quest, and you need the key item Whisper of the Wyrmking.",
        "Wait until the next in-game day after completing Storms of Fate to activate this quest. If you reset your memories, this wait does not apply.",
        "Walk into the Palace in Ru'Lude Gardens for the cutscene in which you receive the key item Note written by Esha'ntarl. It is a different cutscene from the one that ended Storms of Fate, which does not give a key item.",
        "Travel to the crags of Holla, Dem and Mea and investigate the coordinates where the strange readings from the Emptiness are occurring, to obtain the key items Promyvion - Holla sliver, Promyvion - Dem sliver and Promyvion - Mea sliver.",
    },

    jeu_rg_apocalypse_nigh = {
        "You need to have completed Rise of the Zilart Mission 17 and Chains of Promathia Mission 8-4. You must zone and wait until the next game day after completing the previous quest.",
        "Zone and wait until the next Vana'diel day after completing the battlefield, then talk to Gilgamesh in Norg for a cutscene to complete the quest and receive an earring of your choice.",
        "If you chose the wrong earring or want a different one, drop your earring and proceed to the Empyreal Paradox (it must be dropped before you zone into the Empyreal Paradox). The fastest way is the Home Point warp: Lumoria, The Garden of Ru'Hmet, #1, and descend.",
        "Select the ??? near the entrance and erase your memories (\"I've already forgotten them\" and \"Yes, erase my memories\"), then complete Shadows of the Departed and Apocalypse Nigh again to obtain an earring of your choice.",
    },

    jeu_rg_ducal_hospitality = {
        "You need to have completed Chains of Promathia Mission 3-2. Speak with Taillegeas in Ru'Lude Gardens (I-7) to begin the quest.",
        "He asks you to bring him a few items from a list of possible requests.",
        "Trade Taillegeas the items he requests to receive your reward, 4,000 gil. You can repeat the quest.",
    },

    jeu_rg_empty_memories = {
        "First enter any Promyvion area, and return to Harith in the Grand Duke's house in Ru'Lude Gardens (H-5) without erasing your memory at the Large Apparatus.",
        "Some monsters inside Promyvion drop items called Recollections. Trade Harith one of these Recollections plus 2,000 gil to receive an Anima: Recollection of Pain gives Hysteroanima (negates special attacks), Recollection of Fear gives Psychoanima (negates normal attacks) and Recollection of Guilt gives Terroanima (causes the monster to flee).",
        "Alternatively, trade Harith one of these Recollections, without gil, to receive an item: Recollection of Suffering gives a Hamayumi, Recollection of Anxiety gives a Stone Gorget and Recollection of Animosity gives a Dia Wand. The Recollections of Suffering and Animosity come from Notorious Monsters in Promyvion - Vahzl.",
        "The quest can be repeated.",
    },

}

return Q