-- THANKS & CREDITS GOES TO Freebaser (oUF_Freebgrid)
-- http://www.wowinterface.com/downloads/info12264-oUF_Freebgrid.html

local _, L = ...
local oUF = L.oUF or oUF

local spellcache = setmetatable({}, {__index=function(t,v)
    local a = {GetSpellInfo(v)}
    if (GetSpellInfo(v)) then
        t[v] = a
    end

    return a
end})

local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

-- instance name and the instance ID,
-- find out the instance ID by typing this in the chat "/run print(C_Map.GetBestMapForUnit("player"))"
-- Note: Just must be in this instance, when you run the script above
local Instance = {
    -- BfA Raids
    -- BfA Instances
    ['Freehold'] = 936,
    --['Shrine of the Storm'] = 1114,
    --['Siege of Boralus'] = 1114,
    --['Tol Dagor'] = 1114,
    ['Waycrest Manor'] = 1015,
    --['Atal'Dazar'] = 1114,
    --['King's Rest'] = 1114,
    --['Motherlode'] = 1114,
    --['Temple of Sethraliss'] = 1114,
    --['Underrot'] = 1114,

    -- PVP
    ['PVP'] = 9999,
    --[[
    936     Freehold
    1015    Waycrest Manor
    1162    Siege of Boralus        Dungeon     Tiragarde Sound

    934     Atal'Dazar      Dungeon     Zuldazar
    935     Atal'Dazar  Sacrificial Pits    Dungeon     Zuldazar

    975     Tol Dagor   The Drain   Dungeon     Tiragarde Sound
    976     Tol Dagor   The Brig    Dungeon     Tiragarde Sound
    977     Tol Dagor   Detention Block     Dungeon     Tiragarde Sound
    978     Tol Dagor   Officer Quarters    Dungeon     Tiragarde Sound
    979     Tol Dagor   Overseer's Redoubt  Dungeon     Tiragarde Sound
    980     Tol Dagor   Overseer's Summit   Dungeon     Tiragarde Sound
    ]]
}

L.auras = {

    -- Ascending aura timer
    -- Add spells to this list to have the aura time count up from 0
    -- NOTE: This does not show the aura, it needs to be in one of the other list too.

    ascending = {
        --[GetSpellInfo(89421)] = true, -- Wrack
    },

    -- General debuffs
    debuffs = {
        -- Mythic+ Dungeons
        --[GetSpellInfo(209858)] = 16, -- Necrotic - 괴저
        --[GetSpellInfo(240443)] = 15, -- Bursting - 파열
        --[GetSpellInfo(240559)] = 15, -- Grievous - 치명상
        --[GetSpellInfo(196376)] = 15, -- Grievous Tear
        --[GetSpellInfo(226512)] = 14, -- Sanguine - 피웅덩이

        --[GetSpellInfo(115804)] = 3, -- Mortal Wounds
        --[GetSpellInfo(51372)] = 1, -- Daze
        --[GetSpellInfo(5246)] = 2, -- Intimidating Shout
        --[GetSpellInfo(6788)] = 16, -- Weakened Soul
    },

    -- General buffs
    buffs = {
        -- Immunities
        [GetSpellInfo(642)]    = 10, -- Divine Shield
        [GetSpellInfo(186265)] = 10, -- Aspect of the Turtle
        [GetSpellInfo(45438)]  = 10, -- Ice Block
        [GetSpellInfo(47585)]  = 10, -- Dispersion
        [GetSpellInfo(1022)]   = 10, -- Blessing of Protection
        [GetSpellInfo(216113)] = 10, -- Way of the Crane
        [GetSpellInfo(31224)]  = 10, -- Cloak of Shadows
        [GetSpellInfo(212182)] = 10, -- Smoke Bomb
        [GetSpellInfo(212183)] = 10, -- Smoke Bomb
        [GetSpellInfo(8178)]   = 10, -- Grounding Totem Effect
        [GetSpellInfo(199448)] = 10, -- Blessing of Sacrifice

        -- Anti CCs
        [GetSpellInfo(23920)]  = 9, -- Spell Reflection
        [GetSpellInfo(216890)] = 9, -- Spell Reflection (Honor Talent)
        [GetSpellInfo(213610)] = 9, -- Holy Ward
        [GetSpellInfo(212295)] = 9, -- Nether Ward
        [GetSpellInfo(48707)]  = 9, -- Anti-Magic Shell
        [GetSpellInfo(5384)]   = 9, -- Feign Death
        [GetSpellInfo(213602)] = 9, -- Greater Fade

        -- Offensive Buffs
        [GetSpellInfo(1719)]   = 5, -- [Warrior] Battle Cry
        [GetSpellInfo(107574)] = 5, -- [Warrior] Avatar
        [GetSpellInfo(12292)]  = 5, -- [Warrior] Bloodbath
        [GetSpellInfo(31884)]  = 5, -- [Paladin] Avenging Wrath (Retribution)
        [GetSpellInfo(19574)]  = 5, -- [Hunter] Bestial Wrath
        [GetSpellInfo(186289)] = 5, -- [Hunter] Aspect of the Eagle
        [GetSpellInfo(193526)] = 5, -- [Hunter] Trueshot
        [GetSpellInfo(13750)]  = 5, -- [Rogue] Adrenaline Rush
        [GetSpellInfo(51690)]  = 5, -- [Rogue] Killing Spree
        [GetSpellInfo(121471)] = 5, -- [Rogue] Shadow Blades
        [GetSpellInfo(10060)]  = 5, -- [Priest] Power Infusion
        [GetSpellInfo(194249)] = 5, -- [Priest] Voidform
        [GetSpellInfo(51271)]  = 5, -- [DK] Pillar of Frost
        [GetSpellInfo(152279)] = 5, -- [DK] Breath of Sindragosa
        [GetSpellInfo(2825)]   = 5, -- [Shaman] Bloodlust
        [GetSpellInfo(32182)]  = 5, -- [Shaman] Heroism
        [GetSpellInfo(16166)]  = 5, -- [Shaman] Elemental Mastery
        [GetSpellInfo(114050)] = 5, -- [Shaman] Ascendance (Elemental)
        [GetSpellInfo(114051)] = 5, -- [Shaman] Ascendance (Enhancement)
        [GetSpellInfo(204361)] = 5, -- [Shaman] Bloodlust (Honor Talent)
        [GetSpellInfo(204362)] = 5, -- [Shaman] Heroism (Honor Talent)
        [GetSpellInfo(204945)] = 5, -- [Shaman] Doom Winds
        [GetSpellInfo(12042)]  = 5, -- [Mage] Arcane Power
        [GetSpellInfo(12472)]  = 5, -- [Mage] Icy Veins
        [GetSpellInfo(190319)] = 5, -- [Mage] Combustion
        [GetSpellInfo(198144)] = 5, -- [Mage] Ice Form
        [GetSpellInfo(196098)] = 5, -- [Warlock] Soul Harvest
        [GetSpellInfo(137639)] = 5, -- [Monk] Storm, Earth, and Fire
        [GetSpellInfo(152173)] = 5, -- [Monk] Serenity
        [GetSpellInfo(102543)] = 5, -- [Duruid] Incarnation: King of the Jungle
        [GetSpellInfo(102560)] = 5, -- [Duruid] Incarnation: Chosen of Elune
        [GetSpellInfo(106951)] = 5, -- [Duruid] Berserk
        [GetSpellInfo(194223)] = 5, -- [Duruid] Celestial Alignment
        [GetSpellInfo(162264)] = 5, -- [DH] Metamorphosis
        --[GetSpellInfo(211048)] = 5, -- [DH] Chaos Blades

        -- Defensive Buffs
        [GetSpellInfo(210256)] = 4, -- Blessing of Sanctuary
        [GetSpellInfo(6940)]   = 4, -- Blessing of Sacrifice
        [GetSpellInfo(125174)] = 4, -- Touch of Karma
        [GetSpellInfo(47788)]  = 4, -- Guardian Spirit
        [GetSpellInfo(197268)] = 4, -- Ray of Hope
        [GetSpellInfo(5277)]   = 4, -- Evasion
        [GetSpellInfo(199754)] = 4, -- Riposte
        [GetSpellInfo(212800)] = 4, -- Blur
        [GetSpellInfo(102342)] = 4, -- Ironbark
        [GetSpellInfo(22812)]  = 4, -- Barkskin
        [GetSpellInfo(117679)] = 4, -- Incarnation: Tree of Life
        [GetSpellInfo(198065)] = 4, -- Prismatic Cloak
        [GetSpellInfo(198111)] = 4, -- Temporal Shield
        [GetSpellInfo(108271)] = 4, -- Astral Shift
        [GetSpellInfo(114052)] = 4, -- Ascendance (Restoration)
        [GetSpellInfo(207319)] = 4, -- Corpse Shield
        [GetSpellInfo(104773)] = 4, -- Unending Resolve
        [GetSpellInfo(48792)]  = 4, -- Icebound Fortitude
        [GetSpellInfo(55233)]  = 4, -- Vampiric Blood
        [GetSpellInfo(61336)]  = 4, -- Survival Instincts
        [GetSpellInfo(116849)] = 4, -- Life Cocoon
        [GetSpellInfo(33206)]  = 4, -- Pain Suppression
        [GetSpellInfo(197862)] = 4, -- Archangel
        [GetSpellInfo(31850)]  = 4, -- Ardent Defender
        [GetSpellInfo(120954)] = 4, -- Fortifying Brew
        [GetSpellInfo(108416)] = 4, -- Dark Pact
        [GetSpellInfo(216331)] = 4, -- Avenging Crusader
        --[GetSpellInfo(31842)]  = 4, -- Avenging Wrath (Holy)
        [GetSpellInfo(118038)] = 4, -- Die by the Sword
        [GetSpellInfo(12975)]  = 4, -- Last Stand
        [GetSpellInfo(205191)] = 4, -- Eye for an Eye
        [GetSpellInfo(498)]    = 4, -- Divine Protection
        [GetSpellInfo(871)]    = 4, -- Shield Wall
        [GetSpellInfo(53480)]  = 4, -- Roar of Sacrifice
        [GetSpellInfo(197690)] = 4, -- Defensive Stance

        -- Miscellaneous
        [GetSpellInfo(199450)] = 2, -- Ultimate Sacrifice
        [GetSpellInfo(188501)] = 2, -- Spectral Sight
        [GetSpellInfo(1044)]   = 2, -- Blessing of Freedom
    },

    -- Instance Debuffs
    instances = {
        [Instance['Freehold']] = {
        },

        [Instance['Waycrest Manor']] = {
            [GetSpellInfo(260703)] = 1, -- Unstable Runic Mark
            [GetSpellInfo(263905)] = 1, -- Marking Cleave
            [GetSpellInfo(265880)] = 1, -- Dread Mark
            [GetSpellInfo(265882)] = 1, -- Lingering Dread
            [GetSpellInfo(264105)] = 1, -- Runic Mark
            [GetSpellInfo(264050)] = 1, -- Infected Thorn
            [GetSpellInfo(261440)] = 1, -- Virulent Pathogen
            [GetSpellInfo(263891)] = 1, -- Grasping Thorns
            [GetSpellInfo(264378)] = 1, -- Fragment Soul
            [GetSpellInfo(266035)] = 1, -- Bone Splinter
            [GetSpellInfo(266036)] = 1, -- Drain Essence
            [GetSpellInfo(260907)] = 1, -- Soul Manipulation
            [GetSpellInfo(260741)] = 1, -- Jagged Nettles
            [GetSpellInfo(264556)] = 1, -- Tearing Strike
            [GetSpellInfo(265760)] = 1, -- Thorned Barrage
            [GetSpellInfo(260551)] = 1, -- Soul Thorns
            [GetSpellInfo(263943)] = 1, -- Etch
            [GetSpellInfo(265881)] = 1, -- Decaying Touch
            [GetSpellInfo(261438)] = 1, -- Wasting Strike
            [GetSpellInfo(268202)] = 1, -- Death Lens
            [GetSpellInfo(278456)] = 1, -- Infest
        },

        [Instance['PVP']] = {
            --Death Knight
            [GetSpellInfo(47476)]  = 1, -- Strangulate
            [GetSpellInfo(108194)] = 1, -- Asphyxiate UH
            [GetSpellInfo(221562)] = 1, -- Asphyxiate Blood
            [GetSpellInfo(207171)] = 1, -- Winter is Coming
            [GetSpellInfo(206961)] = 1, -- Tremble Before Me
            [GetSpellInfo(207167)] = 1, -- Blinding Sleet
            [GetSpellInfo(212540)] = 1, -- Flesh Hook (Pet)
            [GetSpellInfo(91807)]  = 1, -- Shambling Rush (Pet)
            [GetSpellInfo(204085)] = 1, -- Deathchill
            [GetSpellInfo(233395)] = 1, -- Frozen Center
            [GetSpellInfo(212332)] = 1, -- Smash (Pet)
            [GetSpellInfo(212337)] = 1, -- Powerful Smash (Pet)
            [GetSpellInfo(91800)]  = 1, -- Gnaw (Pet)
            [GetSpellInfo(91797)]  = 1, -- Monstrous Blow (Pet)
            [GetSpellInfo(210141)] = 1, -- Zombie Explosion

            --Demon Hunter
            [GetSpellInfo(207685)] = 1, -- Sigil of Misery
            [GetSpellInfo(217832)] = 1, -- Imprison
            [GetSpellInfo(221527)] = 1, -- Imprison (Banished version)
            [GetSpellInfo(204490)] = 1, -- Sigil of Silence
            [GetSpellInfo(179057)] = 1, -- Chaos Nova
            [GetSpellInfo(211881)] = 1, -- Fel Eruption
            [GetSpellInfo(205630)] = 1, -- Illidan's Grasp
            [GetSpellInfo(208618)] = 1, -- Illidan's Grasp (Afterward)
            [GetSpellInfo(213491)] = 1, -- Demonic Trample (it's this one or the other)
            [GetSpellInfo(208645)] = 1, -- Demonic Trample

            --Druid
            [GetSpellInfo(81261)]  = 1, -- Solar Beam
            [GetSpellInfo(5211)]   = 1, -- Mighty Bash
            [GetSpellInfo(163505)] = 1, -- Rake
            [GetSpellInfo(203123)] = 1, -- Maim
            [GetSpellInfo(202244)] = 1, -- Overrun
            [GetSpellInfo(99)]     = 1, -- Incapacitating Roar
            [GetSpellInfo(33786)]  = 1, -- Cyclone
            [GetSpellInfo(209753)] = 1, -- Cyclone Balance
            [GetSpellInfo(45334)]  = 1, -- Immobilized
            [GetSpellInfo(102359)] = 1, -- Mass Entanglement
            [GetSpellInfo(339)]    = 1, -- Entangling Roots
            [GetSpellInfo(2637)]   = 1, -- Hibernate

            --Hunter
            [GetSpellInfo(202933)] = 1, -- Spider Sting (it's this one or the other)
            [GetSpellInfo(233022)] = 1, -- Spider Sting
            [GetSpellInfo(213691)] = 1, -- Scatter Shot
            [GetSpellInfo(19386)]  = 1, -- Wyvern Sting
            [GetSpellInfo(3355)]   = 1, -- Freezing Trap
            [GetSpellInfo(203337)] = 1, -- Freezing Trap (Survival PvPT)
            [GetSpellInfo(209790)] = 1, -- Freezing Arrow
            [GetSpellInfo(24394)]  = 1, -- Intimidation
            [GetSpellInfo(117526)] = 1, -- Binding Shot
            [GetSpellInfo(190927)] = 1, -- Harpoon
            [GetSpellInfo(201158)] = 1, -- Super Sticky Tar
            [GetSpellInfo(162480)] = 1, -- Steel Trap
            [GetSpellInfo(212638)] = 1, -- Tracker's Net
            [GetSpellInfo(200108)] = 1, -- Ranger's Net

            --Mage
            [GetSpellInfo(61721)]  = 1, -- Rabbit (Poly)
            [GetSpellInfo(61305)]  = 1, -- Black Cat (Poly)
            [GetSpellInfo(28272)]  = 1, -- Pig (Poly)
            [GetSpellInfo(28271)]  = 1, -- Turtle (Poly)
            [GetSpellInfo(126819)] = 1, -- Porcupine (Poly)
            [GetSpellInfo(161354)] = 1, -- Monkey (Poly)
            [GetSpellInfo(161353)] = 1, -- Polar bear (Poly)
            [GetSpellInfo(61780)]  = 1,  -- Turkey (Poly)
            [GetSpellInfo(161355)] = 1, -- Penguin (Poly)
            [GetSpellInfo(161372)] = 1, -- Peacock (Poly)
            [GetSpellInfo(277787)] = 1, -- Direhorn (Poly)
            [GetSpellInfo(277792)] = 1, -- Bumblebee (Poly)
            [GetSpellInfo(118)]    = 1, -- Polymorph
            [GetSpellInfo(82691)]  = 1, -- Ring of Frost
            [GetSpellInfo(31661)]  = 1, -- Dragon's Breath
            [GetSpellInfo(122)]    = 1, -- Frost Nova
            [GetSpellInfo(33395)]  = 1, -- Freeze
            [GetSpellInfo(157997)] = 1, -- Ice Nova
            [GetSpellInfo(228600)] = 1, -- Glacial Spike
            [GetSpellInfo(198121)] = 1, -- Forstbite

            --Monk
            [GetSpellInfo(119381)] = 1, -- Leg Sweep
            [GetSpellInfo(202346)] = 1, -- Double Barrel
            [GetSpellInfo(115078)] = 1, -- Paralysis
            [GetSpellInfo(198909)] = 1, -- Song of Chi-Ji
            [GetSpellInfo(202274)] = 1, -- Incendiary Brew
            [GetSpellInfo(233759)] = 1, -- Grapple Weapon
            [GetSpellInfo(123407)] = 1, -- Spinning Fire Blossom
            [GetSpellInfo(116706)] = 1, -- Disable
            [GetSpellInfo(232055)] = 1, -- Fists of Fury (it's this one or the other)

            --Paladin
            [GetSpellInfo(853)]    = 1, -- Hammer of Justice
            [GetSpellInfo(20066)]  = 1, -- Repentance
            [GetSpellInfo(105421)] = 1, -- Blinding Light
            [GetSpellInfo(31935)]  = 1, -- Avenger's Shield
            [GetSpellInfo(217824)] = 1, -- Shield of Virtue
            [GetSpellInfo(205290)] = 1, -- Wake of Ashes

            --Priest
            [GetSpellInfo(9484)]   = 1, -- Shackle Undead
            [GetSpellInfo(200196)] = 1, -- Holy Word: Chastise
            [GetSpellInfo(200200)] = 1, -- Holy Word: Chastise
            [GetSpellInfo(226943)] = 1, -- Mind Bomb
            [GetSpellInfo(605)]    = 1, -- Mind Control
            [GetSpellInfo(8122)]   = 1, -- Psychic Scream
            [GetSpellInfo(15487)]  = 1, -- Silence
            [GetSpellInfo(64044)]  = 1, -- Psychic Horror

            --Rogue
            [GetSpellInfo(2094)]   = 1, -- Blind
            [GetSpellInfo(6770)]   = 1, -- Sap
            [GetSpellInfo(1776)]   = 1, -- Gouge
            [GetSpellInfo(1330)]   = 1, -- Garrote - Silence
            [GetSpellInfo(207777)] = 1, -- Dismantle
            [GetSpellInfo(199804)] = 1, -- Between the Eyes
            [GetSpellInfo(408)]    = 1, -- Kidney Shot
            [GetSpellInfo(1833)]   = 1, -- Cheap Shot
            [GetSpellInfo(207736)] = 1, -- Shadowy Duel (Smoke effect)
            [GetSpellInfo(212182)] = 1, -- Smoke Bomb

            --Shaman
            [GetSpellInfo(51514)]  = 1, -- Hex
            [GetSpellInfo(211015)] = 1, -- Hex (Cockroach)
            [GetSpellInfo(211010)] = 1, -- Hex (Snake)
            [GetSpellInfo(211004)] = 1, -- Hex (Spider)
            [GetSpellInfo(210873)] = 1, -- Hex (Compy)
            [GetSpellInfo(196942)] = 1, -- Hex (Voodoo Totem)
            [GetSpellInfo(269352)] = 1, -- Hex (Skeletal Hatchling)
            [GetSpellInfo(277778)] = 1, -- Hex (Zandalari Tendonripper)
            [GetSpellInfo(277784)] = 1, -- Hex (Wicker Mongrel)
            [GetSpellInfo(118905)] = 1, -- Static Charge
            [GetSpellInfo(77505)]  = 1, -- Earthquake (Knocking down)
            [GetSpellInfo(118345)] = 1, -- Pulverize (Pet)
            [GetSpellInfo(204399)] = 1, -- Earthfury
            [GetSpellInfo(204437)] = 1, -- Lightning Lasso
            [GetSpellInfo(157375)] = 1, -- Gale Force
            [GetSpellInfo(64695)]  = 1, -- Earthgrab

            --Warlock
            [GetSpellInfo(710)]    = 1, -- Banish
            [GetSpellInfo(6789)]   = 1, -- Mortal Coil
            [GetSpellInfo(118699)] = 1, -- Fear
            [GetSpellInfo(6358)]   = 1, -- Seduction (Succub)
            [GetSpellInfo(171017)] = 1, -- Meteor Strike (Infernal)
            [GetSpellInfo(22703)]  = 1, -- Infernal Awakening (Infernal CD)
            [GetSpellInfo(30283)]  = 1, -- Shadowfury
            [GetSpellInfo(89766)]  = 1, -- Axe Toss
            [GetSpellInfo(233582)] = 1, -- Entrenched in Flame

            --Warrior
            [GetSpellInfo(5246)]   = 1, -- Intimidating Shout
            [GetSpellInfo(7922)]   = 1, -- Warbringer
            [GetSpellInfo(132169)] = 1, -- Storm Bolt
            [GetSpellInfo(132168)] = 1, -- Shockwave
            [GetSpellInfo(199085)] = 1, -- Warpath
            [GetSpellInfo(105771)] = 1, -- Charge
            [GetSpellInfo(199042)] = 1, -- Thunderstruck
            [GetSpellInfo(236077)] = 1, -- Disarm

            --Racial
            [GetSpellInfo(20549)]  = 1, -- War Stomp
            [GetSpellInfo(107079)] = 1, -- Quaking Palm
        },
    },
}
