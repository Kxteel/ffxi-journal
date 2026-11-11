local Q = {}

Q.STEPS = {

    -- ========================================================
    -- PORT BASTOK
    -- ========================================================

    bsz_pb_welcome_to_bastok = {
        "Obtain a Shell Shield, either at the Auction House or from Young Quadav enemies in North Gustaberg, South Gustaberg, Palborough Mines or Konschtat Highlands. Only level 7 or higher WAR, RDM, PLD, BST and SAM can equip it.",
        "Speak with Powhatan in Port Bastok (E-6) to start the quest.",
        "Equip the Shell Shield.",
        "Speak with Bartolomeo in Port Bastok (F-7), one of the clerks inside the air travel agency.",
        "After the cutscene, return to Powhatan to complete the quest and receive a Spatha.",
    },

    bsz_pb_beauty_and_galka = {
        "Speak with Talib in Port Bastok (F-6) to start the quest. After the cutscene, accept the quest to proceed to the next portion. If you declined it the first time, you can restart it by speaking with Parraggoh in Bastok Mines (H-5), who is on the lower level.",
        "Obtain a Zinc Ore. Monsters in Gustaberg are known to drop it.",
        "Trade the Zinc Ore to Talib.",
        "Speak with Parraggoh in the house on the bottom level in Bastok Mines (H-5) to complete the quest and receive a Bronze Knife. You may need to speak with him twice.",
    },

    bsz_pb_quadavs_curse = {
        "Speak with Corann in Port Bastok (K-6), inside the northmost house, to start the quest.",
        "Obtain a Quadav Backplate, either at the Auction House or by farming Amethyst Quadav enemies in North Gustaberg, South Gustaberg, Palborough Mines or Konschtat Highlands.",
        "Turn in the Quadav Backplate to Corann to complete the quest.",
    },

    bsz_pb_guest_of_hauteur = {
        "You have to zone after completing Welcome to Bastok. You must be level 31 or higher. Speak with Powhatan in Port Bastok (E-6) to start the quest.",
        "Equip either a Maul or a Replica Maul. A Maul can be bought at the Auction House, dropped by Garnet Quadav enemies in Rolanberry Fields and Beadeaux, or bought for 228 Sparks of Eminence from A.M.A.N. representatives.",
        "Speak with Bartolomeo in Port Bastok (F-7), inside the Air Travel Agency.",
        "Revisit Powhatan and select the second option, \"Where am I supposed to meet your guest?\".",
        "Speak with Steel Bones in Port Bastok (D-8).",
        "Return to Powhatan to complete the quest and receive a Targe.",
    },

    bsz_pb_wisdom_of_elders = {
        "Speak with Benita in Port Bastok (J-6) to begin the quest.",
        "Speak with Tete at (I-5) in Port Bastok.",
        "Obtain a Bomb Ash from the Auction House, from Tenshodo or Alchemy vendors, or by farming Lantern and Bomb type monsters.",
        "Trade the Bomb Ash to Benita to complete the quest.",
    },

    bsz_pb_ayame_and_kaede = {
        "Speak with Kaede in Port Bastok (J-5) to start the quest. You must have a job at level 30 or higher and the Rise of the Zilart pack. Ensetsu wants his item back from the Tenshodo, who will only trade it for a strangely shaped coral from Korroloka Tunnel.",
        "In Korroloka Tunnel, click on the ??? to spawn 3 Korroloka Leech enemies. They link with any Thread Leech enemies nearby. If the leeches do not appear after you click the ???, try relogging.",
        "Once the leeches are defeated and their bodies despawn, click on the ??? to receive the key item Strangely shaped coral. Several players can do this at the same time: have one member spawn the leeches and, after they despawn, have the others select the ??? before the player who spawned them. If the player who spawned them is KO'd, do not raise them until the Korroloka Leeches are defeated, or the leeches respawn immediately.",
        "Return to Ensetsu in Port Bastok (I-5).",
        "Travel to Norg and speak with Ryoma at (H-8), who gives you the key item Sealed dagger.",
        "Return to Ensetsu to complete the quest.",
    },

    bsz_pb_fear_of_flying = {
        "Speak with Kurando in Port Bastok (H-6) to begin the quest.",
        "Travel to Rolanberry Fields and proceed to (K-7).",
        "Look for the NM Silk Caterpillar. It spawns when an airship goes by, about every 11 to 14 minutes.",
        "Defeat the NM to receive a Silkworm Egg.",
        "Return to Kurando and trade him the egg to complete the quest.",
    },

    bsz_pb_forever_to_hold = {
        "Speak with Qiji in Port Bastok (I-7); he wants to give his wife, Romilda, a Brass Hairpin.",
        "Obtain a Brass Hairpin. It can be bought at the Auction House, or crafted.",
        "Trade the Brass Hairpin to Romilda, who is standing next to Qiji.",
        "Speak with Qiji to receive your reward, 300 gil.",
    },

    bsz_pb_till_death_do_part = {
        "You must have zoned once after finishing Forever to Hold to receive this quest.",
        "Speak with Romilda in Port Bastok (I-7), who wants to give her husband, Qiji, a pair of Cotton Gloves.",
        "Once you have the Cotton Gloves, trade them to Romilda to finish the quest and receive 2,000 gil.",
    },

    bsz_pb_silence_of_rams = {
        "Speak with Paujean in Port Bastok (F-6) to begin the quest.",
        "Obtain a Rampaging Horn and a Lumbering Horn.",
        "The Lumbering Horn comes from defeating Lumbering Lambert or Bloodtear Baldurf in La Theine Plateau; Bloodtear Baldurf is also a Records of Eminence objective under Combat: Region (Original Areas 1). It also comes from various battlefields.",
        "The Rampaging Horn comes from defeating Rampaging Ram or Steelfleece Baldarich in Konschtat Highlands, or from various battlefields.",
        "Trade both horns to Paujean to complete the quest.",
    },

    bsz_pb_bite_the_dust = {
        "Speak with Yazan in Port Bastok (H-6), who asks you to exterminate Sand Bats in Valkurm Dunes.",
        "Obtain a Sand Bat Fang. It can be bought at the Auction House (Materials, Bonecraft) or taken from Sand Bat enemies found in the tunnels of Valkurm Dunes. It is also a Records of Eminence objective: Combat (Wide Area), Combat (Spoils) 2, Spoils (Sand Bat Fang).",
        "Once you have one, trade it to Yazan for your reward, 350 gil.",
    },

    bsz_pb_ladys_heart = {
        "Optional: speak with Valah Molkot in Port Bastok (J-12). She does not say it at first, but she would like an Amaryllis.",
        "Obtain an Amaryllis. It can be bought at the Auction House, or from Areebah in Upper Jeuno (H-6).",
        "Trade the Amaryllis to Valah Molkot to complete the quest.",
        "If you trade her the wrong flower, such as one meant for the other two Mog House exit quests, she takes it and you will have to get another.",
    },

    bsz_pb_lure_of_wildcat = {
        "Speak with Alib-Mufalib in Port Bastok (K-7) to receive a Blue Sentinel badge and begin the quest. This quest requires the Treasures of Aht Urhgan pack.",
        "Speak with the people around Bastok. In Bastok Mines: Deidogg (H-6), Echo Hawk (I-7), Griselda (H-5), Goraow (I-6) and Vaghron (H-9).",
        "In Bastok Markets: Horatius (I-9), Arawn (J-10), Harmodios (K-10), Pavel (E-11) and Ken (E-10).",
        "In Port Bastok: Paujean (F-6), Kaede (J-5), Tilian (F-8), Hilda (E-6) and Patient Wheel (F-5). In Metalworks: Manilam (G-7), Invincible Shield (G-8), Ayame (K-7) and Kaela (I-8).",
        "Once you have spoken to all 20 people, return to Alib-Mufalib. He takes your Blue Sentinel badge and gives you a Blue invitation card.",
        "After joining Salaheem's Sentinels, speak with Naja Salaheem with the invitation card to be rewarded with Imperial currency; the more Lure of the Wildcat quests you have completed, the greater the reward. Alib-Mufalib will also offer to teleport you to Aht Urhgan Whitegate.",
    },

    bsz_pb_test_of_true_love = {
        "Zone after completing Love and Ice. You need Bastok fame level 6.",
        "Speak with Carmelo in Port Bastok (E-6) to begin the quest.",
        "Travel to the three required locations and obtain three key items from Treasure Chests: Un Moment, L'Ephemere and L'Ancienne, the missing parts of the Chanson de Liberte.",
        "Return to Bastok and speak with Carmelo with all three key items in your possession.",
        "After the conversation, zone out, then return and speak with him one last time to complete the quest and receive 10,000 gil.",
    },

    bsz_pb_love_and_ice = {
        "Locate the key item you received during The Stars of Ifrit. You receive it before the end of that quest, so you do not need to complete The Stars of Ifrit before starting this one.",
        "Speak with Carmelo inside the Steaming Sheep in Port Bastok (E-6) to receive the actual quest and Carmelo's song sheet. If you have The Siren's Tear active, you get a prompt to ask him about the Siren's Tear instead. You need Bastok fame level 5.",
        "Travel to (G-10) in Beaucedine Glacier, at the ice pond, and click on the Mirror Pond. It only appears on days without snow or clouds.",
        "After the cutscene, return to Bastok and speak with Carmelo to complete the quest.",
    },

    bsz_pb_lovers_in_dusk = {
        "Zone after completing A Test of True Love. You need Bastok fame level 6.",
        "Speak with Carmelo in Port Bastok (E-6) to begin the quest and receive the key item Chanson de Liberte.",
        "Travel to (H-8) in The Sanctuary of Zi'Tah to locate a ???, in the middle of the pool. The Survival Guide of The Sanctuary of Zi'Tah is the quickest way to get there.",
        "Touch the ??? between 16:00 and 18:00 in-game time to complete the quest.",
    },

    bsz_pb_the_usual = {
        "Speak with Hilda in Port Bastok (E-6) to begin the quest. You need Bastok fame level 5.",
        "Trade a King Truffle to Hilda to receive the Steaming Sheep invitation. King Truffle can be found at the Auction House, in Voidwatch, or dropped by some Funguar enemies in Crawlers' Nest.",
        "Travel to Metalworks and speak with Raibaht at (G-8), in Cid's Lab. Make sure you receive a short dialog for this specific quest and not a cutscene for one of the several quests that involve Raibaht.",
        "Return to the Steaming Sheep restaurant and speak with Hilda to complete the quest.",
    },

    bsz_pb_trial_size_earth = {
        "You must be a Summoner of level 20 or higher. Speak with Ferrol in Port Bastok (I-8) to begin the quest and obtain a Mini tuning fork of earth.",
        "Prepare for the battle. Whenever you are ready, trade the tuning fork to Ferrol to be transported to the arena.",
        "Trade the fork to the Earth Protocrystal to enter the fighting arena.",
        "Defeat Titan Prime to complete the quest.",
        "You can get the Mini tuning fork again from Ferrol at any point and repeat the fight, but he will no longer teleport you to the Cloister.",
    },

    bsz_pb_trial_by_earth = {
        "Speak with Juroro in Port Bastok (I-8); Home Point #1 is the closest. You need Bastok fame level 6. Once you have received the key item Tuning fork of earth, you can safely undertake the quest.",
        "Travel to Quicksand Caves and go to (E-10) of the map to find the hidden entrance to the Cloister of Tremors. Each party member must have their own Tuning fork of earth.",
        "Defeat Titan Prime to receive the key item Whisper of tremors.",
        "Return to Juroro with the whisper and she offers several rewards, including the ability to summon Titan. You can only select one reward at a time, and you can repeat the quest once per Earth day.",
        "To save travel time to the Cloister of Tremors, you can use the Mini tuning fork of earth from the quest Trial-Size Trial by Earth. You must be on Summoner as your main job: get the Mini tuning fork from Ferrol, trade the fork back to Ferrol, and enter the Protocrystal normally. As long as you do not clear the level 20 version of the battlefield, you may warp to the Cloister as many times as you wish.",
        "You may also keep the whisper to meet the requirements of the quest The Moonlit Path. Do not turn in the quest if you want to complete The Moonlit Path.",
    },

    bsz_pb_eco_warrior = {
        "Speak with Raifa (D-6) in the Steaming Sheep Restaurant in Port Bastok to begin the quest. You must be level 25 or higher. You can only have one Eco-Warrior quest active at a time, and they cannot be deactivated.",
        "Head to Gusgen Mines and speak with Degga (H-9). Your level will be restricted to 25.",
        "Head to (H-6) to find a ???. It is on the top floor; do not go down the stairs. It is advised to clear the area around the ???.",
        "Return to Raifa in Port Bastok to receive your reward, 5,000 gil and Dragon Chronicles. Only one Eco-Warrior quest can be completed per Conquest Tally.",
    },

    bsz_pb_escort_for_hire = {
        "Speak with Trilok in Port Bastok (D-6) to begin the quest. Only one Escort for Hire quest can be active at a time, and only one can be completed each Conquest Tally.",
        "Zone into Crawlers' Nest from Rolanberry Fields. If you get a cutscene with a Hume female NPC named Olavia, you are ready to head out. If you do not, another team may already be on the quest, so wait a while and try zoning in again. You can summon Trusts, but zoning in with an Adventuring Fellow makes the escort NPC disappear.",
        "Escort Olavia to the end point, and she presents you with a Completion certificate. Every member of the party or alliance must speak to her when she stops, or they will not get a completion.",
        "Return to Trilok to complete the quest. The first completion gives 10,000 gil and a Page from Miratete's Memoirs.",
    },

    bsz_pb_trust_bastok = {
        "Speak with Clarion Star in Port Bastok, near Home Point #1 at (K-7); he gives you the Blue institute card.",
        "Head to Metalworks, Home Point #1 (J-8), and speak with Naji.",
        "If this is not your first Trust quest, you are finished with the quest at this point and receive the Bastok Trust permit.",
        "If this is your first Trust quest, you must use the Trust spell Naji in South Gustaberg or North Gustaberg. After that, return to Naji to receive the Bastok Trust permit.",
    },

    bsz_pb_walls_of_mind = {
        "You cannot start this quest if you have another Weapon Skill quest active; return to the person who gave it and quit it first. You need level 71, and the Rise of the Zilart pack.",
        "Speak with Oggbi in Port Bastok (E-6) to receive the key item Weapon training guide and the Knuckles of Trials. You need to break the latent on the Knuckles of Trials before completing the rest of the quest.",
        "With the Knuckles of Trials equipped in your main hand, fight enemies rated Extremely Easy Prey or higher and use weapon skills or close skillchains to accumulate 300 Trial Points.",
        "Your elemental resistances are listed underneath your equipped gear grid. The latent is broken when the elemental resistances of the Knuckles of Trials disappear from them.",
        "Trade the Knuckles of Trials back to Oggbi. The Bostaunieux Oubliette page lists the notorious monster Bodach for this quest.",
        "Go back and speak with Oggbi to receive your reward.",
    },

    bsz_pb_ghosts_of_past = {
        "Speak with Oggbi inside the Steaming Sheep Restaurant in Port Bastok (E-6) for a cutscene, as a Monk of level 40 or higher. Once the quest is active you can complete it on any job.",
        "Get a Pickaxe from the Auction House or from any other source.",
        "In Gusgen Mines, get to the third map by taking the ramp down at (F-5) and trade the Pickaxe to the ???.",
        "The Wandering Ghost that appears drops a Miner's Pendant, and the Pickaxe is still in your inventory.",
        "Trade the Miner's Pendant to Oggbi to receive the Beat Cesti.",
    },

    bsz_pb_achieving_true_power = {
        "You need to be level 66 or higher. Speak with Shamarhaan, the Puppetmaster standing near the fountain in Bastok Markets (F-9), as a Puppetmaster to begin the quest.",
        "Obtain a Puppetmaster's Testimony (Pup. Testimony). It drops from Troll Surveillant enemies in Bhaflau Thickets (F-8, northern map) and from Troll Engraver enemies in Halvung. It can be used for up to three fight attempts before you need a new one.",
        "Trade the Pup. Testimony to Shamarhaan to initiate the Navukgo Execution Chamber battlefield; you are warped there. Just like the Maat fight, you have to fight Shamarhaan to break the level cap limit.",
        "Upon arrival at Navukgo Execution Chamber, trade the Testimony to the Decorative Bronze Gate to begin the battle. Shamarhaan is accompanied by his automaton Valkeng, so prepare for a fight against both of them. The time limit is 10 minutes.",
        "Bring Shamarhaan down to -20% HP and you should win the battle. The quest does not need to be completed for the level limit increase if you have already completed New Worlds Await or better.",
    },

    bsz_pb_out_of_ones_shell = {
        "Speak with Ronan in Port Bastok (K-6) to activate the quest.",
        "Obtain Shell Bug x3 from Quadav enemies or at the Auction House, and trade them to Ronan. Shell Bug can also be obtained from the Green Thumb Moogle if you have a Baby eft memento.",
        "Zone out and back in again, then speak with Ronan to complete the quest.",
    },

    -- ========================================================
    -- BASTOK MINES
    -- ========================================================

    bsz_bm_sirens_tear = {
        "Speak with Wahid in Bastok Mines (I-8), near Home Point #1; he asks for a Siren's Tear.",
        "Travel to (J-9) in North Gustaberg and look for a ???. It appears randomly up and down the length of the river. Taking Port Bastok Home Point #1 to North Gustaberg is the quickest way to reach the river.",
        "Make sure you have one free inventory slot. Unequip all weapons and shield in the Main and Sub slots, then examine the ??? and you receive the message that you have obtained a Siren's Tear.",
        "Go back to Wahid and trade the Siren's Tear to complete the quest and receive 150 gil. If you are doing this quest for a Vana'Bout objective and have already completed it once, you do not need to speak to Wahid again to start it.",
    },

    bsz_bm_hearts_of_mythril = {
        "Speak with Elki in the Bat's Lair Inn in Bastok Mines (H-5) to trigger a cutscene and start the quest. When the cutscene ends you have a Bouquet for the pioneers.",
        "Head out to Zegham Hill in North Gustaberg. Go up the winding hill until you reach the peak and find a monument at (J-7). Alternatively, use the Port Bastok exit near Home Point #1 and in North Gustaberg climb starting on the southwest part of the hill, in a patch of trees at the (H-8)/(I-8) border.",
        "Touch the monument for an event.",
        "After the event ends, head back to Elki and speak to him to complete the quest.",
    },

    bsz_bm_elevenths_hour = {
        "After just completing Hearts of Mythril, you must zone to flag this quest. You need Bastok fame level 3.",
        "Speak with Elki in Bastok Mines (H-5) to start the quest.",
        "Travel to the top floor of Palborough Mines (map 3). Palborough Mines Home Point #1 is the fastest way.",
        "Examine the Old Toolbox at the intersection of (H-7) and (H-8) to receive the key item Old toolbox.",
        "Return to Elki and speak to him.",
        "After the cutscene, speak with Babenn in Bastok Mines (J-6) to complete the quest.",
    },

    bsz_bm_minesweeper = {
        "Speak with Gerbaum in Bastok Mines (F-8); he asks you to exterminate the pests that roam inside Zeruhn Mines.",
        "Collect Zeruhn Soot x3, either by defeating the monsters in Zeruhn Mines or by buying it at the Auction House.",
        "Trade the 3 Zeruhn Soot to Gerbaum for your reward, 150 gil.",
    },

    bsz_bm_fallen_comrades = {
        "Speak with Pavvke in Bastok Mines (I-7), who asks you to bring back name tags.",
        "Obtain a Silver Name Tag. It can be bought at the Auction House, or dropped by Onyx Quadav and Greater Quadav enemies in Palborough Mines. Since the tags are rare, you can only turn in one at a time.",
        "Trade the Silver Name Tag to Pavvke for your reward, 550 gil.",
    },

    bsz_bm_rivals = {
        "Obtain a Mythril Sallet from the Auction House (Armor, Head) or for 437 Sparks.",
        "Speak with Detzo in Bastok Mines (I-6) to begin the quest.",
        "Trade the Mythril Sallet to Detzo to complete the quest and receive your reward. The sallet is returned to you, so make sure you have space in your inventory.",
    },

    bsz_bm_vengeful_wrath = {
        "Speak with Goraow in Bastok Mines (I-6), in the upper stairway of Ore Street, to begin the quest. It is close to Bastok Mines Home Point #3.",
        "Obtain a Quadav Helm. It only drops from Old Quadav enemies in Beadeaux; Old Quadav in other areas do not drop the same items. It can also be bought at the Auction House (Others, Beast-made).",
        "Trade a Quadav Helm to Goraow to complete the quest and receive 900 gil. You can repeat it without zoning.",
    },

    bsz_bm_groceries = {
        "Speak with Tami in Bastok Mines (J-8) to begin the quest. She gives you the key item Tami's note. If you open and read the key item, you can no longer repeat the quest.",
        "If you do not read the note: proceed to Zeruhn Mines and locate Zelman at (I-8). He tells you that he is busy and to tell Tami. Return to Tami for your reward of 10 gil. You can then repeat the quest.",
        "If you read the note: proceed to Zeruhn Mines and locate Zelman at (I-8), then go to the Bat's Lair Inn at (H-5) in Bastok Mines and buy a Meat Jerky from Griselda.",
        "Trade the Meat Jerky to Tami for your reward, a Rabbit Mantle. The quest is then complete and no longer repeatable.",
    },

    bsz_bm_blade_of_darkness = {
        "Teleport to Bastok Mines Home Point #1, go inside the house (upper floor) at (J-7) and speak with Gumbah. Speak to him repeatedly until you get the cutscene that begins the quest. You must be level 30 or higher.",
        "Travel to Palborough Mines and go to the top floor (map 3). If you have not unlocked it yet and have completed the limit break quest Beyond Infinity, you can use Domenic to teleport right to the home point outside Waughroon Shrine.",
        "Defeat the required number of monsters with the Chaosbringer. If you need to reobtain it, return to Palborough Mines and ride the boat back to Zeruhn Mines; your kill count is reset to zero.",
        "Set the Records of Eminence objective Conflict: South Gustaberg (or similar) to help you keep track of the kills.",
        "Zone in for a cutscene to complete the quest.",
    },

    bsz_bm_drachenfall = {
        "Speak with Black Mud in Bastok Mines (J-7) to begin the quest. You receive a Brass Canteen. If you drop it, you can speak to him again to get another one.",
        "Travel to Dangruf Wadi and head north from the entrance. The quickest method is the Survival Guide; otherwise zone in from South Gustaberg (D-9).",
        "Locate the Waterfall Base and trade the Brass Canteen to it, not to the ???, to receive Drachenfall Water. A headstone for the quest An Explorer's Footsteps is along the way.",
        "Return to Bastok and trade the Drachenfall Water to Black Mud to complete the quest and receive 2,000 gil.",
    },

    bsz_bm_blade_of_death = {
        "Speak with Gumbah in Bastok Mines (J-7) to receive the key item Letter from Zeid. You need Bastok fame level 3.",
        "Use the Chaosbringer to slay 100 more enemies. If you discarded your Chaosbringer, take the boat from Palborough Mines to Zeruhn Mines to receive a new one from Zeid; this resets the blade, so you will have to kill a total of 200 monsters with it to complete the quest.",
        "The same rules apply as in the original quest: for example, weapon skill kills do not count.",
        "Go to Gusgen Mines and trade the Chaosbringer to the ??? at (J-7) on map 1 to receive your reward, the Deathbringer. It is the same ??? used in Bastok Mission 3-2 to spawn the NM Blind Moby.",
    },

    bsz_bm_inheritance = {
        "You cannot start this quest if you have another Weapon Skill quest active; return to the person who gave it and quit it first. You need Great Sword skill 250 or higher and level 71.",
        "Speak with Gumbah in Bastok Mines (J-7) to receive the key item Weapon training guide and the Sword of Trials. You need to break the latent on the Sword of Trials before completing the rest of the quest.",
        "With the Sword of Trials equipped in your main hand, fight enemies rated Extremely Easy Prey or higher and use weapon skills or close skillchains to accumulate 300 Trial Points.",
        "Trade the Sword of Trials back to Gumbah.",
        "Go back and speak with Gumbah to receive your reward, the Ground Strike weapon skill.",
    },

    bsz_bm_the_doorman = {
        "Speak with Phara in Bastok Mines (J-9), a Warrior of level 40 or higher; she is right beside the Gobbie Mystery Box at Home Point #2. She needs sword grip material to repair her son's sword, which can be found in a tent in Davoi.",
        "If multiple people are doing the quest, you will have to wait 5 minutes for the monsters to pop again.",
        "Speak with Phara, then wait a game day (until the clock rolls past 00:00).",
        "Speak with Phara again to receive Yasin's sword.",
        "Speak with Naji outside the President's Office in Metalworks (J-8) for a cutscene that finishes the quest, and receive your Razor Axe.",
    },

    bsz_bm_talekeepers_truth = {
        "Speak with Phara in Bastok Mines (J-9), a Warrior of level 50 or higher.",
        "Speak with Deidogg in Bastok Mines (H-6) twice; he is at the bottom of the ramp that leads to the guild. After this point the quest can be completed on any job.",
        "Go to Palborough Mines and work your way to the top floor. You will find a ??? at (G-10) in a dead-end room.",
        "Return to Bastok and trade the Mottled Quadav Egg to Deidogg.",
        "Go to Castle Oztroja and defeat the Yagudo Parasite in the pond on the third floor (H-9) for a Parasite Skin.",
        "Return to Bastok again and trade the Parasite Skin to Deidogg.",
    },

    bsz_bm_talekeepers_gift = {
        "You must wait until the next game day after completing The Talekeeper's Truth before you can activate this quest. You must be a Warrior of level 50 or higher.",
        "Speak with Deidogg in Bastok Mines (H-6).",
        "Speak with Detzo in Bastok Mines (I-6), in the alleyway around the corner from Deidogg.",
        "Obtain a Ginger Cookie, sold by the Curio Vendor Moogle or by Valeriano in Port Bastok, and trade it to Deidogg. The quest is not flagged in your log until after you trade the Ginger Cookie, and from then on it is active.",
        "Defeat the NMs, and zone out of Behemoth's Dominion back into Qufim to receive a cutscene and the reward for completing the quest.",
    },

    bsz_bm_first_meeting = {
        "If you just finished Ghosts of the Past, you must zone before beginning this quest. You must be on Monk.",
        "Speak with Oggbi inside the Steaming Sheep Restaurant in Port Bastok (E-6) for a cutscene. Once the quest is active you can complete it on any job.",
        "Travel to Fei'Yin. You can use the Home Point warp #1 if you have it.",
        "When ready, click the Hide Flap to pop Deloknok (PLD) and Bilopdop (MNK).",
        "Go back and speak with Oggbi to receive your Temple Gaiters.",
    },

    bsz_bm_true_strength = {
        "Speak with Ayame in Metalworks (K-7), as a Monk of level 50 or higher. If you have finished the Treasures of Aht Urhgan missions, you may need to speak with her twice. Once you have talked to Ayame, the quest shows up in your quest log and you may switch to another job to complete it.",
        "Acquire a Yagudo Drink from the Auction House, or buy one from a Curio Vendor Moogle if you have the appropriate Rhapsody key item.",
        "Travel to Castle Oztroja. You do not need the three passwords to enter the Altar Room.",
        "Trade the Yagudo Drink to the ??? to spawn Huu Xalmo the Savage.",
        "Huu Xalmo the Savage drops the Xalmo Feather. Trade the feather to Ayame for your Temple Hose.",
    },

    bsz_bm_wondrous_whatchamacallit = {
        "Speak with Selliste in Bastok Mines (K-7) to begin the quest. You need a Synergy skill of 5 or higher.",
        "To synergize Astral Matter you must gather six stones from ??? spots in the matching cloisters: Flamestone from the Cloister of Flames, Froststone from the Cloister of Frost, Galestone from the Cloister of Gales, Tremorstone from the Cloister of Tremors, Stormstone from the Cloister of Storms and Tidestone from the Cloister of Tides.",
        "Synergize the stones into Astral Matter in a Synergy Furnace, then trade the result to Selliste for your reward, a Portafurnace.",
    },

    bsz_bm_fully_mental_alchemist = {
        "Speak with Titus on the second floor of the Alchemy Guild in Bastok Mines (L-7) for a cutscene that begins the quest. You receive the key item Corked ampoule.",
        "Go to the Riverbed in Grauberg (S) (F-13). To extract gold you must wash away as much sediment as possible without washing away any gold dust, so wash carefully.",
        "Each wash gives you a random amount of gold dust grains, generally between 3 and 11. Repeat examining the Riverbed and the washing steps until you have at least 20 grains, which gives you the key item Ampoule of gold dust.",
        "If you leave Grauberg (S), you lose any gold dust you have acquired and have to start over.",
        "Speak with Titus again for a cutscene and to receive your reward.",
    },

    bsz_bm_chocobo_riding_game = {
        "Speak with the starting NPC at the Chocobo stables in Bastok Mines (J-9): Azette, Eulaphe or Quelle. You must be level 20 or higher, and you are asked to deliver a Chocobo to a distant stable.",
        "You are placed on a Chocobo and must ride to the destination. If you dismount, the quest ends in failure.",
        "The standard riding time limit for a Chocobo is 30 minutes, which is not enough time to ride to Windurst unless you have equipped Orange Race Silks and/or a Chocobo Wand.",
        "Your reward depends on how quickly you deliver the Chocobo. To San d'Oria: Miratete's Memoirs at 27:00 to 28:36, a Chocobo Ticket at 28:37 to 29:59, Gysahl Greens at 30:00 or more.",
        "To Windurst: Miratete's Memoirs at 31:00 to 32:29, a Chocobo Ticket at 32:30 to 34:43, Gysahl Greens at 34:44 or more. To Jeuno: a Bastok Mines Glyph at 16:00 to 18:49, Gysahl Greens at 18:50 or more.",
    },

    -- ========================================================
    -- BASTOK MARKETS
    -- ========================================================

    bsz_bkt_shady_business = {
        "Speak with Talib in Port Bastok (F-6) to start the quest. This quest follows Beauty and the Galka.",
        "Obtain Zinc Ore x4. It can be bought from Teerth in Bastok Markets for 200 gil, from Celestina in Mhaura for 200 gil, or at the Auction House, or you can mine it from a Mineral Vein.",
        "Trade the Zinc Ore x4 to Talib to complete the quest and receive 350 gil. You do not have to zone to repeat it.",
    },

    bsz_bkt_breaking_stones = {
        "Speak with Horatius inside the Trader's Home at (I-9) in Bastok Markets, who sends you to Dangruf Wadi. You need Bastok fame level 2.",
        "Find the ??? in Dangruf Wadi to get a Dangruf Stone. The monsters around the ??? are level 90 to 95; only the Goblins are aggressive, and they can be avoided with just Invisible since they do not have pets. You lose Invisible when riding the geyser at (I-8) in Dangruf Wadi, so Field Support from the Grounds Tome will fail.",
        "If there is weather when you attempt the quest, you have to wait for it to clear up to find the ???.",
        "Head back to Horatius to trade the Dangruf Stone and receive your reward, 400 gil.",
    },

    bsz_bkt_cold_light_of_day = {
        "Speak with Malene in Bastok Markets (I-5) to begin the quest.",
        "Obtain a Steam Clock. You can buy one at the Auction House, or defeat Bubbly Bernie: get a Quus (a fish), from the Auction House or by fishing, travel to the lighthouse in South Gustaberg (M-10) and look for a ???, then trade the Quus to the ??? and Bubbly Bernie appears. Defeat him and loot his corpse for a Steam Clock.",
        "Return to town and trade the Steam Clock to Malene to complete the quest and receive 500 gil.",
    },

    bsz_bkt_gourmet = {
        "Speak with Salimah in Bastok Markets (L-8) to begin the quest.",
        "Obtain Sleepshroom, Treant Bulb or Wild Onion and trade it to her depending on the time of day. Sleepshroom pays 200 gil from 18:00 to 5:59, Treant Bulb 200 gil from 6:00 to 11:59, and Wild Onion 350 gil from 12:00 to 17:59. If you trade an item that does not match the time of day, you only receive 100 gil.",
        "All three items can be farmed (Sleepshroom from Funguar type enemies, Treant Bulb from Sapling type enemies, and Wild Onion from Goblin Thug enemies or by gardening) or bought at the Auction House. If you buy, avoid Wild Onion, which is a hugely popular item for cooks and always expensive.",
        "The quest can be repeated as many times as you want, but it requires zoning between each trade.",
    },

    bsz_bkt_elvaan_goldsmith = {
        "Speak with Michea in Bastok Markets (F-10) to start the quest.",
        "Obtain a Copper Ingot from the Auction House, Goldsmithing guild shops, or by crafting it. To buy the Copper Ore for crafting at a guild shop, visit Teerth or Visala in Bastok Markets (H-8), or Yabby Tanmikey or Celestina in Mhaura (G-8).",
        "To craft the ingot, use a Fire Crystal with 4 Copper Ores.",
        "Trade the Copper Ingot to Michea to complete the quest and receive 180 gil. You can repeat it by zoning out of the area, but it is no longer repeatable once you reach Bastok fame level 2.",
    },

    bsz_bkt_flash_in_the_pan = {
        "Speak with Aquillina in Bastok Markets (K-9); she asks for Flint Stones.",
        "Obtain Flint Stone x4. It drops from worm type enemies such as Tunnel Worm, Carrion Worm and Stone Eater, and can also be found at the Auction House (Materials, Goldsmithing).",
        "Trade the Flint Stone x4 to Aquillina to complete the quest and receive 100 gil. The page notes that the quest can be repeated but has a restriction of 15 Earth minutes that applies to everyone, so if another player completed it recently it will not be available.",
    },

    bsz_bkt_stamp_hunt = {
        "Speak with Arawn in Bastok Markets (J-10) to start the quest. You receive the Stamp sheet to collect stamps.",
        "Speak to the following 7 guards to obtain the stamps. In Bastok Markets: Pavel (D-11), at the gate to Gustaberg. In Bastok Mines: Deadly Spider (G-8), on the 2nd floor of the Depot, and Tall Mountain (J-7), by going down the ramp toward the Alchemist Guild and turning right at the no-entrance area.",
        "In Metalworks: Romualdo (K-9), in the southeastern Cannonry, and Elayne (G-8), at the entrance to the Temple of the Goddess. In Port Bastok: Ehrhard (G-5), in the northeast corner outside Warehouse #1, and Latifah (J-8), north of the drawbridge.",
        "Speak to Arawn again once you have collected all the stamps to complete the quest and receive a Leather Gorget.",
    },

    bsz_bkt_mom_the_adventurer = {
        "Speak with Nbu Latteh on Gold Street in Bastok Markets (J-9) to start the quest. She gives you a Fire Crystal that you can use to craft your Copper Ring if you choose.",
        "Obtain a Copper Ring, either at the Auction House, from merchants (Carmelide or Raghd in Bastok Markets) or by crafting it.",
        "Trade the Copper Ring to Roh Latteh in Bastok Mines (H-7), in the first-floor house on Ore Street. When her dialogue ends, you obtain the key item Letter from Roh Latteh. If you check (read) the letter from your key item menu, you get a penalty and only half of the actual reward.",
        "Return to Nbu Latteh to complete the quest and receive 100 or 200 gil. The quest is repeatable for players below Bastok fame level 2: zone out each time and you can redo it.",
    },

    bsz_bkt_signpost_marks_spot = {
        "Speak with Nbu Latteh in Bastok Markets (J-9) to begin the quest. You need Bastok fame level 2 and to have completed Mom, the Adventurer?.",
        "Travel to Konschtat Highlands and inspect the signpost at the south edge of (G-4) and the north edge of (G-5). You receive a Painting of a windmill. Consider doing this together with the quest Past Perfect, since both click on a location in the Highlands.",
        "Return to Bastok Mines and speak with Roh Latteh at (H-7) to complete the quest and receive a Linen Robe.",
    },

    bsz_bkt_bare_bones = {
        "Obtain a Bone Chip from the Auction House or by farming Skeleton type monsters.",
        "Speak with Degenhard in Bastok Markets (I-10) to begin the quest.",
        "Trade him the Bone Chip to complete the quest and receive the Map of the Dangruf Wadi.",
    },

    bsz_bkt_buckets_of_gold = {
        "Start the quest by speaking with Foss in Bastok Markets (F-7).",
        "Once you accept, obtain Rusty Bucket x5, either by fishing for them or by buying them at the Auction House or from Kahah Hobichai in Al Zahbi.",
        "Trade the 5 Rusty Buckets to Foss for your reward, 300 gil.",
    },

    bsz_bkt_curse_collector = {
        "Speak with Zon-Fobun in Bastok Markets (G-5) to begin the quest. You receive the key item Cursepaper. You need Bastok fame level 4.",
        "Go to Beadeaux and proceed to one of the sets of machines. You need to visit an Afflictor, which curses whoever comes near it unless they are currently silenced, and a Mute, which silences whoever touches it. So get cursed first by coming near the Afflictor, then touch the Mute to become silenced.",
        "The first and easiest set of machines: go straight in when entering Beadeaux, then turn left (north) when you reach the wall at (F-7). Go north to the wall in (F-6), then due east to (H-6).",
        "The curse dramatically lowers your maximum HP and MP.",
        "Return to Zon-Fobun to complete the quest and receive your Poison Cesti.",
    },

    bsz_bkt_return_of_adventurer = {
        "You need Bastok fame level 3 and to have completed Father Figure. Obtain a Cinnamon from the Auction House or, if you have the Kazham Airship Pass, from the port shop in Kazham. You can reach the vendor without being on the airship side: take the Survival Guide or Home Point to Kazham and buy Cinnamon from Ghemi Sinterilo.",
        "Speak with Gwill in Bastok Markets (E-11) to begin the quest.",
        "When the cutscene ends, trade him the Cinnamon to complete the quest and receive a Cotton Headband.",
    },

    bsz_bkt_wish_upon_a_star = {
        "Speak with Zacc in Bastok Markets (G-9), who is standing next to Enu. You need Bastok fame level 5.",
        "Speak with Malene (I-5), more popularly known as the Steam Clock and Bubbly Bernie quest giver.",
        "Return to the fountain and speak with Enu. The quest now appears in your log.",
        "Acquire a Hatchet from the Auction House, NPC stores or crafting.",
        "Travel to Yuhtunga Jungle, on Elshimo Island and reached by airship, and locate a Logging Point. Start logging and you receive a Fallen Star.",
        "Return to Enu and trade her the star on a clear starry night (clear weather, with stars visible in the sky) to complete the quest.",
    },

    bsz_bkt_brygid_stylist = {
        "Speak with Brygid in Bastok Markets (K-9). She tells you how bad your fashion sense is and wants you to come back wearing a Robe and a Bronze Subligar.",
        "Acquire a Robe and a Bronze Subligar, both easy to find at the Auction House or from some armor merchants.",
        "Wear both pieces of equipment. Only some jobs can wear both items at the same time.",
        "Speak with Brygid again to complete the quest and receive the Gloves. Completing it later unlocks Brygid the Stylist Returns.",
    },

    bsz_bkt_brygid_stylist_returns = {
        "Complete Brygid the Stylist first. Then speak with Brygid in Bastok Markets (K-9), on any job, while wearing any 1 to 5 pieces of Artifact Armor to begin the quest.",
        "Brygid asks for armor pieces from a list of ordinary body and leg armors, for example Banded Mail, Bishop's Robe, Pyro Robe or Silver Mail.",
        "Some pieces are job-specific armor that needs a matching subligar dropped by a Fomor enemy: for example Aikido Gi (MNK) needs an Aquarius Subligar from Fomor Monk, Gaudy Harness (BRD/BST) an Ophiuchus Subligar from Fomor Beastmaster, Gloom Breastplate (DRK) a Sagittarius Subligar from Fomor Dark Knight, Nokizaru Gi (NIN) a Taurus Subligar from Fomor Ninja, and Wyvern Mail (DRG) a Leo Subligar from Fomor Dragoon.",
        "Bring Brygid what she requests to complete the quest and receive your reward.",
    },

    bsz_bkt_father_figure = {
        "Obtain a Silver Ingot from the Auction House or by crafting it. This quest follows The Elvaan Goldsmith.",
        "Speak with Michea in Bastok Markets (F-10) to start the quest.",
        "When the cutscene ends, trade her the Silver Ingot to complete the quest and receive 2,200 gil.",
    },

    bsz_bkt_proper_burial = {
        "Speak with Offa in Bastok Markets (F-10) to begin the quest.",
        "Travel to Bastok Markets (S) and speak with young Offa. You are given two options, which lead to two different paths through the quest.",
        "Return to Bastok Markets and Bastok Markets (S), speaking to Offa each time. In the longer path you go Bastok Markets, Bastok Markets (S), Bastok Markets, Bastok Markets (S), where you trade Offa the Fish Bones, then Bastok Markets, Bastok Markets (S) and Bastok Markets again; the last time he ends this part of the quest and gives you a Rolanberry. In the shorter path you trade the Fish Bones sooner, with fewer trips between the two zones.",
        "Whichever way you completed the previous section, once you have the Rolanberry, travel to Bastok Markets (S) one more time and speak with young Offa, then return to Bastok Markets and speak with Offa there to complete the quest and obtain the Withered Berry.",
    },

    bsz_bkt_all_by_myself = {
        "Speak with Marin in Bastok Markets (E-10) and accept the quest. You need Bastok fame level 2. She wants you to watch over her little brother Ken during his military academy exam.",
        "Speak with the NPC Ken to initiate the escort. Buffs remain active, but you cannot cast anything on Ken before starting the quest.",
        "Ken engages all enemies that are in his line of sight, and he cannot be stopped like the NPCs used in the three nation escort quests. One way to make the quest easier is to have a higher level friend run slightly ahead of Ken and kill monsters before he attacks them.",
        "After Ken despawns, Marin appears at the exit.",
        "Return to Bastok Markets and speak to Marin again to finish the quest and receive 1,500 gil.",
    },

    bsz_bkt_discerning_eye = {
        "Speak with Grin in Port Bastok (G-7) and accept the quest.",
        "Grin shows you a picture of an NPC that you must memorize.",
        "Board the next airship.",
        "Several NPCs that look very similar to the one Grin showed you appear on the ship.",
        "Speak to the NPCs to get the option of returning the key item Dropped item to them. You only have one chance to get it right.",
        "If you choose correctly, you are given 500 gil. If you choose incorrectly, you fail the quest.",
    },

    -- ========================================================
    -- METALWORKS
    -- ========================================================

    bsz_mw_smoke_on_mountain = {
        "Speak with Hungry Wolf inside the Craftmen's Eatery in Metalworks (G-9) to start the quest; Home Point #1 is close. He wants a Galkan Sausage.",
        "Optional: speak with Offa in Bastok Markets (F-10), on the second floor behind the door on the left, for instructions on how to make the sausage.",
        "Obtain a Giant Sheep Meat from the Auction House or from Ornery Sheep in South Gustaberg.",
        "Travel to South Gustaberg (K-9) to find a Goblin campfire (???). To find it, look on your map for the small hill at (K-9); it blends in with the surroundings, so keep an eye open for it.",
        "Trade the Giant Sheep Meat to the campfire to begin cooking it, then wait one minute (Earth time). Do not zone out, or you will have to repeat the steps.",
        "After the wait, check the campfire again and it drops a Galkan Sausage into your inventory, so make sure you have inventory room.",
        "Trade the Galkan Sausage to Hungry Wolf to complete the quest and receive 300 gil.",
    },

    bsz_mw_foremans_best_friend = {
        "Obtain a Dog Collar, either at the Auction House or by farming Black Wolf enemies in North Gustaberg and South Gustaberg at night (game time 20:00 to 04:00).",
        "Speak with Gudav in Port Bastok (H-5) to begin the quest.",
        "At the end of the cutscene, trade the Dog Collar to Gudav to complete the quest and receive the Map of the Gusgen Mines.",
    },

    bsz_mw_stardust = {
        "Speak with Baldric inside the Darksteel Forge on the first floor of Metalworks (G-9) to begin the quest. You need Bastok fame level 2.",
        "Obtain a Valkurm Sunsand, either at the Auction House or by traveling to Valkurm Dunes.",
        "To collect it in its natural environment, locate the ??? on an overturned boat on the easternmost beach in Valkurm Dunes, called Siren Sands (H-9). You must first wait for dusty weather for the ??? to appear. Click it and you receive a Valkurm Sunsand.",
        "Return to Baldric and trade him the Valkurm Sunsand to complete the quest and receive 300 gil.",
    },

    bsz_mw_mean_machine = {
        "Speak with Unlucky Rat on the first floor of the Cermet Refinery in Metalworks (G-7). You need Bastok fame level 2. He is having a machine problem.",
        "Although he does not ask for help, bring him a Slime Oil to solve his problem and obtain your reward, a Scroll of Warp.",
    },

    bsz_mw_cids_secret = {
        "Speak with Cid in Metalworks (H-8) to begin the quest. You need Bastok fame level 4.",
        "Travel to Port Bastok (Home Point #3) and visit the Steaming Sheep Restaurant.",
        "Locate Hilda at (E-6) and speak with her. You can interact with her through the floor if you stand under her, near the bar, while she is upstairs.",
        "Obtain a Rolanberry 874, either at the Auction House (Food, Ingredients) or by defeating the Drone Crawler (G) in Crawlers' Nest (Survival Guide, Derfland Region).",
        "Trade the Rolanberry 874 to Hilda to receive the Unfinished letter.",
        "Return to Cid and speak with him to complete the quest.",
    },

    bsz_mw_beadeaux_smog = {
        "Speak with High Bear in Metalworks (I-8) to begin the quest. You need Bastok fame level 4. He needs a sample of polluted dirt from Beadeaux.",
        "Travel to Beadeaux. Upon entry, proceed straight in, then turn left (north) when you reach the wall at (F-7). Go north to the wall in (F-6), then due east to (H-6).",
        "From there head south and you will go into a cave that leads down. Take it down until it exits at (H-7) on the lower map.",
        "From there go west and south as you can until you come to the tunnel at (F-8) that leads back to the surface; you pass one Afflictor that curses you as you proceed.",
        "Follow the surface path along, south past the Mute at (F-9). When the weather is raining, a ??? appears; take your sample of polluted dirt from it.",
        "Return to High Bear and speak with him to complete the quest and receive a Chakram.",
    },

    bsz_mw_the_darksmith = {
        "Obtain Darksteel Ore x2 from the Auction House, Mog Garden, mining or other sources.",
        "Speak with Mighty Fist on the first floor of Metalworks (Home Point #2, G-9) to begin the quest. You need Bastok fame level 3.",
        "Trade him the two ores to end the quest and receive 8,000 gil. You may immediately repeat the quest.",
    },

    bsz_mw_stars_of_ifrit = {
        "You can only work on this quest after you have obtained an Airship Pass, as completing it requires a trip on the airship. You need Bastok fame level 3.",
        "Speak with Agapito in Port Bastok (G-6) to begin the quest.",
        "On a Full Moon cycle, at night, board the Jeuno to San d'Oria airship.",
        "Search for an abnormal ???, which only appears during this specific time frame, and touch it to receive the key item Carrier pigeon letter.",
        "Return to Agapito and speak to him to complete the quest and receive 2,100 gil.",
    },

    bsz_mw_gustaberg_tour = {
        "Speak with Izabele in Metalworks (G-8) to begin the quest. You must form a party with two or more people, all of level 15 or below.",
        "Together with your party, travel to North Gustaberg and locate the Galka Hunting Bear at (F-8), near the waterfalls.",
        "Speak with Hunting Bear to complete the quest and receive 500 gil.",
    },

    bsz_mw_dark_legacy = {
        "Speak with Raibaht, Cid's assistant, in Cid's Lab in Metalworks (G-8) as a Dark Knight of level 40 or higher. After this point the rest of the quest can be completed on any job.",
        "Speak with Mighty Fist in Metalworks (G-9), on the lower level inside the Darksteel Forge, to receive the key item Letter from the Darksteel Forge.",
        "Travel to Windurst Waters and speak with Cochal-Monchal at (F-8), at Home Point #1 on the north map, in the Optistery.",
        "Obtain a Yagudo Cherry from a vendor or the Auction House. One is enough for multiple people doing the quest.",
        "Travel to Giddeus and trade the Yagudo Cherry to the ??? at (H-14). This spawns the NM Vaa Huja the Erudite. You then obtain the key item Darksteel Formula.",
        "Return to Raibaht and speak with him to complete the quest.",
    },

    bsz_mw_dark_puppet = {
        "Speak with Cid in Metalworks (G-8) as a Dark Knight of level 50 or higher to begin the quest.",
        "Obtain a Darksteel Ingot from the Auction House or by crafting it. One is enough for multiple people doing the quest.",
        "Zone into Ordelle's Caves for a cutscene. The Survival Guide and the Voidwatch warp bring you to the same entrance.",
        "Trade the Darksteel Ingot to the ??? at (I-8) on map 1 to spawn Gerwitz's Axe (NM). If you zoned in from La Theine Plateau or used the Survival Guide, take the east path (B on the wiki maps). If you are defeated you need another Darksteel Ingot to respawn the NM.",
        "Defeat Gerwitz's Axe and it drops Gerwitz's Axe. Head south up the ramp (D on the wiki maps). At (H-11/12) drop down the hole (the southeast hole), then go east to reach map 3 (E on the wiki maps).",
        "Trade Gerwitz's Axe to the ??? at (H-8) on map 3 to spawn Gerwitz's Sword (NM). Defeat it and it drops Gerwitz's Sword.",
        "Head south to enter a large square room and trade Gerwitz's Sword to the ??? at (H-10) to spawn Gerwitz's Soul.",
        "Defeat Gerwitz's Soul, then head for La Theine Plateau at (G-10) on the same map. You receive your reward after the cutscene. All party members in the zone receive credit for the defeat of Gerwitz's Soul, even if they are too far away to gain experience.",
    },

    bsz_mw_teak_to_the_stars = {
        "Speak with Raibaht in Cid's lab in Metalworks (G-8) to begin the quest. You need Bastok fame level 3.",
        "Travel to Carpenters' Landing to obtain a Garhada Teak Lumber. It can be obtained from monsters that appear on the Phanauet Channel barge, or that spawn from fishing on the barge or on the Carpenters' Landing pier.",
        "Return to Raibaht and trade him the lumber to complete the quest and receive 2,100 gil.",
    },

    bsz_mw_hyper_active = {
        "If you have just completed Teak Me to the Stars, you must zone before starting this quest. You need Bastok fame level 4.",
        "Speak with Raibaht in Metalworks (G-8) to begin the quest. You receive a Molybdenum box.",
        "Travel to Lower Delkfutt's Tower and proceed to the basement. A Delkfutt Key (or the key item version) is required.",
        "Travel to (I-6) of the basement map and touch the Cermet Door to pop 3 NMs: Orna, the boss, and 2 Fomorian Spear.",
        "Defeat Orna, which makes the other two despawn, and touch the Cermet Door again.",
        "Travel to Lower Jeuno and inspect the Street Lamp targets until you find a Hyper altimeter.",
        "Return to Bastok and speak with Raibaht to complete the quest and receive 3,000 gil.",
    },

    bsz_mw_the_naming_game = {
        "Obtain an Ordrynite. Enter Pso'Xja from Beaucedine Glacier (G-9) and defeat Cryptonberry Plaguer or Cryptonberry Stalker enemies for it. You can use an Outpost Warp or the Survival Guide to Beaucedine Glacier, then go to (G-9), or use Home Point #1 in Pso'Xja, Escape and go to (G-9). With Rank 10 Chocobo Digging you can probably get 10 in a day, although they are Rare, so you have to turn each one in.",
        "Speak with Raibaht in Metalworks (G-8) to begin the quest. You need Bastok fame level 5.",
        "Trade the Ordrynite to Raibaht to complete the quest.",
        "By completing this quest ten times, the fourth segment of the airship name is unlocked, and it can then be changed from the default, C.I.D.",
    },

    bsz_mw_out_of_the_depths = {
        "Speak with Ayame in Metalworks (K-7) for a cutscene and agree twice to start the quest. You need Bastok fame level 3 and the Chains of Promathia pack.",
        "Go to Port Bastok and speak with Ravorara at (E-7), outside the Steaming Sheep Restaurant, for a cutscene.",
        "Go to Oldton Movalpolos and speak with Brakobrik at (K-10). The closest warp is the Proto-Waypoint to the Geomagnetic Fount at (K-11), if you have it.",
        "Defeat Ancient Bomb enemies in Oldton Movalpolos to get Hoary Bomb Ash. You need 11 in total, which you trade to Brakobrik in exchange for key items.",
        "Go to Bastok Mines and speak with Pavvke in his residence on the lower level (I-7) for a cutscene that completes the quest and gives you your reward.",
    },

    bsz_mw_question_of_faith = {
        "Speak with Ayame in Metalworks (K-7) for a cutscene that starts the quest. You need Bastok fame level 4 and the Chains of Promathia pack.",
        "Go to Bastok Mines and speak with Virnage at (I-5) for a cutscene. Agree to his proposal and you receive the Dawn talisman.",
        "Go to Oldton Movalpolos and speak with Rakorok at (K-10). This spawns the NM Bugallug, which must be defeated. It has around 5,000 HP and uses the standard Bugbear attacks (Earthshock, Heavy Whisk, Flying Hip Press, etc.).",
        "After defeating Bugallug, speak with Rakorok for a cutscene in which you lose the Dawn talisman.",
        "Return to Bastok Mines and speak with Virnage to complete the quest and receive 3,000 gil.",
    },

    bsz_mw_return_to_depths = {
        "Speak with Ayame in Metalworks (K-7) for a cutscene that starts the quest. You need Bastok fame level 5 and the Chains of Promathia pack.",
        "Go to Oldton Movalpolos for a cutscene upon zoning.",
        "You receive the 10,000 gil back at the end of the quest. Trading Magriffon the 10,000 gil continues this specific quest even if other quests that involve giving Magriffon gil are active.",
        "Each person involved in the quest must trade a tear to Tarnotik to be teleported to the battlefield zone.",
        "Return to Metalworks and speak with Ayame to receive the Bowyer Ring and end the quest.",
    },

    bsz_mw_faded_promises = {
        "Change your main job to Ninja (level 20 or above) and speak with Romualdo at (K-9), in the southern Cannonry in Metalworks, to begin the quest. You need Norg fame level 4 and to have completed Ayame and Kaede.",
        "Speak with Ayame at (K-7), in the other Cannonry.",
        "Obtain a Palborough Chest Key. It drops from Scimitar Scorpion, Brass Quadav, Copper Quadav and Old Quadav enemies in Palborough Mines, or can be bought from the Curio Vendor Moogle for 2,500 gil if you have the key item Rhapsody in White.",
        "Travel to Palborough Mines and open a Treasure Chest to receive the key item Diary of Mukunda.",
        "Return to Bastok and speak with Kagetora in Port Bastok at (F-6).",
        "After that, speak with Ayame again.",
        "Finally, speak with Alois in the conference room of the President's Office in Metalworks (J-8) to complete the quest and receive the Fukuro.",
    },

    bsz_mw_too_many_chefs = {
        "Speak with Ferghus in the Craftsmen's Eatery in Metalworks (G-9), south of Cid's workshop, for a cutscene. Metalworks Home Point #1 is the closest. You need Bastok fame level 5 and the Wings of the Goddess pack.",
        "Speak with Leonhardt for another cutscene.",
        "Go to Bastok Markets (S) and speak with Raginmund near Harmodio's Music Shop (L-10).",
        "Obtain a Red Oven Mitt from Copper Quadav and Onyx Quadav enemies in Grauberg (S).",
        "Trade the Red Oven Mitt to Leonhardt for a brief cutscene.",
        "Speak with Umberto in Bastok Markets, near Harmodio's Music Shop (L-10), for a cutscene and your reward.",
    },

    bsz_mw_bait_and_switch = {
        "Speak with Salim in Metalworks (G-7) to start the quest; he wants you to help get rid of someone. You need Bastok fame level 3.",
        "Place Snares at the Cermet Refinery, the Kiln and the Metalworks Replica. The Costume kit only becomes available after you clear each of the first six items and the quest Chameleon Capers is cleared. You must use the Costume kit to get information and to avoid Salim at the switches.",
        "The goal is to find an NPC who tells you the switch order without talking to other NPCs who would call the guards to capture the Mithra and the Tarutaru friend. The following NPCs give clues about the switch order: Darha (ground floor, Galka near Home Point #2), Helmut (ground floor, Hume old man near Home Point #2), Hungry Wolf (upper floor, Craftsmen's Eatery, south of Cid's Lab) and Striking Snake (upper floor, Gunpowder Room, north of Cid's Lab).",
        "The small switch is at the Cermet Refinery (G-7). The medium switch is at the Replica (G-8) near the Metalworks entrance, next to the NPC Quasim. The large switch is at the kiln (F-8), just outside of the Blacksmithing Guild.",
        "If you activate an incorrect switch you have to start from the beginning. When you try to activate a switch, Salim may appear. If the same character gets captured twice, the quest ends.",
        "You can repeat this quest once per Conquest Tally.",
    },

    bsz_mw_synergistic_pursuits = {
        "It is no longer possible to flag the original quest. Speak to a Synergy Engineer to obtain a Synergy Crucible if you did not activate this quest before March 27, 2012.",
        "Speaking to Hildolf in Metalworks (F-8) still triggers a quest under the same title. This time he asks for a vial of Slime Oil.",
        "Once you bring him the item, you are given the option to choose a Fewell element. He crafts it for you while explaining the crafting process.",
        "After giving you the Fewell of your choosing, he no longer offers to craft it and instead encourages you not to give up if you are running low on Fewell.",
    },

    bsz_mw_synergistic_support = {
        "Speak with Hildolf in Metalworks (F-8) to learn how to create your own Fewell.",
        "Choose a type from the list and you are given three of that choice, which completes the quest.",
    },

    bsz_mw_weight_of_limits = {
        "You cannot start this quest if you have another Weapon Skill quest active; return to the person who gave it and quit it first. You need Great Axe skill 240 or higher, level 71, and the Rise of the Zilart pack.",
        "Speak with Iron Eater in Metalworks (J-8) to receive the Axe of Trials. You need to break the latent on the Axe of Trials before completing the rest of the quest.",
        "With the Axe of Trials equipped in your main hand, fight enemies rated Extremely Easy Prey or higher and use weapon skills or close skillchains to accumulate 300 Trial Points: 7 points for a level 1 skillchain, 9 for level 2 and 11 for level 3. Your elemental resistances are listed underneath your equipped gear grid.",
        "Alternatively, for the fastest route, use the Unity Warp to Ro'Maeve (level 125), then zone into The Sanctuary of Zi'Tah.",
        "Go back and speak with Iron Eater to receive your reward, the Steel Cyclone weapon skill.",
    },

    bsz_mw_shoot_first = {
        "You cannot start this quest if you have another Weapon Skill quest active or if you are on the quest Cid's Secret. You need level 71 and the Rise of the Zilart pack.",
        "Speak with Cid in Metalworks (H-8) to receive the Gun of Trials. You need to break the latent on the Gun of Trials before completing the rest of the quest.",
        "With the Gun of Trials equipped in your main hand, fight enemies rated Extremely Easy Prey or higher and use weapon skills or close skillchains to accumulate 300 Trial Points: 7 points for a level 1 skillchain, 9 for level 2 and 11 for level 3. Your elemental resistances are listed underneath your equipped gear grid.",
        "Go back and speak with Cid to receive your reward, the Detonator weapon skill.",
    },

    -- ========================================================
    -- OTHER LOCATIONS
    -- ========================================================

    bsz_ol_blade_of_evil = {
        "Travel to Beadeaux as a Dark Knight of level 50 or higher, and zone in from Pashhow Marshlands (this is important) to receive a cutscene that starts the quest. The quest follows Dark Puppet.",
        "Farm Topaz Quadav enemies until you obtain a Quadav Mage Blood. Only one is needed if you are doing this with a group.",
        "Proceed to Qufim and enter Delkfutt's Tower. Climb to Floor 7 (Middle Delkfutt's Tower).",
        "Defeat the 3 NMs in Middle Delkfutt's Tower. You then receive the Chaos Burgeonet from Zeid in a cutscene, which completes the quest.",
    },

    bsz_ol_chips = {
        'Steps not added yet.',
    },
}

return Q