local Q = {}

Q.STEPS = {

    -- ========================================================
    -- SAN D'ORIA
    -- ========================================================

    sdz_ss_sentrys_peril = {
        "Speak with Glenne in Southern San d'Oria (F-8) to receive an Ointment.",
        "Zone to West Ronfaure and look for Aaveleon at (G-6).",
        "Trade the Ointment to Aaveleon, who gives you back an Ointment Case.",
        "Return to Glenne and trade her the Ointment Case to complete the quest and receive your reward.",
    },

    sdz_ns_waters_of_cheval = {
    "Speak with Miageau at (L-7) in Northern San d'Oria, just past the entrance to the Cathedral.",
    "Trade 10 gil to Nouveil nearby to receive a Blessed Waterskin.",
    "Travel to East Ronfaure.",
    "Reach the Cheval River target at (H-5).",
    "Trade the Blessed Waterskin to the Cheval River to obtain Cheval Water.",
    "Return to Miageau in Northern San d'Oria.",
    "Trade the Cheval Water to Miageau to receive the Wing Pendant.",
    },

    sdz_ss_rosel_the_armorer = {
        "Speak with Rosel in Southern San d'Oria (K-8) to start the quest; you receive the receipt for the prince's cloak to deliver to the Chateau guards.",
        "Leave Rosel's Armour Shop and head west into Victory Square. Head north through Victory Arch into Northern San d'Oria, then straight north towards Chateau d'Oraguille.",
        "Look for the guard Guilerme near the bridge into the Chateau. He takes the receipt but cannot read the intended recipient: tell him which prince it is for, Pieuje or Trion, and he runs into the Chateau to deliver it.",
        "After the cutscene with Guilerme, return to Rosel for your reward: 200 gil if you named the right prince, only 100 gil if you named the wrong one.",
    },

    sdz_ps_the_pickpocket = {
        "Speak with Miene by the water in Port San d'Oria (I-8); a cutscene reveals a burglary in progress.",
        "Speak with Altiret, who asks you to retrieve the stolen item.",
        "Speak with Miene again to obtain a clue, an Eagle Button.",
        "Head to West Ronfaure and look for Esca inside a tower at (F-6).",
        "Trade the Eagle Button to her, which prompts her to admit she was the thief.",
        "After receiving the Gilt Glasses, return them to Altiret for your reward.",
    },

    sdz_ns_father_and_son = {
        "Speak with Ailbeche in Northern San d'Oria (J-9) for a cutscene that starts the quest. You must be level 10 or higher.",
        "Find his father, Exoroche, in Southern San d'Oria at (K-7) in Helbort's Blade.",
        "Return to Ailbeche and speak with him again for a cutscene. You receive the Willow Fishing Rod as your reward.",
        "To activate the Paladin quest Sharpening the Sword, trade the fishing rod back to Ailbeche. Doing so also changes your title to Family Counselor.",
    },

    sdz_ss_the_seamstress = {
        "Obtain 3 Sheepskins.",
        "Speak with Hanaa Punaa on the second floor balcony of the Leathercraft guild in Southern San d'Oria (E-8) to start the quest, then trade her the 3 skins to complete it.",
    },

    sdz_ps_dismayed_customer = {
        "Speak with Gulemont in Port San d'Oria (G-7) to begin the quest. This quest follows A Taste For Meat.",
        "Travel to West Ronfaure and locate a ???. It appears in one of three places: the border of (G-10) and (G-11), (G-9) at the outpost, or (F-11) in the south part of the square, close to a wall.",
        "Touch the ??? to obtain Gulemont's document.",
        "Return to Gulemont and speak with him to end the quest.",
    },

    sdz_ns_trader_in_forest = {
        "Speak with Abeaule in Northern San d'Oria (F-8); he needs someone to fill an order. Accept the task and he gives you a Supplies Order.",
        "Take the Supplies Order to the tower at (I-11) in West Ronfaure and trade it to Phairet to receive the Batagreens. Trading him 50 gil also gets you the Batagreens, as long as the quest has been flagged.",
        "Take the Batagreens back to Abeaule for your reward.",
    },

    sdz_ss_sweetest_things = {
        "Speak with Raimbroy in Southern San d'Oria (F-8) to start the quest.",
        "Obtain Honey x5. It drops from Maneating Hornet enemies in North Gustaberg and South Gustaberg, or can be bought from Chomo Jinjahl in Windurst Waters North (E-8) for 200 gil with Cooking Guild Recruit rank or higher.",
        "Trade the Honey x5 to Raimbroy to complete the quest and receive 400 gil.",
    },

    sdz_ns_vicasques_sermon = {
        "Speak with Abioleget in Northern San d'Oria (M-7); he needs you to deliver Blue Peas.",
        "Trade him 70 gil to receive the Blue Peas.",
        "Look for Andelain in East Ronfaure at (J-11) and give him the peas.",
        "Return to Abioleget for your reward.",
    },

    sdz_ss_squires_test = {
        "Speak with Balasiel on the upper walkways of Southern San d'Oria (F-7); he asks you for a Revival Tree Root. You must be level 10 or higher.",
        "Obtain a Revival Tree Root. It can be bought at the Auction House (Materials, Alchemy) or dropped by Ghost-type enemies, and it does not need to come from King Ranperre's Tomb.",
        "Trade the root to Balasiel to complete the quest and receive your reward.",
    },

    sdz_ss_grave_concerns = {
        "Speak with Andecia, in the middle house on the first floor of Squire's Alley in Southern San d'Oria (M-7), once to trigger the story text. Speak with her again to receive the Well Water.",
        "Go to King Ranperre's Tomb (I-10) on the first map.",
        "Trade the Well Water to the tombstone to receive a Tomb Waterskin.",
        "Return to Andecia and trade her the Tomb Waterskin to complete the quest.",
        "If you lose the Well Water, touch the tombstone in King Ranperre's Tomb to receive a Tomb Waterskin, then trade it to the water well in Southern San d'Oria (F-6) to get a new Well Water.",
    },

    sdz_ps_brugaire_consortium = {
        "Speak with Fontoumant in Port San d'Oria (H-9). He asks you to deliver parcels to various NPCs in Port San d'Oria. You can only hold one parcel at a time, so deliver it and then return to him for another.",
        "Deliver the Magic Shop Parcel to Regine (J-8).",
        "Deliver the Auction Parcel to Apstaule, who is upstairs (H-10).",
        "Deliver the Pub Parcel to Thierride (G-7).",
        "Once all parcels are delivered, speak with Fontoumant again for your reward.",
    },

    sdz_ss_lizard_skins = {
        "Obtain 3 Lizard Skins. They can be bought from Cletae in Southern San d'Oria (D-8) for 600 gil, but only with Leathercraft Recruit rank or higher.",
        "Speak with Hanaa Punaa in Southern San d'Oria (E-8) to start the quest and trade her the 3 skins to complete it.",
    },

    sdz_ps_flyers_for_regine = {
        "Speak with Regine in Port San d'Oria (J-8) to begin the quest, and choose the option to look for work.",
        "Hand out the 15 Magicmart Flyers, only to townsfolk and not to adventurers. While the quest is active, when you come close to an NPC who should get a flyer, a message in /say tells you that the NPC looks over curiously for a moment.",
        "You must hand out all 15 flyers or the quest will not be completed. If you lose them, you can buy more from Regine for 10 gil each.",
        "Once all 15 Magicmart Flyers have been distributed, return to Regine and speak with her to end the quest.",
    },

    sdz_ns_gates_to_paradise = {
        "Speak with Olbergieut in the Cathedral in Northern San d'Oria (L-7) to begin the quest; you receive the Scripture of Wind.",
        "Travel to (K-8) in La Theine Plateau, at the tail end wall of the Crag of Holla, and look for the NPC Faurbellant.",
        "Speak with Faurbellant, who gives you the Scripture of Water.",
        "Return to Olbergieut and speak with him to end the quest.",
    },

    sdz_ss_squires_test_2 = {
        "Speak with Balasiel in Southern San d'Oria (F-7) to start the quest.",
        "Go to Ordelle's Caves. You can use the Abyssea La Theine Plateau warp and enter from La Theine Plateau (H-7), or the Survival Guide if you have picked it up.",
        "If you entered from La Theine Plateau (H-7) you arrive on map 1 (K-3): head to (I-5), a room with Fly Agaric enemies. If you used the Survival Guide you arrive on map 2 (G-2): go to map 1 (Point A, G-4), then to (I-5).",
        "From the Fly Agaric room, take the southwest passage (to Point C, G-6/H-6) to reach map 2, and proceed to the large room at (G-7).",
        "Examine the ??? to get the Stalactite dew.",
        "Speak with Balasiel to complete the quest.",
    },

    sdz_ss_cure_a_cough = {
        "Speak with Nenne in Southern San d'Oria (F-6). The quest does not appear in your quest log until the item hunt part has been activated.",
        "After hearing Nenne's story, go into the first house on Watchdog Alley (G-7), go upstairs to a bedroom and examine the ??? on the table. Click it to get the option to read a diary.",
        "Speak with Amaura (G-6), who asks for Thyme Moss.",
        "Obtain Thyme Moss and return it to Amaura, who gives you Cough Medicine.",
        "Speak with Nenne, who gives you a Scroll of Treasure as your reward.",
    },

    sdz_ss_tigers_teeth = {
        "Obtain Black Tiger Fang x3. It can be found at the Auction House (Materials, Bonecraft) or bought from Retto-Marutto in Windurst Woods (H-13) for 2,000 gil.",
        "Trade the Black Tiger Fang x3 to Taumila in Southern San d'Oria (E-9) to complete the quest and receive 2,100 gil.",
    },

    sdz_ns_undying_flames = {
        "Speak with Pagisalis in Northern San d'Oria (M-6) to start the quest; he wants two lumps of beeswax to make candles.",
        "Obtain Beeswax x2.",
        "Trade the Beeswax x2 to Pagisalis for your reward.",
    },

    sdz_ns_purchase_of_arms = {
        "Speak with Helbort at the weapon shop in Southern San d'Oria (K-7) after completing Father and Son; you receive the key item Weapons order.",
        "Bring the Weapons order to Alexius in Jugner Forest (I-6), near the lake; you receive the key item Weapons receipt.",
        "Return to Helbort to complete the quest and receive your reward.",
    },

    sdz_ss_knights_test = {
        "Speak with Balasiel in Southern San d'Oria (F-7), who gives you the Book of Tasks with hints on how to proceed. You must be level 30.",
        "Speak with Cahaurme (J-9), reached from (L-8) in the tower above the East Gate, to receive the Book of the East.",
        "Speak with Baunise (H-9), reached from (F-8) in the tower above the West Gate, to receive the Book of the West.",
        "Go to the dead end at (E-10) in Davoi and examine the Disused Well to receive the Knight's soul. To get there, follow the river west from (J-10), then head south after reaching (D-8).",
        "Beware of Orcish Farkiller enemies on top of the ledge, which can aggro even at level 99, and of Pugil enemies in the river, which aggro by sound to characters near level 30.",
        "Return to Balasiel to complete the quest.",
    },

    sdz_ns_medicine_woman = {
        "Speak with Abeaule in Northern San d'Oria (F-8).",
        "Go to Southern San d'Oria (G-6) and speak with Amaura. She needs certain ingredients to brew the medicine and gives you Amaura's formula, which lists them: 1 Insect Wing, 1 Malboro Vine and 1 Zinc Ore.",
        "Gather those items and trade them to Amaura to receive the key item Cold medicine.",
        "Deliver the Cold medicine to Abeaule for your reward, 2,100 gil.",
    },

    sdz_ss_black_tiger_skins = {
        "Obtain 3 Black Tiger Hides.",
        "Speak with Hanaa Punaa in Southern San d'Oria (E-8) to start the quest and trade her the 3 hides to complete it.",
    },

    sdz_ns_growing_flowers = {
        "Optional: speak with Kuu Mohzolhi in Northern San d'Oria (F-8). She does not say it at first, but she would like a Marguerite.",
        "Obtain a Marguerite. It can be bought at the Auction House, or from Areebah in Upper Jeuno (H-6) for 120 gil.",
        "Trade the Marguerite to Kuu Mohzolhi to complete the quest.",
        "If you trade her the wrong flower, such as one meant for the other two Mog House exit quests, she keeps it and you will have to get another.",
    },

    sdz_ns_trial_by_ice = {
        "Speak with Gulmama in Northern San d'Oria (E-7) to get the quest. If you are sure you have the required fame but she does not offer it, keep speaking with her until her text changes. Once you receive the key item Tuning fork of ice you can safely undertake the quest.",
        "Go to Fei'Yin. In the basement (map B) travel to (I-5) to find the entrance to the Cloister of Frost. Each party member must have their own Tuning fork of ice.",
        "Defeat Shiva Prime to receive the key item Whisper of frost.",
        "Return to Gulmama with the whisper and she offers several rewards, including the ability to summon Shiva. You can only select one reward at a time, and you can repeat the quest once per Earth day.",
        "To save travel time to the Cloister of Frost, you can use the Mini tuning fork of ice from the quest Trial-Size Trial by Ice. You must be on Summoner as your main job: get the Mini tuning fork from Castilchat, trade the fork back to Castilchat, and enter the Protocrystal normally. As long as you do not clear the level 20 version, you may warp to the Cloister as many times as you like.",
        "You may also keep the whisper to meet the requirements of the quest The Moonlit Path.",
    },

    sdz_co_generals_secret = {
        "Speak with Curilla in Chateau d'Oraguille (I-9) and agree to help her; you receive the key item Curilla's bottle.",
        "Head to Horlais Peak by going through Yughott Grotto.",
        "Once in Horlais Peak, go to the Hot Springs and check them to fill the bottle. The name does not change, so to confirm you filled it, read the description of the item under Temporary Items: it should say it is full of water from the hot spring that flows from Horlais Peak.",
        "Return to Curilla for your reward.",
    },

    sdz_bo_the_rumor = {
        "Speak with Novalmauge in Bostaunieux Oubliette (G-8) to begin the quest. You must be level 10 or higher.",
        "Trade Novalmauge a vial of Beastman Blood to complete the quest.",
    },

    sdz_co_majestys_garden = {
        "Speak with Chalvatot in Chateau d'Oraguille (F-7) to begin the quest.",
        "Obtain a Derfland Humus. It drops from Doom Scorpion enemies in Crawlers' Nest, and can also be purchased at the Auction House.",
        "Trade the Derfland Humus to Chalvatot to complete the quest and receive the Map of the Northlands area.",
    },

    sdz_wr_intro_teamwork = {
        "You must be level 10 or higher. First, zone at (C-7) in Northern San d'Oria.",
        "You should now be in a watchtower in West Ronfaure, and Vilatroire should be up ahead after zoning in (H-5). Speak with him to activate the quest.",
        "Form a party of two, yourself and one other player, with the same allegiance, then speak with him again to complete the quest.",
    },

    sdz_wr_intermediate_teamwork = {
        "You must be level 10 or higher. First, zone at (C-7) in Northern San d'Oria.",
        "You should now be in a watchtower in West Ronfaure, and Vilatroire should be up ahead after zoning in (H-5). Speak with him to activate the quest.",
        "Form a party of two, yourself and one other player, with the same race, then speak with him again to complete the quest.",
    },

    sdz_wr_advanced_teamwork = {
        "You must be level 10 or higher. First, zone at (C-7) in Northern San d'Oria.",
        "You should now be in a watchtower in West Ronfaure, and Vilatroire should be up ahead after zoning in (H-5). Speak with him to activate the quest.",
        "Form a party of two, yourself and one other player, with the same job, then speak with him again to complete the quest.",
    },

    sdz_ss_grimy_signposts = {
        "Speak with Maugie in Southern San d'Oria (L-9) to start the quest.",
        "Travel to Jugner Forest and click on the signposts at the following spots to clean them: (E-11), (G-8), (H-7) and (J-5).",
        "Speak with Maugie again after cleaning them to receive your reward, 1,500 gil.",
    },

    sdz_ps_job_for_consortium = {
        "Speak with Portaure in Cargo Room B, near Home Point #1 in Port San d'Oria (H-9), to accept the quest and obtain the Brugaire goods. Nighttime is the safest option.",
        "Take the next airship to Jeuno. You must go through Jeuno's Air Travel Agency before delivering to the Tenshodo, or the package will be damaged and the quest failed.",
        "If you pass through undetected, speak with Yin Pocanakhu in Lower Jeuno (J-8). If you are caught, your airship pass is revoked until midnight Japan time and the quest is failed.",
        "Return to Portaure for your reward. Completing this quest raises your fame in Norg.",
    },

    sdz_ns_trouble_at_sluice = {
        "Speak with Belgidiveau in Northern San d'Oria (G-8) to begin the quest.",
        "Speak with Novalmauge in Bostaunieux Oubliette (G-8).",
        "Trade Novalmauge a Dahlia to receive a Neutralizer.",
        "Return to Belgidiveau to complete the quest.",
    },

    sdz_ss_merchants_bidding = {
        "Speak with Parvipon, the tanner, in Southern San d'Oria (E-8) outside the Leathercraft Guild to begin the quest. The first time you must answer \"I shall help.\" before you can proceed; speaking to him again is not needed for later trade-ins.",
        "Trade Rabbit Hide x3 to Parvipon for your reward. Rabbit Hide is sold upstairs in the Leathercraft guild by Cletae (D-8).",
        "You can repeat this quest as often as you like.",
    },

    sdz_ns_unexpected_treasure = {
        "Buy a Cupboard from the furniture shop in Northern San d'Oria (F-8) and put it in your Mog House.",
        "Zone out of and back into your Mog House, then wait some time (between 10 and 15 real-world minutes).",
        "Talk to your Moogle. He says he found something and gives you a Small teacup. If he does not give it to you, you may not have waited long enough.",
        "Return to the furniture shop and speak with Morunaude twice.",
        "Speak with Calovour in the Cathedral (M-6).",
        "Bring Calovour a Mistletoe to complete the quest.",
    },

    sdz_ns_blackmail = {
        "Speak with Dauperiat in Northern San d'Oria (I-10) to obtain a Suspicious envelope, and deliver it to Halver in Chateau d'Oraguille.",
        "Return to Dauperiat, who now asks you to do a second job for him. If you choose to keep helping him you lose fame; if you choose no, you can proceed to the next quest, The Setting Sun.",
        "If you say yes, he asks you to get the floor plans back from the Orcs. Orcish Serjeant enemies in Fort Ghelsba and Batallia Downs can drop the Castle Floor Plans.",
        "Trade the Castle Floor Plans back to Dauperiat for your reward.",
    },

    sdz_ns_setting_sun = {
        "Speak with Vamorcote in Northern San d'Oria (F-5) to begin the quest.",
        "Head to the island in Batallia Downs (J-11). The only way to get there is through The Eldieme Necropolis: enter it from (I-10) in Batallia Downs. The Survival Guide puts you in the correct part of the Eldieme for this quest.",
        "Once inside, hug the south side until you reach a large room at (G-9), and fall through the grave in the center of the room. To reach the room at (G-9) you need someone to operate the gates for you, or the Magicked astrolabe.",
        "Defeat Ahtu to obtain an Engraved Key.",
        "Trade the Engraved Key to Vamorcote to complete the quest and receive 10,000 gil.",
    },

    sdz_ss_distant_loyalties = {
        "Speak with Femitte in Southern San d'Oria (I-8), who needs a goldsmithing order fulfilled and asks for an Elvaan specifically. She gives you a Goldsmithing order.",
        "Go to Bastok Markets (Home Point #1) and look for Michea at (F-10), upstairs inside Brunhilde the Armorer's shop.",
        "Michea asks for a Mythril Ingot. Trade it to her, then zone out of Bastok Markets once.",
        "Zone back into Bastok Markets and return to Michea to receive the key item Mythril hearts.",
        "Travel back to Southern San d'Oria and speak with Femitte to complete the quest.",
    },

    sdz_ps_the_rivalry = {
        "The quest begins with either Joulet (for The Competition) or Gallijaux (for The Rivalry) in Port San d'Oria (H-8).",
        "Trade whichever brother you want to help Moat Carp and/or Forest Carp x10,000.",
        "Ufanne in Port San d'Oria (H-8) keeps track of how many fish you have turned in, and to which brother. You may need to speak to her multiple times.",
        "Speaking to either brother tells you how many carp he has been traded by all players since the last server maintenance.",
    },

    sdz_ss_starting_a_flame = {
        "Speak with Legata in the Lion Spring's Tavern in Southern San d'Oria (K-6) to begin the quest.",
        "Obtain Flint Stone x4. It can be found at the Auction House (Materials, Goldsmithing) or dropped by worm enemies such as Tunnel Worm in East Ronfaure, West Ronfaure, North Gustaberg and South Gustaberg.",
        "Trade the 4 Flint Stones to Legata for your reward.",
    },

    sdz_ns_fear_of_dark = {
        "Speak with Secodiand in Northern San d'Oria (F-6) to start the quest; he wants two bat wings.",
        "Obtain Bat Wing x2.",
        "Trade the Bat Wing x2 to Secodiand to complete the quest and receive 200 gil.",
    },

    sdz_ns_warding_vampires = {
        "Speak with Maloquedil in Northern San d'Oria (J-8) to begin the quest.",
        "Obtain Shaman Garlic x2, which drops from Orcish Cursemaker enemies.",
        "Trade him the 2 Shaman Garlic to complete the quest and receive 900 gil.",
    },

    sdz_ss_sleepless_nights = {
        "Speak with Paouala in Southern San d'Oria (M-8); she asks for Mary's Milk.",
        "Obtain a Mary's Milk. It drops from Stray Mary in Konschtat Highlands, and can also be bought at the Auction House.",
        "Trade the Mary's Milk to Paouala to complete the quest and receive 5,000 gil.",
    },

    sdz_ps_lufets_lake_salt = {
        "Speak with Nogelle in Port San d'Oria (G-7) to start the quest; she wants three chunks of salt from Lufet's Lake.",
        "Obtain Lufet Salt x3.",
        "Trade the Lufet Salt x3 to Nogelle to complete the quest and receive 600 gil.",
    },

    sdz_ns_healing_the_land = {
        "Speak with Eperdur at (M-7) in Northern San d'Oria. He gives you the Seal of banishing, which you must place on a ??? target. You must be level 10 or higher.",
        "Travel to Gusgen Mines from Konschtat Highlands. The fastest way is the Survival Guide, then Zulkheim, then Gusgen Mines.",
        "Head north, down the stairs, and hit the lever to go through the middle door at (H-6). Then north again, down the stairs, and hit the lever for the left door this time.",
        "Take a left at the T intersection, then head north. Go west until another split.",
        "Check the ???.",
        "Speak with Eperdur again for your reward. You must zone before you can be offered the follow-up quest, Sorcery of the North.",
    },

    sdz_ns_sorcery_of_north = {
        "Zone after completing Healing the Land to begin this quest.",
        "Speak with Eperdur in Northern San d'Oria (M-7), on the second level of the Cathedral.",
        "Obtain a Fei'Yin Chest Key by defeating Shadow, Underworld Bat and Ore Golem enemies in that area.",
        "Open a treasure chest using either the key or Thief's Tools to obtain the key item Fei'Yin magic tome.",
        "Return to Eperdur to receive your reward.",
    },

    sdz_ss_crimson_trial = {
        "Speak with Sharzalion in the Lion Springs Tavern in Southern San d'Oria (K-6) with Red Mage as your main job, level 40 or higher. You only have to be on Red Mage to start the quest, and you must answer \"Yes\" for it to start.",
        "Go to Davoi and defeat Purpleflash Brukdok (BLM) at (E-9)/(F-9) to obtain a Davoi Storage Key. It drops one key and respawns after about 10 minutes; each Red Mage doing the quest needs a key. To get there, run along the creekbed from (J-10) to (D-8).",
        "Trade the Davoi Storage Key to the targetable Storage Hole, which moves randomly around the zone at the start or end of each game day and is usually in open areas. Known locations: (E-10), (F-6), (F-7), (F-9), (G-9), (G-10), (H-8), (I-7), (I-8), (J-7), (J-8), (K-7), (K-8), (K-9) and (K-10). The center island Storage Hole at (H-8) can be reached from the river.",
        "You obtain the key item Orcish dried food after trading the key.",
        "Return to Sharzalion to receive your Fencing Degen.",
    },

    sdz_co_enveloped_darkness = {
        "After completing The Crimson Trial and reaching level 50 or higher as a Red Mage, speak with Curilla (I-9) in Chateau d'Oraguille. You no longer have to be on Red Mage after starting the quest.",
        "Depending on your character's progress, you may get the Savage Blade quest and The General's Secret first.",
        "The NPC you are sent to requests a Velvet Cloth. Trade him a Velvet Cloth.",
        "Speak with Curilla again.",
        "Head to Crawlers' Nest and open a Treasure Chest with a Nest Chest Key to obtain the key item Crawler blood. The chest has a 3 minute respawn time.",
        "You can buy a Nest Chest Key from the Curio Vendor Moogle for 2,500 gil if you have the key item Rhapsody in White, from completing Rhapsodies of Vana'diel Mission 1-6.",
        "If you get the message \"Someone has been digging here\", you forgot to speak to Curilla after trading the Velvet Cloth.",
    },

    sdz_co_peace_for_spirit = {
        "Speak with Curilla in Chateau d'Oraguille (I-9) to start the quest; you must be a Red Mage of level 50 or higher and able to enter Chateau d'Oraguille.",
        "Go to Southern San d'Oria and speak with Sharzalion in the Lion Springs Tavern (K-6).",
        "Go to Fei'Yin and defeat Miser Murphy for an Antique Coin. He appears at (H-8) on map 1 if the quest is active.",
        "Trade the Antique Coin to the Dry Fountain at (H-8) for a cutscene.",
        "Head to Southern San d'Oria and speak with Sharzalion, and then with Daggao, who is in the bar as well.",
    },

    sdz_ns_messenger_beyond = {
        "As a White Mage, level 40 or higher, speak with Narcheral upstairs in the Cathedral in Northern San d'Oria (M-6) to get the quest. You can do the rest of the quest on any job.",
        "Head to (B-8), the Secret Beach, in Valkurm Dunes. The Survival Guide teleport to Gustav Tunnel, then walking out, leaves you right next to the spawn point.",
        "Between 18:00 and 5:00 a ??? appears near the Song Runes. Click it to spawn Marchelute.",
        "Marchelute drops a Tavnazia Pass.",
        "Take the Tavnazia Pass back to Narcheral to complete the quest and receive your Blessed Hammer.",
    },

    sdz_co_prelude_black_white = {
        "As a White Mage of level 50 or higher, examine the Door: Prince Regent's Rm in Chateau d'Oraguille at (H-8) to start the quest. You must be able to enter Chateau d'Oraguille.",
        "Go to Castle Oztroja or Castle Zvahl Keep and defeat Yagudo Abbot enemies until a Yagudo Holy Water drops.",
        "Find a pair of Moccasins.",
        "Take the Moccasins and the Yagudo Holy Water to Narcheral (M-6) in Northern San d'Oria to complete the quest and obtain your Healer's Duckbills.",
    },

    sdz_co_pieujes_decision = {
        "Open the Door: Prince Regent's Rm in Chateau d'Oraguille at (H-8) to start the quest. You can continue as any job from this point.",
        "Go to Eldieme Necropolis and defeat Dark Stalker enemies until a Tavnazia Bell drops.",
        "Travel to Fei'Yin and zone in for a cutscene.",
        "Trade the Tavnazia Bell to the ???.",
        "Defeat the monster that appears to obtain a Tavnazian Mask. If more than one character is doing this quest, you will have to wait a few minutes before popping it again.",
        "Trade the Tavnazian Mask to Narcheral in the Cathedral, upstairs in Northern San d'Oria (M-6), to receive your reward.",
    },

    sdz_ns_sharpening_sword = {
        "To start this quest you must first trade the fishing rod from Father and Son back to Ailbeche. You need to be a Paladin of level 40 or higher, and to have completed A Knight's Test.",
        "Speak with Ailbeche near Home Point #2 in Northern San d'Oria (J-8) to begin the quest; he asks you for an Ordelle whetstone.",
        "Speak with Sobane in Southern San d'Oria (D-6). Be sure to speak with her twice if you get a cutscene the first time.",
        "Enter Ordelle's Caves from the entrance in La Theine Plateau (F-7), which puts you on map 2. Taking the Survival Guide to Ordelle's Caves is the fastest route.",
        "Take the first left and walk toward (I-6) on map 2 to use exit B, which puts you on map 1.",
        "Return to Ailbeche to end the quest and receive your reward.",
    },

    sdz_ns_boys_dream = {
        "Speak with Ailbeche in Northern San d'Oria (J-8).",
        "Return to Ailbeche and speak with him again.",
        "Trade Ailbeche a Giant Shell Bug. You can buy one at the Auction House, or go to Crawlers' Nest and defeat Dreadbug through the ???. Dreadbug can be spawned again once per game day while the quest is active.",
        "Be careful to do the NPC interactions above: if you skip them, you use up the Giant Shell Bug you get in the next step.",
        "Fish in Castle Oztroja with a rod used for catching big fish, using the Giant Shell Bug as bait. Bring more than one Giant Shell Bug.",
        "The Odontotyrannus monster is fished up; defeat it and it drops Odontotyrannus.",
        "Return to Ailbeche and trade him the Odontotyrannus.",
        "Trade the Odontotyrannus to Zaldon, inside the Fisherman's Guild in Selbina (H-9), to receive the Knight's boots.",
    },

    sdz_co_under_oath = {
        "Examine the door to Prince Trion's room (Door: Prince Royal's Rm) at Chateau d'Oraguille (H-7) while you are a Paladin, for a cutscene. Check your active quests: you should see Under Oath. The rest of the quest can be completed as any job.",
        "Obtain a Zvahl Coffer Key and trade it to a Treasure Coffer in Castle Zvahl Baileys to get the key item Mique's paintbrush. You can buy the key from the Curio Vendor Moogle for 5,000 gil if you have the key item Rhapsody in Umber. It also drops from Ahriman, Abyssal Demon, Arch Demon, Blood Demon and Doom Demon, or a Thief can pick the coffer's lock with Thief's Tools, a Living Key or a Skeleton Key.",
        "Look behind the painting and read the letter to get the key item Strange sheet of paper.",
        "Defeat One-eyed Gwajboj (PLD), which drops the Well Weight you need to continue the quest.",
        "Trade the Well Weight to the Village Well for a cutscene and the key item Knight's confession.",
        "Head back to Chateau d'Oraguille and speak with Prince Trion for your reward.",
        "You may additionally speak with Ailbeche, Exoroche and Vemalpeau for more quest-related dialogue. Vemalpeau takes your Knight's confession key item.",
    },

    sdz_ps_the_holy_crest = {
        "Speak with Arminibit and Ceraulian inside Cargo Room A in Port San d'Oria (I-9). You must be level 30 or higher and have the Rise of the Zilart pack.",
        "If you have not yet completed the quest The Rumor, you can speak to Novalmauge a second time to accept it. You no longer need to complete The Rumor before advancing the job quest.",
        "The quest now shows up in your quests tab. Go to the Maze of Shakhrami and trade a Pickaxe to an Excavation Point to receive a Wyvern Egg.",
        "Only people who have reached this point in the quest, or who have already completed it, may enter the battlefield.",
    },

    sdz_ns_craftsmans_work = {
        "Make sure your main job is Dragoon, level 40 or higher, when you speak with Miaux in Northern San d'Oria (E-6). She asks you to obtain an Altepa polishing stone. After speaking to her you can change to another job to do the rest of the quest.",
        "Examine the ??? in Eastern Altepa Desert, in the lower part of (H-8), to spawn Decurio I-III. The Survival Guide warp puts you very near; Teleport-Altep is another good option.",
        "Defeat Decurio I-III, then examine the ??? again to receive the Altepa polishing stone.",
        "Speak with Miaux again to receive your reward.",
    },

    sdz_ps_chasing_quotas = {
        "Speak with Ceraulian inside Cargo Room A in Port San d'Oria (I-10) to begin the quest; you must be a Dragoon of level 50 or higher. Agree to help him obtain a Gold Hairpin. From this point on you can change to any other job.",
        "Trade him a Gold Hairpin for a cutscene. A Gold Hairpin +1 will not work.",
        "Wait one minute, then speak to Ceraulian again.",
        "Speak with Miaux in Northern San d'Oria (E-6) to receive a Shiny earring.",
        "Speak with Ardea in Bastok Markets (H-8), in front of the Goldsmithing Guild next to Home Point #4. If you have started the quest Rock Racketeer, you must finish it before Ardea lets you continue.",
        "Next, speak with Esca in West Ronfaure (F-6).",
        "Return to Ceraulian for your reward.",
    },

    sdz_co_knight_stalker = {
        "Speak with Rahal in Chateau d'Oraguille (H-9), inside the Royal Knight Quarters, as a Dragoon of level 50 or higher to begin the quest.",
        "Speak with Ceraulian in Port San d'Oria (I-10), inside Cargo Room A, for a cutscene.",
        "Speak with Ceraulian once more after the cutscene.",
        "Obtain a Kuftal Coffer Key and use it to open any coffer in Kuftal Tunnel. This gives you the key item Challenge to the Royal Knights.",
        "Return to Rahal and speak to him again.",
        "Speak with Balasiel in Southern San d'Oria (F-7).",
        "Speak with Rahal again.",
    },

    sdz_ss_eco_warrior = {
        "Speak with Norejaie in Southern San d'Oria (K-6) to begin the quest. You must be level 25 or higher, and you cannot get it while the quest Eco-Warrior (Bastok) or Eco-Warrior (Windurst) is active.",
        "Enter Ordelle's Caves from the (F-7) entrance in La Theine Plateau; the Survival Guide warp takes you right there.",
        "Speak with Rojaireaut (G-3) to have your level capped at 25. Everyone in your party or alliance needs the level cap applied to them, and it has no timer.",
        "Stink Bat enemies link to Hognosed Bat enemies.",
        "Go to the ??? at the northeast corner of (G-9).",
        "Return to Norejaie to complete the quest. You can only complete one Eco-Warrior quest a week; wait until the next Conquest tally before accepting another.",
    },

    sdz_ss_methods_madness = {
        "You cannot start this quest while another Weapon Skill quest is active; return to the person who gave it and quit it first. You need Polearm skill 240 or higher, level 71 and the Rise of the Zilart pack.",
        "Speak with Balasiel in Southern San d'Oria (F-7) to receive the key item Weapons Training Guide and the Spear of Trials.",
        "Break the latent on the Spear of Trials before doing the rest of the quest. Each skillchain gives points: 5 with no skillchain, 7 at level 1, 9 at level 2 and 11 at level 3.",
        "Trade the Spear of Trials back to Balasiel.",
        "Obtain a Sahagin Key, which the quest requires.",
        "Go back and speak with Balasiel to receive your reward.",
    },

    sdz_bo_souls_in_shadow = {
        "You cannot start this quest if you have another Weapon Skill quest active; return to the person who gave it and quit it first. You need Scythe skill 240 or higher and level 71.",
        "Speak with Novalmauge in Bostaunieux Oubliette (G-8) to receive the key item Weapons Training Guide and the Scythe of Trials. You need to break the latent on the Scythe of Trials before completing the rest of the quest.",
        "With the Scythe of Trials equipped in your main hand, fight enemies rated Extremely Easy Prey or higher and use weapon skills or close skillchains to accumulate 300 Trial Points.",
        "You know the latent is broken when the elemental resistances listed in the Scythe of Trials description have disappeared from the elemental resistances in the equipment window.",
        "Trade the Scythe of Trials back to Novalmauge.",
        "Make sure that you, or someone in your party, has a Paintbrush of Souls. Use it to open the Granite Door at (I-7) and head into the Den of Rancor.",
        "Go back and speak with Novalmauge to receive your reward.",
    },

    sdz_ps_taste_for_meat = {
        "Speak with Antreneau and then Thierride, both in the Rusty Anchor Pub (G-7) in Port San d'Oria, to begin the quest.",
        "Obtain Hare Meat x5. For low-level players, Wild Rabbit and Forest Hare enemies can be defeated for experience points and have a chance to drop it.",
        "Trade the 5 Hare Meat to Thierride to complete the quest.",
        "Afterwards, speak with Antreneau and he gives you a Grilled Hare.",
    },

    sdz_ns_exit_the_gambler = {
        "Speak with Aurege in Northern San d'Oria (F-3), near Home Point #4 outside the Carpenter's Guild, to start the quest.",
        "Optional: speak with Nonterene (I-10) at the Parade Grounds near Victory Arch.",
        "Find Varchet in Southern San d'Oria at (L-6), right next to the fountains. You need to gamble against him; each attempt costs 5 gil, so keep trying until you win. You can still gamble with him after the quest is complete.",
        "After winning, return and speak with Aurege for your reward. The quest does not appear in your log until it is completed.",
    },

    sdz_co_old_wounds = {
        "You cannot start this quest if you have another Weapon Skill quest active; return to the person who gave it and quit it first.",
        "Speak with Curilla in Chateau d'Oraguille (I-9) to receive the Sapara of Trials. You need to break the latent on the Sapara of Trials before completing the rest of the quest.",
        "With the Sapara of Trials equipped in your main hand, fight enemies rated Extremely Easy Prey or higher and use weapon skills or close skillchains to accumulate 300 Trial Points.",
        "You know the latent is broken when the elemental resistances listed in the Sapara of Trials description have disappeared from the elemental resistances in the equipment window.",
        "Trade the Sapara of Trials back to Curilla.",
        "Before you go on, speak with Lokpix in Eastern Altepa Desert (G-7) and complete the quest Open Sesame.",
        "Go back and speak with Curilla to receive your reward.",
    },

    sdz_ns_escort_for_hire = {
        "Speak with Rondipur in Northern San d'Oria (F-6) to begin the quest. Only one Escort for Hire quest can be active at a time, and only one can be completed each Conquest Tally.",
        "Head to Eldieme Necropolis from Batallia Downs (I-10). As soon as you zone in you receive a cutscene, after which the NPC Cannau appears. You can summon Trusts, but zoning in with an Adventuring Fellow makes the escort NPC disappear.",
        "You have 30 minutes to complete the quest.",
        "Return to Rondipur for your reward.",
    },

    sdz_ss_timely_visit = {
        "Speak with Deraquien in Southern San d'Oria (G-8) for a cutscene.",
        "Go to La Theine Plateau and speak with Narvecaint (F-7) for another cutscene.",
        "Return to Deraquien and speak with him again.",
        "Go to Chateau d'Oraguille and speak with Halver. If you have just cleared The Voracious Resurgence, you will have to rezone after the cutscene and speak with him again.",
        "Speak with Deraquien again.",
        "Speak with Phillone (D-7).",
        "Go back and speak with Deraquien.",
        "Head to Jugner Forest through King Ranperre's Tomb. If you have access to the Proto-Waypoint, it is the fastest way to reach the location.",
        "Click the ??? at (F-5) between 18:00 and 4:00 to spawn two NMs, Giollemitte B Feroun and Skeleton Esquire. Both must be defeated to proceed.",
    },

    sdz_co_fit_for_a_prince = {
        "Speak with Halver in Chateau d'Oraguille (I-9) for a cutscene. In it you are told the description of the type of female Prince Trion is attracted to.",
        "Find a player who matches the description and make a party with them. Then return to Halver while in the same party as the match. Having a female character in the party does not force Halver to ask for that character; the choice is random.",
        "Both players must speak to Halver, and each one receives the same cutscene. The player who started the quest gains the title Royal Wedding Planner as well as Castor's Ring. The player who matches the description gains the title Consort Candidate and Pollux's Ring.",
        "The rings can be synthesized with a Wind Crystal, and can also be signed with a Cyclone Crystal. Doing so with either removes the Rare and Exclusive attributes, and the rings can then be traded to another person, acting like a Wedding Ring.",
        "The quest can be abandoned and re-accepted every minute without zoning. To be given a different female description, you must accept and then cancel the quest. It resets every minute at XX:XX:00 Earth time, not when you actually cancel it.",
    },

    sdz_ns_trial_size_ice = {
        "You must be a Summoner of level 20 or higher. Speak with Castilchat in Northern San d'Oria (E-7) to begin the quest and obtain a Mini tuning fork of ice.",
        "Prepare for the battle. Whenever you are ready, trade the tuning fork to Castilchat to be transported to the arena.",
        "Trade the fork to the Ice Protocrystal to enter the fighting arena.",
        "Defeat Shiva Prime to complete the quest.",
        "You can get the Mini tuning fork again from Castilchat at any time and repeat the fight, but he will no longer teleport you to the Cloister.",
    },

    sdz_ss_signed_in_blood = {
        "Speak with Sobane in Southern San d'Oria (D-6); she asks you to bring her a Cathedral Tapestry.",
        "Obtain a Cathedral Tapestry. It drops from Orcish Fighter enemies in Fort Ghelsba or the Yughott Grotto. Trade it to Sobane.",
        "Travel to Selbina and speak with Abelard (G-9).",
        "Go to Ordelle's Caves and obtain an Ordelle Chest Key from the monsters inside. Certain monsters in the cave drop it; to reach that area take path D on map 1, drop into the southeastern hole shown on map 2, then take path E. The high-level monsters Buds Bunny, Swagger Spruce and Targe Beetle do not aggro.",
        "Use the key on a chest inside to receive the key item Torn-out pages.",
        "Return to Abelard.",
        "Speak with Sobane to complete the quest.",
    },

    sdz_ss_tea_with_tonberry = {
        "Speak with Sobane in Southern San d'Oria (D-6) to begin the quest. You must zone after finishing Signed in Blood.",
        "Obtain an Attohwa Ginseng, which drops from Gallinipper, Ogrefly and Monarch Ogrefly enemies in Attohwa Chasm.",
        "Enter Carpenters' Landing from the entrance in Jugner Forest (J-8).",
        "Speak with Anguenet (J-10) and trade him the Attohwa Ginseng.",
        "Return to Sobane for your reward.",
    },

    sdz_ss_spice_gals = {
        "Speak with Rouva on the west side of Victory Square in Southern San d'Oria (I-8) to begin the quest. She asks you to bring her a sprig of Rivernewort. This quest requires the Chains of Promathia pack.",
        "The key item Rivernewort is found at a ??? in either Riverne - Site #B01 or Riverne - Site #A01. To reach either you need Giant Scale(s), or the Home Point warps, to teleport through the Unstable Displacements.",
        "In Riverne - Site #A01 the ??? is on the island at (E-8) that holds the zone to Monarch Linn. Two Giant Scales are required, and the Home Point warp places you at (I-9).",
        "In Riverne - Site #B01 the ??? is on the island at (E-7), just before the final Stable Displacement heading toward Monarch Linn. One Giant Scale, or the Home Point warp, is required.",
        "Once you have the Rivernewort, return to Rouva for your reward, a Page from Miratete's Memoirs. Like other Experience Points scroll quests, it can be completed once per Conquest tally.",
    },

    sdz_ps_over_hills_away = {
        "First go to the second floor of the house at (G-7) in Southern San d'Oria and read the diary there until you have read up to Page 4. This quest requires the Chains of Promathia pack, and follows A Squire's Test II.",
        "Speak with Antreneau in Port San d'Oria (G-7) to flag the quest.",
        "Head to Oldton Movalpolos and defeat Moblin Ashman and Moblin Gurneyman enemies until one drops a Moblin Hotrok. Alternatively, go to Newton Movalpolos and defeat Moblin Groundman enemies.",
        "Head to Uleguerand Range and climb to the top, where Jormungand spawns.",
        "Trade the Moblin Hotrok to the ??? to complete the quest.",
    },

    sdz_ss_lure_of_wildcat = {
        "Speak with Amutiyaal in Southern San d'Oria (L-6) to receive a Red Sentinel badge and begin the quest. This quest requires the Treasures of Aht Urhgan pack.",
        "Speak with 20 people around the kingdom's cities; for example Daggao in Southern San d'Oria (K-5), Rouva in Southern San d'Oria (I-8), Giaunne in Northern San d'Oria (I-9) and Perdiouvilet in Port San d'Oria (G-7).",
        "Once you have spoken to all 20 people, return to Amutiyaal, who takes your Red Sentinel badge and gives you a Red invitation card.",
        "After joining Salaheem's Sentinels, speak with Naja Salaheem with the invitation card to be rewarded with Imperial currency; the more Lure of the Wildcat quests you have completed, the greater the reward.",
    },

    sdz_ss_atelloune_lament = {
        "Speak with Atelloune in Southern San d'Oria (L-6) for a cutscene that starts the quest. This quest requires the Wings of the Goddess pack and follows Seeing Spots.",
        "Trade her a Ladybug Wing for a cutscene and to receive your reward.",
    },

    sdz_ps_thick_shells = {
        "Speak with Vounebariont in Port San d'Oria (I-10) to begin the quest.",
        "Trade Vounebariont 5 Beetle Shells to complete the quest and receive 750 gil. About 5 to 6 stacks of Beetle Shells raise your fame from around 1 up to the maximum of 9.",
    },

    sdz_ns_forest_for_trees = {
        "You must already have signed up with the Woodworking Guild: speak to the Guild Master, Cheupirudaux, in Northern San d'Oria (F-3).",
        "Speak with Ramua in Northern San d'Oria (E-3) for a cutscene that begins the quest. She gives you the Timber survey checklist and a Hatchet.",
        "Travel to Jugner Forest and log the five items on the checklist: Arrowwood Log, Ash Log, Yew Log, Willow Log and Walnut Log. Each one you log shows a message that data was recorded; you must log them yourself and cannot buy them from shops or the Auction House.",
        "Trade the logs to Ramua for your reward. She also returns the logs to you.",
    },
    sdz_ps_discerning_eye = {
        "Speak with Eddy in Port San d'Oria (H-6) and accept the quest.",
        "Eddy shows you a picture of an NPC that you must memorize.",
        "Board the next airship.",
        "Several NPCs that look very similar to the one Eddy showed you appear on the ship.",
        "Speak to the NPCs to get the option of returning the key item Dropped item to them. You only have one chance to get it right.",
        "If you choose correctly, you are given 500 gil. If you choose incorrectly, you fail the quest.",
    },

}

return Q