local Q = {}

Q.STEPS = {

    -- ========================================================
    -- AHT URHGAN WHITEGATE
    -- ========================================================

    tau_wg_keeping_notes = {
        "Speak with Ahkk Jharcham in Aht Urhgan Whitegate (I-10). You need Aht Urhgan fame level 1. She wants a Parchment and a Black Ink so she can write down her secret.",
        "Obtain a Parchment, which Pikini-Mikini sells in Mhaura (G-9) for 2,019 gil, and a Black Ink, which Maymunah sells in Bastok Mines (K-7) for 570 gil.",
        "Trade the Parchment and the Black Ink to Ahkk Jharcham. The reward is the ability to exit your Mog House to any zone within the city of Aht Urhgan.",
    },

    tau_wg_arts_and_crafts = {
        "Speak with Hadahda in Aht Urhgan Whitegate (F-10), above the Mog House. He wants paper pieces with letters written on them: one each of M, U and T, and two each of A and D.",
        "Collect the letters from NPCs in Aht Urhgan Whitegate: Qutiba (K-12) gives an A, Zabahf (F-8) gives the T, Mathlouq (F-5) gives the U, Mhasbaf (J-8) gives the M, Balakaf (I-5) gives a D, and Ekhu Pesshyadha (H-6) gives the second A. You may need to speak to Ekhu Pesshyadha twice if you have logged The Die Is Cast.",
        "Collect the 7 letters in total. The source I found does not say who gives the first D.",
        "Return to Hadahda for another cutscene and your reward, a Sutlac.",
        "You can trade the Sutlac back to Hadahda if you prefer an Imperial Bronze Piece.",
    },

    tau_wg_olduum = {
        "Make sure you pick up a few Pickaxes before leaving, since they can break. This quest requires the Treasures of Aht Urhgan pack.",
        "Speak with Dkhaaya in Aht Urhgan Whitegate (G-9) for a cutscene and to obtain Dkhaaya's research journal.",
        "Enter Aydeewa Subterrane through the cave at (I-7) in Bhaflau Thickets.",
        "Head to the room at (H-9) and mine in it until you find one of three key items: Electrocell, Electropot or Electrolocomotive. This is the same room where you finish the Blue Mage flag quest.",
        "Return to Dkhaaya, who rewards you with a Lightning Band.",
        "At this point the quest is completed. If you trade the Lightning Band to the Leypoint in Wajaom Woodlands (G-8), it transforms into an Olduum Ring.",
        "If you drop your Olduum Ring, speak to Dkhaaya to repeat the quest.",
    },

    tau_wg_got_it_all = {
        "Speak with Tehf Kimasnahya in Aht Urhgan Whitegate (F-8). You need Aht Urhgan fame level 1 and the Treasures of Aht Urhgan pack. He wants you to get a vial of luminous water from Ekhu Pesshyadha.",
        "Speak with Ekhu Pesshyadha in Aht Urhgan Whitegate (H-6).",
        "Speak with Zabahf in Aht Urhgan Whitegate (F-8).",
        "Speak with Ekhu Pesshyadha to receive the Vial of luminous water.",
        "Speak with Tehf Kimasnahya.",
        "Go to the lower level of Aht Urhgan Whitegate (J-10) to trigger a cutscene, near the NPC Hajaom.",
        "Speak with Tehf Kimasnahya again.",
        "Zone and then speak with Tehf Kimasnahya once more to receive your reward, the Bibiki Seashell.",
    },

    tau_wg_empty_vessel = {
        "Speak with Waoud in Aht Urhgan Whitegate (J-10), on the top floor. You need to be level 30 or higher.",
        "He offers a divination for 1,000 gil and asks a series of questions. Upon success, Waoud mentions seeing all five serpent symbols. It is possible not to be able to progress further, as he may mention only one serpent.",
        "If you progress through the questions, Waoud will not progress the quest until at least one game day later, and you must zone at least once.",
        "Waoud then asks for one item, giving clues. The possible items include Sunsand, Dangruf Stone and Siren's Tear; read the item entries themselves for how to get each one. Sunsand is the only requested item that can be bought at the Auction House.",
        "Unequip your weapons in order to pick up the item if needed, and keep it in your inventory.",
        "Trade him the item and he tells you to go to Aydeewa Subterrane.",
        "In Aydeewa Subterrane, go to the pond room at (H-9) for a cutscene. You do not get the cutscene if you do not have the requested item on you.",
        "If you refuse him every time instead, the entire quest resets and you have to start over from the beginning.",
        "When the cutscene is over, you are returned to Aht Urhgan Whitegate and able to change to Blue Mage. You receive the key item Mark of Zahak, and the item you brought is still in your inventory.",
        "You can return to Waoud and ask him to \"gaze away\" at your fate to get a cutscene. This is necessary for the next quest.",
    },

    tau_wg_luck_of_the_draw = {
        "As a job at level 30 or higher, speak with Ratihb in Aht Urhgan Whitegate (J-12), at the Shararat Teahouse, for a cutscene that begins the quest. This quest requires the Treasures of Aht Urhgan pack.",
        "Speak with Mafwahb at the Palace Door in Aht Urhgan Whitegate (L-9) for a cutscene.",
        "Go to Arrapago Reef and click on the ??? (not the shining spot labeled \"-\") at the northeast corner of (H-10) for a cutscene. It is located on a ship, and you need a Lamian Fang Key to get there. There are only a few possible opponents (5) between the zone line and the gate before the quest marker.",
        "Lamian Fang Keys drop from Lamia and Drauger enemies in the area. You can also receive one from a ??? spot in Caedarva Mire (I-7), Map 1, once every game day: use the Lamian Fang Key on the Iron Gate at (J-10), then go west on the small map to another Iron Gate, which is unlocked. The Survival Guide in Arrapago Reef is very near to the Iron Gate.",
        "Travel west into the tunnel entrance, then north to find the Rock Slab. Examine it for a cutscene that ends the quest and gives you your reward, the Corsair Die.",
    },

    tau_wg_give_peace_a_chance = {
        "Speak with Mishhar in Aht Urhgan Whitegate (H-8) to begin the quest. He wants you to find out what Isween is doing in Wajaom Woodlands at night.",
        "Head to Wajaom Woodlands (K-7) and check the ??? at night (after 20:00 game time) for a cutscene.",
        "Return to Mishhar for a cutscene.",
        "Head to Mamook using the (E-12) entrance in Wajaom Woodlands.",
        "At the end of the tunnel (L-9) there is a ??? you need to examine for another cutscene.",
        "Return to Mishhar for your reward.",
    },

    tau_wg_taste_of_honey = {
        "After completing Vanishing Act, zone and wait one Earth minute.",
        "Speak with Qutiba in Aht Urhgan Whitegate (K-12) for a cutscene. You may have to talk to her several times and agree to listen to a recipe before the cutscene plays.",
        "Trade Qutiba three pots of White Honey for another cutscene and your reward, the Irmik Helvasi and additional recipes.",
    },

    tau_wg_such_sweet_sorrow = {
        "Speak with Dabhuh in Aht Urhgan Whitegate (K-11), near The Pit, to begin the quest. He wants you to bring him a Merrow Scale. This quest requires the Treasures of Aht Urhgan pack.",
        "Trade him a Merrow Scale to complete the quest and receive Merrow No.17's Locket.",
    },

    tau_wg_die_is_cast = {
        "Speak with Ratihb in Aht Urhgan Whitegate (J-12) to start this quest. The correct cutscene is the one about Balajaha, Yadhiwa and a game of dice, not the one for Luck of the Draw. This quest requires the Treasures of Aht Urhgan pack.",
        "Speak with Ekhu Pesshyadha (H-6) for a cutscene with Yadhiwa. You can pick any option to proceed; you may choose to gamble with her, but she always wins.",
        "Travel to Nashmau and speak with Jijiroon (H-8). You can pick any option again to proceed with this cutscene. Before you leave Nashmau, bring a good supply of Echo Drops for the NM fight.",
        "Obtain a Lamian Fang Key. You can get one from a ??? in Caedarva Mire at (I-7), in a small crevice behind a Jnun, or it can drop from a Reserve Draugar in Caedarva Mire. Otherwise, obtain it from Merrow enemies inside Arrapago Reef.",
        "Travel to Arrapago Reef by way of the (I-6) entrance from Caedarva Mire and open the first Iron Gate at (J-10) with the Lamian Fang Key.",
        "Cross over the Corsair quest ship and down onto land, cross two bridges to the west shore (G-10), then head west to (F-10) and cross two more bridges. The first bridge is the start of Arrapago Reef map 2 (K-11).",
        "The quest's ??? is at (K-10), at the water's edge on map 2. Cast your buffs before you click it, as the NM Bukki that spawns uses Deafening Tantara (area Silence) immediately and often.",
        "Defeat Bukki, then click the ??? again to get the Bag of gold pieces and complete this part of the quest.",
        "Return to Aht Urhgan Whitegate and speak with Ratihb for the final cutscene with Balajaha to complete the quest and receive your reward, the Random Ring.",
    },

    tau_wg_two_horn_the_savage = {
        "Speak with Milazahn in Aht Urhgan Whitegate (G-8) for a cutscene.",
        "Speak with Cacaroon (G-11) for a cutscene.",
        "Trade Cacaroon 1,000 gil for another cutscene.",
        "Zone into Mamook from the Mamool Ja Staging Point exit.",
        "Head northwest to (E-8) and check the Viscous Liquid for a cutscene.",
        "Examine the Viscous Liquid again to spawn the NM Mamool Ja.",
        "After the NM is defeated, examine the Viscous Liquid for a cutscene.",
        "Return to Milazahn for your reward, an Imperial Mythril Piece.",
    },

    tau_wg_beginnings = {
        "Begin this quest by speaking to Waoud in Aht Urhgan Whitegate (J-10) once your Blue Mage is level 40 and you have completed Aht Urhgan Mission 2. This quest follows An Empty Vessel.",
        "If you did not originally watch the extra scene for completing An Empty Vessel, you need to speak to him again after zoning. Tell Waoud that you want him to \"Gaze Away\" at your fate and the quest cutscene begins. Wait three in-game days, zone, and speak to Waoud again, choosing the same option. The quest log says you have the quest from Raubahn, even though Waoud acts as your contact.",
        "Once the quest has started, go to each of the five staging points with Blue Mage as your main job and talk to the Immortal there for a quick cutscene and a key item: Azouph Isle Staging Point, Dvucca Isle Staging Point, Mamool Ja Staging Point, Halvung Staging Point and Ilrusi Atoll Staging Point. You do not need to speak to the guard at Nyzul Isle for this quest.",
        "The key items are the Brand of the Springserpent, the Brand of the Galeserpent, the Brand of the Flameserpent, the Brand of the Skyserpent and the Brand of the Stoneserpent. They are permanent.",
        "After you have all five Brand key items, speak to Waoud again for the final cutscene to finish the quest and receive the Immortal's Scimitar. You also receive the title Branded by the Five Serpents.",
    },

    tau_wg_omens = {
        "Wait one in-game day since completing Beginnings and re-zone into Aht Urhgan Whitegate if you have not already. You need to be a Blue Mage of level 50 or higher.",
        "Speak with Waoud in Aht Urhgan Whitegate (J-10) to begin the quest. Raubahn directs you to find and kill a Flan in the Navukgo Execution Chamber.",
        "The quickest way is the Home Point in the part of Mount Zhayolm just outside the chamber, or the Mount Zhayolm Unity warps (level 128 or 135).",
        "In the Navukgo Execution Chamber, examine the Decorative Bronze Gate to start a battlefield fight. Up to 18 people can enter, but more people cause more Immortal Flans to spawn. Trust Magic is allowed.",
        "Return to Aht Urhgan Whitegate and speak with Waoud. You are given a Sealed Immortal envelope.",
        "Deliver the envelope to Lathuya in Aht Urhgan Whitegate (F-8), on the second floor inside the stall.",
        "Return to Aht Urhgan Whitegate and speak with Lathuya again to receive your reward, the Magus Charuqs.",
    },

    tau_wg_transformations = {
        "You must zone after completing Omens to start this quest; if you do not zone and get a divination from Waoud, you will have to wait for the next game day. You need the Treasures of Aht Urhgan pack.",
        "Speak with Waoud in Aht Urhgan Whitegate (J-10) as a Blue Mage of level 50 or higher.",
        "Ask for a divination by selecting \"Gaze away.\" and pay the 1,000 gil. He tells you that your fate lies beyond the gate of nobility. There are other cutscenes possible here, so make sure you have the quest flagged before leaving Aht Urhgan Whitegate.",
        "Examine the Imperial Whitegate in Aht Urhgan Whitegate (L-8) for a cutscene. The quest is formally added to your quest log after this cutscene, and you no longer need to be on Blue Mage.",
        "After this cutscene you may commission Blue Mage Artifact Armor (Magus Shalwar, Magus Bazubands and Magus Jubbah) from Lathuya, who gives you a Magus order slip and tells you to come back later. You do not have to defeat the Nepionic Soulflayer first.",
        "To fight the Nepionic Soulflayer, gather your party and make sure everyone has an Imperial Silver Piece. Go to Nashmau, take the western exit to Caedarva Mire, head west to (E-11) and enter the Alzadaal Undersea Ruins by trading your Imperial Silver Piece to the guard.",
        "Go down to the main room for a cutscene and take the right teleporter.",
        "Examine the blank spot at (G-7) to spawn the NM Nepionic Soulflayer. When you have defeated it, examine the blank spot again to receive your Magus Keffiyeh and the title Paragon of Blue Mage Excellence.",
    },

    tau_wg_equipped_for_all = {
        "Speak with Ratihb in Aht Urhgan Whitegate (J-12), at the Shararat Teahouse. If his response is to welcome you and revitalize you with tea, you probably already did the optional last step of the previous quest. You need to be a Corsair of level 40 or higher.",
        "Go to Arrapago Reef. Use the Arrapago Reef Survival Guide to get there quickly; if you do not have it, you can get it by walking from Nashmau or take the long way using the Azouph Isle Staging Point from Aht Urhgan Whitegate. You need a Lamian Fang Key to get to the ???.",
        "Lamian Fang Keys drop from Lamia and Drauger enemies in the area, and you can also receive one from a ??? spot in Caedarva Mire (I-7), map 1, once every game day. Use the key on the Iron Gate at (J-10), then go west on the small map to another Iron Gate, which is unlocked.",
        "Examine the ??? in Arrapago Reef (H-10) for a cutscene, as a Corsair of level 40 or higher.",
        "Speak with Ratihb in Aht Urhgan Whitegate (J-12) for your reward, the Trump Gun. You may have to speak to him twice.",
    },

    tau_wg_against_all_odds = {
        "While on Corsair at level 50 or higher, head to the Shararat Teahouse in Aht Urhgan Whitegate (K-12) for a cutscene and the key item Life float. This quest requires the Treasures of Aht Urhgan pack.",
        "After the cutscene you may commission Corsair Artifact Armor from Leleroon. You may choose the order in which you receive the armor, and you may commission a new piece one Vana'diel day (one Earth hour) after the last piece was completed.",
        "The rest of this quest may be completed on any job. If you lose the battle, you may return to get another key item after one real life day (midnight JST).",
        "Head to the Ashu Talif in Arrapago Reef through the Dvucca Isle Staging Point or Alzadaal Undersea Ruins. To access the Cutter, first travel to the Dvucca Isle Staging Point and leave it, which puts you in Caedarva Mire (Map 2).",
        "Head west to (F-9) and zone into Arrapago Reef through entrance 3. Head north to (H-8) to find the Cutter.",
        "Approach the Cutter for a cutscene. Examine the Cutter to enter a battlefield against Yazquhl and Gowam.",
    },

    tau_wg_wayward_automaton = {
        "Speak with Iruki-Waraki in Aht Urhgan Whitegate (K-9). You need to be a Puppetmaster of level 40 or higher, and this quest follows No Strings Attached. He wants to recover his stolen automaton, which you can tell is his because of its very unique personality.",
        "He asks you to go to Nashmau and search for the culprit. Once in Nashmau, proceed to (H-6) (second floor) and speak with Dnegan.",
        "Go back to Iruki-Waraki in Aht Urhgan Whitegate to receive your Turbo Animator.",
    },

    tau_wg_operation_teatime = {
        "You must zone after the previous quest, The Wayward Automaton, in order to start this quest. Speak with Iruki-Waraki in Aht Urhgan Whitegate (K-9) as a Puppetmaster of level 50 or higher. You discover that he is trying to get his automaton back and has formed a plan, and he gives you a shopping list of items. From here on you can be on any job.",
        "Trade Iruki-Waraki 1 Sleeping Potion and 1 Chai.",
        "He asks you to arrange a meeting with the thief in Nashmau. Head to Nashmau and seek out Dnegan at (H-6), on the second floor. Do not choose \"Ask about the automaton.\"; choose either of the other first dialogue options to continue.",
        "When asked what to drink, choose either Chai or coffee. Do not choose \"I'll pass, thanks.\". When choosing a cup, select the cup with the suspicious vapor.",
        "The next part of the cutscene takes you to Nashmau Port, where you see Iruki's plan in action. You are then presented with 3 options.",
        "The next part of this quest is long and leaves you stuck in a remote area, so bring either a Warp Ring or a Scroll of Instant Warp.",
        "Obtain a Lamian Fang Key. Enter Arrapago Reef from Caedarva Mire at (I-6), use the Lamian Fang Key to pass through the Iron Gate in Arrapago Reef, and continue through Arrapago Reef to exit back into Caedarva Mire.",
        "A location for this quest is in Caedarva Mire at (K-5), which is actually part of the Azouph Isle map.",
    },

    tau_wg_puppetmaster_blues = {
        "Speak with Iruki-Waraki in Aht Urhgan Whitegate (K-9). You need to be a Puppetmaster of level 50 or higher and have the Treasures of Aht Urhgan pack; this quest follows Operation Teatime. In a cutscene he wonders why Shamarhaan picked him to be a Puppetmaster and asks you to inquire with his mentor about the situation.",
        "At this point you can commission Dhima Polevhia to craft three Artifact pieces.",
        "Go to Bastok Markets and speak with Shamarhaan. He compliments you on becoming a fine Puppetmaster and, after contemplating, tells you that Iruki-Waraki has always had what a Puppetmaster should ideally have. You receive the key items Valkeng's memory chip and Toggle switch.",
        "Head to Nashmau and zone into Caedarva Mire at (G-7), on the second floor (west exit). The battlefield Puppetmaster Blues has a maximum of 6 people and a time limit of 30 minutes.",
        "After the cutscene you face an automaton named Valkeng. Upon defeating Valkeng, a cutscene occurs; your choice of answer does not affect any outcome.",
        "Return to Bastok Markets and speak with Shamarhaan for a cutscene. Again, the answer to the question does not matter. He tells you to come to the port in Nashmau.",
        "As soon as you enter Nashmau, a cutscene should start. If it does not, trigger it by talking to Sajhra at (H-9), in the docks. Travel back to Aht Urhgan Whitegate to speak with Iruki-Waraki once again for a cutscene if the quest asks for it.",
        "Return to Iruki-Waraki in Aht Urhgan Whitegate and speak with him for one last cutscene and to receive your reward, the Puppetry Taj.",
    },

    tau_wg_moment_of_truth = {
        "Speak with Mishhar in Aht Urhgan Whitegate (H-8), near Home Point #1. This requires waiting until after Japanese midnight following Give Peace a Chance.",
        "Go to the Shararat Teahouse (J-12) for another cutscene.",
        "Return to Mishhar (H-8).",
        "Enter Mamook from (D-12) in Wajaom Woodlands and click on a nearby ???, which is right next to the Survival Guide. Using the Mamook Survival Guide puts you at the correct entrance.",
        "Head to Jade Sepulcher and click the battlefield entrance (Ornamental Door) for a cutscene. The Home Point #1 warp from Aht Urhgan Whitegate to Bhaflau Thickets makes this fast.",
        "Click again to enter the battlefield Moment of Truth. Protect Blacktattoo Vedool Ja (BLM), Shadowhand Kajeel Ja (NIN) and Whitetattoo Rahool Ja (WHM), who must not die.",
        "Return to Mishhar for your reward.",
    },

    tau_wg_three_men_closet = {
        "Speak with Kubhe Ijyuhla in Serpentking Square, Aht Urhgan Whitegate (I-8), to begin the quest. This quest requires the Treasures of Aht Urhgan pack and follows Got It All. The rest of the quest involves running around Aht Urhgan Whitegate and watching cutscenes.",
        "Head to the (G/H-10) boundary and exit into Wajaom Woodlands through the Ironbound Gate. As you zone, you watch a cutscene.",
        "Head back to Kubhe Ijyuhla, who started the quest, for another cutscene.",
        "Speak with Ratihb inside the Shararat Teahouse (J-12). If the cutscene does not involve Foudeel and Wahboud, speak to him again for the correct cutscene.",
        "Next, speak with Tehf Kimasnahya at (F-8) on Balrahn Way, who explains the whole thing.",
        "Finally, return to Kubhe Ijyuhla to complete the quest. She rewards you with an Imperial Bronze Piece.",
    },

    tau_wg_beast_within = {
        "Speak with Waoud in Aht Urhgan Whitegate (J-10) to flag the quest. You need to be a Blue Mage of level 66 or higher and have the Treasures of Aht Urhgan pack. Remember to set the Records of Eminence objective Level Cap Increase: 75 (BLU) under Objective, Tutorial, Level Cap Increase. Waoud may offer an optional 1,000-gil divination afterwards, which is not required.",
        "Obtain a Blue Mage's Testimony from Mamool Ja Mimicker enemies.",
        "Trade the testimony to the Imperial Whitegate (L-8) and you are teleported to Jade Sepulcher.",
        "Trade the same testimony to the Ornamental Door to initiate a battle against Raubahn. If you have the key item Rhapsody in Umber, you can summon Trust Magic to aid you. If the attempt fails, return to the Imperial Whitegate with a usable testimony and trade it again.",
        "Defeat Raubahn to complete the quest and raise your level cap to 75. You receive the title Master of Ambition. This quest does not need to be completed for the level limit increase if you have already completed New Worlds Await.",
    },

    tau_wg_saga_of_skyserpent = {
        "Speak with Fari-Wari at the Shararat Teahouse in Aht Urhgan Whitegate (K-12) for a cutscene that begins the quest. General Rughadjeen must be present in Al Zahbi, or you will not get the cutscenes in Aht Urhgan Whitegate.",
        "Go to Wajaom Woodlands (C-8) to enter Halvung. Go to (H-11) and examine the ??? to acquire a Lilac ribbon. The fastest way is the Wajaom Woodlands Survival Guide.",
        "Speak with Fari-Wari.",
        "Wait a game day and speak with Fari-Wari to complete the quest and receive 1,000 Imperial Standing and an Imperial Gold Piece.",
    },

    tau_wg_ode_to_serpents = {
        "Speak with Fari-Wari in Aht Urhgan Whitegate (K-12) for a cutscene that begins the quest. You need to have completed When the Bow Breaks and Fist of the People, or complete them during this quest.",
        "With the key item Biyaada's letter, go to Al Zahbi and speak with Gaweesh (G-8) and Talhaal (H-6).",
        "Complete the quests When the Bow Breaks and Fist of the People.",
        "Speak with Fari-Wari to complete the quest and receive an Imperial Gold Piece.",
    },

    tau_wg_soothing_waters = {
        "You need to have completed Aht Urhgan Mission 11, and Mihli Aliapoh must be present in Al Zahbi. Go to (G-9) in Aht Urhgan Whitegate and talk to Eunheem.",
        "Talk to Nadeey at (K-7) inside the Walahra Temple. You may get a cutscene upon entry for The Rider Cometh.",
        "Talk to Mihli Aliapoh in Al Zahbi (H-7), who tells you to obtain a Colorful Hair.",
        "Kill Aydeewa Diremite enemies until you get a Colorful Hair. You can find them around (I-9) after you take the (I-7) entrance from Bhaflau Thickets and slide down at (H-8). Circle back up to farm the item, then slide back down. The Voidwatch warp, if you have it, is a quick shortcut.",
        "Use the (I-7) Bhaflau Thickets entrance to Aydeewa Subterrane (not the Survival Guide entrance) and find the ??? at (H-8) after sliding down the ramp. Trade the Colorful Hair for a cutscene.",
        "Return to Fari-Wari to complete the quest and receive 1,000 Imperial Standing and an Imperial Gold Piece.",
    },

    tau_wg_embers_of_his_past = {
        "Talk to Fari-Wari at the Shararat Teahouse in Aht Urhgan Whitegate (K-12) for a cutscene that begins the quest. This quest requires the Treasures of Aht Urhgan pack, and Gadalar must be present in Al Zahbi.",
        "Head to Mount Zhayolm and click on the Sprightly Footsteps at (L-7) between 18:00 and 06:00. The Voidwatch teleport takes you to the exact location; casting Escape from inside Halvung puts you at (L-7), just north of the location.",
        "Click on the Withered Petals at (L-6), in the southeast portion near the coastal cliffs, between 18:00 and 06:00.",
        "Trade a Hydrangea to Fari-Wari.",
        "Return to Fari-Wari for a cutscene and an Imperial Gold Piece. Speak to Fari-Wari after this to learn Trust: Gadalar.",
        "Speak to Fari-Wari after the day changes to receive a Mercenary Camp Entry Slip.",
    },

    tau_wg_the_prankster = {
        "Speak with Ahaadah in Aht Urhgan Whitegate (G-6), in Philosopher's Alley near the Alchemists' Guild, to begin the quest. Alcander and Ahaadah want you to help Tinga-Matonga become a respectable citizen.",
        "Walk beneath the roofed stall at (I-11) to trigger a cutscene.",
        "Continue to the end of the upper walkway at (I-12) to trigger another cutscene.",
        "Travel to Bhaflau Thickets through the northern exit from Aht Urhgan Whitegate at (H-7).",
        "Check the ??? among the grass at (I-8) for a cutscene. Plague Chigoe appears when the cutscene ends.",
        "Defeat Plague Chigoe, which has a 75% Triple Attack rate.",
        "Check the ??? again after defeating Plague Chigoe to complete the quest and receive the Map of Caedarva Mire.",
    },

    tau_wg_delivering_goods = {
        "Speak with Fochacha in Aht Urhgan Whitegate (I-9), in Serpentking Square, for a cutscene that starts the quest. Her cooking supplies have been stolen and her son has gone to retrieve them. This quest requires the Treasures of Aht Urhgan pack.",
        "Go to the Shararat Teahouse (K-12), on the upper level, and talk to either Ulamaal or Qutiba for another cutscene.",
        "Return to Fochacha for a cutscene that completes the quest and gives you 3 Imperial Bronze Pieces.",
    },

    tau_wg_vanishing_act = {
        "You must zone after completing Delivering the Goods before Ulamaal gives you this quest. Speak with Ulamaal in Aht Urhgan Whitegate (K-12) to begin the quest. This quest requires the Treasures of Aht Urhgan pack. The leader of the Epicureans has been missing since saying he was going to the port.",
        "Speak with Fochacha at (I-9).",
        "Head to the Alchemy Guild at (G-5) for a cutscene.",
        "Begin harvesting in Wajaom Woodlands with a Sickle (you may need several) to obtain the Rainbow berry.",
        "Speak with Ulamaal for your reward, an Imperial Silver Piece.",
    },

    tau_wg_striking_a_balance = {
        "Speak with Wazyih in Aht Urhgan Whitegate (F-11) to begin the quest. This quest requires the Treasures of Aht Urhgan pack. His failure to deliver a package has caused a rift between him and Saliyahf, and the self-proclaimed Defenders of Aht Urhgan need your help.",
        "Talk to Saliyahf at (G-7).",
        "Return to Wazyih.",
        "Walk towards the crates at (F-9).",
        "Return to Saliyahf.",
        "Speak with Wazyih again.",
        "You must now find a targetable location in Al Zahbi to find Munahda's package.",
        "Zone back into Aht Urhgan Whitegate from Al Zahbi for a cutscene.",
        "Return to Wazyih at (F-11) in Aht Urhgan Whitegate.",
        "Finally, speak with Saliyahf at (G-7) for your reward, 3 Imperial Bronze Pieces, and to finish the quest.",
    },

    tau_wg_led_astray = {
        "Speak with Mhasbaf in Aht Urhgan Whitegate (J-8) to begin the quest. This quest requires the Treasures of Aht Urhgan pack. Galiwao and his colleagues need help locating their employer.",
        "Walk downstairs to the pillar at (J-8) for a cutscene.",
        "Speak with Tohka Telposkha at (I-8) for a cutscene. You must tell the Galka to go to Port Ephramad; if you choose any other option, you must select again until you pick Port Ephramad.",
        "Talk to Rubahah at (F-9) and repeat this process, and then do the same with Cacaroon at (G-11).",
        "Walk to (I-11), down the ramp beside the ferry, for a cutscene to obtain the key item Letter from Bernahn.",
        "Speak with Tataroon in Nashmau (G-8) to complete the quest and receive an Imperial Silver Piece.",
    },

    tau_wg_prince_and_hopper = {
        "Talk to Maudaal in Aht Urhgan Whitegate (E-9) to start the quest. You receive a lengthy cutscene. You have been hired by Professor Clavauert B Chanoix to accompany him and his guinea toad, Salwa-Molwa, to Mamook to research the elusive Poroggo.",
        "You are directed to head to the secret entrance to Wajaom Woodlands, at (G-10)/(H-10) of Aht Urhgan Whitegate. Upon zoning, you receive another cutscene.",
        "Reach Mamook by entering the cave at (D-12) on the Wajaom Woodlands map, or by using the Mamook Survival Guide warp.",
        "Once inside, find a Toad's Footprint at (J-7) and click it for another cutscene.",
        "Enter the hallway in the southern part of (G-7)/(H-7) that contains the Toad's Footprints and click one for another cutscene. Check them a second time for a fight.",
        "A Poroggo Casanova spawns, assisted by Mikiruru, Mikiluru, Mikirulu, Nikilulu and Mikilulu. They cannot be put to sleep, even with Elemental Seal.",
        "Killing the Casanova makes all the other frogs disappear and ends the battle. Mikilulu cannot be killed but can be brought down to 1% HP. You only have to fight it once for it to count for the rest of your party if they are at that stage of the quest.",
        "Return to Aht Urhgan Whitegate and talk to Maudaal again for the final cutscene and your reward, the Chanoix's Gorget.",
    },

    -- ========================================================
    -- PROMOTION QUESTS
    -- ========================================================

    tau_wg_promo_pfc = {
        "Complete 25 points worth of Assaults as a Private Second Class. You need Aht Urhgan fame level 1 and the Treasures of Aht Urhgan pack. President Naja wants you to bring her an Imp Wing.",
        "Trade an Imp Wing to Naja Salaheem in Aht Urhgan Whitegate (I-10) to complete the quest and receive the key item PFC Wildcat badge, which gives access to PFC Assaults.",
        "You can skip this quest by purchasing the key item PFC Wildcat badge from a Curio Vendor Moogle once you meet the 25 Mercenary Rank points requirement and have the key item Rhapsody in Azure from Rhapsodies of Vana'diel.",
    },

    tau_wg_promo_sp = {
        "Complete 25 points worth of Assaults as a Private First Class. You need Aht Urhgan fame level 1 and the Treasures of Aht Urhgan pack. Your task is to find hard evidence that the Dark Rider has truly appeared out of legend and is terrorizing the Empire.",
        "Return to Naja Salaheem in Aht Urhgan Whitegate (I-10) to complete the quest and receive the SP Wildcat badge, which gives access to SP Assaults.",
    },

    tau_wg_promo_lc = {
        "Complete 25 points worth of Assaults as a Superior Private (5 points for a previously unbeaten Assault, 1 point for one already beaten). You need Aht Urhgan fame level 1 and the Treasures of Aht Urhgan pack. Falzum, your fellow mercenary, has been given the task of creating a batch of mythralline liquid, and as his superior it is your job to teach him how a mercenary carries out his duty. Speak with Abquhbah in Aht Urhgan Whitegate (I-10) for a cutscene that starts the quest.",
        "After accepting the quest, talk to Nafiwaa at the Alchemist's Guild in Aht Urhgan Whitegate (G-5). She gives you 5 empty test tube key items.",
        "Fill each test tube at its Mythralline Wellspring (the ??? at each pond), in any order. Enter Wajaom Woodlands through the Ironbound Gate at (H-10) and Bhaflau Thickets through the Ironbound Gate at (H-7).",
        "Test tube #1 goes to Wajaom Woodlands (H-11), #2 to Wajaom Woodlands (G-11), #3 to Wajaom Woodlands (I-7), #4 to Wajaom Woodlands (J-8) and #5 to Bhaflau Thickets (G-7), on map 1.",
        "Return to Nafiwaa for a cutscene and begin the mixing process. All five tubes must be filled first, and the quality of the mixture decides your Imperial currency reward. The best quality is Luminium: choose Test Tube #3 three times, Test Tube #2 once, Test Tube #4 once and Test Tube #5 once.",
        "Wait a game day and zone at least once, then return to Abquhbah for a cutscene. Choose \"Helping his fellow mercenaries\" to complete the quest. You receive the LC Wildcat badge, access to LC Assaults, and a varying amount of Imperial currency, up to 2 Imperial Gold Pieces.",
    },

    tau_wg_promo_cpl = {
        "Complete 25 points worth of Assaults as a Lance Corporal. You need Aht Urhgan fame level 1 and the Treasures of Aht Urhgan pack. To track the movements of the Dark Rider, you are given a quartz transmitter to place in his warhorse's hoofprint.",
        "Talk to Naja Salaheem in Aht Urhgan Whitegate (I-10) to receive the Quartz transmitter.",
        "Find the Warhorse Hoofprint and click on it to place the Quartz transmitter. The Warhorse Hoofprint is visible on Widescan and is found in four different zones: Bhaflau Thickets, Caedarva Mire, Mount Zhayolm and Wajaom Woodlands.",
        "Return to Naja Salaheem to complete the quest and receive the C Wildcat badge, which gives access to C Assaults.",
    },

    tau_wg_promo_sgt = {
        "Complete 25 points worth of Assaults as a Corporal. You need Aht Urhgan fame level 1 and the Treasures of Aht Urhgan pack. The perfumier Liliroon has come to Salaheem's Sentinels in search of help, believing it to be a famous detective agency, and President Naja wants you to help collect her reward.",
        "Talk to Naja Salaheem in Aht Urhgan Whitegate (I-10). When presented an option, choose \"Balrahn Way\".",
        "Go to Balrahn Way for another cutscene. When presented an option, choose \"Where have you been\".",
        "Obtain a Sutlac and head off to Nashmau.",
        "At (H-9) in Nashmau, another cutscene takes place. Choose \"No, let's keep trying!\". If you choose the wrong answer during the cutscene, you need to wait for a new game day before repeating it.",
        "Trade a Sutlac to Totoroon.",
        "Exit east to Caedarva Mire and go to (I-10). Check the ??? on the east side of the pond for a cutscene.",
        "Return to Naja Salaheem to complete the quest and receive the S Wildcat badge, which gives access to S Assaults.",
    },

    tau_wg_promo_sgtmaj = {
        "Complete 25 points worth of Assaults as a Sergeant. You need Aht Urhgan fame level 1 and the Treasures of Aht Urhgan pack. You must fulfill your duty as a sergeant by training your subordinates into proper mercenaries. Head to Salaheem's Sentinels in Aht Urhgan Whitegate (I-10) for a cutscene with Naja Salaheem.",
        "Naja requires you to successfully complete three mini-games. If you fail any portion, wait one real-life minute and speak to Naja again. After each one you may need to wait a game day to find out whether you passed; if you failed, you repeat that mini-game.",
        "Trial 1, push-ups: count three NPCs doing push-ups and determine who did the least; it is either one of the three, or none. A reliable way is to use a piece of paper and make a mark in three different sections each time an NPC does a push-up.",
        "Trial 2, sit-ups: you must give a message advancement prompt with proper timing as the three NPCs do sit-ups. The Windower addon Enternity must be unloaded for this trial, as it repeatedly queues the advancement prompt. You can practice indefinitely with Abquhbah. In the real challenge, three NPCs have slightly different timings.",
        "Trial 3, running: you must give prompts to the three NPCs so that they finish running at the same time. If you select an NPC who is not behind, you are penalized and can fail the trial.",
        "After the final trial is complete, speak to Naja Salaheem to finish the quest and receive the SM Wildcat badge, which gives access to SM Assaults.",
    },

    tau_wg_promo_chiefsgt = {
        "Complete 25 points worth of Assaults as a Sergeant Major (5 points for a previously unbeaten Assault, 1 point for one already beaten). You need Aht Urhgan fame level 1 and the Treasures of Aht Urhgan pack. Abquhbah asks you to visit the weapon shop in his stead; his heavy sighs have you slightly worried.",
        "Head to Salaheem's Sentinels in Aht Urhgan Whitegate (I-10) for a cutscene with Abquhbah, who redirects you to Hagakoff at (K-10).",
        "Talk to Hagakoff, then go back to Abquhbah, then Hagakoff once more. Through these cutscenes you learn that Naja Salaheem's mace is rusty and needs to be cleaned, and that the best way is with Scourshrooms, found in Aydeewa Subterrane.",
        "Enter Aydeewa Subterrane from Wajaom Woodlands (I-10). This is the same entrance next to the Aydeewa Subterrane Survival Guide.",
        "Once inside, go to the point where (I-9) and (J-8) meet and check the mushroom patch to find a mature Scourshroom (a key item). Then check the mushroom patch at (I-9)/(J-9) to plant it. Repeat the process at (E-7).",
        "Zone out and back in and wait for the game day to change. Return to both patches of mushrooms between 04:00 and 06:00 game time to harvest young Scourshrooms. You need at least 2 young Scourshrooms to complete the quest.",
        "After cleaning the weapon twice you may choose to complete the quest or continue cleaning. Whether you stop at two cleanings or five, the quest is complete and you receive the CS Wildcat badge, access to CS Assaults, 1 Imperial Mythril Piece and possibly 1 Imperial Gold Piece as well.",
    },

    tau_wg_promo_2lt = {
        "Complete 25 points worth of Assaults as a Chief Sergeant. You need Aht Urhgan fame level 1 and the Treasures of Aht Urhgan pack. You also need 3 Imperial Gold Pieces and 6 Imperial Mythril Pieces. You have enrolled in the Salaheem Officer Academy to earn your position in the upper ranks of Salaheem's Sentinels.",
        "Enter Naja's office in Aht Urhgan Whitegate (I-10) to start the quest.",
        "Trade 3 Imperial Gold Pieces to Abquhbah, who gives you the Officer Academy manual.",
        "Trade 2 Imperial Mythril Pieces to Abquhbah to start the first trial. Trial 1, Memory: you are shown a scene for a short period of time and then asked questions about it. Get them all right to pass. In scene 1 you are asked what kind of critters were shown to you.",
        "Trade 2 Imperial Mythril Pieces to Abquhbah to start the second trial. Trial 2, Proof of competence: any unwearable Aht Urhgan beastmen weapon or armor will work.",
        "Trade 2 Imperial Mythril Pieces to Abquhbah to start the third trial. Trial 3, Trivia.",
        "After all 3 trials are complete, you are awarded your promotion and the SL Wildcat badge, which gives access to SL Assaults. If you fail any trial, you need to pay the initiation fee of 2 Imperial Mythril Pieces again in order to repeat it.",
    },

    tau_wg_promo_1lt = {
        "Complete 25 points worth of Assaults as a Second Lieutenant. You need Aht Urhgan fame level 1, the Treasures of Aht Urhgan pack and 5 Imperial Gold Pieces. Your final term at the Salaheem Officer Academy has begun.",
        "The quest is started by entering the Salaheem's Sentinels office in Aht Urhgan Whitegate (I-10). Trade Abquhbah 5 Imperial Gold Pieces.",
        "Talk to Abquhbah to start the first trial. The quest is split into three parts, and you must wait until the next in-game day between each part.",
        "Part 1, Counterespionage: a three-part mini-game in which you must find the qiqirn hiding in a crowd of twelve humes. In the first group there are three qiqirn to find.",
        "Part 2, Cipher: talk to Abquhbah to start it, and answer his questions.",
        "Part 3, BCG Training: a rock-paper-scissors type game against the cadets. An opponent always repeats whatever his first three calls were, and they switch plans after every two or three hit points they lose. The final round is against Drill Sergeant Rongelouts: get him down to four, tie him three times in a row, then win the next round by dealing four points of damage.",
        "Once you have beaten everyone, wait until the next in-game day and talk to Abquhbah to be promoted and receive the FL Wildcat badge, which gives access to FL Assaults.",
    },

    -- ========================================================
    -- AL ZAHBI
    -- ========================================================

    tau_alz_fear_of_dark_2 = {
        "If Suldiran is taken prisoner during Besieged, this quest is unavailable until he is rescued. This quest requires the Treasures of Aht Urhgan pack.",
        "Speak with Suldiran in Al Zahbi (J-10), on the upper level, to begin the quest. He asks for 2 Imp Wings.",
        "Trade Suldiran 2 Imp Wings to complete the quest and receive 200 gil. You can repeat the quest.",
    },

    tau_alz_when_bow_breaks = {
        "While the quest Ode to the Serpents is active, speak with Gaweesh in Al Zahbi (G-8). You may only get the cutscenes when General Najelith is in Al Zahbi.",
        "In Wajaom Woodlands, kill Aht Urhgan Attercop enemies (spiders) until you get a Frayed Arrow. Three Aht Urhgan Attercops are located at the Giwahb Watchtower.",
        "Go to the Giwahb Watchtower in Wajaom Woodlands (F-5) and trade the Frayed Arrow to the door for a cutscene that completes the quest and gives you 500 Imperial Standing.",
    },

    tau_alz_fist_of_people = {
        "While the quest Ode to the Serpents is active, speak with Talhaal in Al Zahbi (H-6). You may only get the cutscenes when General Zazarg is in Al Zahbi.",
        "Speak with Fari-Wari in Aht Urhgan Whitegate (K-12).",
        "In Wajaom Woodlands, kill Wajaom Tiger enemies until you get a Rusty Medal.",
        "Go to the Leypoint in Wajaom Woodlands (G-8) and trade the Rusty Medal for a cutscene that completes the quest and gives you 500 Imperial Standing.",
        "Return to the teahouse and speak with Fari-Wari again to learn Trust: Zazarg.",
    },

    -- ========================================================
    -- NASHMAU
    -- ========================================================

    tau_nas_cook_a_roon = {
        "Speak with Ququroon in Nashmau (H-6) for a cutscene that starts the quest. He wants to practice cooking so he can open a restaurant one day. This quest requires the Treasures of Aht Urhgan pack.",
        "Obtain the five fish he asks for: Ahtapot, Istakoz, Istavrit, Istiridye and Mercanbaligi. You can buy them at the Auction House or fish them up in the Treasures of Aht Urhgan zones.",
        "Fishing tip: with a Lu Shang's Fishing Rod you can do this at fishing skill 32. Fishing in Nashmau with Minnow, Sinking Minnow and Crayfish Balls eventually gives 4 of the 5 fish, and the Istavrit can be fished in Talacca Cove with a Sinking Minnow. You can also catch 4 of the 5 in Talacca Cove and the Istiridye in Nashmau.",
        "Trade all five fish to Ququroon to complete the quest and receive a Nashmau Stew. There is a small chance that he fails to make the stew: the quest still counts as completed, but you do not receive the reward. You can repeat the quest.",
    },

    tau_nas_what_friends_are_for = {
        "Speak with Tsetseroon in Nashmau (G-6) to begin the quest. There is no cutscene to start it. He needs a cobalt jellyfish and a chunk of tin ore to make his special stew. This quest requires the Treasures of Aht Urhgan pack.",
        "Head to Wajaom Woodlands (D-9) and zone into Aydeewa Subterrane. Reach (G-10) on map 3 for a cutscene.",
        "Return to Tsetseroon to officially begin the quest.",
        "Trade Tsetseroon a Tin Ore and a Cobalt Jellyfish. He gives you a Pot of Tsetseroon's stew.",
        "Return to Aydeewa Subterrane (G-10, map 3) and check the ??? at the top of the damaged stairwell for a cutscene. Choose to look into Wawaroon's bag to receive a Map of Aydeewa Subterrane.",
        "Return to Tsetseroon for an Imperial Bronze Piece and to complete the quest. If you chose not to look into Wawaroon's bag, you receive the Map of Aydeewa Subterrane from Tsetseroon instead, and you do not get the Imperial Bronze Piece.",
    },

    tau_nas_not_meant_to_be = {
        "Speak with Fhe Maksojha in Nashmau (H-6). Wadayra wants you to look for her son Ahgdeen, who ran away from home and was last sighted in the northern part of Caedarva Mire.",
        "Head to Caedarva Mire and click the ??? at (K-8).",
        "Speak with Fhe Maksojha again.",
        "Return to the ??? in Caedarva Mire.",
        "Click the ??? to spawn the NMs Lamia No. 27 and Moshdahn.",
        "Defeat the NMs, then check the ??? again.",
        "Return to Fhe Maksojha for your reward, 3 Imperial Gold Pieces.",
    },

    tau_nas_rat_race = {
        "Speak with Kakkaroon in Nashmau (H-8). He is afraid of children, and young Rapipi adores the Qiqirn and wants to make friends with the beastmen in Nashmau.",
        "Speak with Nadee Periyaha in Aht Urhgan Whitegate (H-9).",
        "Speak with Cacaroon in Aht Urhgan Whitegate (G-11) and trade him one Imperial Bronze Piece.",
        "Now you must complete Cook-a-roon? to get a Nashmau Stew. Buying one from the Auction House will not work, and keeping one from a previous repeat of Cook-a-roon? will not work either.",
        "Trade the Nashmau Stew to Kyokyoroon back in Nashmau (H-7).",
        "Speak with Kakkaroon to complete the quest and receive 2 Imperial Gold Pieces, 2 Imperial Mythril Pieces and 3 Imperial Silver Pieces.",
    },

    -- ========================================================
    -- MOUNT ZHAYOLM
    -- ========================================================

    tau_mtz_rock_bottom = {
        "Examine the unnamed target on a manhole cover at (L-7) in Mount Zhayolm for a cutscene that begins the quest. This quest requires the Treasures of Aht Urhgan pack. Zurtermor has dropped his precious pickaxe into a crevasse.",
        "During this quest the Plasma rock key item is mentioned, but it is actually not obtainable.",
        "Trade a Pickaxe to the same unnamed target for another cutscene.",
        "Head south to zone out of Mount Zhayolm, then zone back in.",
        "Trade a Mythril Pick to the same unnamed target for the final cutscene and your reward: the Map of Mount Zhayolm (if you do not already own it), 2,000 experience points and 2,000 gil.",
    },

    -- ========================================================
    -- ARRAPAGO REEF
    -- ========================================================

    tau_arr_navigating_seas = {
        "Examine the ??? in Arrapago Reef (H-10), map 1, for a cutscene. You need to be a Corsair of level 50 or higher, and a Lamian Fang Key is required to reach this point.",
        "Lamian Fang Keys drop from Lamia and Drauger enemies in the area. You can also receive one from a ??? spot in Caedarva Mire (I-7), map 1 (southern part of the block); you can obtain a new key from there once every game day.",
        "You no longer have to be on Corsair for the rest of this quest. You are asked to fish up a Hydrogauge.",
        "Once you have fished up a Hydrogauge, trade it to Leleroon in Nashmau (G-7).",
        "Head to (G-8) in Wajaom Woodlands and trade the Hydrogauge to the Leypoint.",
        "Return to the ??? in Arrapago Reef (H-10), map 1, for your reward, the Corsair's Culotte.",
    },

    tau_arr_breaking_bonds = {
        "You need to be a Corsair of level 66 or higher and have a Corsair's Testimony. Obtain a Corsair's Testimony from Merrow Icedancer, Merrow Kabukidancer, Merrow Chantress or Lamia Fatedealer enemies.",
        "Go to the Rock Slab in Arrapago Reef (H-10), on map 1. You end up in the correct area to continue after the conclusion of Against All Odds.",
        "Trade the Corsair's Testimony to the Rock Slab to enter the battlefield. This quest does not need to be completed for the level limit increase if you have already completed New Worlds Await or better.",
        "Completing the battle raises your level limit to 75 and gives you the title Master of Chance.",
    },

    -- ========================================================
    -- BASTOK MARKETS
    -- ========================================================

    tau_bas_no_strings_attached = {
        "Talk to Shamarhaan in Bastok Markets (F-9). You need to be level 30 or higher and have the Treasures of Aht Urhgan pack.",
        "Head to Aht Urhgan Whitegate and talk to Iruki-Waraki (K-9, top floor).",
        "Speak with Ghatsad in Aht Urhgan Whitegate (I-7), inside the Automaton Workshop.",
        "Take the northern Port Ephramad ferry to Nashmau and go through the North Gate to Caedarva Mire. Head northeast or northwest to the (I-6) zone line to Arrapago Reef.",
        "Speak with Iruki-Waraki (K-9, top floor) in Aht Urhgan Whitegate to complete the quest and receive your Animator.",
    },

    -- ========================================================
    -- IMPERIAL WARD
    -- ========================================================

    tau_iw_waking_colossus = {
        "Approach Naja Salaheem in Aht Urhgan Whitegate (I-10) for a cutscene that begins the quest. Imperial researchers are uneasy about curious readings from the chamber where the iron colossus sleeps.",
        "Examine the Imperial Whitegate in Aht Urhgan Whitegate (L-8/9) to receive the key item Imperial missive. The quest now appears under Aht Urhgan: Current Quests.",
        "Examine the Imperial Whitegate in Aht Urhgan Whitegate (L-8/9) to receive the key item Present for Megomak.",
        "In the battle you face Alexander, who can spawn up to three Alexander Images. At low HP, Alexander uses Divine Judgment, dealing high damage to everyone in range.",
        "Upon defeating the battlefield you receive the Whisper of radiance. Examine the Imperial Whitegate in Aht Urhgan Whitegate (L-8/9) for a cutscene.",
        "Speak with Naja Salaheem to choose your reward: an Imperial Gold Piece and one of Pact with Alexander, Colossus's Torque, Colossus's Mantle, Colossus's Earring or 10,000 gil.",
    },

    tau_iw_divine_interference = {
        "Approach Naja Salaheem in Aht Urhgan Whitegate (I-10) for a cutscene that begins the quest. If you are repeating this quest, skip this step and go straight to the Imperial Whitegate in the next step. This quest follows Waking the Colossus.",
        "Examine the Imperial Whitegate in Aht Urhgan Whitegate (L-8/9).",
        "In the battle you face Alexander, who can spawn up to three Alexander Images. At low HP, Alexander uses Divine Judgment, dealing high damage to everyone in range.",
        "Speak with Naja Salaheem to choose your reward. You can repeat the quest.",
    },

}

return Q