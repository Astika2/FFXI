addon.name      = 'anglin'
addon.author    = 'Astika'
addon.version   = '3.9.7'
addon.desc      = 'Like "Fishaid" plugin, with more insight and tracking. Updated for ToAU'
addon.link      = 'https://github.com/Astika2/FFXI/tree/main/addons'

-- Capture before the local `addon` table below shadows the global.
local CURRENT_VERSION = addon.version

require('common')
local fonts    = require('fonts')
local settings = require('settings')
local imgui    = require('imgui')
local data     = require('data_manager')
local json     = require('json')
local https    = require('socket.ssl.https')
local addon = { name = 'Anglin' }
local playerName = nil
local Colors = {
    Primary = 0xFFFFB974,        -- Soft Sky Blue
    PrimaryDark = 0xFFD69954,    -- Deeper Blue
    PrimaryLight = 0xFFFFD49F,   -- Light Sky Blue
    Accent = 0xFFC0D37D,         -- Soft Teal
    Success = 0xFF7CDB69,        -- Soft Green
    Warning = 0xFF96E5FA,        -- Pale Yellow (very soft)
    Error = 0xFFA29AFF,          -- Soft Pink-Red
    TextPrimary = 0xFFFFFFFF,
    TextSecondary = 0xBFFFFFFF,
    TextMuted = 0x80FFFFFF,
    BgDark = 0x1A1A1A,
    BgMedium = 0x2D2D2D,
    BgLight = 0x3A3A3A,
    Legendary = 0xFF7CE8FF,      -- Pale Gold
    Large = 0xFFFAC981,          -- Light Blue
    Small = 0xFFEFD966,          -- Cyan
    Item = 0xFFE7C7B4,           -- Soft Periwinkle
    Monster = 0xFFC88CFF,        -- Soft Pink
    Good = 0xFF66CF51,           -- Soft Green
    Bad = 0xFF96E5FA,            -- Pale Yellow
    Terrible = 0xFFA29AFF,       -- Soft Coral
    CaughtColor = 0xFFFFFFFF,    -- White  (ABGR)
    UncaughtColor = 0xFF808080,  -- Gray   (ABGR)
}
local guideColorOptions = {
    { name = "White",       value = 0xFFFFFFFF, hex = "FFFFFFFF" },
    { name = "Gray",        value = 0xFF808080, hex = "808080FF" },
    { name = "Green",       value = 0xFF69DB68, hex = "68DB69FF" },
    { name = "Yellow",      value = 0xFF00FFFF, hex = "FFFF00FF" },
    { name = "Orange",      value = 0xFF00A5FF, hex = "FFA500FF" },
    { name = "Red",         value = 0xFF4444FF, hex = "FF4444FF" },
    { name = "Cyan",        value = 0xFFFFFF00, hex = "00FFFFFF" },
    { name = "Purple",      value = 0xFFFF88CC, hex = "CC88FFFF" },
    { name = "Light Blue",  value = 0xFFFFCC88, hex = "88CCFFFF" },
    { name = "Pink",        value = 0xFFCCAAFF, hex = "FFAACCFF" },
    { name = "Dark Gray",   value = 0xFF505050, hex = "505050FF" },
}

local function guideColorNameFromHex(hex)
    for _, c in ipairs(guideColorOptions) do
        if c.hex:upper() == (hex or ""):upper() then return c.name end
    end
    return guideColorOptions[1].name
end

local function guideColorFromName(name)
    for _, c in ipairs(guideColorOptions) do
        if c.name == name then return c end
    end
    return guideColorOptions[1]
end
local ColorThemes = {
    ["Soft Blue"] = {
        Primary = 0xFFFFB974,
        PrimaryDark = 0xFFD69954,
        PrimaryLight = 0xFFFFD49F,
        Accent = 0xFFC0D37D,
        Success = 0xFF7CDB69,
        Warning = 0xFF96E5FA,
        Error = 0xFFA29AFF,
    },
    ["Ocean Teal"] = {
        Primary = 0xFFC0D37D,
        PrimaryDark = 0xFFA0B35D,
        PrimaryLight = 0xFFD0E39D,
        Accent = 0xFFFFB974,
        Success = 0xFF7CDB69,
        Warning = 0xFF96E5FA,
        Error = 0xFFA29AFF,
    },
    ["Purple Dream"] = {
        Primary = 0xFFD87F8B,
        PrimaryDark = 0xFFB85F6B,
        PrimaryLight = 0xFFE899A5,
        Accent = 0xFFC0D37D,
        Success = 0xFF7CDB69,
        Warning = 0xFF96E5FA,
        Error = 0xFFA29AFF,
    },
    ["Forest Green"] = {
        Primary = 0xFF69B350,
        PrimaryDark = 0xFF499330,
        PrimaryLight = 0xFF89D370,
        Accent = 0xFFFFB974,
        Success = 0xFF7CDB69,
        Warning = 0xFF96E5FA,
        Error = 0xFFA29AFF,
    },
    ["Sunset Orange"] = {
        Primary = 0xFF5599FF,
        PrimaryDark = 0xFF3579DF,
        PrimaryLight = 0xFF75B9FF,
        Accent = 0xFFC0D37D,
        Success = 0xFF7CDB69,
        Warning = 0xFF96E5FA,
        Error = 0xFFA29AFF,
    },
    ["Cool Gray"] = {
        Primary = 0xFFAAAAAA,
        PrimaryDark = 0xFF8A8A8A,
        PrimaryLight = 0xFFCCCCCC,
        Accent = 0xFFFFB974,
        Success = 0xFF7CDB69,
        Warning = 0xFF96E5FA,
        Error = 0xFFA29AFF,
    },
    ["Custom"] = {
        Primary = 0xFFFFB974,
        PrimaryDark = 0xFFD69954,
        PrimaryLight = 0xFFFFD49F,
        Accent = 0xFFC0D37D,
        Success = 0xFF7CDB69,
        Warning = 0xFF96E5FA,
        Error = 0xFFA29AFF,
    }
}
local function applyColorTheme(themeName)
    local theme = ColorThemes[themeName]
    if theme then
        Colors.Primary = theme.Primary
        Colors.PrimaryDark = theme.PrimaryDark
        Colors.PrimaryLight = theme.PrimaryLight
        Colors.Accent = theme.Accent
        Colors.Success = theme.Success
        Colors.Warning = theme.Warning
        Colors.Error = theme.Error
    end
end
local AnimState = {
    hookPulse = 0,
    catchFlash = 0,
    buttonHover = {},
}

local defaults = T{
    Font = T{
        visible = true,
        font_family = 'Arial',
        font_height = 16,
        color = 0xFFFFFFFF,
        position_x = 1,
        position_y = 1,
        background = T{
            visible = true,
            color = 0x80000000,
        }
    },
    WindowTransparency = 0.92,
    FontScale = 1.15,
    ColorTheme = "Soft Blue",  -- NEW
    CustomColors = T{          -- NEW
        Primary = "FFB974FF",
        PrimaryDark = "D69954FF",
        PrimaryLight = "FFD49FFF",
    },
    CaughtColor = "FFFFFFFF",   -- RRGGBBAA hex for guide "Caught" label (white)
    UncaughtColor = "808080FF", -- RRGGBBAA hex for guide "Uncaught" label (gray)
    SilentToggle = false,       -- suppress "X window toggled." chat messages
}

local state = {
    Active = false,
    Settings = nil,
    CurrentBait = 'Unknown',
    CurrentBaitType = 'Unknown',
    CurrentRod = 'Unknown',
    Hook = nil,
    HookColor = nil,
    Feel = nil,
    FeelColor = nil,
    Fish = nil,
    CatchCount = 1,
    BaitBeforeCast = nil,
    IsItem = false,
    CloseTime = nil,
    LastFishingStatus = nil,
    FishingEndTime = nil,
    AwaitingMonsterName = false,
}
local windowPosX = 100
local function push_font()
    imgui.SetWindowFontScale(state.Settings and state.Settings.FontScale or 1.15)
end

local function pop_font()
end
local windowPosY = 100
local windowPosSet = false
local showSettings = false
local showStats = false
local showGuide = false
local activeStatsTab = "Daily"
local statsCache = {
    dailyDirty = true,
    lifetimeDirty = true,
    dailyData = {},
    lifetimeData = {}
}
local statsFilters = {
    bait = "All",
    location = "All",
    skillRange = "All",
    showZeroCatch = true,
}
local filterOptionsCache = {
    baits = {},
    locations = {},
    skillRanges = {
        "All", "0-10", "11-20", "21-30", "31-40", "41-50",
        "51-60", "61-70", "71-80", "81-90", "91-100", "100+"
    },
    dirty = true
}
local guideFilters = {
    bait = "All",
    location = "All",
    skillRange = "All",
    catchType = "All",
    showUncaught = true,
}
local guideFilterOptionsCache = {
    baits = {},
    locations = {},
    skillRanges = {
        "All", "0-10", "11-20", "21-30", "31-40", "41-50",
        "51-60", "61-70", "71-80", "81-90", "91-100", "100+"
    },
    catchTypes = { "All", "Fish", "Item", "Monster" },
    dirty = true
}
local guideFilterCache = {
    lastBait = "",
    lastLocation = "",
    lastSkillRange = "",
    lastShowUncaught = true,
    filteredList = {},
    totalFish = 0,
    totalCaught = 0
}
local lastDailyCheck = 0
local baitTypes = {
    ['Crayfish Ball'] = { consumable = true },
    ['Drill Calamary'] = { consumable = true },
    ['Dwarf Pugil'] = { consumable = true },
    ['Giant Shell Bug'] = { consumable = true },
    ['Insect Ball'] = { consumable = true },
    ['Little Worm'] = { consumable = true },
    ['Lufaise Fly'] = { consumable = true },
    ['Lugworm'] = { consumable = true },
    ['Meatball'] = { consumable = true },
    ['Peeled Crayfish'] = { consumable = true },
    ['Peeled Lobster'] = { consumable = true },
    ['Rotten Meat'] = { consumable = true },
    ['Sardine Ball'] = { consumable = true },
    ['Shell Bug'] = { consumable = true },
    ['Slice of Bluetail'] = { consumable = true },
    ['Slice of Carp'] = { consumable = true },
    ['Sliced Cod'] = { consumable = true },
    ['Sliced Sardine'] = { consumable = true },
    ['Trout Ball'] = { consumable = true },
    ['Fly Lure'] = { consumable = false },
    ['Frog Lure'] = { consumable = false },
    ['Lizard Lure'] = { consumable = false },
    ['Minnow'] = { consumable = false },
    ['Robber Rig'] = { consumable = false },
    ['Rogue Rig'] = { consumable = false },
    ['Sabiki Rig'] = { consumable = false },
    ['Shrimp Lure'] = { consumable = false },
    ['Sinking Minnow'] = { consumable = false },
    ['Worm Lure'] = { consumable = false },
}

local fishSellPrices = {
    ["Ahtapot"]=700, ["Alabaligi"]=98, ["Arrowwood Log"]=5, ["Armored Pisces"]=969,
    ["Bastore Bream"]=600, ["Bastore Sardine"]=9, ["Betta"]=400, ["Bhefhel Marlin"]=307,
    ["Bibiki Urchin"]=750, ["Bibikibo"]=99, ["Black Eel"]=192, ["Black Ghost"]=600,
    ["Black Sole"]=700, ["Bladefish"]=408, ["Blindfish"]=229, ["Bluetail"]=300,
    ["Brass Loach"]=276, ["Bugbear Mask"]=0, ["Ca Cuong"]=560, ["Caedarva Frog"]=100,
    ["Cave Cherax"]=1600, ["Cheval Salmon"]=20, ["Cobalt Jellyfish"]=8,
    ["Cone Calamary"]=165, ["Copper Frog"]=20, ["Copper Ring"]=19, ["Coral Butterfly"]=127,
    ["Coral Fragment"]=1750, ["Crayfish"]=10, ["Crescent Fish"]=403, ["Crystal Bass"]=0,
    ["Damp Scroll"]=1, ["Dark Bass"]=20, ["Denizanasi"]=7, ["Dil"]=700,
    ["Elshimo Frog"]=52, ["Elshimo Newt"]=179, ["Emperor Fish"]=615, ["Fat Greedie"]=0,
    ["Fish Scale Shield"]=384, ["Forest Carp"]=22, ["Gavial Fish"]=500,
    ["Garpike"]=610, ["Gerrothorax"]=118, ["Giant Catfish"]=102, ["Giant Chirai"]=1100,
    ["Giant Donko"]=195, ["Gigant Octopus"]=238, ["Gigant Squid"]=612, ["Gil"]=0,
    ["Gold Carp"]=289, ["Gold Lobster"]=194, ["Greedie"]=11, ["Grimmonite"]=717,
    ["Gugru Tuna"]=100, ["Gugrusaurus"]=1760, ["Gurnard"]=475, ["Hamsi"]=7,
    ["Hydrogauge"]=0, ["Icefish"]=156, ["Istakoz"]=200, ["Istavrit"]=100,
    ["Istiridye"]=279, ["Jungle Catfish"]=612, ["Kalamar"]=170, ["Kalkanbaligi"]=780,
    ["Kaplumbaga"]=830, ["Kayabaligi"]=310, ["Kilicbaligi"]=450, ["Lakerda"]=103,
    ["Lamp Marimo"]=786, ["Lik"]=1760, ["Lungfish"]=231, ["Matsya"]=25688,
    ["Megalodon"]=864, ["Mercanbaligi"]=600, ["Mithra Snare"]=0, ["Moat Carp"]=10,
    ["Moblin Mask"]=0, ["Mola Mola"]=975, ["Monke-Onke"]=306, ["Moorish Idol"]=242,
    ["Morinabaligi"]=548, ["Muddy Siredon"]=0, ["Mythril Dagger"]=1431,
    ["Mythril Sword"]=4100, ["Nebimonite"]=52, ["Noble Lady"]=400, ["Norg Shell"]=500,
    ["Nosteau Herring"]=80, ["Ogre Eel"]=32, ["Pamtam Kelp"]=8, ["Phanauet Newt"]=4,
    ["Pipira"]=46, ["Pirarucu"]=901, ["Pterygotus"]=750, ["Quus"]=20,
    ["Red Terrapin"]=306, ["Rhinochimera"]=613, ["Ripped Cap"]=0, ["Rusty Bucket"]=51,
    ["Rusty Cap"]=97, ["Rusty Greatsword"]=86, ["Rusty Leggings"]=12, ["Rusty Pick"]=115,
    ["Rusty Subligar"]=15, ["Ryugu Titan"]=1500, ["Sandfish"]=26, ["Sazanbaligi"]=300,
    ["Sea Zombie"]=628, ["Shall Shell"]=300, ["Shining Trout"]=26, ["Silver Ring"]=250,
    ["Silver Shark"]=500, ["Takitaro"]=714, ["Tarutaru Snare"]=0, ["Tavnazian Goby"]=400,
    ["Three-Eyed Fish"]=512, ["Three-eyed Fish"]=512, ["Tiger Cod"]=52,
    ["Tiny Goldfish"]=1, ["Titanic Sawfish"]=1652, ["Titanictus"]=700,
    ["Tricolored Carp"]=52, ["Tricorn"]=616, ["Trilobite"]=40, ["Trumpet Shell"]=512,
    ["Turnabaligi"]=693, ["Uskumru"]=300, ["Veydal Wrasse"]=420, ["Vongola Clam"]=192,
    ["Yayinbaligi"]=225, ["Yellow Globe"]=20, ["Yilanbaligi"]=200,
    ["Zafmlug Bass"]=31, ["Zebra Eel"]=385,
}

local function get_sell_price(name)
    if not name then return nil end
    local p = fishSellPrices[name]
    if p ~= nil then return p end
    local lower = name:lower()
    for k, v in pairs(fishSellPrices) do
        if k:lower() == lower then return v end
    end
    return nil
end

local function calc_gil_value(catchData)
    local total = 0
    for name, count in pairs(catchData.fishCaught) do
        local price = get_sell_price(name)
        if price and price > 0 then
            total = total + price * count
        end
    end
    return total
end

