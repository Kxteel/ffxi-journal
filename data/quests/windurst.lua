local M = {}

-- ============================================================
-- WINDURST QUESTS
--
-- Source:
-- XiQlog / BG-Wiki quest data
--
-- Status is intentionally NOT stored here.
-- Status is provided by tracker.lua at runtime.
-- ============================================================

M.name = 'Windurst'
M.area = 'windurst'

M.zones = {

    -- ========================================================
    -- HEAVEN'S TOWER
    -- ========================================================

    {
        name = "Heaven's Tower",
        quests = {

            {
                id = 'wq_ht_three_magi',
                name = 'The Three Magi',
                area = 'windurst',
                zone = "Heaven's Tower",
                loc = "Heaven's Tower",
                npc = 'Chumimi',
                req = 'Lv.40+ BLM',
                prereq = '',
                reward = 'Casting Wand',
                repeatable = true,
                items = 'Faded Crystal',
            },

            {
                id = 'wq_ht_recollections',
                name = 'Recollections',
                area = 'windurst',
                zone = "Heaven's Tower",
                loc = "Heaven's Tower",
                npc = 'Chumimi',
                req = 'Lv.50+ BLM',
                prereq = 'The Three Magi',
                reward = "Wizard's Sabots",
                repeatable = true,
                items = 'Bag of Seeds, Wine Cellar Key',
            },

            {
                id = 'wq_ht_root_of_the_problem',
                name = 'The Root of the Problem',
                area = 'windurst',
                zone = "Heaven's Tower",
                loc = "Heaven's Tower",
                npc = 'Chumimi',
                req = 'Lv.50+ BLM',
                prereq = 'Recollections',
                reward = "Wizard's Petasos",
                repeatable = true,
                items = 'Silk Cloth',
            },
        },
    },

    -- ========================================================
    -- PORT WINDURST
    -- ========================================================

    {
        name = 'Port Windurst',
        quests = {

            {
                id = 'wq_pw_discerning_eye',
                name = 'A Discerning Eye (Windurst)',
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (M-7)',
                npc = 'Pygmalion',
                req = 'NOT IMPLEMENTED on this server',
                prereq = '',
                reward = '500 gil',
                repeatable = true,
            },

            {
                id = 'wq_pw_truth_justice_onion',
                name = 'Truth, Justice, and the Onion Way!',
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (G-5)',
                npc = 'Kohlo-Lakolo',
                req = '',
                prereq = '',
                reward = 'Justice Badge',
                items = 'Rarab Tail',
            },

            {
                id = 'wq_pw_something_fishy',
                name = 'Something Fishy',
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (C-8)',
                npc = 'Tokaka',
                req = '',
                prereq = '',
                reward = '70 gil',
                repeatable = true,
                items = 'Bastore Sardine',
            },

            {
                id = 'wq_pw_know_ones_onions',
                name = "Know One's Onions",
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (G-5)',
                npc = 'Kohlo-Lakolo',
                req = '',
                prereq = 'Truth, Justice, and the Onion Way!',
                reward = 'Blaze Spikes',
                items = '4x Wild Onion',
            },

            {
                id = 'wq_pw_catch_a_falling_star',
                name = 'To Catch a Falling Star',
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (E-7)',
                npc = 'Sigismund',
                req = 'Fame 4',
                prereq = '',
                reward = 'Fish Scale Shield',
                items = 'Pugil Scale',
            },

            {
                id = 'wq_pw_making_amens',
                name = 'Making Amens!',
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (E-7)',
                npc = 'Kuroido-Moido',
                req = 'Fame 4',
                prereq = 'Making Amends',
                reward = '6,000 gil',
                items = 'Garlaige Key',
            },

            {
                id = 'wq_pw_one_good_deed',
                name = 'One Good Deed?',
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (C-8)',
                npc = 'Chipmy-Popmy',
                req = 'Fame 5',
                prereq = '',
                reward = 'Map of the Attohwa Chasm (key item), 1,200 gil',
            },

            {
                id = 'wq_pw_escort_for_hire',
                name = 'Escort for Hire (Windurst)',
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (G-6)',
                npc = 'Dehn Harzhapan',
                req = 'Fame 6',
                prereq = '',
                reward = "10,000 gil and Miratete's Memoirs (first time), Miratete's Memoirs (repeats)",
                repeatable = true,
            },

            {
                id = 'wq_pw_orastery_woes',
                name = 'Orastery Woes',
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (E-7)',
                npc = 'Kuroido-Moido',
                req = 'Club skill 230+, Lv.71',
                prereq = '',
                reward = 'Black Halo weapon skill',
            },

            {
                id = 'wq_pw_inspectors_gadget',
                name = "Inspector's Gadget!",
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (G-5)',
                npc = 'Kohlo-Lakolo',
                req = '',
                prereq = "Know One's Onions",
                reward = 'Heko Obi',
                items = '4x Saruta Cotton',
            },

            {
                id = 'wq_pw_onion_rings',
                name = 'Onion Rings',
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (G-5)',
                npc = 'Kohlo-Lakolo',
                req = '',
                prereq = "Inspector's Gadget!",
                reward = 'Bouncer Club',
                items = 'Old Ring',
            },

            {
                id = 'wq_pw_crying_over_onions',
                name = 'Crying Over Onions',
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (G-5)',
                npc = 'Kohlo-Lakolo',
                req = '',
                prereq = 'Onion Rings',
                reward = 'Star Necklace',
                items = 'Star Spinel',
            },

            {
                id = 'wq_pw_the_promise',
                name = 'The Promise',
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (G-5)',
                npc = 'Kohlo-Lakolo',
                req = '',
                prereq = 'Wild Card',
                reward = 'Promise Badge',
                items = 'Shoalweed',
            },

            {
                id = 'wq_pw_all_at_sea',
                name = 'All at Sea',
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (I-7)',
                npc = 'Paytah',
                req = 'Fame 3',
                prereq = '',
                reward = '',
                items = '4x Dhalmel Hide, Ripped Cap',
            },

            {
                id = 'wq_pw_catch_it_if_you_can',
                name = 'Catch It If You Can!',
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (E-7)',
                npc = 'Ohruru',
                req = '',
                prereq = '',
                reward = '1,000-1,500 gil',
                repeatable = true,
            },

            {
                id = 'wq_pw_making_amends',
                name = 'Making Amends',
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (E-7)',
                npc = 'Hakkuru-Rinkuru',
                req = 'Fame 2',
                prereq = '',
                reward = '',
                items = 'Animal Glue',
            },

            {
                id = 'wq_pw_wonder_wands',
                name = 'Wonder Wands',
                area = 'windurst',
                zone = 'Port Windurst',
                loc = 'Port Windurst (E-7)',
                npc = 'Hakkuru-Rinkuru',
                req = '',
                prereq = 'Making Amens!',
                reward = 'New Moon Armlets, 4,800 gil',
                items = 'Rose Wand, Oak Staff, Mythril Rod',
            },
        },
    },

    -- ========================================================
    -- WINDURST WALLS
    -- ========================================================

    {
        name = 'Windurst Walls',
        quests = {

            {
                id = 'wq_wl_star_struck',
                name = 'Star Struck',
                area = 'windurst',
                zone = 'Windurst Walls',
                loc = 'Windurst Walls (E-7)',
                npc = 'Koru-Moru',
                req = '',
                prereq = '',
                reward = '',
                items = 'Torn Epistle, Meteorite',
            },

            {
                id = 'wq_wl_postman_ko_twice',
                name = "The Postman Always K.O.'s Twice",
                area = 'windurst',
                zone = 'Windurst Walls',
                loc = 'Windurst Walls (J-12)',
                npc = 'Ambrosius',
                req = '',
                prereq = '',
                reward = '50, 150, 250 or 500 gil (1 to 4 letters in one trade)',
                repeatable = true,
                items = 'Damp Envelope, Muddy Bar Tab, Odd Postcard, or Torn Epistle',
            },

            {
                id = 'wq_wl_puppet_master',
                name = 'The Puppet Master',
                area = 'windurst',
                zone = 'Windurst Walls',
                loc = 'Windurst Walls',
                npc = 'Carbuncle',
                req = 'Lv.40+ SMN, Rise of Zilart required',
                prereq = '',
                reward = "Kukulcan's Staff",
                repeatable = true,
                items = 'Earth Pendulum',
            },

            {
                id = 'wq_wl_class_reunion',
                name = 'Class Reunion',
                area = 'windurst',
                zone = 'Windurst Walls',
                loc = 'Windurst Walls',
                npc = 'Carbuncle',
                req = 'Lv.50+ SMN, Rise of Zilart required',
                prereq = 'The Puppet Master',
                reward = "Evoker's Spats",
                items = 'Ice Pendulum, 4x Astragalos',
            },

            {
                id = 'wq_wl_curses_foiled_again',
                name = 'Curses, Foiled Again!',
                area = 'windurst',
                zone = 'Windurst Walls',
                loc = 'Windurst Walls (K-7)',
                npc = 'Shantotto',
                req = '',
                prereq = '',
                reward = 'Brass Rod',
                items = '2x Bone Chip, Bomb Ash',
            },

            {
                id = 'wq_wl_flower_child',
                name = 'Flower Child',
                area = 'windurst',
                zone = 'Windurst Walls',
                loc = 'Windurst Walls (C-13)',
                npc = 'Ojha Rhawash',
                req = '',
                prereq = '',
                reward = 'Exit to any area of Windurst from your Mog House',
                items = 'Lilac',
            },

            {
                id = 'wq_wl_mandragora_mad',
                name = 'Mandragora-Mad',
                area = 'windurst',
                zone = 'Windurst Walls',
                loc = 'Windurst Walls (E-5)',
                npc = 'Yoran-Oran',
                req = '',
                prereq = '',
                reward = '120-5,500 gil',
                repeatable = true,
                items = 'Cornette, Four-Leaf Mandragora Bud, Snobby Letter, Three-Leaf Mandragora Bud, Yuhtunga Sulfur',
            },

            {
                id = 'wq_wl_to_bee_or_not_to_bee',
                name = 'To Bee or Not to Bee?',
                area = 'windurst',
                zone = 'Windurst Walls',
                loc = 'Windurst Walls (F-7)',
                npc = 'Raamimi',
                req = 'Fame 2',
                prereq = "The Postman Always K.O.'s Twice",
                reward = '3x Mulsum',
                items = '4x Honey',
            },

            {
                id = 'wq_wl_blast_from_the_past',
                name = 'Blast from the Past',
                area = 'windurst',
                zone = 'Windurst Walls',
                loc = 'Windurst Walls (E-7)',
                npc = 'Koru-Moru',
                req = 'Fame 3',
                prereq = 'Star Struck',
                reward = '',
                items = 'Burnite Shell',
            },

            {
                id = 'wq_wl_curses_foiled_again2',
                name = 'Curses, Foiled...Again!?',
                area = 'windurst',
                zone = 'Windurst Walls',
                loc = 'Windurst Walls (K-7)',
                npc = 'Shantotto',
                req = 'Fame 4',
                prereq = 'Curses, Foiled Again!',
                reward = 'Misery Staff',
                items = '2x Bomb Arm, Revival Tree Root, Hiwon\'s Hair',
            },

            {
                id = 'wq_wl_curses_foiled_a_golem',
                name = 'Curses, Foiled A-Golem!?',
                area = 'windurst',
                zone = 'Windurst Walls',
                loc = 'Windurst Walls (K-7)',
                npc = 'Shantotto',
                req = 'Fame 4, Lv.10+',
                prereq = 'Curses, Foiled...Again!?',
                reward = 'Scroll of Warp II',
            },

            {
                id = 'wq_wl_nothing_matters',
                name = 'Nothing Matters',
                area = 'windurst',
                zone = 'Windurst Walls',
                loc = 'Windurst Walls (E-7)',
                npc = 'Koru-Moru',
                req = 'Fame 8',
                prereq = 'Blast from the Past',
                reward = '',
                items = 'Cold Bone, Warm Egg',
            },

            {
                id = 'wq_wl_hear_a_rainbow',
                name = 'I Can Hear a Rainbow',
                area = 'windurst',
                zone = 'Windurst Walls',
                loc = 'Windurst Walls (G-3)',
                npc = 'House of the Hero',
                req = 'Lv.30+',
                prereq = '',
                reward = 'Ability to summon Carbuncle',
                items = "Carbuncle's Ruby",
            },

            {
                id = 'wq_wl_blood_and_glory',
                name = 'Blood and Glory',
                area = 'windurst',
                zone = 'Windurst Walls',
                loc = 'Windurst Walls (K-7)',
                npc = 'Shantotto',
                req = 'Lv.71, Staff skill 230+',
                prereq = '',
                reward = 'Retribution weapon skill',
            },

            {
                id = 'wq_wl_carbuncle_debacle',
                name = 'Carbuncle Debacle',
                area = 'windurst',
                zone = 'Windurst Walls',
                loc = 'Windurst Walls',
                npc = 'Carbuncle',
                req = 'Lv.50+ SMN, Rise of Zilart required',
                prereq = 'Class Reunion',
                reward = "Evoker's Horn",
                repeatable = true,
                items = 'Lightning Pendulum, Daze-breaker Charm, Wind Pendulum',
            },
        },
    },

    -- ========================================================
    -- WINDURST WATERS
    -- ========================================================

    {
        name = 'Windurst Waters',
        quests = {

            {
                id = 'wq_wt_hat_in_hand',
                name = 'Hat in Hand',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (H-7)',
                npc = 'Baren-Moren',
                req = 'Rise of Zilart required',
                prereq = '',
                reward = '',
            },

            {
                id = 'wq_wt_pose_by_any_other_name',
                name = 'A Pose by Any Other Name',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (F-10)',
                npc = 'Angelica',
                req = '',
                prereq = '',
                reward = "Ancient Blood, Angelica's autograph",
                items = 'Bronze Harness, Leather Vest, Robe, Tunic, or Kenpogi',
            },

            {
                id = 'wq_wt_glyph_hanger',
                name = 'Glyph Hanger',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (F-8)',
                npc = 'Hariga-Origa',
                req = '',
                prereq = '',
                reward = 'Map of the Horutoto Ruins (if not owned), 2,000 experience points',
            },

            {
                id = 'wq_wt_eco_warrior',
                name = 'Eco-Warrior (Windurst)',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (F-10)',
                npc = 'Lumomo',
                req = 'Lv.25+',
                prereq = '',
                reward = '5,000 gil, Dragon Chronicles',
                repeatable = true,
            },

            {
                id = 'wq_wt_hoist_the_jelly_roger',
                name = 'Hoist the Jelly, Roger',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (E-9)',
                npc = 'Maysoon',
                req = '',
                prereq = '',
                reward = 'Super soup pot (key item)',
                items = 'Royal Jelly',
            },

            {
                id = 'wq_wt_in_a_pickle',
                name = 'In a Pickle',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (F-10)',
                npc = 'Chamama',
                req = '',
                prereq = '',
                reward = '',
                repeatable = true,
                items = 'Smooth Stone',
            },

            {
                id = 'wq_wt_teachers_pet',
                name = "Teacher's Pet",
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (L-6)',
                npc = 'Moreno-Toeno',
                req = '',
                prereq = '',
                reward = '',
                items = 'Bird Feather, Two-Leaf Mandragora Bud',
            },

            {
                id = 'wq_wt_crisis_in_the_making',
                name = 'A Crisis in the Making',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (D-9)',
                npc = 'Ranpi-Monpi',
                req = 'Fame 2',
                prereq = '',
                reward = '',
            },

            {
                id = 'wq_wt_early_bird',
                name = 'Early Bird Catches the Bookworm',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (G-8)',
                npc = 'Tosuka-Porika',
                req = 'Fame 2',
                prereq = 'Glyph Hanger',
                reward = '',
                items = 'Silver Beastcoin',
            },

            {
                id = 'wq_wt_say_it_with_flowers',
                name = 'Say It with Flowers',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (C-9)',
                npc = 'Moari-Kaaori',
                req = 'Fame 2',
                prereq = '',
                reward = 'Iron Sword (first time), 400 gil (repeats)',
                repeatable = true,
                items = 'Tahrongi Cactus',
            },

            {
                id = 'wq_wt_overnight_delivery',
                name = 'Overnight Delivery',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (J-9)',
                npc = 'Kenapa-Keppa',
                req = 'Fame 2',
                prereq = 'Food for Thought',
                reward = '',
            },

            {
                id = 'wq_wt_water_way_to_go',
                name = 'Water Way to Go!',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (J-9)',
                npc = 'Ohbiru-Dohbiru',
                req = 'Fame 3',
                prereq = 'Overnight Delivery',
                reward = '900 gil',
                repeatable = true,
                items = 'Canteen of Giddeus Water',
            },

            {
                id = 'wq_wt_feather_in_ones_cap',
                name = "A Feather in One's Cap",
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (H-7)',
                npc = 'Baren-Moren',
                req = 'Fame 3, Rise of Zilart required',
                prereq = 'Hat in Hand',
                reward = '',
                items = '3x Giant Bird Feather',
            },

            {
                id = 'wq_wt_chasing_tales',
                name = 'Chasing Tales',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (G-8)',
                npc = 'Tosuka-Porika',
                req = 'Fame 3',
                prereq = 'Early Bird Catches the Bookworm',
                reward = '2,800 gil',
            },

            {
                id = 'wq_wt_making_the_grade',
                name = 'Making the Grade',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (L-6)',
                npc = 'Fuepepe',
                req = 'Fame 3',
                prereq = "Teacher's Pet",
                reward = '',
                items = 'Test Answers',
            },

            {
                id = 'wq_wt_waking_dreams',
                name = 'Waking Dreams',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (J-8)',
                npc = 'Kerutoto',
                req = 'Fame 3',
                prereq = '',
                reward = 'Several options, including the ability to summon Diabolos',
                repeatable = true,
            },

            {
                id = 'wq_wt_reap_what_you_sow',
                name = 'Reap What You Sow',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (K-6)',
                npc = 'Mashuu-Ajuu',
                req = 'Fame 4',
                prereq = '',
                reward = 'Stationery Set and 500 gil (Sobbing Fungus) or 700 gil (Deathball)',
                repeatable = true,
                items = 'Deathball or Sobbing Fungus',
            },

            {
                id = 'wq_wt_let_sleeping_dogs_lie',
                name = 'Let Sleeping Dogs Lie',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (K-6)',
                npc = 'Paku-Nakku',
                req = 'Fame 4',
                prereq = 'Reap What You Sow',
                reward = 'Hypno Staff',
                items = 'Blazing Peppers',
            },

            {
                id = 'wq_wt_acting_in_good_faith',
                name = 'Acting in Good Faith',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (E-10)',
                npc = 'Gantineux',
                req = 'Fame 4, Lv.10+',
                prereq = '',
                reward = 'Scroll of Teleport-Mea',
                items = 'Spirit Incense',
            },

            {
                id = 'wq_wt_smudge_on_ones_record',
                name = "A Smudge on One's Record",
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (F-8)',
                npc = 'Hariga-Origa',
                req = 'Fame 4',
                prereq = 'Chasing Tales',
                reward = "Map of Fei'Yin (if not owned), 2,000 experience points, 5,000 gil",
                items = 'Slime Oil, Frost Turnip',
            },

            {
                id = 'wq_wt_tuning_in',
                name = 'Tuning In',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (J-9)',
                npc = 'Leepe-Hoppe',
                req = 'Fame 4',
                prereq = '',
                reward = '4,000 gil',
                items = 'Extra-Fine File, Spruce Lumber, Magicked Steel',
            },

            {
                id = 'wq_wt_blue_ribbon_blues',
                name = 'Blue Ribbon Blues',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (J-8)',
                npc = 'Kerutoto',
                req = 'Fame 5',
                prereq = 'Water Way to Go!',
                reward = '',
                items = 'Purple Ribbon',
            },

            {
                id = 'wq_wt_wondering_minstrel',
                name = 'Wondering Minstrel',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (F-10)',
                npc = 'Jatan-Paratan',
                req = 'Fame 5',
                prereq = '',
                reward = '',
                items = 'Rosewood Lumber',
            },

            {
                id = 'wq_wt_toraimarai_turmoil',
                name = 'Toraimarai Turmoil',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (J-9)',
                npc = 'Ohbiru-Dohbiru',
                req = 'Fame 6',
                prereq = 'Blue Ribbon Blues',
                reward = '4,500 gil, Rhinostery certificate (key item)',
                repeatable = true,
                items = '3x Starmite Shell',
            },

            {
                id = 'wq_wt_moonlit_path',
                name = 'The Moonlit Path',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (J-9)',
                npc = 'Leepe-Hoppe',
                req = 'Fame 6',
                prereq = "'Trial by' quests",
                reward = '',
                repeatable = true,
            },

            {
                id = 'wq_wt_tuning_out',
                name = 'Tuning Out',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (J-9)',
                npc = 'Leepe-Hoppe',
                req = '',
                prereq = 'Tuning In',
                reward = '6,000 gil, Cache-nez',
                items = 'Habaneros, Black Curry, Mutton Tortilla',
            },

            {
                id = 'wq_wt_heaven_cent',
                name = 'Heaven Cent',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (F-7)',
                npc = 'Ropunono',
                req = '',
                prereq = '',
                reward = '4,800 gil',
                items = 'Ahriman Lens, Rusty Key, Shelling Piece',
            },

            {
                id = 'wq_wt_food_for_thought',
                name = 'Food for Thought',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (J-8)',
                npc = 'Kerutoto',
                req = '',
                prereq = 'Say It with Flowers',
                reward = '',
                items = 'Grilled Hare, Hard-boiled Egg, Pamtam Kelp, Tortilla, Windurstian Tea',
            },

            {
                id = 'wq_wt_wild_card',
                name = 'Wild Card (Quest)',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (E-7)',
                npc = 'Honoi-Gomoi',
                req = '',
                prereq = 'Crying Over Onions',
                reward = '',
                items = 'Toraimarai Coffer Key',
            },

            {
                id = 'wq_wt_babban_ny_mheillea',
                name = 'Babban Ny Mheillea',
                area = 'windurst',
                zone = 'Windurst Waters',
                loc = 'Windurst Waters (H-10)',
                npc = 'Khoto Rokkorah',
                req = '',
                prereq = '',
                reward = 'Tree Saplings x3, Regen cast from Lycopodium',
            },
        },
    },

    -- ========================================================
    -- WINDURST WOODS
    -- ========================================================

    {
        name = 'Windurst Woods',
        quests = {

            {
                id = 'wq_wd_all_new_c2000',
                name = 'The All-New C-2000',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (H-10)',
                npc = 'Kopuro-Popuro',
                req = '',
                prereq = '',
                reward = '200 gil',
                items = 'Rabbit Hide, Two-Leaf Mandragora Bud, Insect Wing',
            },

            {
                id = 'wq_wd_creepy_crawlies',
                name = 'Creepy Crawlies',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (I-6)',
                npc = 'Illu Bohjaa',
                req = '',
                prereq = '',
                reward = '600 gil',
                repeatable = true,
                items = '3x Silk Thread or 3x Crawler Calculus',
            },

            {
                id = 'wq_wd_sin_hunting',
                name = 'Sin Hunting',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (K-7)',
                npc = 'Perih Vashai',
                req = 'Lv.40+ RNG',
                prereq = '',
                reward = 'Sniping Bow',
                repeatable = true,
                items = 'Glittersand',
            },

            {
                id = 'wq_wd_fire_and_brimstone',
                name = 'Fire and Brimstone',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (K-7)',
                npc = 'Perih Vashai',
                req = 'Lv.50+ RNG',
                prereq = 'Sin Hunting',
                reward = "Hunter's Beret",
                repeatable = true,
                items = 'Old Earring',
            },

            {
                id = 'wq_wd_mihgos_amigo',
                name = "Mihgo's Amigo",
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (J-3)',
                npc = 'Nanaa Mihgo',
                req = '',
                prereq = '',
                reward = '200 gil',
                repeatable = true,
                items = '4x Yagudo Necklace',
            },

            {
                id = 'wq_wd_unbridled_passion',
                name = 'Unbridled Passion',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (K-7)',
                npc = 'Perih Vashai',
                req = 'Lv.50+ RNG',
                prereq = 'Fire and Brimstone',
                reward = "Hunter's Socks, Ice Arrow x99",
                repeatable = true,
                items = 'Gold Earring',
            },

            {
                id = 'wq_wd_paying_lip_service',
                name = 'Paying Lip Service',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (I-8)',
                npc = 'Tapoh Lihzeh',
                req = '',
                prereq = '',
                reward = '150-200 gil',
                repeatable = true,
                items = '3x Beehive Chip or 2x Remi Shell',
            },

            {
                id = 'wq_wd_chocobilious',
                name = 'Chocobilious',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (K-12)',
                npc = 'Kuoh Rhel',
                req = 'Fame 2',
                prereq = '',
                reward = '1,500 gil',
                items = 'Papaka Grass',
            },

            {
                id = 'wq_wd_twinstone_bonding',
                name = 'Twinstone Bonding',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (K-5)',
                npc = 'Gioh Ajihri',
                req = 'Fame 3',
                prereq = '',
                reward = 'Wrapped Bow (first time), 900 gil (repeats)',
                repeatable = true,
                items = 'Twinstone Earring',
            },

            {
                id = 'wq_wd_in_a_stew',
                name = 'In a Stew',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (K-12)',
                npc = 'Kuoh Rhel',
                req = 'Fame 3',
                prereq = 'Chocobilious',
                reward = '900 gil',
                repeatable = true,
                items = '3x Woozyshroom',
            },

            {
                id = 'wq_wd_greeting_cardian',
                name = 'A Greeting Cardian',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (H-9)',
                npc = 'Kororo',
                req = 'Fame 3',
                prereq = 'The All-New C-2000',
                reward = 'Tourmaline Earring',
            },

            {
                id = 'wq_wd_legendary_plan_b',
                name = 'Legendary Plan B',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (H-10)',
                npc = 'Kopuro-Popuro',
                req = 'Fame 3',
                prereq = 'A Greeting Cardian',
                reward = '700 gil, Scentless Armlets',
                items = 'Luminicloth, Revival Tree Root, Wolf Hide',
            },

            {
                id = 'wq_wd_all_new_c3000',
                name = 'The All-New C-3000',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (H-10)',
                npc = 'Kopuro-Popuro',
                req = 'Fame 4',
                prereq = 'Legendary Plan B',
                reward = '600 gil',
                repeatable = true,
                items = 'Beetle Shell, Hecteyes Eye',
            },

            {
                id = 'wq_wd_can_cardians_cry',
                name = 'Can Cardians Cry?',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (H-9)',
                npc = 'Apururu',
                req = 'Fame 6',
                prereq = 'The All-New C-3000',
                reward = '5,000 gil, then 1,000 gil',
                repeatable = true,
                items = 'Bruised Starfruit',
            },

            {
                id = 'wq_wd_the_fanged_one',
                name = 'The Fanged One',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (K-7)',
                npc = 'Perih Vashai',
                req = 'Lv.30+',
                prereq = '',
                reward = "Ranger's Necklace, ability to become a Ranger",
                items = 'Black Tiger Fang',
            },

            {
                id = 'wq_wd_rock_racketeer',
                name = 'Rock Racketeer',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (J-3)',
                npc = 'Nanaa Mihgo',
                req = 'Fame 3',
                prereq = "Mihgo's Amigo",
                reward = '2,100 gil',
                items = 'Sharp Stone',
            },

            {
                id = 'wq_wd_amazin_scorpio',
                name = "The Amazin' Scorpio",
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (H-10)',
                npc = 'Soni-Muni',
                req = '',
                prereq = '',
                reward = '1,500 gil',
                items = 'Scorpion Stinger',
            },

            {
                id = 'wq_wd_lure_of_the_wildcat',
                name = 'Lure of the Wildcat (Windurst)',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (G-11)',
                npc = 'Ibwam',
                req = '',
                prereq = '',
                reward = 'Green invitation card',
            },

            {
                id = 'wq_wd_from_saplings_grow',
                name = 'From Saplings Grow',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (K-7)',
                npc = 'Perih Vashai',
                req = 'Rise of Zilart required, Archery skill 250+',
                prereq = '',
                reward = 'Empyreal Arrow weapon skill',
            },

            {
                id = 'wq_wd_chocobo_riding_game',
                name = 'A Chocobo Riding Game (Windurst)',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (K-12)',
                npc = 'Amimi, Sariale, Orlaine',
                req = 'NOT IMPLEMENTED on this server',
                prereq = '',
                reward = "Depends on delivery time: Windurst Woods Glyph, Miratete's Memoirs, Chocobo Ticket or Gysahl Greens",
            },

            {
                id = 'wq_wd_tenshodo_showdown',
                name = 'The Tenshodo Showdown',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (J-3)',
                npc = 'Nanaa Mihgo',
                req = 'Lv.40+ THF',
                prereq = '',
                reward = '',
                items = 'Quadav Stew',
            },

            {
                id = 'wq_wd_thick_as_thieves',
                name = 'As Thick as Thieves',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (J-3)',
                npc = 'Nanaa Mihgo',
                req = 'Lv.50+ THF',
                prereq = 'The Tenshodo Showdown',
                reward = "Rogue's Bonnet",
                repeatable = true,
                items = 'Gausebit Grass, Rock Salt, Lizard Egg',
            },

            {
                id = 'wq_wd_trust_windurst',
                name = 'Trust: Windurst',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (G-10)',
                npc = 'Wetata',
                req = '',
                prereq = '',
                reward = 'Windurst Trust permit (key item), Kupipi Trust spell',
                cw_na = true,
            },

            {
                id = 'wq_wd_hitting_the_marquisate',
                name = 'Hitting the Marquisate',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (J-3)',
                npc = 'Nanaa Mihgo',
                req = 'Lv.50+ THF',
                prereq = 'As Thick as Thieves',
                reward = '',
                repeatable = true,
                items = '4x Quake Grenade, Pickaxe',
            },

            {
                id = 'wq_wd_making_headlines',
                name = 'Making Headlines',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (C-11)',
                npc = 'Naiko-Paneiko',
                req = '',
                prereq = '',
                reward = '',
            },

            {
                id = 'wq_wd_scooped',
                name = 'Scooped!',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (C-11)',
                npc = 'Naiko-Paneiko',
                req = '',
                prereq = 'Making Headlines',
                reward = '1,500 gil',
                items = 'Bronze Box',
            },

            {
                id = 'wq_wd_magicked_astrolabe',
                name = 'Magicked Astrolabe',
                area = 'windurst',
                zone = 'Windurst Woods',
                loc = 'Windurst Woods (F-8)',
                npc = 'Churano-Shurano',
                req = '',
                prereq = '',
                reward = 'Magicked astrolabe (key item)',
                items = '10,000 gil',
            },
        },
    },
}

