local Q = {}

Q.STEPS = {

    -- ========================================================
    -- KAZHAM
    -- ========================================================

    out_kaz_guardian = {
        "Speak with Hari Pakhroib in Kazham (I-11), who wants Wild Pamamas. You need Kazham fame level 7 and the Rise of the Zilart pack.",
        "Obtain a Wild Pamamas, which drops from Young Opo-opo enemies in Yuhtunga Jungle and can sometimes be found at the Auction House. On later repeats a Wild Melon also works. Despite what the NPC says, you do not need to bring Ice Clusters, as there are no Flame Spouts on the path.",
        "Head to Ifrit's Cauldron using the entrance from (G-6) in Yhoator Jungle. The Survival Guide can also bring you there.",
        "Once inside Ifrit's Cauldron, take the left path at the fork and continue until you find the Altar of Ashes at (I-9) on map 2, a black pillar near the edge of the path. Alternatively, use the Unity 125 teleport to map 3 and take exit G, then A, then B to reach (I-9) of map 2.",
        "Trade the Wild Pamamas to the Altar. The NPC mentions needing to shout your name, but that is not necessary.",
        "Return to Hari Pakhroib for your reward, 5,000 gil. You can repeat the quest.",
    },

    out_kaz_question_of_taste = {
        "Talk to Etteh Sulaej in Kazham (J-9). You need Kazham fame level 6 and the Rise of the Zilart pack, and this quest follows A Pose by Any Other Name. You receive the key item Letter to Angelica.",
        "Take the letter to Windurst Waters and talk to Angelica at the Rarab Tail Hostelry. You receive the key items Angelica's letter and the painting \"Final Fantasy\", which she wants you to hang in the Temple of Uggalepih.",
        "Go back to Kazham and talk to Etteh Sulaej.",
        "Go to (G-8) on the first map of the Temple of Uggalepih and hang the picture at the Stone Picture Frame, on the south wall of the Paintbrush Room, to spawn the Golem NM Trompe L'Oeil. The Temple of Uggalepih Survival Guide warp puts you a short distance from the Stone Frame.",
        "Return to Etteh Sulaej to receive your reward, 3,000 gil. You can repeat the quest.",
    },

    out_kaz_grudging = {
        "To begin this quest you must have traded an Unlit Lantern to the Altar of Rancor and received a Rancor Flame at some point before; it helps to have a Rancor Flame on you. This quest follows A Question of Taste and requires the Rise of the Zilart pack.",
        "Once you have used a Rancor Flame, talk to Jakoh Wahcondalo in Kazham (J-9), who tells you to leave her village. The other NPCs in the room tell you to go to the Den of Rancor and Temple of Uggalepih complex to be cleansed and then come back. You get the title Excommunicate of Kazham as soon as the quest becomes active.",
        "Once in the temple, head to (I-10) and defeat the Temple Guardian to open the door.",
        "Past the guardian's door, head north to (I-7) inside the paintings room.",
        "Kill the Rancor Torch, then head back to Kazham and talk to the Chieftainess for your reward, 11,000 gil.",
    },

    out_kaz_knife = {
        "Trade Mhebi Juhbily in Kazham (I-10) a Sandfish. You need Kazham fame level 6 and the Rise of the Zilart pack. When asked, tell her you give it to her. Then check the shed behind her for a cutscene.",
        "Speak with Vah Keshura at (H-9).",
        "Obtain a Tonberry Board. It drops from Tonberry Pursuer enemies in the Temple of Uggalepih, Tonberry Shadower enemies in Yhoator Jungle and Tonberry Trailer enemies in the Den of Rancor.",
        "Use a Unity Concord NPC warp to the Temple of Uggalepih (level 125), or walk in. Part of the route leads you back outside to Yhoator Jungle; head left and re-enter the Temple at (H-11).",
        "Back inside, head west, then south until you reach (H-10). There you receive the key item Nonberry's knife.",
        "Return to Mhebi Juhbily for your reward, 7,200 gil.",
    },

    out_kaz_missionary_man = {
        "Speak with Rauteinot in Kazham (G-9), who asks for a slab of Elshimo Marble. You need Kazham fame level 3 and the Rise of the Zilart pack.",
        "Obtain an Elshimo Marble, which drops from Ivory Lizard enemies in Yuhtunga Jungle.",
        "Trade the Elshimo Marble to Rauteinot. You receive Rauteinot's parcel.",
        "Head to Northern San d'Oria and speak with Mulaujeant at (E-5), on the second floor near the Blacksmithing Guild.",
        "Wait until one Earth minute has passed and speak with Mulaujeant again to be given the Sublime statue of the Goddess.",
        "Return to Rauteinot for your reward, the Scroll of Teleport-Yhoat.",
    },

    out_kaz_gullibles_travels = {
        "Speak with Magriffon in Kazham (I-7), inside Celodekhi's B&B. You need Kazham fame level 6 and the Rise of the Zilart pack. He has given all his worldly possessions to save a pack of Opo-opos from starvation, and needs someone to save him from getting kicked out before he completes his top-secret mission.",
        "Trade him the gil he asks for, between 10,000 and 30,000 gil. This earns you the title Gullible's Travels.",
    },

    out_kaz_even_more_gullibles = {
        "You must zone after completing Gullible's Travels before you can flag this quest. You need Kazham fame level 7 and the Rise of the Zilart pack. Magriffon has spent all of his (your?) money to save a maiden in distress.",
        "Speak with Magriffon in Kazham (I-7) and trade him the gil he asks for.",
        "Zone, then return to Magriffon, who gives you a Treasure map key item.",
        "Return to Magriffon to finish the quest and receive 3 Rafflesia Nectar.",
        "After completing this quest, all Mithra in Kazham are repulsed by you, but Opo-opos are attracted to you. The only way to fix this is by completing Personal Hygiene, though it is recommended that you finish The Opo-opo and I first so you can get an Opo-opo Crown.",
    },

    out_kaz_personal_hygiene = {
        "You need the scent from Even More Gullible's Travels. This scent repulses all Mithra in Kazham, but it is required to start The Opo-opo and I, so if you plan to do that quest, do not wash it off before you start it. You need the Rise of the Zilart pack.",
        "Speak with Gatih Mijurabi in Kazham (I-8) to begin the quest to remove the scent. The Mithra of Kazham are having a hard time holding in their lunches, and the only way to get clean is a long dip in a hot spring deep beneath the sea.",
        "The hot spring is in Korroloka Tunnel (G-9) on map 4.",
        "Return to Gatih Mijurabi to complete the quest and receive the Mithran Stone.",
        "If you need to re-apply the scent for The Opo-opo and I, you can check the three Rafflesia flowers in Yuhtunga Jungle once per game day until you get the scent back.",
    },

    out_kaz_opo_opo_and_i = {
        "Once you have finished Even More Gullible's Travels and received the scent, speak with Lulupp in Kazham (G-7) for a cutscene. The Opo-opo in Kazham love your new fragrance: bring them what they want, in the correct order, and they make you their king.",
        "You must trade items in order to a list of Opo-opos. The first is Lulupp (G-7), who wants a Broken Mithran Rod, which can be bought at the Auction House.",
        "If you forget how far you are into the quest, simply chat with the Opo-opos on the list. One that has already received the correct item responds and you can bow to it.",
        "When every Opo-opo has received its item, you receive the Opo-opo Crown and the title King of the Opo-opos.",
    },

    out_kaz_trial_by_fire = {
        "Speak with Ronta-Onta in Kazham (J-9) to obtain the quest. You need Kazham fame level 6 and the Rise of the Zilart pack. Once you have the key item Tuning fork of fire, you can safely undertake the quest. Each party member must have their own Tuning fork of fire.",
        "Travel to Yhoator Jungle and look for the entrance to Ifrit's Cauldron at (I-6). On the first map of Ifrit's Cauldron head to the Flame Spout at (H-6). When you land (Map C) go to the drop at (H-7), then proceed to (G-6) to find the entrance to the Cloister of Flames. Preferably, use the Home Point warp to Ifrit's Cauldron #1.",
        "Defeat Ifrit Prime to receive the key item Whisper of flames.",
        "Return to Ronta-Onta with the whisper and he offers several reward options, including the ability to summon Ifrit. You can only select one of the rewards at any time, and you may repeat this quest once per Earth day. You may also keep the whisper to meet the requirements of The Moonlit Path.",
        "To save travel time to the Cloister, use the Mini Fork of Fire from Trial-Size Trial by Fire: be on Summoner as your main job, get the Mini Tuning Fork from Dodmos, trade it back to Dodmos, and enter the Protocrystal normally. As long as you do not clear the level 20 version of the battlefield, you may warp to the Cloister as many times as you wish.",
    },

    out_kaz_cloak_and_dagger = {
        "You cannot start this quest if you have another Weapon Skill quest active; return to the person who gave it and quit it first. Speak with Jakoh Wahcondalo in Kazham (J-9) to receive the Dagger of Trials.",
        "You need to break the latent on the Dagger of Trials before completing the rest of the quest. You know you have enough points when the latent breaks and the weapon's elemental resistances disappear from your active resistances (the colored dots below the gear grid).",
        "You are instructed to travel to Gustav Tunnel. Take Silent Oils and Prism Powders with you. You will also find a Grounds Tome close to your spawn point, where you can get Sneak and Invisible.",
        "Defeat the NM that appears and, once you kill it, re-examine the ???. Return to Jakoh Wahcondalo to receive your reward, the Evisceration weapon skill.",
    },

    out_kaz_trial_size_fire = {
        "You need to be a Summoner of level 20 or higher, Kazham fame level 2 and the Rise of the Zilart pack. Speak with Dodmos in Kazham (J-9) to begin the quest and obtain a Mini Tuning Fork of Fire.",
        "You may prepare for the upcoming battle and, whenever you are ready, trade Dodmos the tuning fork to be transported to the arena.",
        "Trade the fork to the Fire Protocrystal to enter the fighting arena.",
        "Defeat Ifrit Prime to complete the quest.",
        "You may re-obtain the Mini Tuning Fork from Dodmos at any point if you want to repeat the fight, but he will no longer teleport you to the Cloister. Try to fight Ifrit on Watersday and do not fight him on Firesday.",
    },

    -- ========================================================
    -- NORG
    -- ========================================================

    out_nrg_forge_your_destiny = {
        "Speak with Jaucribaix in Norg (K-8), near the Captain's Chamber, to begin the quest. You need to be level 30 or higher on any job and have the Rise of the Zilart pack. A lump of bomb steel and a sacred branch are required to make a new katana, and Jaucribaix's pupils can tell you where to get them.",
        "Speak with Aeka at (I-8) to receive the first material.",
        "If you are doing the quest for multiple people, you must wait 4 minutes for the Forger to respawn for another Bomb Steel, and you only need to kill the Treant once.",
        "Trade the Bomb Steel and the Sacred Branch to Jaucribaix.",
        "Return in 72 in-game hours (3 real-life hours) to receive your reward: the Mumeito and the ability to become a Samurai, with the title Bushido Blade.",
        "The Mumeito is required for the Samurai artifact quest The Sacred Katana, so hold on to it. If you lose it, you have to pay Ranemaud 30,000 gil for a replacement.",
    },

    out_nrg_black_market = {
        "Speak with Muzaffar in Norg (I-8) to begin the quest. You need Outlands fame level 1 (the page is unsure) and the Rise of the Zilart pack.",
        "Bring him either 4 Eastern Pottery, 4 Northern Fur or 4 Southern Mummy to complete the quest. Eastern Pottery x4 pays 2,000 gil and drops from Clockwork Pods in Garlaige Citadel or Fei'Yin.",
        "Northern Fur x4 pays 1,500 gil and drops from Giant Hunter enemies in Qufim Island, and from Giant Lobber enemies in Lower Delkfutt's Tower or Middle Delkfutt's Tower. Southern Mummy x4 pays 3,000 gil and drops from Lich enemies in Western Altepa Desert.",
        "All the required items can also be found at the Auction House, under Others, Misc. 1. The quest gives you the title Black Marketeer and can be repeated.",
    },

    out_nrg_mama_mia = {
        "Speak with Mamaulabion in Norg (G-6) to activate the quest. You need Norg fame level 4 and the Rise of the Zilart pack. This does not need to be done before obtaining the seven items. He would like any \"thuper-dee-duper\" special power items you come across, but cannot tell you where to find them.",
        "Obtain the seven items by selecting them as your reward after defeating the seven Prime Avatars in the Trial battles: Bubbly Water, Egil's Torch, Eye of Nept, Desert Light, Elder Branch, Rust 'B' Gone and Ancients' Key.",
        "Return all seven items to Mamaulabion. They must be traded one at a time, and it is not necessary to turn in all seven at once.",
        "Wait until midnight (JST), then speak with Mamaulabion once more to receive the Evoker's Ring.",
        "The quest is only repeatable if the Evoker's Ring is dropped.",
    },

    out_nrg_stop_your_whining = {
        "Travel to Norg and enter the Buccaneer's Quarters at (J-8). You need to be level 10 or higher with Norg fame level 4 and have the Rise of the Zilart pack.",
        "Talk to Washu. He gives you an Empty Barrel, which you need to fill with Opo-opo brew found in a Yhoator Jungle tree.",
        "Examine a ??? that spawns randomly in Yhoator Jungle. Once you find it, the Empty Barrel turns into a Barrel of Opo-opo brew.",
        "Return to Washu to receive your reward, the Scroll of Hojo: Ichi, and the title Apprentice Sommelier.",
    },

    out_nrg_trial_by_water = {
        "Speak with Edal-Tahdal in Norg (H-9) to obtain the quest. You need Norg fame level 4 and the Rise of the Zilart pack. Once you have the key item Tuning fork of water, you can safely undertake the quest. Each party member must have their own Tuning fork of water.",
        "Use the Paintbrush of souls on the empty Picture frame to open the door to the Den of Rancor. Use the Home Point warp to Den of Rancor #2 if you can.",
        "On the first map of the Den of Rancor (Map C), drop down the hole at (J-7) to the sixth map (Map D) and enter the Cloister of Tides at (I-7).",
        "Defeat Leviathan Prime to receive the key item Whisper of tides.",
        "Return to Edal-Tahdal with the whisper and he offers several reward options, including the ability to summon Leviathan. You can only select one of the rewards at any time, and you may repeat this quest once per Earth day. You receive the title Heir of the Great Water.",
        "To save travel time to the Cloister, use the Mini Tuning Fork given by the quest Trial-Size Trial by Water. As long as you do not clear the level 20 version of the battlefield, you may warp to the Cloister as many times as you wish.",
    },

    out_nrg_everyones_grudge = {
        "Speak with Magephaud in Norg (I-8) to begin the quest. You need Outlands fame level 2 and the Rise of the Zilart pack, and you must have defeated a Tonberry before you can start it. He asks for three gold beastcoins if you want to learn how to rid yourself of the Tonberries' rancor.",
        "Bring Magephaud the 3 gold beastcoins. You receive the permanent key item Tonberry key (Zilart).",
        "With the Tonberry key (Zilart) you can reset your Tonberry Hate at any time: use it on the secret door at (F-11) on map 1 of the Temple of Uggalepih, where the Tonberry Priest resets your Tonberry Hate in exchange for a gil penance.",
        "The Tonberry key (Shantotto) from the A Shantotto Ascension missions is a temporary key item and does not do this. If you are having trouble resetting Tonberry Hate, you may have the wrong key item; check with Magephaud to see if he still requests the 3 beastcoins.",
    },

    out_nrg_damp_scroll = {
        "To begin this quest you first need a Damp Scroll. It can be fished up in Sea Serpent Grotto or bought at the Auction House. You need level 10 or higher, Outlands fame level 3 and the Rise of the Zilart pack.",
        "You must have the Damp Scroll in your inventory when you speak with Shivivi in Norg (J-8) to begin the quest.",
        "Take the scroll to Horlais Peak (hot springs side) and trade it to the hot springs there. This transforms the scroll into a Scroll of Jubaku: Ichi and gives you the title Cracker of the Secret Code.",
    },

    out_nrg_sahagins_stash = {
        "Speak with Laisrean in Norg (H-7) to begin the quest. You need Norg fame level 4 and the Rise of the Zilart pack. He wants something from the Sahagins' storage area in the Sea Serpent Grotto; anything will do.",
        "Exit Norg into Sea Serpent Grotto. Head south until you reach the fork at (H-6) and go east. Turn south at (J-5), head east at (J-10), and turn east at (K-12).",
        "Go past the Silver Door at (N-14): examine the door three times and trade it a Silver Beastcoin to get through. You keep the Silver Beastcoin.",
        "Fall off the path to the one below at (H-8) and continue north. Follow the path until you find the ??? at (H-3). Interacting with it gives you a Sea serpent statue.",
        "Return to Laisrean for your reward, the Scroll of Utsusemi: Ichi, and the title Treasure-House Ransacker.",
    },

    out_nrg_not_your_vault = {
        "Speak with Keal in Norg (H-8) to begin the quest. He walks around by the Survival Guide. You need to be level 5 or higher, Outlands fame level 3 and have the Rise of the Zilart pack. He wants you to bring back a sealed iron box from the Sahagin-infested Norg vault.",
        "Exit Norg into Sea Serpent Grotto. Once there, head south until you reach (H-7) and go west from there.",
        "Turn south at (F-7) and continue west, following the path as it turns north at (B-7).",
        "The ??? you are looking for is in the room at (C-5). Examine it to get the key item Sealed iron box.",
        "Return to Keal to complete the quest and receive the Scroll of Tonko: Ichi.",
    },

    out_nrg_shining_subligar = {
        "Speak with Heiji in Norg (I-7) to begin the quest. You need Norg fame level 3 and the Rise of the Zilart pack. Ten rusty subligaria are needed for the training of young ninjas, and Heiji accepts them one at a time.",
        "Obtain 10 Rusty Subligar (they are fished up) and trade them to Heiji. You do not have to trade all 10 at the same time, as he remembers how many you have traded.",
        "Once all 10 are traded you receive your reward, the Scroll of Kurayami: Ichi, and the title Looks Sublime in a Subligar.",
    },

    out_nrg_shining_leggings = {
        "Speak with Heizo in Norg (H-7) to begin the quest. You need Norg fame level 3 and the Rise of the Zilart pack. Ten pairs of rusty leggings are needed for the training of young ninjas, and Heizo accepts them one at a time.",
        "Obtain 10 Rusty Leggings (they are fished up or come from a Goblin Box) and trade them to Heizo. You do not have to trade all 10 at the same time, as he remembers how many you have traded.",
        "Once all 10 are traded you receive your reward, the Scroll of Dokumori: Ichi, and the title Looks Good in Leggings.",
    },

    out_nrg_sacred_katana = {
        "Talk to Jaucribaix in Norg (K-8), near the Captain's Chamber, while on Samurai to initiate the quest. You need to be a Samurai of level 40 or higher and have the Rise of the Zilart pack; this quest follows Forge Your Destiny. You may change to a different job to complete the rest of the quest.",
        "Travel to The Sanctuary of Zi'Tah.",
        "Kill Goblin Robber enemies to get a Sack of Fish Bait, a common drop.",
        "Trade the Fish Bait to the ??? at (E-8) to pop Isonade, a fish NM with approximately 6,100 HP.",
        "Re-examine the ??? to obtain the Handful of crystal scales.",
        "Return to Norg and trade your Mumeito to Jaucribaix to complete the quest and receive the Magoroku. If you do not have your Mumeito, Ranemaud at (I-7) can give you a new one for 30,000 gil.",
    },

    out_nrg_yomi_okuri = {
        "You must zone after completing The Sacred Katana to begin this quest. Speak with Jaucribaix in Norg (K-8). You need to be a Samurai of level 50 or higher and have the Rise of the Zilart pack. A ritual is needed to send the souls of those who died in a long-ago war to their proper resting place.",
        "Speak with Washu at (J-8).",
        "Trade Washu a Bastore Sardine, a Frost Turnip, a piece of Giant Sheep Meat and a Hecteyes Eye to receive the key item Washu's tasty wurst.",
        "Examine the ??? in Labyrinth of Onzozo (F-8) to spawn the NM Ubume. An alternate route to Labyrinth of Onzozo is through Buburimu Peninsula.",
        "Return to Norg and speak with Jaucribaix.",
        "Exit Norg, re-enter, and speak with Jaucribaix to receive the key item Yomotsu Hirasaka.",
        "Speak with Jaucribaix again to receive your reward, the Myochin Sune-Ate.",
    },

    out_nrg_thief_in_norg = {
        "You must zone after completing Yomi Okuri to begin this quest. Speak with Jaucribaix in Norg (K-8). You need to be a Samurai of level 50 or higher and have the Rise of the Zilart pack. At the close of the Great War, Gilgamesh's father trapped a terrible spirit within a helm, and that helm has been stolen.",
        "Speak with Sanosuke in Port Jeuno (H-8), inside the Duty Free Shop.",
        "Speak with Phoochuchu in Mhaura (H-8), on the ground level under the bridge.",
        "Speak with Jaucribaix in Norg to receive a Banishing Charm.",
        "Speak with Jaucribaix again; he requests a Gold Thread. Trade a Gold Thread to Jaucribaix.",
        "Zone out of Norg, then return to Jaucribaix for your reward, the Myochin Kabuto, and the title Paragon of Samurai Excellence. You can toss the Banishing Charm after completing the quest, as it serves no further purpose.",
    },

    out_nrg_pirate_years = {
        "Talk to Ryoma in Norg (H-8), at Home Point #1, to begin the quest, then head to Port Bastok. You need to be a Ninja of level 40 or higher, Outlands fame level 1 and the Rise of the Zilart pack; this quest follows Ayame and Kaede. Norg has begun investigating an ancient scroll that was rediscovered recently.",
        "Speak with Kagetora inside Warehouse #2 at (F-6) in Port Bastok (near Port Bastok Home Point #3).",
        "Go to (I-5) in Port Bastok and speak with Ensetsu.",
        "After speaking with Ensetsu, make your way to (H-5)/(H-6) of Eastern Altepa Desert. From this point you can continue on any job. The shortest route to the ??? is to take the Survival Guide to Western Altepa Desert and then zone to Eastern Altepa Desert.",
        "Clear the area and examine the ??? once ready. Two Tsuchigumo NMs spawn. Both NM corpses must disappear before you can obtain the Trick box.",
        "Head back to Norg and speak with Ryoma to complete the quest and receive your reward, Anju and Zushio.",
    },

    out_nrg_big_box = {
        "Travel to Norg and speak with Ryoma (H-8) to receive the quest. You need to be a Ninja of level 50 or higher, Outlands fame level 1 and the Rise of the Zilart pack; this quest follows 20 in Pirate Years. If you just completed 20 in Pirate Years, you need to zone and re-enter Norg for Ryoma to begin it. The trick box you brought back has been identified as a fake, and he needs help finding the real box.",
        "Once in Mhaura, take the ferry to Selbina so that you are traveling at nighttime. Suitable ferry departure times for this quest leave Mhaura at 16:00 and 0:00. On the ferry that departs at 16:00, you must wait until night time at 20:00 for the event to appear.",
        "You receive a cutscene and the Ninja Hakama, and the quest is complete. You can repeat the quest.",
    },

    out_nrg_true_will = {
        "Speak with Ryoma in Norg (H-8) to begin the quest. You need to be a Ninja of level 50 or higher and have the Rise of the Zilart pack; this quest follows I'll Take the Big Box. The Sahagin have stolen Mitsunari's treasure and hidden it somewhere in the jungle on Elshimo Island.",
        "Travel to (I-7) in Yhoator Jungle. The quickest way is Survival Guide teleportation from Elshimo Uplands to Yhoator Jungle, with one east of Home Point #1 in Norg. The Unity warp (level 122) teleports you to (J-7).",
        "Once prepared, examine the ??? at (I-7), northwest of Bloodlet Spring, to spawn 3 Sahagin NMs: Kappa Akuso (Monk), Kappa Biwa (Bard) and Kappa Bonze (White Mage).",
        "Only one of them needs to be killed, so a recommended strategy is to zone to Den of Rancor and fight one while the others despawn.",
        "Return to Ryoma for another cutscene.",
        "Return to Leodarion to complete the quest and receive the Ninja Chainmail and the title Paragon of Ninja Excellence. You can repeat the quest.",
    },

    out_nrg_potential_within = {
        "You cannot start this quest if you have another Weapon Skill quest active; return to the person who gave it and quit it first. You need to be level 71 with a base Great Katana skill of 250 or higher.",
        "Speak with Jaucribaix in Norg (K-8). He grants you the key item Weapons Training Guide as well as the Tachi of Trials. Wield the katana to find your true potential; when the blade has lost its power, you will know you have been accepted.",
        "You need to break the latent on the Tachi of Trials. With it equipped in your main hand, fight experience-yielding monsters (Incredibly Easy Prey or higher) and perform Weapon Skills or close skillchains to accumulate 300 Trial Points.",
        "You will know the latent is broken when the elemental resistances listed in the description of the Tachi of Trials have disappeared from the elemental resistances in the equipment window.",
        "Trade the Tachi of Trials back to Jaucribaix. Then go back and speak with him to receive your reward, the weapon skill Tachi: Kasha.",
    },

    out_nrg_bugi_soden = {
        "You cannot start this quest if you have another Weapon Skill quest active; return to the person who gave it and quit it first. You need a Ninja of level 71 and Katana skill 250 or higher, and the Rise of the Zilart pack.",
        "Speak with Ryoma in Norg (H-8). He grants you the key item Weapons Training Guide as well as the Kodachi of Trials.",
        "You need to break the latent on the Kodachi of Trials. With it equipped in your main hand, fight experience-yielding monsters (Incredibly Easy Prey or higher) and perform Weapon Skills or close skillchains to accumulate 300 Trial Points. A weapon skill with no skillchain gives 5 points and a level 1 skillchain gives 7.",
        "You will know the latent is broken when its bonus stats disappear on un-equipping and re-equipping the Kodachi of Trials; the elemental resistances also disappear from your stats.",
        "Take Silent Oil and Prism Powder to the Labyrinth of Onzozo. Inside, follow the path to (H-9) and take the eastern tunnel, continue northeast through the large room and take the tunnel at (J-8). In the next large room, curve around the eastern wall to the tunnel at (H-7), head north at the next intersection, and continue north to the border of (I-5)/(I-6), where the ??? spawns the NM.",
        "Trade the Kodachi of Trials back to Ryoma, then go back and speak with him to receive your reward, the weapon skill Blade: Ku.",
    },

    out_nrg_trial_size_water = {
        "You need to be a Summoner of level 20 or higher, Outlands fame level 2 and the Rise of the Zilart pack. Speak with Verctissa in Norg (H-9) to begin the quest and obtain a Mini Tuning Fork of Water.",
        "Trade the fork to the Water Protocrystal to enter the fighting arena.",
        "Defeat Leviathan Prime to complete the quest. Only Carbuncle may be used for this battle; Siren can also be used, but that seems unintended.",
        "You may re-obtain the Mini Tuning Fork from Verctissa at any point if you want to repeat the fight, but she will no longer teleport you to the Cloister.",
    },

    out_nrg_undying_pledge = {
        "Speak with Stray Cloud in Norg (H-9) for a cutscene. You need Outlands fame level 4 and the Rise of the Zilart pack. Find Stray Cloud's friend Gubokka in the Sea Serpent Grotto.",
        "Head towards Sea Serpent Grotto; you get another cutscene shortly before you reach the zone line.",
        "Once inside Sea Serpent Grotto, head to (K-6), where you find a ???. Check the ??? to spawn Glyryvilu.",
        "Defeat Glyryvilu, then check the ??? again to receive the key item Caliginous Blade.",
        "Return to Stray Cloud for your reward, the Light Buckler.",
    },

    -- ========================================================
    -- OTHER OUTLANDS LOCATIONS
    -- ========================================================

    out_yut_wrath_of_opo_opos = {
        "You must first have Zilart Mission 5, Headstone Pilgrimage, active or complete, and have the Rise of the Zilart pack. The Opo-opos are not happy that you stole their \"red treasure\".",
        "Obtain a Garnet.",
        "Trade the Garnet to the Cermet Headstone in Yuhtunga Jungle (L-7) at any time during or after Zilart Mission 5 to receive an Opo-opo Necklace and the title Friend of the Opo-opos.",
    },

    out_cap_wandering_souls = {
        "You must have Zilart Mission 5, Headstone Pilgrimage, activated (or already completed), and have the Rise of the Zilart pack. Is there any way to soothe the spirits that wander about Cape Teriggan? Perhaps a Rain Lily.",
        "Obtain a Rain Lily.",
        "Trade the Rain Lily to the Cermet Headstone in Cape Teriggan (H-5) to receive a Flagellant's Rope and the title Bearer of Bonds Beyond Time.",
    },

    out_zit_soul_searching = {
        "You must first have completed Zilart Mission 7 and have the Rise of the Zilart pack.",
        "Touch the Cermet Headstone in The Sanctuary of Zi'Tah (I-7) with the key item from that mission in your possession.",
        "You receive the Bat Earring and the title Guider of Souls to the Sanctuary.",
    },

    out_sra_divine_might = {
        "Enter The Shrine of Ru'Avitau from the (H-9) entrance in Ru'Aun Gardens. You need to have completed Zilart Mission 13, and you need an Illuminink, a Parchment and an Ark Pentasphere; the Illuminink and the Parchment are also needed to do the quest a second time.",
        "Examine the Blank Target at (G/H-11) in the main entrance of The Shrine of Ru'Avitau to flag the quest. You must flag it there, or you will not receive credit and will have to acquire another Ark Pentasphere. Divine Might now appears in your Outlands quests log.",
        "Enter and complete the Divine Might battlefield at La'Loff Amphitheater.",
        "Once you have finished the battle, return to the Blank Target in The Shrine of Ru'Avitau to choose your reward: the key items Shard of Apathy, Shard of Arrogance, Shard of Cowardice, Shard of Envy and Shard of Rage, and one of the following earrings: Abyssal Earring, Beastly Earring, Bushinomimi, Knight's Earring or Suppanomimi.",
        "To repeat the quest, drop your current earring and receive the quest again at the unmarked target (G/H-11) in the main entrance of The Shrine of Ru'Avitau. It appears as a second Divine Might quest in your quest log with a different description.",
    },

    out_ead_open_sesame = {
        "Speak with Lokpix in Eastern Altepa Desert (G-7). You need the Rise of the Zilart pack. He requests a Tremorstone in addition to one of the following: 1 Meteorite, 1 Soil Gem or 12 Soil Geode.",
        "A Meteorite is dropped by Crawler enemies in West Sarutabaruta, on Starfall Hillock (R).",
        "Trade Lokpix the Tremorstone and one of the options to receive the key item Loadstone. The Loadstone lets you open the weighted doors in Quicksand Caves solo, without needing multiple players.",
    },

    -- ========================================================
    -- RABAO
    -- ========================================================

    out_rab_missing_piece = {
        "Speak with Alfesar in Rabao (H-7), who asks you to help him find an Ancient tablet fragment. You need Rabao fame level 4 and the Rise of the Zilart pack.",
        "The Ancient tablet fragment is found by checking one of 5 ???s in the Quicksand Caves: (H-6), (H-10) and (E-9) on map 1, and (D-9) and (L-11) on map 2. As soon as the ??? is found, it instantly respawns in one of those 5 locations.",
        "Return to Alfesar, who gives you the Tablet of ancient magic and the Letter from Alfesar.",
        "Speak with Charlaimagnat in Northern San d'Oria (M-7).",
        "Zone and return to Charlaimagnat after one Earth minute for your reward, the Scroll of Teleport-Altep.",
    },

    out_rab_antidote = {
        "Speak with Edigey in Rabao (F-9) to begin the quest. You need Rabao fame level 4 and the Rise of the Zilart pack. He wants sand scorpion poison so he can make an antidote, an essential item for the desert caravans.",
        "Obtain a Desert Venom, which drops from Doom Scorpion enemies in Eastern Altepa Desert and Tulwar Scorpion enemies in Western Altepa Desert, or buy one at the Auction House.",
        "Trade the Desert Venom to Edigey for your reward. The first time you complete the quest you receive a Dotanuki and the title Desert Hunter; each time after that you only receive gil. You can repeat the quest.",
    },

    out_rab_trial_by_wind = {
        "Speak with Agado-Pugado in Rabao (G-9) to obtain the quest. You need Rabao fame level 6 and the Rise of the Zilart pack. Once you have the key item Tuning fork of wind, you can safely undertake the quest. Each party member must have their own Tuning fork of wind.",
        "Travel to Cape Teriggan (F-5) to enter the Cloister of Gales and ring the tuning fork upon the protocrystal.",
        "Defeat Garuda Prime to receive the key item Whisper of gales.",
        "Return to Agado-Pugado with the whisper and she offers several reward options, including the ability to summon Garuda. You can only select one of the rewards at any time, and you may repeat this quest once per Earth day. You receive the title Heir of the Great Wind. You may also keep the whisper to meet the requirements of The Moonlit Path.",
        "To save travel time to the Cloister, use the Mini Fork of Wind from Trial-Size Trial by Wind: be on Summoner as your main job, get the Mini Tuning Fork from Rahi Fohlatti, trade it back to her, and enter the Protocrystal normally. As long as you do not clear the level 20 version of the battlefield, you may warp to the Cloister as many times as you wish.",
    },

    out_rab_kuftal_tour = {
        "Speak with Datta in Rabao (F-7) to begin the quest. You need to be level 40 or lower and have the Rise of the Zilart pack. You have been asked to join a tour planned by Datta: travel to the cliff inside the entrance to Kuftal Tunnel with a party of two or more people of level forty or lower, and meet Datta's partner, Hawk Nose.",
        "Form a party with at least two people who are level 40 or lower. Level sync does work. If you buy a chocobo in Rabao, you can cross the desert without having to worry about aggro.",
        "Head to Kuftal Tunnel and examine the ??? just inside the entrance for a cutscene, with your party members close by. You and your party overlook the Kuftal Tunnel.",
        "Once you get the cutscene in Kuftal Tunnel, return to Datta for your reward, 8,000 gil, and the title Kuftal Tourist. You can watch the cutscene again with the Goblin Footprint after returning to Datta.",
    },

    out_rab_immortal_lu_shang = {
        "You need a Broken Lu Shang's Rod, which you can get by breaking your own Lu Shang's Fishing Rod or buying a broken one. You need the Rise of the Zilart pack.",
        "Trade Irmilant in Rabao (G-7) the Broken Lu Shang's Rod, a Piece of Ancient Lumber and 2 Light Crystals.",
        "Irmilant repairs the rod and you receive the Lu Shang's Fishing Rod and the title The Immortal Fisher, Lu Shang. You do not need to have completed The Competition or The Rivalry to have your rod fixed. You can repeat the quest.",
    },

    out_rab_trial_size_wind = {
        "You need to be a Summoner, Rabao fame level 2 and have the Rise of the Zilart pack. Speak with Rahi Fohlatti in Rabao (G-9) to begin the quest and obtain a Mini Tuning Fork of Wind.",
        "You may prepare for the upcoming battle and, whenever you are ready, trade Rahi Fohlatti the tuning fork to be transported to the arena.",
        "Trade the fork to the Wind Protocrystal to enter the fighting arena.",
        "Defeat Garuda Prime to complete the quest. Clarsach Call is wind-elemental and gets absorbed, so do not use it.",
        "You may re-obtain the Mini Tuning Fork from Rahi Fohlatti at any point if you want to repeat the fight, but she will no longer teleport you to the Cloister.",
    },

    out_rab_chasing_dreams = {
        "First head to Rabao and talk to Rudolfo (J-7). You need to have completed Promathia Mission 2-1 and have the Chains of Promathia pack. A young cargo hauler named Sanctia has suddenly left Rabao, and Zoriboh wants you to find her; she has probably headed for Norg to board a ship bound for the Tavnazian Marquisate.",
        "Talk to Zoriboh in Rabao (F-6).",
        "Head to Norg and talk to Sohyon (J-8). Then talk to Washu to receive the key item Washu's flask.",
        "Head to Korroloka Tunnel. You need to fill the flask by interacting with four different Giant Clams. The first Giant Clam is at (F-10) on map 1, as you zone into Korroloka Tunnel from Zeruhn Mines.",
        "Head to Rabao and talk to Zoriboh (F-6) to complete the quest and receive your reward, the Venerer Ring and 4,000 gil.",
    },

    out_rab_indomitable_spirit = {
        "To begin this quest in your log, you need the key item Serpent Rumors. It can be bought from Fennella in Port Windurst (C-8) for 95,000 Guild Points with Fishing rank Adept or higher. You can still obtain the other items needed for this quest before initiating it. You need the Rise of the Zilart pack.",
        "Speak with Irmilant in Rabao (G-7). He asks you to bring the two base materials required to craft a legendary fishing rod, which seem to have found their way into the bellies of sea creatures that still elude the finest fishermen.",
        "Trade the Opal Silk and the Saber Shoot to Irmilant.",
        "Return to Irmilant after the Conquest tally to receive your reward, the Ebisu Fishing Rod. It can be re-obtained if dropped by mistake.",
    },

}

return Q