local fishingGuide = {
	{ name = "Ahtapot", skill = 90, location = "Arrapago Reef, Nashmau, Talacca Cove", bait = "Ball of Crayfish Paste, Peeled Lobster, Shrimp Lure", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Alabaligi", skill = 37, location = "Bhaflau Thickets, Mamook, Wajaom Woodlands", bait = "Ball of Sardine Paste, Ball of Trout Paste, Fly Lure, Minnow, Sinking Minnow", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Armored Pisces", skill = 108, location = "Oldton Movalpolos", bait = "Frog Lure, Meatball, Minnow, Sinking Minnow", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Bastore Bream", skill = 86, location = "East Sarutabaruta, Port Bastok, Port Windurst, Sea Serpent Grotto, South Gustaberg, West Sarutabaruta", bait = "Shrimp Lure", rod = "Halcyon Rod", notes = "East Sarutabaruta: Seaside only (not lake or riverbanks). Sea Serpent Grotto: Pond Under a Bridge and Mythril door area only (not other pools). South Gustaberg and West Sarutabaruta: Seaside only.", type = "Fish" },
	{ name = "Bastore Sardine", skill = 9, location = "Batallia Downs, Bibiki Bay, Cape Teriggan, East Sarutabaruta, Kazham, Lower Jeuno, Manaclipper, Mhaura, Norg, Port Bastok, Port Jeuno, Port Windurst, Sea Serpent Grotto, Selbina, Ship bound for Mhaura, Ship bound for Mhaura (with Pirates), Ship bound for Selbina, Ship bound for Selbina (with Pirates), South Gustaberg, Valkurm Dunes, West Sarutabaruta", bait = "Sabiki Rig", rod = "Halcyon Rod", notes = "East Sarutabaruta: Seaside only (not lake or riverbanks). Bibiki Bay: not available at PI - South Beach. South Gustaberg and West Sarutabaruta: Seaside only (not inland ponds).", type = "Fish" },
	{ name = "Betta", skill = 68, location = "Mamook", bait = "Fly Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Bhefhel Marlin", skill = 61, location = "Ship bound for Mhaura, Ship bound for Mhaura (with Pirates), Ship bound for Selbina, Ship bound for Selbina (with Pirates)", bait = "Slice of Bluetail", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Bibiki Urchin", skill = 3, location = "Bibiki Bay, Manaclipper", bait = "Any", rod = "Halcyon Rod", notes = "Bibiki Bay: PI beaches only (South/North/West/East) - not available on BB side.", type = "Fish" },
	{ name = "Bibikibo", skill = 8, location = "Bibiki Bay, Manaclipper", bait = "Fly Lure", rod = "Halcyon Rod", notes = "Bibiki Bay: PI - South Beach only (not North/West/East Beach and not BB side).", type = "Fish" },
	{ name = "Black Eel", skill = 47, location = "Bastok Markets, Gusgen Mines, Korroloka Tunnel, North Gustaberg, Oldton Movalpolos, Palborough Mines, Zeruhn Mines", bait = "Ball of Crayfish Paste, Shell Bug", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Black Ghost", skill = 88, location = "Caedarva Mire", bait = "Minnow", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Black Sole", skill = 96, location = "Batallia Downs, Beaucedine Glacier, Lower Jeuno, Port Jeuno, Qufim Island, Sauromugue Champaign", bait = "Sinking Minnow", rod = "Halcyon Rod", notes = "Beaucedine Glacier: Seaside only (not Ponds).", type = "Fish" },
	{ name = "Bladefish", skill = 71, location = "Bibiki Bay, East Sarutabaruta, Manaclipper, South Gustaberg, West Sarutabaruta", bait = "Meatball, Slice of Bluetail", rod = "Composite Fishing Rod", notes = "East Sarutabaruta: Seaside only (not lake or riverbanks). Bibiki Bay: BB - South Seaside only. South Gustaberg and West Sarutabaruta: Seaside only.", type = "Fish" },
	{ name = "Blindfish", skill = 28, location = "Aydeewa Subterrane, Oldton Movalpolos", bait = "Ball of Insect Paste", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Bluetail", skill = 55, location = "Batallia Downs, Beaucedine Glacier, Bibiki Bay, Buburimu Peninsula, Den of Rancor, East Sarutabaruta, Manaclipper, Qufim Island, Sauromugue Champaign, Sea Serpent Grotto, Ship bound for Mhaura, Ship bound for Mhaura (with Pirates), Ship bound for Selbina, Ship bound for Selbina (with Pirates), West Sarutabaruta", bait = "Minnow", rod = "Halcyon Rod", notes = "East Sarutabaruta: Seaside only (not lake or riverbanks). Bibiki Bay: PI - North/West/East Beach only (not PI - South Beach or BB side). Den of Rancor: Pools E-8 and F-11 (not Misc Water). Sea Serpent Grotto: Pond Under a Bridge and Mythril door area only.", type = "Fish" },
	{ name = "Caedarva Frog", skill = 30, location = "Caedarva Mire", bait = "Fly Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Cave Cherax", skill = 130, location = "Aydeewa Subterrane, Kuftal Tunnel, Quicksand Caves", bait = "Meatball, Rotten Meat", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Cheval Salmon", skill = 21, location = "East Ronfaure, Ghelsba Outpost, Jugner Forest", bait = "Fly Lure", rod = "Halcyon Rod", notes = "Ghelsba Outpost: River only (not ponds). Jugner Forest: River only (not lakes or springs).", type = "Fish" },
	{ name = "Cone Calamary", skill = 48, location = "Batallia Downs, Beaucedine Glacier, Bibiki Bay, Manaclipper, Qufim Island, Sauromugue Champaign, Ship bound for Mhaura, Ship bound for Mhaura (with Pirates), Ship bound for Selbina, Ship bound for Selbina (with Pirates)", bait = "Minnow", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Copper Frog", skill = 16, location = "Bastok Mines, Eastern Altepa Desert, Gusgen Mines, Korroloka Tunnel, North Gustaberg, Oldton Movalpolos, Palborough Mines, Pashhow Marshlands, Zeruhn Mines", bait = "Fly Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Coral Butterfly", skill = 40, location = "Den of Rancor, Kazham, Norg, Sea Serpent Grotto", bait = "Worm Lure", rod = "Halcyon Rod", notes = "Den of Rancor: Pools E-8 and F-11 only (not Misc Water). Sea Serpent Grotto: not available in Misc Puddles.", type = "Fish" },
	{ name = "Crayfish", skill = 7, location = "Al Zahbi, Bastok Markets, Bastok Mines, Bostaunieux Oubliette, Caedarva Mire, Carpenters' Landing, Castle Oztroja, Dangruf Wadi, Davoi, Dragon's Aery, East Ronfaure, East Sarutabaruta, Eastern Altepa Desert, Ghelsba Outpost, Giddeus, Gusgen Mines, Jugner Forest, Korroloka Tunnel, La Theine Plateau, Mamook, North Gustaberg, Northern San d'Oria, Oldton Movalpolos, Ordelle's Caves, Palborough Mines, Pashhow Marshlands, Phanauet Channel, Phomiuna Aqueducts, Port San d'Oria, Quicksand Caves, Rabao, Ranguemont Pass, Rolanberry Fields, Ru'Aun Gardens, Tavnazian Safehold, Temple of Uggalepih, The Boyahda Tree, The Shrine of Ru'Avitau, West Ronfaure, West Sarutabaruta, Western Altepa Desert, Windurst Walls, Windurst Waters, Windurst Woods, Yhoator Jungle, Yughott Grotto, Yuhtunga Jungle, Zeruhn Mines", bait = "Slice of Moat Carp", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Crescent Fish", skill = 69, location = "Dragon's Aery, East Sarutabaruta, Yuhtunga Jungle", bait = "Fly Lure", rod = "Halcyon Rod", notes = "East Sarutabaruta: Lake Tepokalipuka only (not Seaside or riverbanks). Yuhtunga Jungle: Northeast Pond and Gremini Falls only.", type = "Fish" },
	{ name = "Crystal Bass", skill = 35, location = "Jugner Forest, The Sanctuary of Zi'Tah", bait = "Minnow, Sinking Minnow", rod = "Halcyon Rod", notes = "Jugner Forest: Crystalwater Spring only (not lakes or river).", type = "Fish" },
	{ name = "Dark Bass", skill = 33, location = "Bastok Markets, Bhaflau Thickets, Caedarva Mire, Carpenters' Landing, Davoi, Giddeus, Jugner Forest, La Theine Plateau, Lufaise Meadows, Misareaux Coast, Phanauet Channel, Rolanberry Fields, The Boyahda Tree, The Sanctuary of Zi'Tah, Wajaom Woodlands, West Sarutabaruta", bait = "Ball of Sardine Paste, Ball of Trout Paste, Minnow", rod = "Halcyon Rod", notes = "Bastok Markets: South Side only (not North Side). Davoi: Pond only. Giddeus: Giddeus Spring and main ponds (not Misc Puddles). Jugner Forest: Lake Mechieume only (not springs or river). Lufaise Meadows: Leremieu Lagoon only. Misareaux Coast: Cascade Edellaine only. Rolanberry Fields: Fountain of Promises and Fountain of Partings only (not small fountains).", type = "Fish" },
	{ name = "Dil", skill = 96, location = "Talacca Cove", bait = "Slice of Cod", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Elshimo Frog", skill = 30, location = "Yhoator Jungle, Yuhtunga Jungle", bait = "Fly Lure", rod = "Halcyon Rod", notes = "Yhoator Jungle: Front of Temple areas and Underground Pool 2/3 only (not Teardrop Spring, Pool 1, or Bloodlet Spring). Yuhtunga Jungle: Northeast Pond, Gremini Falls, and riverbanks only (not southwest areas).", type = "Fish" },
	{ name = "Elshimo Newt", skill = 60, location = "Yhoator Jungle, Yuhtunga Jungle", bait = "Frog Lure", rod = "Halcyon Rod", notes = "Yhoator Jungle: Front of Temple - West Side, Underground Pools 2 and 3 only. Yuhtunga Jungle: Gremini Falls and all southwest/riverside areas - not Northeast Pond.", type = "Fish" },
	{ name = "Emperor Fish", skill = 91, location = "Beaucedine Glacier, Jugner Forest, Lufaise Meadows, The Boyahda Tree", bait = "Ball of Sardine Paste, Ball of Trout Paste, Peeled Crayfish", rod = "Composite Fishing Rod", notes = "Beaucedine Glacier: Ponds only (not Seaside). Jugner Forest: Lake Mechieume - Mouth only. Lufaise Meadows: Leremieu Lagoon only. The Boyahda Tree: hidden Waterfall Basin pool only.", type = "Fish" },
	{ name = "Fat Greedie", skill = 24, location = "Selbina", bait = "Ball of Crayfish Paste, Lugworm, Minnow, Sinking Minnow, Slice of Sardine, Worm Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Forest Carp", skill = 20, location = "Yhoator Jungle, Yuhtunga Jungle", bait = "Ball of Insect Paste", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Gavial Fish", skill = 81, location = "Gusgen Mines, North Gustaberg, Western Altepa Desert", bait = "Lizard Lure, Meatball", rod = "Composite Fishing Rod", notes = "Gusgen Mines: Interior Pools only (not upper/lower pools). North Gustaberg: Basin of Waterfall only (not River). Western Altepa Desert: Oasis of Hubol only (not Central Spring).", type = "Fish" },
	{ name = "Giant Catfish", skill = 31, location = "Bastok Markets, Carpenters' Landing, Davoi, Ghelsba Outpost, Giddeus, Jugner Forest, La Theine Plateau, Pashhow Marshlands, Phanauet Channel, Port San d'Oria, Rolanberry Fields, West Ronfaure, West Sarutabaruta, Western Altepa Desert, Zeruhn Mines", bait = "Minnow, Sinking Minnow", rod = "Composite Fishing Rod", notes = "Bastok Markets: South Side only (not North Side). Carpenters' Landing: inland waterways only (not landing areas). Davoi: Pond only. Ghelsba Outpost: Ponds only (not River). Giddeus: Pond - North only. Jugner Forest: Lake Mechieume - Main only. Rolanberry Fields: Fountain of Promises and Fountain of Partings only. Zeruhn Mines: River only (not Pool).", type = "Fish" },
	{ name = "Giant Chirai", skill = 110, location = "The Boyahda Tree", bait = "Lufaise Fly", rod = "Composite Fishing Rod", notes = "The Boyahda Tree: Waterfall Basin only (not other areas).", type = "Fish" },
	{ name = "Giant Donko", skill = 50, location = "Eastern Altepa Desert, Kuftal Tunnel, Rabao, Western Altepa Desert", bait = "Peeled Crayfish", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Gigant Squid", skill = 91, location = "Beaucedine Glacier, Qufim Island", bait = "Minnow, Slice of Cod", rod = "Composite Fishing Rod", notes = "Beaucedine Glacier: Seaside only (not Ponds). Qufim Island: Northwest Seaside only.", type = "Fish" },
	{ name = "Gold Carp", skill = 56, location = "Bastok Markets, Davoi, East Ronfaure, Ghelsba Outpost, Gusgen Mines, Jugner Forest, Lufaise Meadows, Misareaux Coast, North Gustaberg, Northern San d'Oria, Phanauet Channel, Port San d'Oria, Windurst Walls, Windurst Waters, Windurst Woods", bait = "Shrimp Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Gold Lobster", skill = 46, location = "Den of Rancor, East Sarutabaruta, South Gustaberg, West Sarutabaruta", bait = "Sinking Minnow", rod = "Halcyon Rod", notes = "East Sarutabaruta: Seaside only (not lake or riverbanks). Den of Rancor: Pool E-8 only (not Pool F-11). South Gustaberg and West Sarutabaruta: Seaside only.", type = "Fish" },
	{ name = "Greedie", skill = 14, location = "Cape Teriggan, Lufaise Meadows, Misareaux Coast, Selbina, Valkurm Dunes", bait = "Minnow", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Grimmonite", skill = 90, location = "Sea Serpent Grotto", bait = "Shrimp Lure", rod = "Composite Fishing Rod", notes = "Sea Serpent Grotto: Pond Under a Bridge and Mythril door area only.", type = "Fish" },
	{ name = "Gugru Tuna", skill = 41, location = "Manaclipper, Open sea route to Al Zahbi, Open sea route to Mhaura, Ship bound for Mhaura, Ship bound for Mhaura (with Pirates), Ship bound for Selbina, Ship bound for Selbina (with Pirates)", bait = "Sinking Minnow", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Gugrusaurus", skill = 140, location = "Manaclipper, Open sea route to Al Zahbi, Open sea route to Mhaura, Ship bound for Mhaura (with Pirates), Ship bound for Selbina (with Pirates)", bait = "Meatball", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Gurnard", skill = 26, location = "Open sea route to Al Zahbi, Open sea route to Mhaura", bait = "Ball of Crayfish Paste, Slice of Sardine", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Hamsi", skill = 9, location = "Aht Urhgan Whitegate, Mount Zhayolm, Silver Sea route to Al Zahbi, Silver Sea route to Nashmau", bait = "Sabiki Rig", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Icefish", skill = 49, location = "Beaucedine Glacier", bait = "Sabiki Rig", rod = "Halcyon Rod", notes = "Beaucedine Glacier: Ponds only (not Seaside).", type = "Fish" },
	{ name = "Istakoz", skill = 46, location = "Arrapago Reef, Nashmau, Talacca Cove", bait = "Sinking Minnow", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Istavrit", skill = 37, location = "Talacca Cove", bait = "Lugworm", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Istiridye", skill = 53, location = "Arrapago Reef, Nashmau", bait = "Ball of Crayfish Paste", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Jungle Catfish", skill = 80, location = "Yhoator Jungle, Yuhtunga Jungle", bait = "Ball of Sardine Paste, Ball of Trout Paste, Minnow", rod = "Composite Fishing Rod", notes = "Yhoator Jungle: Front of Temple areas and Underground Pool 1 only. Yuhtunga Jungle: Northeast Pond and Southwest Pond only (not falls or riverside).", type = "Fish" },
	{ name = "Kalamar", skill = 48, location = "Aht Urhgan Whitegate, Mount Zhayolm, Silver Sea route to Al Zahbi, Silver Sea route to Nashmau", bait = "Slice of Bluetail", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Kalkanbaligi", skill = 105, location = "Silver Sea route to Al Zahbi, Silver Sea route to Nashmau", bait = "Shrimp Lure", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Kaplumbaga", skill = 53, location = "Caedarva Mire", bait = "Frog Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Kayabaligi", skill = 75, location = "Al Zahbi, Bhaflau Thickets, Mamook, Wajaom Woodlands", bait = "Sinking Minnow", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Kilicbaligi", skill = 62, location = "Silver Sea route to Al Zahbi, Silver Sea route to Nashmau", bait = "Slice of Bluetail", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Lakerda", skill = 41, location = "Silver Sea route to Al Zahbi, Silver Sea route to Nashmau", bait = "Sinking Minnow", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Lamp Marimo", skill = 3, location = "Aydeewa Subterrane", bait = "Fly Lure, Lugworm, Sabiki Rig", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Lik", skill = 140, location = "Lufaise Meadows", bait = "Minnow, Sinking Minnow, Dwarf Pugil", rod = "Composite Fishing Rod", notes = "Lufaise Meadows: Leremieu Lagoon only (not Seaside or river).", type = "Fish" },
	{ name = "Lungfish", skill = 32, location = "Phanauet Channel", bait = "Shrimp Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Mercanbaligi", skill = 86, location = "Arrapago Reef, Nashmau, Talacca Cove", bait = "Shrimp Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Moat Carp", skill = 11, location = "Al Zahbi, Bastok Markets, Davoi, Dragon's Aery, East Sarutabaruta, Eastern Altepa Desert, Jugner Forest, Korroloka Tunnel, La Theine Plateau, Misareaux Coast, Northern San d'Oria, Port San d'Oria, Rabao, Rolanberry Fields, Temple of Uggalepih, The Boyahda Tree, West Ronfaure, West Sarutabaruta, Western Altepa Desert, Windurst Walls, Windurst Waters, Windurst Woods, Yhoator Jungle, Yuhtunga Jungle, Zeruhn Mines", bait = "Ball of Insect Paste", rod = "Halcyon Rod", notes = "East Sarutabaruta: Lake Tepokalipuka only (not Seaside or riverbanks). Davoi: Pond only (not waterfalls or other areas). Korroloka Tunnel: Salt Water side only.", type = "Fish" },
	{ name = "Mola Mola", skill = 135, location = "Open sea route to Al Zahbi, Open sea route to Mhaura", bait = "Shrimp Lure", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Monke-Onke", skill = 51, location = "East Sarutabaruta, Giddeus, Yhoator Jungle, Yuhtunga Jungle", bait = "Shrimp Lure", rod = "Composite Fishing Rod", notes = "East Sarutabaruta: Lake Tepokalipuka only (not Seaside or riverbanks). Giddeus: Giddeus Spring only (not other ponds). Yhoator Jungle: Underground Pool 1 only. Yuhtunga Jungle: Northeast Pond only.", type = "Fish" },
	{ name = "Moorish Idol", skill = 26, location = "Bibiki Bay, Manaclipper", bait = "Shrimp Lure, Worm Lure", rod = "Halcyon Rod", notes = "Bibiki Bay: PI beaches only (South/North/West/East) - not available on BB side.", type = "Fish" },
	{ name = "Morinabaligi", skill = 94, location = "Bhaflau Thickets, Wajaom Woodlands", bait = "Ball of Sardine Paste, Ball of Trout Paste", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Muddy Siredon", skill = 18, location = "Carpenters' Landing, Phanauet Channel", bait = "Frog Lure", rod = "Halcyon Rod", notes = "Carpenters' Landing: inland waterways and landing docks (not the Central Landing).", type = "Fish" },
	{ name = "Nebimonite", skill = 27, location = "Sea Serpent Grotto, Ship bound for Mhaura, Ship bound for Mhaura (with Pirates), Ship bound for Selbina, Ship bound for Selbina (with Pirates)", bait = "Ball of Crayfish Paste", rod = "Halcyon Rod", notes = "Sea Serpent Grotto: Pond Under a Bridge and Mythril door area only.", type = "Fish" },
	{ name = "Noble Lady", skill = 66, location = "Manaclipper, Open sea route to Al Zahbi, Open sea route to Mhaura, Ship bound for Mhaura, Ship bound for Mhaura (with Pirates), Ship bound for Selbina, Ship bound for Selbina (with Pirates)", bait = "Sinking Minnow", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Nosteau Herring", skill = 39, location = "Batallia Downs, Beaucedine Glacier, Lower Jeuno, Port Jeuno, Qufim Island", bait = "Ball of Sardine Paste, Lugworm, Shrimp Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Ogre Eel", skill = 35, location = "East Sarutabaruta, South Gustaberg, West Sarutabaruta", bait = "Shrimp Lure", rod = "Halcyon Rod", notes = "East Sarutabaruta: Seaside only (not lake or riverbanks). South Gustaberg and West Sarutabaruta: Seaside only.", type = "Fish" },
	{ name = "Phanauet Newt", skill = 4, location = "Carpenters' Landing, Phanauet Channel", bait = "Fly Lure", rod = "Halcyon Rod", notes = "Carpenters' Landing: inland waterways only (not landing docks).", type = "Fish" },
	{ name = "Pipira", skill = 29, location = "East Sarutabaruta, Windurst Walls, Windurst Waters, Windurst Woods, Yhoator Jungle, Yuhtunga Jungle", bait = "Minnow", rod = "Halcyon Rod", notes = "East Sarutabaruta: Lake Tepokalipuka only (not Seaside or riverbanks). Yhoator Jungle: Front of Temple - East Side only. Yuhtunga Jungle: Southwest Waterfall and Southwest Pond only (not Northeast Pond, Gremini Falls, or riverbanks).", type = "Fish" },
	{ name = "Pterygotus", skill = 99, location = "Nashmau", bait = "Lugworm", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Quus", skill = 19, location = "Bibiki Bay, Cape Teriggan, Den of Rancor, East Sarutabaruta, Kazham, Korroloka Tunnel, Lufaise Meadows, Manaclipper, Misareaux Coast, Norg, Port Bastok, Port Windurst, Sea Serpent Grotto, Selbina, Ship bound for Mhaura, Ship bound for Mhaura (with Pirates), Ship bound for Selbina, Ship bound for Selbina (with Pirates), South Gustaberg, Valkurm Dunes, West Sarutabaruta", bait = "Lugworm", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Red Terrapin", skill = 53, location = "Davoi, Ghelsba Outpost, Giddeus, Jugner Forest, La Theine Plateau, Pashhow Marshlands, Phanauet Channel, Rolanberry Fields, The Sanctuary of Zi'Tah, West Ronfaure", bait = "Frog Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Rhinochimera", skill = 72, location = "Arrapago Reef", bait = "Sinking Minnow", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Ryugu Titan", skill = 150, location = "Den of Rancor, Manaclipper, Ship bound for Mhaura, Ship bound for Mhaura (with Pirates), Ship bound for Selbina, Ship bound for Selbina (with Pirates)", bait = "Slice of Cod", rod = "Composite Fishing Rod", notes = "Den of Rancor: Pool F-11 only (not Pool E-8).", type = "Fish" },
	{ name = "Sandfish", skill = 50, location = "Eastern Altepa Desert, Korroloka Tunnel, Kuftal Tunnel, Rabao, Western Altepa Desert", bait = "Worm Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Sazanbaligi", skill = 56, location = "Al Zahbi, Bhaflau Thickets, Mamook, Wajaom Woodlands", bait = "Ball of Insect Paste, Little Worm, Shrimp Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Sea Zombie", skill = 100, location = "Ship bound for Mhaura (with Pirates), Ship bound for Selbina (with Pirates)", bait = "Drill Calamary, Meatball, Slice of Bluetail", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Shall Shell", skill = 53, location = "Bibiki Bay, Buburimu Peninsula, Cape Teriggan, Valkurm Dunes", bait = "Robber Rig", rod = "Halcyon Rod", notes = "Bibiki Bay: PI beaches only (South/North/West/East) - not available on BB side.", type = "Fish" },
	{ name = "Shining Trout", skill = 37, location = "Carpenters' Landing, East Ronfaure, Ghelsba Outpost, Jugner Forest, Phanauet Channel", bait = "Fly Lure, Minnow, Sinking Minnow", rod = "Halcyon Rod", notes = "Carpenters' Landing: South/North Landing only (not central or inland pools). Ghelsba Outpost: River only (not ponds). Jugner Forest: River only.", type = "Fish" },
	{ name = "Silver Shark", skill = 76, location = "Batallia Downs, Sauromugue Champaign, Sea Serpent Grotto, Ship bound for Mhaura, Ship bound for Mhaura (with Pirates), Ship bound for Selbina, Ship bound for Selbina (with Pirates)", bait = "Meatball", rod = "Halcyon Rod", notes = "Sea Serpent Grotto: Mythril door area only (not Pond Under a Bridge or other areas).", type = "Fish" },
	{ name = "Takitaro", skill = 101, location = "Davoi, Misareaux Coast", bait = "Fly Lure", rod = "Composite Fishing Rod", notes = "Davoi: Basin of a Waterfall only. Misareaux Coast: Cascade Edellaine only.", type = "Fish" },
	{ name = "Tavnazian Goby", skill = 75, location = "Lufaise Meadows, Misareaux Coast", bait = "Minnow", rod = "Halcyon Rod", notes = "Lufaise Meadows: Leremieu Lagoon and Rafeloux River only (not Seaside). Misareaux Coast: Rafeloux River and Cascade Edellaine only (not Seaside).", type = "Fish" },
	{ name = "Three-Eyed Fish", skill = 79, location = "Qufim Island", bait = "Minnow, Slice of Cod", rod = "Composite Fishing Rod", notes = "Qufim Island: Southwest Seaside only (not Northwest or other areas).", type = "Fish" },
	{ name = "Tiger Cod", skill = 29, location = "Batallia Downs, Beaucedine Glacier, Lower Jeuno, Port Jeuno, Qufim Island, Sauromugue Champaign", bait = "Lugworm, Shrimp Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Tiny Goldfish", skill = 20, location = "Al Zahbi", bait = "Ball of Insect Paste, Little Worm, Worm Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Titanic Sawfish", skill = 125, location = "Manaclipper", bait = "Meatball, Slice of Cod", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Titanictus", skill = 101, location = "Manaclipper, Ship bound for Mhaura, Ship bound for Mhaura (with Pirates), Ship bound for Selbina, Ship bound for Selbina (with Pirates)", bait = "Meatball", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Tricolored Carp", skill = 27, location = "Bastok Markets, Davoi, East Ronfaure, Ghelsba Outpost, Giddeus, Gusgen Mines, Jugner Forest, North Gustaberg, Northern San d'Oria, Palborough Mines, Phanauet Channel, Port San d'Oria, The Boyahda Tree, Zeruhn Mines", bait = "Shrimp Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Tricorn", skill = 128, location = "Phanauet Channel", bait = "Fly Lure, Lufaise Fly", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Trilobite", skill = 59, location = "Bibiki Bay, Manaclipper", bait = "Worm Lure", rod = "Halcyon Rod", notes = "Bibiki Bay: PI - South Beach and PI - North Beach only (not West/East Beach and not BB side).", type = "Fish" },
	{ name = "Turnabaligi", skill = 104, location = "Bhaflau Thickets, Wajaom Woodlands", bait = "Shrimp Lure", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Uskumru", skill = 55, location = "Silver Sea route to Al Zahbi, Silver Sea route to Nashmau", bait = "Minnow, Shrimp Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Veydal Wrasse", skill = 35, location = "Open sea route to Al Zahbi, Open sea route to Mhaura", bait = "Slice of Bluetail", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Vongola Clam", skill = 53, location = "Bibiki Bay, Manaclipper", bait = "Ball of Crayfish Paste, Peeled Crayfish", rod = "Halcyon Rod", notes = "Bibiki Bay: PI beaches only (South/North/West/East) - not available on BB side.", type = "Fish" },
	{ name = "Yayinbaligi", skill = 31, location = "Caedarva Mire", bait = "Frog Lure, Minnow, Sinking Minnow, Worm Lure", rod = "Composite Fishing Rod", type = "Fish" },
	{ name = "Yellow Globe", skill = 17, location = "Batallia Downs, Beaucedine Glacier, Buburimu Peninsula, Lower Jeuno, Mhaura, Norg, Open sea route to Al Zahbi, Open sea route to Mhaura, Port Jeuno, Qufim Island, Sauromugue Champaign", bait = "Ball of Crayfish Paste, Sabiki Rig, Worm Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Yilanbaligi", skill = 47, location = "Al Zahbi, Bhaflau Thickets, Mamook, Wajaom Woodlands", bait = "Ball of Sardine Paste, Ball of Trout Paste, Little Worm, Peeled Crayfish, Shell Bug, Sinking Minnow, Worm Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Zafmlug Bass", skill = 43, location = "Bibiki Bay, Cape Teriggan, Manaclipper, Port Bastok, Selbina, South Gustaberg, Valkurm Dunes", bait = "Worm Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Zebra Eel", skill = 71, location = "Den of Rancor", bait = "Shrimp Lure, Slice of Sardine", rod = "Halcyon Rod", notes = "Den of Rancor: Pool E-8 only (not Pool F-11).", type = "Fish" },
	{ name = "Arrowwood Log", skill = 4, location = "Beaucedine Glacier, Buburimu Peninsula, Carpenters' Landing, Davoi, Dragon's Aery, East Ronfaure, Jugner Forest, Kazham, Lufaise Meadows, Misareaux Coast, The Boyahda Tree, The Sanctuary of Zi'Tah, Valkurm Dunes, West Ronfaure, Yhoator Jungle, Yuhtunga Jungle", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Bugbear Mask", skill = 54, location = "Oldton Movalpolos", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Cobalt Jellyfish", skill = 5, location = "Batallia Downs, Bibiki Bay, Cape Teriggan, Den of Rancor, Kazham, Lower Jeuno, Lufaise Meadows, Manaclipper, Misareaux Coast, Norg, Open sea route to Al Zahbi, Open sea route to Mhaura, Port Bastok, Port Jeuno, Sea Serpent Grotto, Selbina, South Gustaberg, Valkurm Dunes", bait = "Ball of Crayfish Paste, Ball of Insect Paste, Ball of Sardine Paste, Ball of Trout Paste, Fly Lure, Frog Lure, Little Worm, Lizard Lure, Lufaise Fly, Lugworm, Meatball, Minnow, Peeled Crayfish, Peeled Lobster, Robber Rig, Rogue Rig, Sabiki Rig, Shell Bug, Shrimp Lure, Sinking Minnow, Slice Of Bluetail, Slice Of Carp, Slice Of Cod, Slice of Sardine, Worm Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Copper ring", skill = 24, location = "Bastok Markets, Bastok Mines, Beaucedine Glacier, Bostaunieux Oubliette, Buburimu Peninsula, Dragon's Aery, East Ronfaure, Eastern Altepa Desert, Fei'Yin, Heavens Tower, Kazham, Lower Jeuno, Mhaura, Norg, Northern San d'Oria, Oldton Movalpolos, Port Jeuno, Qufim Island, Ro'Maeve, Ru'Aun Gardens, Temple of Uggalepih, The Boyahda Tree, The Shrine of Ru'Avitau, Yhoator Jungle, Yuhtunga Jungle", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Coral Fragment", skill = 74, location = "Bibiki Bay, Den of Rancor, Korroloka Tunnel, Labyrinth of Onzozo, Sea Serpent Grotto", bait = "Any", rod = "Any", notes = "Bibiki Bay: PI beaches only (not BB side). Den of Rancor: Pools E-8 and F-11 only (not Misc Water). Sea Serpent Grotto: not in Gold door area or Misc Puddles.", type = "Item" },
	{ name = "Damp Scroll", skill = 20, location = "Sea Serpent Grotto", bait = "Any", rod = "Any", notes = "Sea Serpent Grotto: Pond Under a Bridge only.", type = "Item" },
	{ name = "Denizanasi", skill = 5, location = "Aht Urhgan Whitegate, Mount Zhayolm", bait = "Ball of Crayfish Paste, Ball of Insect Paste, Ball of Sardine Paste, Ball of Trout Paste, Fly Lure, Frog Lure, Little Worm, Lizard Lure, Lufaise Fly, Lugworm, Meatball, Minnow, Peeled Crayfish, Peeled Lobster, Robber Rig, Rogue Rig, Sabiki Rig, Shell Bug, Shrimp Lure, Sinking Minnow, Slice Of Bluetail, Slice Of Carp, Slice Of Cod, Slice of Sardine, Worm Lure", rod = "Halcyon Rod", type = "Fish" },
	{ name = "Fish Scale Shield", skill = 7, location = "Bibiki Bay, Den of Rancor, Qufim Island, Rolanberry Fields", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Gil", skill = 1, location = "Port Windurst", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Hydrogauge", skill = 7, location = "Aht Urhgan Whitegate, Al Zahbi, Nashmau, Silver Sea route to Al Zahbi, Silver Sea route to Nashmau", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Mithra Snare", skill = 30, location = "Valkurm Dunes", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Moblin Mask", skill = 54, location = "Oldton Movalpolos", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Mythril Dagger", skill = 90, location = "Beaucedine Glacier, Dragon's Aery, Port Jeuno", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Mythril Sword", skill = 90, location = "Batallia Downs, Beaucedine Glacier, Bostaunieux Oubliette, Dragon's Aery, Gusgen Mines, Qufim Island, Rolanberry Fields, Sauromugue Champaign", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Norg Shell", skill = 14, location = "Sea Serpent Grotto", bait = "Any", rod = "Any", notes = "Sea Serpent Grotto: Other Seaside, Pond Under a Bridge, and Mythril door area only (not Gold door or Misc Puddles).", type = "Item" },
	{ name = "Pamtam Kelp", skill = 3, location = "Bibiki Bay, Buburimu Peninsula, Den of Rancor, East Sarutabaruta, Kazham, Manaclipper, Mhaura, Norg, Open sea route to Al Zahbi, Open sea route to Mhaura, Port Windurst, Sea Serpent Grotto, West Sarutabaruta", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Ripped cap", skill = 20, location = "Kazham, Port Windurst", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Rusty Bucket", skill = 1, location = "Al Zahbi, Bastok Markets, Bastok Mines, Bhaflau Thickets, Bibiki Bay, Buburimu Peninsula, Carpenters' Landing, Dangruf Wadi, Davoi, Dragon's Aery, East Sarutabaruta, Giddeus, Gusgen Mines, Jugner Forest, Kazham, Korroloka Tunnel, Kuftal Tunnel, La Theine Plateau, Lower Jeuno, Mamook, Manaclipper, Norg, North Gustaberg, Open sea route to Al Zahbi, Open sea route to Mhaura, Ordelle's Caves, Palborough Mines, Phanauet Channel, Port Bastok, Port Jeuno, Port San d'Oria, Rabao, Rolanberry Fields, Sea Serpent Grotto, Selbina, South Gustaberg, Tavnazian Safehold, Valkurm Dunes, Wajaom Woodlands, West Ronfaure, West Sarutabaruta, Windurst Walls, Windurst Waters, Windurst Woods, Yhoator Jungle, Yuhtunga Jungle, Zeruhn Mines", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Rusty Cap", skill = 30, location = "Bibiki Bay, Buburimu Peninsula, Davoi, Den of Rancor, Jugner Forest, Korroloka Tunnel, Kuftal Tunnel, La Theine Plateau, Mhaura, Ordelle's Caves, Pashhow Marshlands, Rabao, Rolanberry Fields, South Gustaberg, Valkurm Dunes, Western Altepa Desert, Yughott Grotto", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Rusty Greatsword", skill = 60, location = "Batallia Downs, Davoi, Den of Rancor, Eastern Altepa Desert, Korroloka Tunnel, Oldton Movalpolos, Sea Serpent Grotto", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Rusty Leggings", skill = 7, location = "Al Zahbi, Arrapago Reef, Aydeewa Subterrane, Bastok Markets, Bastok Mines, Bibiki Bay, Bostaunieux Oubliette, Buburimu Peninsula, Caedarva Mire, Cape Teriggan, Carpenters' Landing, Davoi, Dragon's Aery, East Sarutabaruta, Giddeus, Gusgen Mines, Jugner Forest, Kazham, Korroloka Tunnel, Labyrinth of Onzozo, Lower Delkfutt's Tower, Lower Jeuno, Mamook, Mhaura, Middle Delkfutt's Tower, Nashmau, Norg, North Gustaberg, Northern San d'Oria, Open sea route to Al Zahbi, Open sea route to Mhaura, Ordelle's Caves, Port Bastok, Port Jeuno, Port San d'Oria, Port Windurst, Qufim Island, Rabao, Rolanberry Fields, Sauromugue Champaign, Selbina, South Gustaberg, Talacca Cove, The Boyahda Tree, Upper Delkfutt's Tower, Valkurm Dunes, Wajaom Woodlands, West Ronfaure, West Sarutabaruta, Western Altepa Desert, Windurst Walls, Windurst Waters, Windurst Woods, Yhoator Jungle, Yughott Grotto, Yuhtunga Jungle, Zeruhn Mines", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Rusty Pick", skill = 40, location = "Batallia Downs, Buburimu Peninsula, Davoi, Gusgen Mines, Jugner Forest, Korroloka Tunnel, Oldton Movalpolos, Pashhow Marshlands, Rolanberry Fields, Yughott Grotto", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Rusty Subligar", skill = 5, location = "Aht Urhgan Whitegate, Al Zahbi, Arrapago Reef, Aydeewa Subterrane, Bastok Markets, Bastok Mines, Beaucedine Glacier, Bhaflau Thickets, Bibiki Bay, Bostaunieux Oubliette, Buburimu Peninsula, Den of Rancor, East Sarutabaruta, Gusgen Mines, Heavens Tower, Jugner Forest, Kazham, Korroloka Tunnel, Kuftal Tunnel, Lower Jeuno, Mamook, Mount Zhayolm, Nashmau, Norg, North Gustaberg, Northern San d'Oria, Ordelle's Caves, Port Bastok, Port Jeuno, Port San d'Oria, Port Windurst, Qufim Island, Quicksand Caves, Rolanberry Fields, Sauromugue Champaign, Selbina, Ship bound for Mhaura, Ship bound for Mhaura (with Pirates), Ship bound for Selbina, Ship bound for Selbina (with Pirates), South Gustaberg, Talacca Cove, Valkurm Dunes, Wajaom Woodlands, West Sarutabaruta, Windurst Walls, Windurst Waters, Windurst Woods, Yhoator Jungle, Yuhtunga Jungle, Zeruhn Mines", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Silver Ring", skill = 34, location = "Batallia Downs, Beaucedine Glacier, Buburimu Peninsula, Fei'Yin, Giddeus, Heavens Tower, Jugner Forest, Mhaura, Misareaux Coast, Ordelle's Caves, Pashhow Marshlands, Port Jeuno, Qufim Island, Ro'Maeve, Ru'Aun Gardens, South Gustaberg, The Shrine of Ru'Avitau, Valkurm Dunes, Yhoator Jungle, Yughott Grotto", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Tarutaru Snare", skill = 30, location = "Valkurm Dunes", bait = "Any", rod = "Any", type = "Item" },
	{ name = "Abyssal Pugil", skill = 0, location = "Silver Sea route to Al Zahbi, Silver Sea route to Nashmau", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Acid Grease", skill = 0, location = "Bostaunieux Oubliette", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Aipaloovik [NM]", skill = 0, location = "Phanauet Channel", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Amoebic Nodule", skill = 0, location = "Oldton Movalpolos", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Anautogenous Slug", skill = 0, location = "Aydeewa Subterrane", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Apsaras", skill = 0, location = "Beaucedine Glacier, Bibiki Bay, Lufaise Meadows, The Sanctuary of Zi'Tah, Western Altepa Desert", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Arrapago Leech", skill = 0, location = "Arrapago Reef", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Aydeewa Crab", skill = 0, location = "Aydeewa Subterrane", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Azoth Apsaras", skill = 0, location = "Bhaflau Thickets, Wajaom Woodlands", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Bathybic Kulshedra", skill = 0, location = "Silver Sea route to Al Zahbi, Silver Sea route to Nashmau", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Big Jaw", skill = 0, location = "Phanauet Channel, Rolanberry Fields, Sauromugue Champaign, Sea Serpent Grotto", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Big Leech", skill = 0, location = "Rolanberry Fields", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Bigclaw", skill = 0, location = "Eastern Altepa Desert, The Sanctuary of Zi'Tah, Western Altepa Desert, Yuhtunga Jungle", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Blanched Kraken", skill = 0, location = "Open sea route to Al Zahbi, Open sea route to Mhaura", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Blind Crab", skill = 0, location = "Oldton Movalpolos", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Bloodsucker", skill = 0, location = "Den of Rancor, Temple of Uggalepih, Yuhtunga Jungle", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Bouncing Ball", skill = 0, location = "Temple of Uggalepih, The Boyahda Tree", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Caedarva Marshscum", skill = 0, location = "Caedarva Mire", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Caedarva Pondscum", skill = 0, location = "Caedarva Mire", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Canal Leech", skill = 0, location = "Bostaunieux Oubliette", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Cave Mold", skill = 0, location = "Aydeewa Subterrane", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Cave Pugil", skill = 0, location = "Aydeewa Subterrane", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Cheval Pugil", skill = 0, location = "East Ronfaure", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Chimera Clot", skill = 0, location = "Arrapago Reef", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Clipper", skill = 0, location = "Buburimu Peninsula, Carpenters' Landing, Lufaise Meadows, Misareaux Coast, The Sanctuary of Zi'Tah, Yhoator Jungle", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Coral Crab", skill = 0, location = "Dangruf Wadi, La Theine Plateau, Palborough Mines", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Cutter", skill = 0, location = "Batallia Downs, Eastern Altepa Desert, Oldton Movalpolos, Sauromugue Champaign, Valkurm Dunes", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Cyan Deep Crab", skill = 0, location = "Silver Sea route to Al Zahbi, Silver Sea route to Nashmau", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Cyclopean Conch [NM]", skill = 0, location = "Manaclipper", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Demonic Pugil", skill = 0, location = "Dragon's Aery, The Boyahda Tree", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Devil Manta [NM]", skill = 0, location = "Cape Teriggan, Kuftal Tunnel", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Ferocious Pugil", skill = 0, location = "Davoi, Jugner Forest", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Fighting Pugil", skill = 0, location = "East Ronfaure, East Sarutabaruta, North Gustaberg", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Fishtrap", skill = 0, location = "Carpenters' Landing, Phanauet Channel", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Ghost Crab", skill = 0, location = "Bibiki Bay, Manaclipper, Oldton Movalpolos", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Giant Orobon [NM]", skill = 0, location = "Arrapago Reef, Mount Zhayolm", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Giant Pugil", skill = 0, location = "Fort Ghelsba, Ghelsba Outpost, La Theine Plateau", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Gloop", skill = 0, location = "Davoi", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Greater Pugil", skill = 0, location = "Batallia Downs, Beaucedine Glacier, Bibiki Bay, Carpenters' Landing, Davoi, Eastern Altepa Desert, Gusgen Mines, Korroloka Tunnel, Lufaise Meadows, Manaclipper, Misareaux Coast, Rolanberry Fields, Sauromugue Champaign, The Sanctuary of Zi'Tah, Yhoator Jungle", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Grindylow", skill = 0, location = "Bibiki Bay, Lufaise Meadows, Misareaux Coast", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Gugru Jagil", skill = 0, location = "Open sea route to Al Zahbi, Open sea route to Mhaura", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Gugru Orobon [NM]", skill = 0, location = "Open sea route to Al Zahbi, Open sea route to Mhaura", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Harajnite [NM]", skill = 0, location = "Manaclipper", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Horrid Fluke", skill = 0, location = "Rolanberry Fields", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Huge Leech", skill = 0, location = "Jugner Forest", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Ironshell", skill = 0, location = "Eastern Altepa Desert, Western Altepa Desert, Yuhtunga Jungle", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Kissing Leech", skill = 0, location = "Bhaflau Thickets, Wajaom Woodlands", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Kraken", skill = 0, location = "Batallia Downs, Beaucedine Glacier, Bibiki Bay, Korroloka Tunnel, Manaclipper, Sauromugue Champaign", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Lahama", skill = 0, location = "Arrapago Reef", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Lancet Jagil [NM]", skill = 0, location = "Bibiki Bay", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Land Crab", skill = 0, location = "Dangruf Wadi, North Gustaberg, South Gustaberg, West Ronfaure, West Sarutabaruta", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Land Pugil", skill = 0, location = "Batallia Downs, Fort Ghelsba, Giddeus", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Limicoline Crab", skill = 0, location = "West Ronfaure", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Llamhigyn Y Dwr", skill = 0, location = "Arrapago Reef, Caedarva Mire", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Makara", skill = 0, location = "Eastern Altepa Desert, Yhoator Jungle", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Mamook Crab", skill = 0, location = "Mamook", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Mamook Mush", skill = 0, location = "Mamook", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Mamool Ja Bloodsucker", skill = 0, location = "Mamook", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Mercurial Makara", skill = 0, location = "Bhaflau Thickets, Wajaom Woodlands", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Mine Crab", skill = 0, location = "Palborough Mines", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Mole Crab", skill = 0, location = "South Gustaberg", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Morgawr", skill = 0, location = "Beaucedine Glacier", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Mousse", skill = 0, location = "Bostaunieux Oubliette", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Mud Pugil", skill = 0, location = "East Ronfaure, East Sarutabaruta", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Mugger Crab", skill = 0, location = "West Sarutabaruta", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Mush", skill = 0, location = "Gusgen Mines", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Northern Piranu [NM]", skill = 0, location = "Open sea route to Al Zahbi", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Ocean Crab", skill = 0, location = "Ship bound for Mhaura, Ship bound for Selbina", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Ocean Pugil", skill = 0, location = "Ship bound for Mhaura, Ship bound for Selbina", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Odontotyrannus [NM]", skill = 0, location = "Castle Oztroja", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Oil Spill", skill = 0, location = "Davoi", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Ooze", skill = 0, location = "Gusgen Mines", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Orcish Fodder", skill = 0, location = "Fort Ghelsba", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Orobon [NM]", skill = 0, location = "Silver Sea route to Al Zahbi, Silver Sea route to Nashmau", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Palm Crab", skill = 0, location = "East Sarutabaruta, West Sarutabaruta", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Passage Crab", skill = 0, location = "Open sea route to Al Zahbi, Open sea route to Mhaura, South Gustaberg, West Ronfaure, West Sarutabaruta", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Pirate Pugil", skill = 0, location = "Gusgen Mines, Ship bound for Mhaura, Ship bound for Selbina", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Poison Leech", skill = 0, location = "Ordelle's Caves", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Protozoan", skill = 0, location = "Phanauet Channel", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Puffer Pugil", skill = 0, location = "Buburimu Peninsula, Ghelsba Outpost, Giddeus, La Theine Plateau, Valkurm Dunes", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Puffer Pugil Brigand", skill = 0, location = "Buburimu Peninsula", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Pug Pugil", skill = 0, location = "East Ronfaure, East Sarutabaruta, Fort Ghelsba, Ghelsba Outpost, Giddeus, La Theine Plateau, North Gustaberg", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Pugil", skill = 0, location = "East Ronfaure, Ghelsba Outpost, Giddeus", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Qufim Pugil", skill = 0, location = "Qufim Island", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Rancid Ooze", skill = 0, location = "Ordelle's Caves", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Razorjaw Pugil", skill = 0, location = "Cape Teriggan, Den of Rancor, Western Altepa Desert", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Red Osculator", skill = 0, location = "Bhaflau Thickets, Wajaom Woodlands", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Red Smoocher", skill = 0, location = "Bhaflau Thickets, Wajaom Woodlands", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Rock Crab", skill = 0, location = "Bostaunieux Oubliette, Cape Teriggan, Den of Rancor", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Sand Crab", skill = 0, location = "North Gustaberg, South Gustaberg", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Savanna Crab", skill = 0, location = "East Sarutabaruta, West Sarutabaruta", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Scavenger Crab", skill = 0, location = "Dragon's Aery, Kuftal Tunnel, Manaclipper", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Sea Bishop", skill = 0, location = "Qufim Island", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Sea Pugil", skill = 0, location = "Ship bound for Mhaura, Ship bound for Selbina", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Shoal Pugil", skill = 0, location = "Buburimu Peninsula", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Sicklemoon Crab", skill = 0, location = "Mount Zhayolm", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Snipper", skill = 0, location = "Batallia Downs, Buburimu Peninsula, Carpenters' Landing, East Sarutabaruta, Korroloka Tunnel, Oldton Movalpolos, Palborough Mines, Phanauet Channel, Rolanberry Fields, Sauromugue Champaign", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Southern Piranu [NM]", skill = 0, location = "Open sea route to Mhaura", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Spring Pugil", skill = 0, location = "Jugner Forest", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Stag Crab", skill = 0, location = "Buburimu Peninsula, Jugner Forest, Ordelle's Caves, Palborough Mines, Pashhow Marshlands, Valkurm Dunes", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Stone Crab", skill = 0, location = "North Gustaberg", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Stygian Pugil", skill = 0, location = "Beaucedine Glacier, Cape Teriggan, Dragon's Aery, Kuftal Tunnel, Manaclipper, Sea Serpent Grotto, The Boyahda Tree", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Submarine Nipper", skill = 0, location = "Silver Sea route to Al Zahbi, Silver Sea route to Nashmau", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Suhur Mas", skill = 0, location = "Caedarva Mire, Mamook", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Swamp Leech", skill = 0, location = "Pashhow Marshlands", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Swamp Pugil", skill = 0, location = "Pashhow Marshlands", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Thalassic Pugil", skill = 0, location = "Silver Sea route to Al Zahbi, Silver Sea route to Nashmau", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Thickshell", skill = 0, location = "La Theine Plateau", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Thread Leech", skill = 0, location = "Dangruf Wadi, Jugner Forest, Ordelle's Caves, Pashhow Marshlands", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Tree Crab", skill = 0, location = "West Ronfaure", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Triangle Crab", skill = 0, location = "Carpenters' Landing", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Uggalepih Leech", skill = 0, location = "Temple of Uggalepih", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Vepar", skill = 0, location = "Beaucedine Glacier, Qufim Island, Yhoator Jungle", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Vermivorous Crab", skill = 0, location = "West Ronfaure", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Vozold Clot", skill = 0, location = "Mount Zhayolm", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Vozold Jagil", skill = 0, location = "Mount Zhayolm", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Wadi Leech", skill = 0, location = "Dangruf Wadi", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Wootzshell", skill = 0, location = "Arrapago Reef", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Zazalda Clot", skill = 0, location = "Mount Zhayolm", bait = "Any", rod = "Any", type = "Monster" },
	{ name = "Zazalda Jagil", skill = 0, location = "Mount Zhayolm", bait = "Any", rod = "Any", type = "Monster" },
}
local hookMessages = {
    { message='Something caught the hook!!!', hook='Large Fish', color='|cFF00FF00|', logcolor=204, isItem=false },
    { message='Something caught the hook!', hook='Small Fish', color='|cFF00FF00|', logcolor=204, isItem=false },
    { message='You feel something pulling at your line.', hook='Item', color='|cFFFFFF00|', logcolor=141, isItem=true },
    { message='Something clamps onto your line ferociously!', hook='Monster', color='|cFFFF0000|', logcolor=167, isItem=false },
}

local feelMessages = {
    { message='This strength... You get the sense that you are on the verge of an epic catch!', feel='EPIC!', color='|cFFFF00FF|', logcolor=204 },
    { message='Your keen angler\'s senses tell you that this is the pull of', feel='Great', color='|cFF00FF00|', logcolor=204 },
    { message='You have a good feeling about this one!', feel='Good', color='|cFF00FF00|', logcolor=204 },
    { message='You have a bad feeling about this one.', feel='Bad', color='|cFFFFFF00|', logcolor=141 },
    { message='You have a terrible feeling about this one...', feel='Terrible', color='|cFFFF0000|', logcolor=167 },
    { message='You don\'t know if you have enough skill to reel this one in.', feel='Low Skill', color='|cFF00FFFF|', logcolor=204 },
    { message='You\'re fairly sure you don\'t have enough skill to reel this one in.', feel='Very Low Skill', color='|cFFFFFF00|', logcolor=141 },
    { message='You\'re positive you don\'t have enough skill to reel this one in!', feel='Extremely Low Skill', color='|cFFFF0000|', logcolor=167 },
}

local function getBackgroundColor(alpha)
    return bit.bor(
        bit.lshift(math.floor(alpha * 255), 24),
        Colors.BgDark
    )
end

local function modernButton(label, width, height)
    imgui.PushStyleColor(ImGuiCol_Button, Colors.Primary)
    imgui.PushStyleColor(ImGuiCol_ButtonHovered, Colors.PrimaryLight)
    imgui.PushStyleColor(ImGuiCol_ButtonActive, Colors.PrimaryDark)
    imgui.PushStyleVar(ImGuiStyleVar_FrameRounding, 4)
    
    local clicked
    if width and height then
        clicked = imgui.Button(label, { width, height })
    else
        clicked = imgui.Button(label)
    end
    
    imgui.PopStyleVar()
    imgui.PopStyleColor(3)
    
    return clicked
end

local function drawColoredText(label, text, color)
    imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
    imgui.TextUnformatted(label)
    imgui.PopStyleColor()
    imgui.SameLine()
    imgui.PushStyleColor(ImGuiCol_Text, color or Colors.TextPrimary)
    imgui.TextUnformatted(text)
    imgui.PopStyleColor()
end

local function drawSection(title)
    imgui.Spacing()
    imgui.PushStyleColor(ImGuiCol_Separator, Colors.Primary)
    imgui.Separator()
    imgui.PopStyleColor()
    imgui.Spacing()
    
    if title then
        imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
        imgui.TextUnformatted(">> " .. title)
        imgui.PopStyleColor()
        imgui.Spacing()
    end
end
local function parseHexColor(hexString)
    hexString = hexString:gsub("^#", ""):gsub("^0x", "")
    if #hexString ~= 8 then
        return nil
    end
    
    local r = tonumber(hexString:sub(1, 2), 16)
    local g = tonumber(hexString:sub(3, 4), 16)
    local b = tonumber(hexString:sub(5, 6), 16)
    local a = tonumber(hexString:sub(7, 8), 16)
    
    if not (r and g and b and a) then
        return nil
    end
    return bit.bor(
        bit.lshift(a, 24),
        bit.lshift(b, 16),
        bit.lshift(g, 8),
        r
    )
end
local function colorToHexString(color)
    local a = bit.band(bit.rshift(color, 24), 0xFF)
    local b = bit.band(bit.rshift(color, 16), 0xFF)
    local g = bit.band(bit.rshift(color, 8), 0xFF)
    local r = bit.band(color, 0xFF)
    
    return string.format("%02X%02X%02X%02X", r, g, b, a)
end
local function getModernColor(originalColor)
    if not originalColor then return Colors.TextPrimary end
    local r = bit.rshift(bit.band(originalColor, 0xFF0000), 16)
    local g = bit.rshift(bit.band(originalColor, 0x00FF00), 8)
    local b = bit.band(originalColor, 0x0000FF)
    if g > 200 and r < 100 and b < 100 then
        return Colors.Good
    end
    if r > 200 and g < 100 and b < 100 then
        return Colors.Terrible
    end
    if r > 200 and g > 200 and b < 100 then
        return Colors.Warning
    end
    if r > 200 and b > 200 then
        return Colors.Large
    end
    if g > 200 and b > 200 and r < 100 then
        return Colors.Accent
    end
    return originalColor
end

local function build_stats_cache(sourceData, cacheData)
    cacheData.totalFish = 0
    cacheData.totalItems = 0
    cacheData.fishList = {}
    cacheData.itemList = {}
    
    for name, count in pairs(sourceData.fishCaught) do
        if sourceData.itemCaught and sourceData.itemCaught[name] then
            cacheData.totalItems = cacheData.totalItems + count
            table.insert(cacheData.itemList, {name = name, count = count})
        else
            cacheData.totalFish = cacheData.totalFish + count
            table.insert(cacheData.fishList, {name = name, count = count})
        end
    end
    
    table.sort(cacheData.fishList, function(a, b) return a.count > b.count end)
    table.sort(cacheData.itemList, function(a, b) return a.count > b.count end)
    
    cacheData.baitList = {}
    for bait, count in pairs(sourceData.baitUsed) do
        table.insert(cacheData.baitList, {name = bait, count = count})
    end
    table.sort(cacheData.baitList, function(a, b) return a.count > b.count end)
end

local function build_filter_options()
    if not filterOptionsCache.dirty then return end
    
    filterOptionsCache.baits = {"All"}
    filterOptionsCache.locations = {"All"}
    local baitSet = {}
    local locationSet = {}
    
    for _, fish in ipairs(fishingGuide) do
        for bait in fish.bait:gmatch("[^,]+") do
            bait = bait:match("^%s*(.-)%s*$")
            if not baitSet[bait] then
                baitSet[bait] = true
                table.insert(filterOptionsCache.baits, bait)
            end
        end
        
        for location in fish.location:gmatch("[^,]+") do
            location = location:match("^%s*(.-)%s*$")
            if not locationSet[location] then
                locationSet[location] = true
                table.insert(filterOptionsCache.locations, location)
            end
        end
    end
    
    table.sort(filterOptionsCache.baits, function(a, b)
        if a == "All" then return true end
        if b == "All" then return false end
        return a < b
    end)
    
    table.sort(filterOptionsCache.locations, function(a, b)
        if a == "All" then return true end
        if b == "All" then return false end
        return a < b
    end)
    
    filterOptionsCache.dirty = false
end

local function build_guide_filter_options()
    if not guideFilterOptionsCache.dirty then return end
    
    guideFilterOptionsCache.baits = {"All"}
    guideFilterOptionsCache.locations = {"All"}
    local baitSet = {}
    local locationSet = {}
    
    for _, fish in ipairs(fishingGuide) do
        for bait in fish.bait:gmatch("[^,]+") do
            bait = bait:match("^%s*(.-)%s*$")
            if not baitSet[bait] then
                baitSet[bait] = true
                table.insert(guideFilterOptionsCache.baits, bait)
            end
        end
        
        for location in fish.location:gmatch("[^,]+") do
            location = location:match("^%s*(.-)%s*$")
            if not locationSet[location] then
                locationSet[location] = true
                table.insert(guideFilterOptionsCache.locations, location)
            end
        end
    end
    
    table.sort(guideFilterOptionsCache.baits, function(a, b)
        if a == "All" then return true end
        if b == "All" then return false end
        return a < b
    end)
    
    table.sort(guideFilterOptionsCache.locations, function(a, b)
        if a == "All" then return true end
        if b == "All" then return false end
        return a < b
    end)
    
    guideFilterOptionsCache.dirty = false
end

local function render_combo(id, options, currentSelection, onSelectCallback)
    if imgui.BeginCombo(id, currentSelection) then
        for _, option in ipairs(options) do
            local isSelected = (option == currentSelection)
            if imgui.Selectable(option, isSelected) then
                onSelectCallback(option)
            end
            if isSelected then
                imgui.SetItemDefaultFocus()
            end
        end
        imgui.EndCombo()
    end
end

local function reset_guide_filters()
    guideFilters.bait = "All"
    guideFilters.location = "All"
    guideFilters.skillRange = "All"
    guideFilters.catchType = "All"
    guideFilters.showUncaught = true
end

local function invalidate_guide_cache()
    guideFilterCache.lastBait = ""
    guideFilterCache.lastLocation = ""
    guideFilterCache.lastSkillRange = ""
    guideFilterCache.lastCatchType = ""
    guideFilterCache.lastShowUncaught = not guideFilters.showUncaught
end

local function clean_fish_name(fishname)
    if not fishname then return "" end
    local cleaned = fishname:gsub("[%z\1-\31\127]", "")
    cleaned = cleaned:gsub("!%p?%d+", "")
    cleaned = cleaned:gsub("!%d+", "")
    cleaned = cleaned:gsub("^%s+", "")
    cleaned = cleaned:gsub("%s+$", "")
    cleaned = cleaned:gsub("[!?.]+$", "")
    return cleaned
end
local function normalize_catch_name(name)
    if not name then return "" end
    local n = name:lower()
    n = n:gsub("^pair of%s+", "")
    n = n:gsub("^set of%s+", "")
    n = n:gsub("^bunch of%s+", "")
    n = n:gsub("^piece of%s+", "")
    return n
end

local function get_filtered_guide_enhanced()
    local currentBait = guideFilters.bait
    local currentLocation = guideFilters.location
    local currentSkillRange = guideFilters.skillRange
    local currentCatchType = guideFilters.catchType
    local currentShowUncaught = guideFilters.showUncaught
    
    if guideFilterCache.lastBait == currentBait and
       guideFilterCache.lastLocation == currentLocation and
       guideFilterCache.lastSkillRange == currentSkillRange and
       guideFilterCache.lastCatchType == currentCatchType and
       guideFilterCache.lastShowUncaught == currentShowUncaught then
        return guideFilterCache.filteredList, guideFilterCache.totalFish, guideFilterCache.totalCaught
    end
    
    local filteredList = {}
    local totalFish = #fishingGuide
    local totalCaught = 0
    
    for _, fish in ipairs(fishingGuide) do
        local passesFilter = true
        
        if currentBait ~= "All" then
            if not fish.bait:find(currentBait, 1, true) then
                passesFilter = false
            end
        end
        
        if passesFilter and currentLocation ~= "All" then
            if not fish.location:find(currentLocation, 1, true) then
                passesFilter = false
            end
        end
        
        if passesFilter and currentSkillRange ~= "All" then
            local skill = fish.skill
            local range = currentSkillRange
            
            if range == "0-10" and (skill < 0 or skill > 10) then passesFilter = false
            elseif range == "11-20" and (skill < 11 or skill > 20) then passesFilter = false
            elseif range == "21-30" and (skill < 21 or skill > 30) then passesFilter = false
            elseif range == "31-40" and (skill < 31 or skill > 40) then passesFilter = false
            elseif range == "41-50" and (skill < 41 or skill > 50) then passesFilter = false
            elseif range == "51-60" and (skill < 51 or skill > 60) then passesFilter = false
            elseif range == "61-70" and (skill < 61 or skill > 70) then passesFilter = false
            elseif range == "71-80" and (skill < 71 or skill > 80) then passesFilter = false
            elseif range == "81-90" and (skill < 81 or skill > 90) then passesFilter = false
            elseif range == "91-100" and (skill < 91 or skill > 100) then passesFilter = false
            elseif range == "100+" and skill <= 100 then passesFilter = false
            end
        end
        
        if passesFilter and currentCatchType ~= "All" then
            if fish.type ~= currentCatchType then
                passesFilter = false
            end
        end
        
        if passesFilter then
            local caught = false
            local lowerFishName = normalize_catch_name(fish.name)
            for caughtFish, _ in pairs(data.state.lifetime.fishCaught) do
                if normalize_catch_name(caughtFish) == lowerFishName then
                    caught = true
                    totalCaught = totalCaught + 1
                    break
                end
            end
            
            if currentShowUncaught or caught then
                table.insert(filteredList, {fish = fish, caught = caught})
            end
        end
    end
    
    guideFilterCache.lastBait = currentBait
    guideFilterCache.lastLocation = currentLocation
    guideFilterCache.lastSkillRange = currentSkillRange
    guideFilterCache.lastCatchType = currentCatchType
    guideFilterCache.lastShowUncaught = currentShowUncaught
    guideFilterCache.filteredList = filteredList
    guideFilterCache.totalFish = totalFish
    guideFilterCache.totalCaught = totalCaught
    
    return filteredList, totalFish, totalCaught
end

local function parse_color(colorString)
    if not colorString then return 0xFFFFFFFF end
    local hex = colorString:match("|c(F+%x+)|")
    if not hex then return 0xFFFFFFFF end
    
    local num = tonumber("0x" .. hex)
    if not num then return 0xFFFFFFFF end
    
    local a = bit.band(bit.rshift(num, 24), 0xFF)
    local r = bit.band(bit.rshift(num, 16), 0xFF)
    local g = bit.band(bit.rshift(num, 8), 0xFF)
    local b = bit.band(num, 0xFF)
    
    return bit.bor(
        bit.lshift(a, 24),
        bit.lshift(b, 16),
        bit.lshift(g, 8),
        r
    )
end

local function update_player_name()
    local partyMgr = AshitaCore:GetMemoryManager():GetParty()
    if partyMgr then
        local pname = partyMgr:GetMemberName(0)
        if pname and pname ~= '' then playerName = pname end
    end
end

local function get_fishing_skill()
    local ok, result = pcall(function()
        return AshitaCore:GetMemoryManager():GetPlayer():GetCraftSkill(0):GetSkill()
    end)
    if ok and result then return result end
    return nil
end

local function detect_bait()
    local inv = AshitaCore:GetMemoryManager():GetInventory()
    if not inv then
        state.CurrentBait = 'Unknown'
        state.CurrentBaitType = 'unknown'
        return
    end

    local eitem = inv:GetEquippedItem(3)
    local container, index, item

    if eitem and eitem.Index ~= 0 then
        container = bit.rshift(eitem.Index, 8)
        index = bit.band(eitem.Index, 0xFF)
        item = inv:GetContainerItem(container, index)
    end

    if not item or item.Id == 0 then
        for bag = 0, 5 do
            for slot = 1, 80 do
                local it = inv:GetContainerItem(bag, slot)
                if it and it.Id > 0 and bit.band(it.Flags, 0x04) ~= 0 then
                    local equipSlot = bit.band(bit.rshift(it.Flags, 5), 0x0F)
                    if equipSlot == 3 then
                        item = it
                        break
                    end
                end
            end
            if item then break end
        end
    end

    if not item or item.Id == 0 then
        state.CurrentBait = 'None'
        state.CurrentBaitType = 'none'
        return
    end

    local resItem = AshitaCore:GetResourceManager():GetItemById(item.Id)
    if resItem and resItem.Name and resItem.Name[1] then
        local name = resItem.Name[1]
        state.CurrentBait = name
        state.CurrentBaitType = baitTypes[name] or 'unknown'
    else
        state.CurrentBait = string.format('Unknown (ID %d)', item.Id)
        state.CurrentBaitType = 'unknown'
    end
end

local function detect_rod()
    local inv = AshitaCore:GetMemoryManager():GetInventory()
    if not inv then
        state.CurrentRod = 'Unknown'
        return
    end

    local eitem = inv:GetEquippedItem(2)
    local container, index, item

    if eitem and eitem.Index ~= 0 then
        container = bit.rshift(eitem.Index, 8)
        index = bit.band(eitem.Index, 0xFF)
        item = inv:GetContainerItem(container, index)
    end

    if not item or item.Id == 0 then
        for bag = 0, 5 do
            for slot = 1, 80 do
                local it = inv:GetContainerItem(bag, slot)
                if it and it.Id > 0 and bit.band(it.Flags, 0x04) ~= 0 then
                    local equipSlot = bit.band(bit.rshift(it.Flags, 5), 0x0F)
                    if equipSlot == 2 then
                        item = it
                        break
                    end
                end
            end
            if item then break end
        end
    end

    if not item or item.Id == 0 then
        state.CurrentRod = 'None'
        return
    end

    local resItem = AshitaCore:GetResourceManager():GetItemById(item.Id)
    if resItem and resItem.Name and resItem.Name[1] then
        state.CurrentRod = resItem.Name[1]
    else
        state.CurrentRod = string.format('Unknown (ID %d)', item.Id)
    end
end

-- ============================================================
-- Auto-Update
-- ============================================================
local UPDATE_VERSION_URL = 'https://raw.githubusercontent.com/Astika2/FFXI/main/anglin/anglin.lua'
local UPDATE_FILES = {
    {
        url      = 'https://raw.githubusercontent.com/Astika2/FFXI/main/anglin/anglin.lua',
        path     = string.format('%s\\addons\\anglin\\anglin.lua', AshitaCore:GetInstallPath()),
        label    = 'anglin.lua',
    },
    {
        url      = 'https://raw.githubusercontent.com/Astika2/FFXI/main/anglin/data_manager.lua',
        path     = string.format('%s\\addons\\anglin\\data_manager.lua', AshitaCore:GetInstallPath()),
        label    = 'data_manager.lua',
    },
}

local updateAvailable = false
local latestVersion   = nil

local function echo(msg)
    AshitaCore:GetChatManager():QueueCommand(1, '/echo [Anglin] ' .. msg)
end

local updateMessageDelay = nil  -- os.clock() target time for showing update message

local function check_for_update()
    local ok, body, code = pcall(function()
        return https.request(UPDATE_VERSION_URL .. '?t=' .. os.time())
    end)

    if not ok or code ~= 200 or not body then
        return
    end

    local remote = body:match("addon%.version%s*=%s*'([^']+)'")
    if not remote then
        remote = body:match('addon%.version%s*=%s*"([^"]+)"')
    end

    if not remote then return end
    if not CURRENT_VERSION or CURRENT_VERSION == '' then return end

    latestVersion = remote

    local function parse_ver(v)
        local parts = {}
        for n in v:gmatch('%d+') do
            table.insert(parts, tonumber(n))
        end
        return parts
    end

    local function ver_gt(a, b)
        local pa, pb = parse_ver(a), parse_ver(b)
        for i = 1, math.max(#pa, #pb) do
            local ai = pa[i] or 0
            local bi = pb[i] or 0
            if ai > bi then return true end
            if ai < bi then return false end
        end
        return false
    end

    if ver_gt(remote, CURRENT_VERSION) then
        updateAvailable = true
        updateMessageDelay = os.clock() + 2
    end
end

local function perform_update()
    if not updateAvailable then
        echo('No update available.')
        return
    end

    echo(string.format('Downloading v%s...', latestVersion))

    local allOk = true

    for _, f in ipairs(UPDATE_FILES) do
        local ok, body, code = pcall(function()
            return https.request(f.url .. '?t=' .. os.time())
        end)

        if not ok or code ~= 200 or not body or body == '' then
            echo(string.format('Failed to download %s (HTTP %s). Update aborted.', f.label, tostring(code)))
            allOk = false
            break
        end

        local out = io.open(f.path, 'wb')
        if not out then
            echo(string.format('Cannot write %s. Check file permissions. Update aborted.', f.path))
            allOk = false
            break
        end
        out:write(body)
        out:close()
        echo(string.format('Updated %s.', f.label))
    end

    if allOk then
        echo(string.format(
            'Update to v%s complete! Type: /addon reload anglin',
            latestVersion
        ))
        updateAvailable = false
    end
end

local function reset_fishing_session()
    state.Hook = nil
    state.HookColor = nil
    state.Feel = nil
    state.FeelColor = nil
    state.Fish = nil
    state.CatchCount = 1
    state.BaitBeforeCast = nil
    state.CloseTime = nil
    state.Active = false
    state.IsItem = false
    state.LastFishingStatus = nil
    state.FishingEndTime = nil
    state.AwaitingMonsterName = false
    windowPosSet = false
    
    statsCache.dailyDirty = true
    statsCache.lifetimeDirty = true
end

-- Save/load window position directly to a file in the config folder,
-- completely independent of the settings library.
local function get_pos_file()
    return settings.settings_path() .. 'window_pos.lua'
end

local function save_window_pos()
    local path = get_pos_file()
    local f = io.open(path, 'w')
    if f then
        f:write(string.format('return { x = %d, y = %d }\n', windowPosX, windowPosY))
        f:close()
    end
end

local function load_window_pos()
    local path = get_pos_file()
    local f = io.open(path, 'r')
    if not f then return end
    f:close()
    local ok, result = pcall(dofile, path)
    if ok and type(result) == 'table' then
        windowPosX = result.x or windowPosX
        windowPosY = result.y or windowPosY
    end
end

ashita.events.register('load', 'load_cb', function()
    update_player_name()
    state.Settings = settings.load(defaults)
    state.Font = fonts.new(state.Settings.Font)
    windowPosX = 100
    windowPosY = 100
    load_window_pos()
    if state.Settings.CaughtColor == nil then
        state.Settings.CaughtColor = "FFFFFFFF"
    end
    if state.Settings.UncaughtColor == nil then
        state.Settings.UncaughtColor = "808080FF"
    end
    if state.Settings.ColorTheme then
        if state.Settings.ColorTheme == "Custom" and state.Settings.CustomColors then
            local primary = parseHexColor(state.Settings.CustomColors.Primary)
            local primaryDark = parseHexColor(state.Settings.CustomColors.PrimaryDark)
            local primaryLight = parseHexColor(state.Settings.CustomColors.PrimaryLight)
            
            if primary then Colors.Primary = primary end
            if primaryDark then Colors.PrimaryDark = primaryDark end
            if primaryLight then Colors.PrimaryLight = primaryLight end
        else
            applyColorTheme(state.Settings.ColorTheme)
        end
    end
    if state.Settings.CaughtColor then
        for _, c in ipairs(guideColorOptions) do
            if c.hex:upper() == state.Settings.CaughtColor:upper() then
                Colors.CaughtColor = c.value
                break
            end
        end
    end
    if state.Settings.UncaughtColor then
        for _, c in ipairs(guideColorOptions) do
            if c.hex:upper() == state.Settings.UncaughtColor:upper() then
                Colors.UncaughtColor = c.value
                break
            end
        end
    end

    build_filter_options()
    build_guide_filter_options()
    
    data.set_daily_reset_callback(function()
        statsCache.dailyDirty = true
        AshitaCore:GetChatManager():QueueCommand(1, '/echo [Anglin] Daily stats have been reset (new day in JST)')
    end)

    -- Init data: resolves path, migrates from old location if needed, then loads
    data.init(playerName)
    
    data.check_daily_reset()

    check_for_update()
end)

-- Flush window position into settings on Zone Exit (0x000B).
ashita.events.register('unload', 'unload_cb', function()
    if state.Font then
        state.Font:destroy()
        state.Font = nil
    end
    save_window_pos()
    if state.Settings then
        settings.save()
    end
    data.save_state()
end)

ashita.events.register('text_in', 'anglin_HandleText', function(e)
    if e.injected then return end
    
    if not playerName then
        update_player_name()
    end
    
    local msg = e.message
    local cleanMsg = msg:gsub("|[cC]%x+|", ""):gsub("[%z\1-\31\127]", "")

    for _, entry in ipairs(hookMessages) do
        if cleanMsg:find(entry.message, 1, true) then
            state.Hook = entry.hook
            state.HookColor = getModernColor(parse_color(entry.color))
            state.Active = true
            state.IsItem = entry.isItem
            detect_bait()
            detect_rod()
            state.BaitBeforeCast = state.CurrentBait
            if state.CurrentBait and state.CurrentBait ~= 'None' and state.CurrentBait ~= 'Unknown' then
                data.record_bait_used(state.CurrentBait, 1)
            end
            AnimState.catchFlash = 0
            return
        end
    end

    for _, entry in ipairs(feelMessages) do
        if cleanMsg:find(entry.message, 1, true) then
            state.Feel = entry.feel
            state.FeelColor = getModernColor(parse_color(entry.color))
            return
        end
    end

    if playerName then
        local count, fishName = cleanMsg:match(playerName .. ' caught (%d+) (.+)')
        if count and fishName then
            fishName = fishName:match('^(.-)%s*,?%s*but cannot') or fishName
            fishName = clean_fish_name(fishName)
            state.Fish = fishName
            state.CatchCount = tonumber(count)
            data.record_fish(fishName, state.CatchCount, state.IsItem)
            invalidate_guide_cache()
            AnimState.catchFlash = 1.0
            
            if state.BaitBeforeCast and state.CurrentBaitType and state.CurrentBaitType.consumable then
                data.record_bait_consumed(state.BaitBeforeCast, state.CatchCount)
            end
            
            state.CloseTime = os.clock() + 3.0
            return
        end

        local singleCatch = cleanMsg:match(playerName .. ' caught an? (.+)')
        if singleCatch then
            singleCatch = singleCatch:match('^(.-)%s*,?%s*but cannot') or singleCatch
            local catchName = clean_fish_name(singleCatch)
            if catchName:lower() == 'monster' then
                state.Fish = 'Monster...'
                state.CatchCount = 1
                state.AwaitingMonsterName = true
                AnimState.catchFlash = 1.0
                if state.BaitBeforeCast and state.CurrentBaitType and state.CurrentBaitType.consumable then
                    data.record_bait_consumed(state.BaitBeforeCast, 1)
                end
                state.CloseTime = os.clock() + 8.0
            else
                state.Fish = catchName
                state.CatchCount = 1
                data.record_fish(catchName, 1, state.IsItem)
                invalidate_guide_cache()
                AnimState.catchFlash = 1.0
                if state.BaitBeforeCast and state.CurrentBaitType and state.CurrentBaitType.consumable then
                    data.record_bait_consumed(state.BaitBeforeCast, 1)
                end
                state.CloseTime = os.clock() + 3.0
            end
            return
        end
    end
    if state.AwaitingMonsterName and playerName then
        local monsterName =
            cleanMsg:match('^The (.-)%s+misses%s+' .. playerName) or
            cleanMsg:match('^The (.-)%s+hits%s+' .. playerName) or
            cleanMsg:match('^(.-)%s+uses%s') or
            cleanMsg:match('^(.-)%s+readies%s')

        if monsterName then
            monsterName = monsterName:match('^%s*(.-)%s*$') -- trim
            if monsterName ~= '' then
                state.Fish = monsterName
                state.AwaitingMonsterName = false
                data.record_fish(monsterName, 1, false)
                invalidate_guide_cache()
                state.CloseTime = os.clock() + 3.0
            end
        end
    end

    if cleanMsg:find('line snaps', 1, true) then
        if state.BaitBeforeCast and state.CurrentBaitType then
            if state.CurrentBaitType.consumable then
                data.record_bait_lost(state.BaitBeforeCast, 1)
            else
                data.record_lure_lost(state.BaitBeforeCast)
            end
        end
        reset_fishing_session()
        return
    end

    if cleanMsg:find('rod breaks', 1, true) then
        if state.CurrentRod and state.CurrentRod ~= 'None' and state.CurrentRod ~= 'Unknown' then
            data.record_rod_break(state.CurrentRod)
        end
        reset_fishing_session()
        return
    end

    if cleanMsg:find('You didn\'t catch anything', 1, true) or 
       cleanMsg:find('You give up and reel in your line', 1, true) or
       cleanMsg:find('The fish got away', 1, true) then
        reset_fishing_session()
        return
    end
end)

ashita.events.register('command', 'anglin_command', function(e)
    local args = e.command:args()
    if (#args == 0 or args[1]:lower() ~= '/anglin') then return end
    e.blocked = true

    if (#args == 1) then
        AshitaCore:GetChatManager():QueueCommand(1, '/echo Usage: /anglin stats | /anglin settings | /anglin guide | /anglin update')
        return
    end

    local subcmd = args[2]:lower()
    
    if subcmd == 'stats' then
        showStats = not showStats
        if not state.Settings.SilentToggle then
            AshitaCore:GetChatManager():QueueCommand(1, '/echo Stats window toggled.')
        end
    
    elseif subcmd == 'settings' then
        showSettings = not showSettings
        if not state.Settings.SilentToggle then
            AshitaCore:GetChatManager():QueueCommand(1, '/echo Settings window toggled.')
        end
    
    elseif subcmd == 'guide' then
        showGuide = not showGuide
        if not state.Settings.SilentToggle then
            AshitaCore:GetChatManager():QueueCommand(1, '/echo Fishing guide window toggled.')
        end

    elseif subcmd == 'update' then
        perform_update()

    else
        AshitaCore:GetChatManager():QueueCommand(1,
            string.format('/echo Unknown subcommand: %s', args[2])
        )
    end
end)

ashita.events.register('d3d_present', 'anglin_render', function()
    if updateMessageDelay and os.clock() >= updateMessageDelay then
        echo(string.format(
            'Update available! Current: v%s  Latest: v%s  --  Type /anglin update to install.',
            CURRENT_VERSION, latestVersion
        ))
        updateMessageDelay = nil
    end

    AnimState.hookPulse = (AnimState.hookPulse + 0.05) % (math.pi * 2)
    if AnimState.catchFlash > 0 then
        AnimState.catchFlash = math.max(0, AnimState.catchFlash - 0.02)
    end
    if showGuide then
        build_guide_filter_options()
        
        imgui.PushStyleColor(ImGuiCol_WindowBg, getBackgroundColor(state.Settings.WindowTransparency))
        imgui.PushStyleColor(ImGuiCol_TitleBg, Colors.Primary)
        imgui.PushStyleColor(ImGuiCol_TitleBgActive, Colors.PrimaryDark)
        imgui.PushStyleColor(ImGuiCol_Border, Colors.Primary)
        imgui.PushStyleVar(ImGuiStyleVar_WindowRounding, 8)
        imgui.PushStyleVar(ImGuiStyleVar_WindowPadding, { 16, 16 })
        imgui.PushStyleVar(ImGuiStyleVar_WindowBorderSize, 1)
        
        imgui.SetNextWindowSize({ 800, 700 }, ImGuiCond_FirstUseEver)
        local guideOpen = { showGuide }
        if imgui.Begin("Fishing Guide", guideOpen, ImGuiWindowFlags_NoCollapse) then
            showGuide = guideOpen[1]
            push_font()

            if imgui.BeginTabBar("GuideTabBar") then

                if imgui.BeginTabItem("Guide") then
            
            drawSection("Filters")
            
            imgui.TextUnformatted("Bait:")
            imgui.SameLine()
            imgui.PushItemWidth(200)
            render_combo("##BaitFilter", guideFilterOptionsCache.baits, guideFilters.bait, function(selected)
                guideFilters.bait = selected
            end)
            imgui.PopItemWidth()
            
            imgui.SameLine()
            imgui.Dummy({20, 0})
            imgui.SameLine()
            
            imgui.TextUnformatted("Location:")
            imgui.SameLine()
            imgui.PushItemWidth(200)
            render_combo("##LocationFilter", guideFilterOptionsCache.locations, guideFilters.location, function(selected)
                guideFilters.location = selected
            end)
            imgui.PopItemWidth()
            
            imgui.TextUnformatted("Skill Range:")
            imgui.SameLine()
            imgui.PushItemWidth(200)
            render_combo("##SkillFilter", guideFilterOptionsCache.skillRanges, guideFilters.skillRange, function(selected)
                guideFilters.skillRange = selected
            end)
            imgui.PopItemWidth()
            
            imgui.SameLine()
            imgui.Dummy({20, 0})
            imgui.SameLine()
            
            imgui.TextUnformatted("Type:")
            imgui.SameLine()
            imgui.PushItemWidth(140)
            render_combo("##TypeFilter", guideFilterOptionsCache.catchTypes, guideFilters.catchType, function(selected)
                guideFilters.catchType = selected
            end)
            imgui.PopItemWidth()
            
            imgui.SameLine()
            imgui.Dummy({20, 0})
            imgui.SameLine()
            
            local showUncaught = { guideFilters.showUncaught }
            if imgui.Checkbox("Show Uncaught Fish", showUncaught) then
                guideFilters.showUncaught = showUncaught[1]
            end
            
            if modernButton("Reset Filters", 120, 25) then
                reset_guide_filters()
            end
            
            drawSection()
            
            local filteredList, totalFish, totalCaught = get_filtered_guide_enhanced()
            
            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
            local skillVal = get_fishing_skill()
            local skillStr = skillVal and string.format(" | Skill: %d", skillVal) or ""
            imgui.TextUnformatted(string.format("Showing %d/%d | Total Caught: %d%s",
                #filteredList, totalFish, totalCaught, skillStr))
            imgui.PopStyleColor()
            
            imgui.Spacing()
            
            if imgui.BeginChild("GuideList", { 0, -40 }, true) then
                for _, entry in ipairs(filteredList) do
                    local fish = entry.fish
                    local caught = entry.caught
                    
                    local skillStr = fish.skill > 0 and string.format(" (Skill: %d)", fish.skill) or ""
                    local typeTag = fish.type == "Monster" and " [MOB]" or (fish.type == "Item" and " [ITEM]" or "")
                    local displayName = fish.name .. typeTag .. skillStr
                    if not caught then
                        imgui.PushStyleColor(ImGuiCol_Text, Colors.UncaughtColor)
                    else
                        imgui.PushStyleColor(ImGuiCol_Text, Colors.CaughtColor)
                    end

                    if imgui.CollapsingHeader(displayName) then
                        imgui.Indent()
                        
                        if caught then
                            local catchCount = 0
                            for caughtFish, count in pairs(data.state.lifetime.fishCaught) do
                                if normalize_catch_name(caughtFish) == normalize_catch_name(fish.name) then
                                    catchCount = catchCount + count
                                end
                            end
                            local cr = bit.band(Colors.CaughtColor, 0xFF) / 255
                            local cg = bit.rshift(bit.band(Colors.CaughtColor, 0xFF00), 8) / 255
                            local cb = bit.rshift(bit.band(Colors.CaughtColor, 0xFF0000), 16) / 255
                            local ca = bit.rshift(bit.band(Colors.CaughtColor, 0xFF000000), 24) / 255
                            imgui.TextColored({cr, cg, cb, ca}, string.format("[CAUGHT] %d times", catchCount))
                        else
                            local ur = bit.band(Colors.UncaughtColor, 0xFF) / 255
                            local ug = bit.rshift(bit.band(Colors.UncaughtColor, 0xFF00), 8) / 255
                            local ub = bit.rshift(bit.band(Colors.UncaughtColor, 0xFF0000), 16) / 255
                            local ua = bit.rshift(bit.band(Colors.UncaughtColor, 0xFF000000), 24) / 255
                            imgui.TextColored({ur, ug, ub, ua}, "[NOT CAUGHT]")
                        end
                        
                        imgui.Separator()
                        imgui.TextWrapped(string.format("Location: %s", fish.location))
                        if fish.type ~= "Monster" then
                            imgui.TextWrapped(string.format("Bait/Lure: %s", fish.bait))
                            imgui.TextWrapped(string.format("Rod: %s", fish.rod))
                        end
                        local sp = get_sell_price(fish.name)
                        if sp ~= nil then
                            if sp > 0 then
                                imgui.PushStyleColor(ImGuiCol_Text, Colors.Warning)
                                imgui.TextUnformatted(string.format("Sell Price: %d gil", sp))
                                imgui.PopStyleColor()
                            else
                                imgui.PushStyleColor(ImGuiCol_Text, Colors.TextMuted)
                                imgui.TextUnformatted("Sell Price: No value")
                                imgui.PopStyleColor()
                            end
                        end
                        if fish.notes then
                            imgui.PushStyleColor(ImGuiCol_Text, Colors.Accent)
                            imgui.TextUnformatted("Notes:")
                            imgui.PopStyleColor()
                            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
                            imgui.TextWrapped(fish.notes)
                            imgui.PopStyleColor()
                        end
                        imgui.Unindent()
                        imgui.Spacing()
                    end
                    imgui.PopStyleColor()
                    
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        imgui.PushTextWrapPos(imgui.GetFontSize() * 28)
                        imgui.TextUnformatted(fish.name)
                        imgui.Separator()
                        imgui.TextUnformatted(string.format("Skill: %d", fish.skill))
                        imgui.TextWrapped(string.format("Location: %s", fish.location))
                        if fish.type ~= "Monster" then
                            imgui.TextWrapped(string.format("Bait: %s", fish.bait))
                            imgui.TextUnformatted(string.format("Rod: %s", fish.rod))
                        end
                        if caught then
                            local catchCount = 0
                            local normFishName = normalize_catch_name(fish.name)
                            for caughtFish, count in pairs(data.state.lifetime.fishCaught) do
                                if normalize_catch_name(caughtFish) == normFishName then
                                    catchCount = catchCount + count
                                end
                            end
                            imgui.Separator()
                            imgui.TextColored({0.41, 0.86, 0.49, 1.0}, string.format("Caught: %d times", catchCount))
                        end
                        local hsp = get_sell_price(fish.name)
                        if hsp ~= nil and hsp > 0 then
                            imgui.Separator()
                            imgui.TextUnformatted(string.format("Sell: %d gil", hsp))
                        end
                        if fish.notes then
                            imgui.Separator()
                            imgui.PushStyleColor(ImGuiCol_Text, Colors.Accent)
                            imgui.TextUnformatted("Notes:")
                            imgui.PopStyleColor()
                            imgui.TextWrapped(fish.notes)
                        end
                        imgui.PopTextWrapPos()
                        imgui.EndTooltip()
                    end
                end
                
                if #filteredList == 0 then
                    imgui.PushStyleColor(ImGuiCol_Text, Colors.TextMuted)
                    imgui.TextUnformatted("No fish match the current filters.")
                    imgui.PopStyleColor()
                end
                
                imgui.EndChild()
            end

                    imgui.EndTabItem()
                end -- Guide tab

                if imgui.BeginTabItem("Skillups") then
                    local playerSkill = get_fishing_skill()

                    if not playerSkill then
                        imgui.TextColored({1,0.4,0.4,1}, "Skill data unavailable.")
                    else
                        imgui.PushStyleColor(ImGuiCol_Text, Colors.Accent)
                        imgui.TextUnformatted(string.format("Your Fishing Skill: %d", playerSkill))
                        imgui.PopStyleColor()
                        imgui.PushStyleColor(ImGuiCol_Text, Colors.TextMuted)
                        imgui.TextWrapped("Best targets are fish with skill requirements 5-11 above yours.")
                        imgui.PopStyleColor()
                        imgui.Spacing()
                        imgui.Separator()
                        imgui.Spacing()

                        local skillMin = playerSkill + 5
                        local skillMax = playerSkill + 11
                        local suggestions = {}
                        for _, fish in ipairs(fishingGuide) do
                            if fish.skill > 0 and fish.type == "Fish" and
                               fish.skill >= skillMin and fish.skill <= skillMax then
                                local normName = normalize_catch_name(fish.name)
                                local caught = false
                                for caughtFish, _ in pairs(data.state.lifetime.fishCaught) do
                                    if normalize_catch_name(caughtFish) == normName then
                                        caught = true
                                        break
                                    end
                                end
                                table.insert(suggestions, {
                                    fish = fish,
                                    caught = caught,
                                    gap = fish.skill - playerSkill,
                                })
                            end
                        end
                        table.sort(suggestions, function(a, b)
                            return a.fish.skill < b.fish.skill
                        end)

                        if #suggestions == 0 then
                            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextMuted)
                            imgui.TextWrapped(string.format(
                                "No fish found with skill %d-%d in the database.",
                                skillMin, skillMax))
                            imgui.PopStyleColor()
                        else
                            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
                            imgui.TextUnformatted(string.format(
                                "Ideal range: Skill %d-%d  (%d targets)",
                                skillMin, skillMax, #suggestions))
                            imgui.PopStyleColor()
                            imgui.Spacing()

                            if imgui.BeginChild("SkillupList", {0, -40}, false) then
                                for _, entry in ipairs(suggestions) do
                                    local fish = entry.fish
                                    local col = entry.caught and Colors.CaughtColor or Colors.UncaughtColor
                                    imgui.PushStyleColor(ImGuiCol_Text, col)
                                    imgui.TextUnformatted(string.format(
                                        "%-30s  Skill: %d  (+%d)",
                                        fish.name, fish.skill, entry.gap))
                                    imgui.PopStyleColor()

                                    if imgui.IsItemHovered() then
                                        imgui.BeginTooltip()
                                        imgui.PushTextWrapPos(300)
                                        imgui.PushStyleColor(ImGuiCol_Text, Colors.Primary)
                                        imgui.TextUnformatted(fish.name)
                                        imgui.PopStyleColor()
                                        imgui.Separator()
                                        imgui.TextUnformatted(string.format("Skill Required: %d  (+%d from yours)", fish.skill, entry.gap))
                                        imgui.TextWrapped(string.format("Location: %s", fish.location))
                                        imgui.TextWrapped(string.format("Bait/Lure: %s", fish.bait))
                                        imgui.TextWrapped(string.format("Rod: %s", fish.rod))
                                        if entry.caught then
                                            imgui.PushStyleColor(ImGuiCol_Text, Colors.CaughtColor)
                                            imgui.TextUnformatted("[Previously Caught]")
                                            imgui.PopStyleColor()
                                        end
                                        imgui.PopTextWrapPos()
                                        imgui.EndTooltip()
                                    end
                                end
                                imgui.EndChild()
                            end
                        end
                    end
                    imgui.EndTabItem()
                end -- Skillups tab

                imgui.EndTabBar()
            end -- TabBar

            imgui.Spacing()
            if modernButton("Close", -1, 30) then
                showGuide = false
            end
            
            pop_font()
            imgui.End()
        else
            showGuide = false
        end
        
        imgui.PopStyleVar(3)
        imgui.PopStyleColor(4)
    end
    if showStats then
        imgui.PushStyleColor(ImGuiCol_WindowBg, getBackgroundColor(state.Settings.WindowTransparency))
        imgui.PushStyleColor(ImGuiCol_TitleBg, Colors.Primary)
        imgui.PushStyleColor(ImGuiCol_TitleBgActive, Colors.PrimaryDark)
        imgui.PushStyleColor(ImGuiCol_Border, Colors.Primary)
        imgui.PushStyleColor(ImGuiCol_Tab, Colors.BgMedium)
        imgui.PushStyleColor(ImGuiCol_TabHovered, Colors.PrimaryLight)
        imgui.PushStyleColor(ImGuiCol_TabActive, Colors.Primary)
        imgui.PushStyleVar(ImGuiStyleVar_WindowRounding, 8)
        imgui.PushStyleVar(ImGuiStyleVar_WindowPadding, { 16, 16 })
        imgui.PushStyleVar(ImGuiStyleVar_WindowBorderSize, 1)
        imgui.PushStyleVar(ImGuiStyleVar_TabRounding, 4)
        
        imgui.SetNextWindowSize({ 550, 600 }, ImGuiCond_FirstUseEver)
        local statsOpen = { showStats }
        if imgui.Begin("Fishing Statistics", statsOpen, ImGuiWindowFlags_NoCollapse) then
            showStats = statsOpen[1]
            push_font()
            if imgui.BeginTabBar("StatsTabBar") then
                if imgui.BeginTabItem("Daily") then
                    activeStatsTab = "Daily"
                    
                    if statsCache.dailyDirty then
                        build_stats_cache(data.state.daily, statsCache.dailyData)
                        statsCache.dailyDirty = false
                    end
                    
                    local dailyData = statsCache.dailyData
                    
                    local jst_now = os.time() + (9 * 3600)
                    local jst_t = os.date('!*t', jst_now)
                    local jst_time_str = string.format('%02d:%02d:%02d', jst_t.hour, jst_t.min, jst_t.sec)
                    local jst_date_str = data.state.daily.date or os.date('!%Y-%m-%d', jst_now)
                    local secs_until_reset = 86400 - (jst_t.hour * 3600 + jst_t.min * 60 + jst_t.sec)
                    if secs_until_reset == 86400 then secs_until_reset = 0 end
                    local reset_h = math.floor(secs_until_reset / 3600)
                    local reset_m = math.floor((secs_until_reset % 3600) / 60)
                    local reset_s = secs_until_reset % 60
                    local reset_str = string.format('%02d:%02d:%02d', reset_h, reset_m, reset_s)
                    drawColoredText("JST Time:", jst_time_str .. '  ' .. jst_date_str, Colors.Primary)
                    drawColoredText("Day Reset:", reset_str, Colors.Warning)
                    local skillVal = get_fishing_skill()
                    if skillVal then
                        drawColoredText("Fishing Skill:", string.format("%d", skillVal), Colors.Accent)
                    end
                    drawSection()
                    
                    if imgui.CollapsingHeader("Fish Caught", ImGuiTreeNodeFlags_DefaultOpen) then
                        drawColoredText("Total Fish:", tostring(dailyData.totalFish), Colors.Success)
                        local dailyGil = calc_gil_value(data.state.daily)
                        if dailyGil > 0 then
                            drawColoredText("Est. Gil Value:", string.format("%d gil", dailyGil), Colors.Warning)
                        end
                        
                        if #dailyData.fishList > 0 then
                            imgui.Spacing()
                            if imgui.BeginChild("DailyFishList", {0, 150}, true) then
                                for _, entry in ipairs(dailyData.fishList) do
                                    imgui.BulletText(string.format("%s: %d", entry.name, entry.count))
                                end
                                imgui.EndChild()
                            end
                        end
                    end
                    
                    if dailyData.totalItems > 0 then
                        if imgui.CollapsingHeader("Items Caught") then
                            drawColoredText("Total Items:", tostring(dailyData.totalItems), Colors.Item)
                            
                            if #dailyData.itemList > 0 then
                                imgui.Spacing()
                                if imgui.BeginChild("DailyItemList", {0, 100}, true) then
                                    for _, entry in ipairs(dailyData.itemList) do
                                        imgui.BulletText(string.format("%s: %d", entry.name, entry.count))
                                    end
                                    imgui.EndChild()
                                end
                            end
                        end
                    end
                    
                    if imgui.CollapsingHeader("Bait Used") then
                        if #dailyData.baitList > 0 then
                            if imgui.BeginChild("DailyBaitList", {0, 150}, true) then
                                for _, entry in ipairs(dailyData.baitList) do
                                    imgui.BulletText(string.format("%s: %d", entry.name, entry.count))
                                end
                                imgui.EndChild()
                            end
                        else
                            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextMuted)
                            imgui.TextUnformatted("No bait used today")
                            imgui.PopStyleColor()
                        end
                    end
                    
                    imgui.Spacing()
                    if modernButton("Reset Daily Stats", -1, 30) then
                        data.reset_daily_stats()
                        statsCache.dailyDirty = true
                    end
                    
                    imgui.EndTabItem()
                end
                
                if imgui.BeginTabItem("Lifetime") then
                    activeStatsTab = "Lifetime"
                    
                    if statsCache.lifetimeDirty then
                        build_stats_cache(data.state.lifetime, statsCache.lifetimeData)
                        statsCache.lifetimeDirty = false
                    end
                    
                    local lifetimeData = statsCache.lifetimeData

                    local skillVal = get_fishing_skill()
                    if skillVal then
                        drawColoredText("Fishing Skill:", string.format("%d", skillVal), Colors.Accent)
                        drawSection()
                    end

                    if imgui.CollapsingHeader("Fish Caught", ImGuiTreeNodeFlags_DefaultOpen) then
                        drawColoredText("Total Fish:", tostring(lifetimeData.totalFish), Colors.Success)
                        local lifetimeGil = calc_gil_value(data.state.lifetime)
                        if lifetimeGil > 0 then
                            drawColoredText("Est. Gil Value:", string.format("%d gil", lifetimeGil), Colors.Warning)
                        end
                        
                        if #lifetimeData.fishList > 0 then
                            imgui.Spacing()
                            if imgui.BeginChild("LifetimeFishList", {0, 200}, true) then
                                for _, entry in ipairs(lifetimeData.fishList) do
                                    imgui.BulletText(string.format("%s: %d", entry.name, entry.count))
                                end
                                imgui.EndChild()
                            end
                        end
                    end
                    
                    if lifetimeData.totalItems > 0 then
                        if imgui.CollapsingHeader("Items Caught") then
                            drawColoredText("Total Items:", tostring(lifetimeData.totalItems), Colors.Item)
                            
                            if #lifetimeData.itemList > 0 then
                                imgui.Spacing()
                                if imgui.BeginChild("LifetimeItemList", {0, 150}, true) then
                                    for _, entry in ipairs(lifetimeData.itemList) do
                                        imgui.BulletText(string.format("%s: %d", entry.name, entry.count))
                                    end
                                    imgui.EndChild()
                                end
                            end
                        end
                    end
                    
                    if imgui.CollapsingHeader("Bait Used") then
                        if #lifetimeData.baitList > 0 then
                            if imgui.BeginChild("LifetimeBaitList", {0, 200}, true) then
                                for _, entry in ipairs(lifetimeData.baitList) do
                                    imgui.BulletText(string.format("%s: %d", entry.name, entry.count))
                                end
                                imgui.EndChild()
                            end
                        else
                            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextMuted)
                            imgui.TextUnformatted("No bait used")
                            imgui.PopStyleColor()
                        end
                    end
                    
                    imgui.Spacing()
                    if modernButton("Reset Lifetime Stats", -1, 30) then
                        data.reset_lifetime_stats()
                        statsCache.lifetimeDirty = true
                    end
                    
                    imgui.EndTabItem()
                end

                imgui.EndTabBar()
            end
            
            imgui.Spacing()
            if modernButton("Close", -1, 30) then
                showStats = false
            end
            
            pop_font()
            imgui.End()
        else
            showStats = false
        end
        
        imgui.PopStyleVar(4)
        imgui.PopStyleColor(7)
    end
    if showSettings then
        imgui.PushStyleColor(ImGuiCol_WindowBg, getBackgroundColor(0.95))
        imgui.PushStyleColor(ImGuiCol_TitleBg, Colors.Primary)
        imgui.PushStyleColor(ImGuiCol_TitleBgActive, Colors.PrimaryDark)
        imgui.PushStyleColor(ImGuiCol_Border, Colors.Primary)
        imgui.PushStyleVar(ImGuiStyleVar_WindowRounding, 8)
        imgui.PushStyleVar(ImGuiStyleVar_WindowPadding, { 20, 20 })
        imgui.PushStyleVar(ImGuiStyleVar_WindowBorderSize, 1)
        
        imgui.SetNextWindowSize({ 500, 450 }, ImGuiCond_FirstUseEver)
        local settingsOpen = { showSettings }
        if imgui.Begin("Anglin Settings", settingsOpen, ImGuiWindowFlags_NoCollapse) then
            showSettings = settingsOpen[1]
            push_font()
            
            drawSection("Appearance")
            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
            imgui.TextUnformatted("Window Transparency")
            imgui.PopStyleColor()
            
            local transparency = { state.Settings.WindowTransparency }
            imgui.PushStyleColor(ImGuiCol_SliderGrab, Colors.Primary)
            imgui.PushStyleColor(ImGuiCol_SliderGrabActive, Colors.PrimaryDark)
            imgui.PushStyleVar(ImGuiStyleVar_GrabRounding, 4)
            
            if imgui.SliderFloat("##transparency", transparency, 0.0, 1.0, "%.2f") then
                state.Settings.WindowTransparency = transparency[1]
                settings.save()
            end
            
            imgui.PopStyleVar()
            imgui.PopStyleColor(2)
            
            imgui.Spacing()
            drawColoredText("Current:", string.format("%.2f", state.Settings.WindowTransparency), Colors.Primary)
            
            drawSection("Font Scale")
            
            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
            imgui.TextUnformatted("UI Font Scale")
            imgui.PopStyleColor()
            
            local fontScale = { state.Settings.FontScale or 1.15 }
            imgui.PushStyleColor(ImGuiCol_SliderGrab, Colors.Primary)
            imgui.PushStyleColor(ImGuiCol_SliderGrabActive, Colors.PrimaryDark)
            imgui.PushStyleVar(ImGuiStyleVar_GrabRounding, 4)
            
            if imgui.SliderFloat("##fontscale", fontScale, 0.8, 2.0, "%.2f") then
                state.Settings.FontScale = fontScale[1]
                settings.save()
            end
            
            imgui.PopStyleVar()
            imgui.PopStyleColor(2)
            
            imgui.Spacing()
            drawColoredText("Current:", string.format("%.2f", state.Settings.FontScale or 1.15), Colors.Primary)
            
            drawSection("Color Theme")
            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
            imgui.TextUnformatted("Select Theme:")
            imgui.PopStyleColor()
            
            local themeNames = {"Soft Blue", "Ocean Teal", "Purple Dream", "Forest Green", "Sunset Orange", "Cool Gray", "Custom"}
            local currentTheme = state.Settings.ColorTheme or "Soft Blue"
            
            imgui.PushItemWidth(200)
            if imgui.BeginCombo("##ThemeSelector", currentTheme) then
                for _, themeName in ipairs(themeNames) do
                    local isSelected = (themeName == currentTheme)
                    if imgui.Selectable(themeName, isSelected) then
                        state.Settings.ColorTheme = themeName
                        if themeName ~= "Custom" then
                            applyColorTheme(themeName)
                        end
                        settings.save()
                    end
                    if isSelected then
                        imgui.SetItemDefaultFocus()
                    end
                end
                imgui.EndCombo()
            end
            imgui.PopItemWidth()
            if currentTheme == "Custom" then
                imgui.Spacing()
                imgui.Spacing()
                
                imgui.PushStyleColor(ImGuiCol_Text, Colors.Warning)
                imgui.TextWrapped("Custom Color Format: RRGGBBAA (hexadecimal)")
                imgui.TextWrapped("Example: FF0000FF = Red, 00FF00FF = Green, 0000FFFF = Blue")
                imgui.PopStyleColor()
                
                imgui.Spacing()
                if not state.Settings.CustomColors then
                    state.Settings.CustomColors = T{
                        Primary = colorToHexString(Colors.Primary),
                        PrimaryDark = colorToHexString(Colors.PrimaryDark),
                        PrimaryLight = colorToHexString(Colors.PrimaryLight),
                    }
                end
                imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
                imgui.TextUnformatted("Primary Color:")
                imgui.PopStyleColor()
                imgui.SameLine()
                
                local primaryBuf = { state.Settings.CustomColors.Primary }
                imgui.PushItemWidth(150)
                if imgui.InputText("##PrimaryColor", primaryBuf, 9) then
                    state.Settings.CustomColors.Primary = primaryBuf[1]
                    local parsed = parseHexColor(primaryBuf[1])
                    if parsed then
                        Colors.Primary = parsed
                        ColorThemes["Custom"].Primary = parsed
                        settings.save()
                    end
                end
                imgui.PopItemWidth()
                imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
                imgui.TextUnformatted("Primary Dark:")
                imgui.PopStyleColor()
                imgui.SameLine()
                
                local primaryDarkBuf = { state.Settings.CustomColors.PrimaryDark }
                imgui.PushItemWidth(150)
                if imgui.InputText("##PrimaryDark", primaryDarkBuf, 9) then
                    state.Settings.CustomColors.PrimaryDark = primaryDarkBuf[1]
                    local parsed = parseHexColor(primaryDarkBuf[1])
                    if parsed then
                        Colors.PrimaryDark = parsed
                        ColorThemes["Custom"].PrimaryDark = parsed
                        settings.save()
                    end
                end
                imgui.PopItemWidth()
                imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
                imgui.TextUnformatted("Primary Light:")
                imgui.PopStyleColor()
                imgui.SameLine()
                
                local primaryLightBuf = { state.Settings.CustomColors.PrimaryLight }
                imgui.PushItemWidth(150)
                if imgui.InputText("##PrimaryLight", primaryLightBuf, 9) then
                    state.Settings.CustomColors.PrimaryLight = primaryLightBuf[1]
                    local parsed = parseHexColor(primaryLightBuf[1])
                    if parsed then
                        Colors.PrimaryLight = parsed
                        ColorThemes["Custom"].PrimaryLight = parsed
                        settings.save()
                    end
                end
                imgui.PopItemWidth()
                
                imgui.Spacing()
                imgui.PushStyleColor(ImGuiCol_Text, Colors.TextMuted)
                imgui.TextWrapped("Tip: Changes apply instantly as you type valid color codes.")
                imgui.PopStyleColor()
            end
            
            imgui.Spacing()
            imgui.Spacing()
            drawSection("Guide Colors")
            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
            imgui.TextUnformatted("\"Caught\" Color:")
            imgui.PopStyleColor()
            imgui.SameLine()

            local currentCaughtName = guideColorNameFromHex(state.Settings.CaughtColor)
            imgui.PushItemWidth(140)
            if imgui.BeginCombo("##CaughtColorDrop", currentCaughtName) then
                for _, c in ipairs(guideColorOptions) do
                    local isSelected = (c.name == currentCaughtName)
                    local r = bit.band(c.value, 0xFF) / 255
                    local g = bit.rshift(bit.band(c.value, 0xFF00), 8) / 255
                    local b = bit.rshift(bit.band(c.value, 0xFF0000), 16) / 255
                    imgui.PushStyleColor(ImGuiCol_Text, c.value)
                    if imgui.Selectable(c.name, isSelected) then
                        state.Settings.CaughtColor = c.hex
                        Colors.CaughtColor = c.value
                        settings.save()
                    end
                    imgui.PopStyleColor()
                    if isSelected then imgui.SetItemDefaultFocus() end
                end
                imgui.EndCombo()
            end
            imgui.PopItemWidth()
            imgui.SameLine()
            do
                local cr = bit.band(Colors.CaughtColor, 0xFF) / 255
                local cg = bit.rshift(bit.band(Colors.CaughtColor, 0xFF00), 8) / 255
                local cb = bit.rshift(bit.band(Colors.CaughtColor, 0xFF0000), 16) / 255
                imgui.TextColored({cr, cg, cb, 1.0}, "Sample Fish (Skill: 50)")
            end

            imgui.Spacing()
            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
            imgui.TextUnformatted("\"Uncaught\" Color:")
            imgui.PopStyleColor()
            imgui.SameLine()

            local currentUncaughtName = guideColorNameFromHex(state.Settings.UncaughtColor)
            imgui.PushItemWidth(140)
            if imgui.BeginCombo("##UncaughtColorDrop", currentUncaughtName) then
                for _, c in ipairs(guideColorOptions) do
                    local isSelected = (c.name == currentUncaughtName)
                    imgui.PushStyleColor(ImGuiCol_Text, c.value)
                    if imgui.Selectable(c.name, isSelected) then
                        state.Settings.UncaughtColor = c.hex
                        Colors.UncaughtColor = c.value
                        settings.save()
                    end
                    imgui.PopStyleColor()
                    if isSelected then imgui.SetItemDefaultFocus() end
                end
                imgui.EndCombo()
            end
            imgui.PopItemWidth()
            imgui.SameLine()
            do
                local ur = bit.band(Colors.UncaughtColor, 0xFF) / 255
                local ug = bit.rshift(bit.band(Colors.UncaughtColor, 0xFF00), 8) / 255
                local ub = bit.rshift(bit.band(Colors.UncaughtColor, 0xFF0000), 16) / 255
                imgui.TextColored({ur, ug, ub, 1.0}, "Sample Fish (Skill: 50)")
            end

            imgui.Spacing()
            if modernButton("Reset Guide Colors", 160, 26) then
                Colors.CaughtColor   = 0xFFFFFFFF
                Colors.UncaughtColor = 0xFF808080
                state.Settings.CaughtColor   = "FFFFFFFF"
                state.Settings.UncaughtColor = "808080FF"
                settings.save()
            end

            imgui.Spacing()
            imgui.Spacing()

            -- Fishing window position
            drawSection("Fishing Window")
            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
            imgui.TextUnformatted("The fishing popup window can be dragged freely while it is open.")
            imgui.TextUnformatted(string.format("Saved position: X=%.0f, Y=%.0f", windowPosX, windowPosY))
            imgui.PopStyleColor()
            imgui.Spacing()
            if modernButton("Reset Window Position", 180, 26) then
                windowPosX = 100
                windowPosY = 100
                windowPosSet = false
                save_window_pos()
            end

            imgui.Spacing()
            imgui.Spacing()

            -- Silent toggle option
            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
            imgui.TextUnformatted("Chat Messages:")
            imgui.PopStyleColor()
            imgui.Spacing()
            local silentToggle = { state.Settings.SilentToggle }
            if imgui.Checkbox("Suppress window toggle messages", silentToggle) then
                state.Settings.SilentToggle = silentToggle[1]
                settings.save()
            end
            if imgui.IsItemHovered() then
                imgui.SetTooltip("When enabled, '/anglin stats|settings|guide' will not print a confirmation message in chat.")
            end

            imgui.Spacing()
            imgui.Spacing()
            
            if modernButton("Close Settings", 150, 30) then
                showSettings = false
            end
            
            pop_font()
            imgui.End()
        else
            showSettings = false
        end
        
        imgui.PopStyleVar(3)
        imgui.PopStyleColor(4)
	end

    local previewMode = showSettings and not state.Active
    if not state.Active and not previewMode then return end
    local entity = AshitaCore:GetMemoryManager():GetEntity()
    local party = AshitaCore:GetMemoryManager():GetParty()
    
    if not previewMode then
        if entity ~= nil and party ~= nil then
            local player_index = party:GetMemberTargetIndex(0)
            local currentStatus = entity:GetStatus(player_index)
            
            if state.LastFishingStatus == nil then
                state.LastFishingStatus = currentStatus
            elseif state.LastFishingStatus ~= 0 and currentStatus == 0 then
                if state.FishingEndTime == nil then
                    state.FishingEndTime = os.clock() + 0.0
                end
            elseif currentStatus ~= 0 then
                state.FishingEndTime = nil
            end
            
            state.LastFishingStatus = currentStatus
            
            if state.FishingEndTime ~= nil and os.clock() >= state.FishingEndTime then
                reset_fishing_session()
                return
            end
        end

        if state.CloseTime and state.Fish then
            local currentTime = os.clock()
            if currentTime >= state.CloseTime then
                reset_fishing_session()
                return
            end
        end
    end
    imgui.PushStyleColor(ImGuiCol_WindowBg, getBackgroundColor(state.Settings.WindowTransparency))
    imgui.PushStyleColor(ImGuiCol_TitleBg, Colors.Primary)
    imgui.PushStyleColor(ImGuiCol_TitleBgActive, Colors.PrimaryDark)
    imgui.PushStyleColor(ImGuiCol_Border, Colors.Primary)
    imgui.PushStyleVar(ImGuiStyleVar_WindowRounding, 8)
    imgui.PushStyleVar(ImGuiStyleVar_WindowPadding, { 16, 16 })
    imgui.PushStyleVar(ImGuiStyleVar_WindowBorderSize, 1)
    
    if not windowPosSet then
        imgui.SetNextWindowPos({ windowPosX, windowPosY })
        windowPosSet = true
    end

    imgui.SetNextWindowSize({ 340, 0 }, ImGuiCond_Always)
    local anglinOpen = { true }
    imgui.Begin("Anglin", anglinOpen, bit.bor(ImGuiWindowFlags_NoCollapse, ImGuiWindowFlags_AlwaysAutoResize))
    if not anglinOpen[1] then
        reset_fishing_session()
    end

    push_font()
    if previewMode then
        imgui.PushStyleColor(ImGuiCol_Text, Colors.TextMuted)
        imgui.TextUnformatted("[ PREVIEW - drag to reposition ]")
        imgui.PopStyleColor()
        imgui.Spacing()
    end
    if state.Hook then
        local pulseAlpha = 0.7 + math.sin(AnimState.hookPulse) * 0.3
        imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
        imgui.TextUnformatted("Hook:")
        imgui.PopStyleColor()
        imgui.SameLine()
        
        if state.HookColor then
            local r = bit.rshift(bit.band(state.HookColor, 0xFF0000), 16) / 255
            local g = bit.rshift(bit.band(state.HookColor, 0x00FF00), 8) / 255
            local b = bit.band(state.HookColor, 0x0000FF) / 255
            local animColor = bit.bor(
                bit.lshift(math.floor(pulseAlpha * 255), 24),
                bit.lshift(math.floor(r * 255), 16),
                bit.lshift(math.floor(g * 255), 8),
                math.floor(b * 255)
            )
            imgui.PushStyleColor(ImGuiCol_Text, animColor)
        end
        imgui.TextUnformatted(state.Hook)
        if state.HookColor then
            imgui.PopStyleColor()
        end
    else
        drawColoredText("Hook:", "Waiting...", Colors.TextMuted)
    end
    if state.Feel then
        imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
        imgui.TextUnformatted("Feel:")
        imgui.PopStyleColor()
        imgui.SameLine()
        
        if state.FeelColor then
            imgui.PushStyleColor(ImGuiCol_Text, state.FeelColor)
        end
        imgui.TextUnformatted(state.Feel)
        if state.FeelColor then
            imgui.PopStyleColor()
        end
    else
        drawColoredText("Feel:", "Waiting...", Colors.TextMuted)
    end
    if state.Fish then
        local displayFish = clean_fish_name(state.Fish)
        local catchText = displayFish
        
        if state.CatchCount > 1 then
            catchText = string.format("%dx %s", state.CatchCount, displayFish)
        end
        
        if AnimState.catchFlash > 0 then
            local flashIntensity = AnimState.catchFlash
            local flashColor = bit.bor(
                bit.lshift(math.floor(255), 24),
                bit.lshift(math.floor(105 + (150 * flashIntensity)), 16),
                bit.lshift(math.floor(219 + (36 * flashIntensity)), 8),
                math.floor(124)
            )
            drawColoredText("Caught:", catchText, flashColor)
        else
            drawColoredText("Caught:", catchText, Colors.Success)
        end
    else
        drawColoredText("Caught:", "Fishing...", Colors.TextMuted)
    end
    imgui.Spacing()
    imgui.PushStyleColor(ImGuiCol_Separator, Colors.Primary)
    imgui.Separator()
    imgui.PopStyleColor()
    imgui.Spacing()
    drawColoredText("Rod:", state.CurrentRod or "None", Colors.TextPrimary)
    drawColoredText("Bait:", state.CurrentBait or "None", Colors.TextPrimary)
    
    imgui.Spacing()
    imgui.Spacing()
    if previewMode then
        if modernButton("Close Settings", -1, 30) then
            showSettings = false
        end
    else
        if modernButton("Close", -1, 30) then
            reset_fishing_session()
        end
    end

    local posX, posY = imgui.GetWindowPos()
    if posX ~= windowPosX or posY ~= windowPosY then
        windowPosX = posX
        windowPosY = posY
        save_window_pos()
    end

    pop_font()
    imgui.End()
    imgui.PopStyleVar(3)
    imgui.PopStyleColor(4)
end)
ashita.events.register('d3d_present', 'anglin_daily_check', function()
    local currentTime = os.time()
    if currentTime - lastDailyCheck >= 1 then
        lastDailyCheck = currentTime
        data.check_daily_reset()
    end
end)