-- ============================================================
-- TRACKER DATA
--
-- Based on XiQlog / FFXI_QUEST_ID.
-- ============================================================

local tracker_data = {

    -- Heaven's Tower
    wq_ht_three_magi         = { area = 'windurst', bit = 66 },
    wq_ht_recollections      = { area = 'windurst', bit = 67 },
    wq_ht_root_of_the_problem= { area = 'windurst', bit = 68 },

    -- Port Windurst
    wq_pw_making_amends      = { area = 'windurst', bit = 3 },
    wq_pw_making_amens       = { area = 'windurst', bit = 8 },
    wq_pw_know_ones_onions   = { area = 'windurst', bit = 40 },
    wq_pw_inspectors_gadget  = { area = 'windurst', bit = 41 },
    wq_pw_onion_rings        = { area = 'windurst', bit = 42 },
    wq_pw_wonder_wands       = { area = 'windurst', bit = 48 },
    wq_pw_truth_justice_onion= { area = 'windurst', bit = 36 },
    wq_pw_something_fishy    = { area = 'windurst', bit = 52 },
    wq_pw_catch_a_falling_star = { area = 'windurst', bit = 53 },
    wq_pw_catch_it_if_you_can = { area = 'windurst', bit = 21 },
    wq_pw_all_at_sea         = { area = 'windurst', bit = 23 },
    wq_pw_crying_over_onions = { area = 'windurst', bit = 76 },
    wq_pw_the_promise        = { area = 'windurst', bit = 78 },
    wq_pw_orastery_woes      = { area = 'windurst', bit = 86 },
    wq_pw_escort_for_hire    = { area = 'windurst', bit = 88 },
    wq_pw_one_good_deed      = { area = 'windurst', bit = 92 },

    -- Windurst Walls
    wq_wl_star_struck        = { area = 'windurst', bit = 10 },
    wq_wl_blast_from_the_past= { area = 'windurst', bit = 11 },
    wq_wl_postman_ko_twice   = { area = 'windurst', bit = 19 },
    wq_wl_mandragora_mad     = { area = 'windurst', bit = 34 },
    wq_wl_to_bee_or_not_to_bee = { area = 'windurst', bit = 35 },
    wq_wl_curses_foiled_again = { area = 'windurst', bit = 32 },
    wq_wl_curses_foiled_again2 = { area = 'windurst', bit = 33 },
    wq_wl_curses_foiled_a_golem = { area = 'windurst', bit = 63 },
    wq_wl_flower_child       = { area = 'windurst', bit = 65 },
    wq_wl_hear_a_rainbow     = { area = 'windurst', bit = 75 },
    wq_wl_nothing_matters    = { area = 'windurst', bit = 79 },
    wq_wl_puppet_master      = { area = 'windurst', bit = 81 },
    wq_wl_class_reunion      = { area = 'windurst', bit = 82 },
    wq_wl_carbuncle_debacle  = { area = 'windurst', bit = 83 },
    wq_wl_blood_and_glory    = { area = 'windurst', bit = 87 },

    -- Windurst Waters
    wq_wt_hat_in_hand        = { area = 'windurst', bit = 0 },
    wq_wt_feather_in_ones_cap= { area = 'windurst', bit = 1 },
    wq_wt_crisis_in_the_making = { area = 'windurst', bit = 2 },
    wq_wt_making_the_grade   = { area = 'windurst', bit = 4 },
    wq_wt_in_a_pickle         = { area = 'windurst', bit = 5 },
    wq_wt_wondering_minstrel = { area = 'windurst', bit = 6 },
    wq_wt_pose_by_any_other_name = { area = 'windurst', bit = 7 },
    wq_wt_moonlit_path        = { area = 'windurst', bit = 9 },
    wq_wt_smudge_on_ones_record = { area = 'windurst', bit = 12 },
    wq_wt_chasing_tales       = { area = 'windurst', bit = 13 },
    wq_wt_food_for_thought    = { area = 'windurst', bit = 14 },
    wq_wt_overnight_delivery  = { area = 'windurst', bit = 15 },
    wq_wt_water_way_to_go     = { area = 'windurst', bit = 16 },
    wq_wt_blue_ribbon_blues   = { area = 'windurst', bit = 17 },
    wq_wt_early_bird          = { area = 'windurst', bit = 20 },
    wq_wt_say_it_with_flowers = { area = 'windurst', bit = 50 },
    wq_wt_hoist_the_jelly_roger = { area = 'windurst', bit = 51 },
    wq_wt_something_fishy     = { area = 'windurst', bit = 52 },
    wq_wt_waking_dreams       = { area = 'windurst', bit = 93 },
    wq_wt_toraimarai_turmoil  = { area = 'windurst', bit = 80 },
    wq_wt_tuning_in           = { area = 'windurst', bit = 90 },
    wq_wt_tuning_out          = { area = 'windurst', bit = 91 },
    wq_wt_one_good_deed       = { area = 'windurst', bit = 92 },
    wq_wt_eco_warrior         = { area = 'windurst', bit = 84 },
    wq_wt_wild_card           = { area = 'windurst', bit = 77 },
    wq_wt_babban_ny_mheillea  = { area = 'windurst', bit = 95 },
    wq_wt_teachers_pet        = { area = 'windurst', bit = 28 },
    wq_wt_reap_what_you_sow   = { area = 'windurst', bit = 29 },
    wq_wt_let_sleeping_dogs_lie = { area = 'windurst', bit = 46 },
    wq_wt_heaven_cent          = { area = 'windurst', bit = 49 },
    wq_wt_acting_in_good_faith = { area = 'windurst', bit = 64 },

    -- Windurst Woods
    wq_wd_all_new_c2000       = { area = 'windurst', bit = 24 },
    wq_wd_mihgos_amigo        = { area = 'windurst', bit = 25 },
    wq_wd_rock_racketeer      = { area = 'windurst', bit = 26 },
    wq_wd_chocobilious        = { area = 'windurst', bit = 27 },
    wq_wd_the_fanged_one      = { area = 'windurst', bit = 31 },
    wq_wd_all_new_c3000       = { area = 'windurst', bit = 18 },
    wq_wd_greeting_cardian    = { area = 'windurst', bit = 43 },
    wq_wd_legendary_plan_b    = { area = 'windurst', bit = 44 },
    wq_wd_in_a_stew           = { area = 'windurst', bit = 45 },
    wq_wd_can_cardians_cry    = { area = 'windurst', bit = 47 },
    wq_wd_paying_lip_service  = { area = 'windurst', bit = 60 },
    wq_wd_amazin_scorpio      = { area = 'windurst', bit = 61 },
    wq_wd_twinstone_bonding   = { area = 'windurst', bit = 62 },
    wq_wd_tenshodo_showdown   = { area = 'windurst', bit = 69 },
    wq_wd_thick_as_thieves    = { area = 'windurst', bit = 70 },
    wq_wd_hitting_the_marquisate = { area = 'windurst', bit = 71 },
    wq_wd_sin_hunting         = { area = 'windurst', bit = 72 },
    wq_wd_fire_and_brimstone  = { area = 'windurst', bit = 73 },
    wq_wd_unbridled_passion   = { area = 'windurst', bit = 74 },
    wq_wd_lure_of_the_wildcat = { area = 'windurst', bit = 94 },
    wq_wd_from_saplings_grow  = { area = 'windurst', bit = 85 },
    wq_wd_trust_windurst      = { area = 'windurst', bit = 96 },

    -- Added from the Windurst quest ID table (moghouse.cc), which lists these
    -- five that had no tracking id.
    wq_pw_discerning_eye      = { area = 'windurst', bit = 89 },
    wq_wt_glyph_hanger        = { area = 'windurst', bit = 30 },
    wq_wd_creepy_crawlies     = { area = 'windurst', bit = 39 },
    wq_wd_making_headlines    = { area = 'windurst', bit = 37 },
    wq_wd_scooped             = { area = 'windurst', bit = 38 },
}

-- ============================================================
-- APPLY TRACKER DATA
-- ============================================================

local function apply_tracker_data(
    quest_list
)
    for _, quest in ipairs(quest_list) do

        local info =
            tracker_data[
                quest.id
            ]

        if info ~= nil then

            quest.tracker_area =
                info.area

            quest.tracker_id =
                info.bit

            quest.trackable = true

        else

            quest.tracker_area =
                quest.tracker_area
                or quest.area

            -- tracker_id se deja en nil: el quest no es rastreable

            quest.trackable = false
        end
    end
end

for _, zone in ipairs(M.zones) do
    apply_tracker_data(zone.quests)
end

return M