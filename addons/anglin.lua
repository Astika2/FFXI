addon.name      = 'anglin'
addon.author    = 'Astika'
addon.version   = '2.3'
addon.desc      = 'Like "Fishaid" plugin, with more insight and tracking'
addon.link      = 'https://github.com/Astika2/FFXI/tree/main/addons'

require('common')
local fonts = require('fonts')
local settings = require('settings')
local imgui = require('imgui')
local data = require('data_manager')
local json = require('json')
local addon = { name = 'Anglin' }
local playerName = nil

-- ================================
-- COLOR PALETTE
-- ================================
local Colors = {
    -- Primary theme colors
    Primary = 0xFFFFB974,        -- Soft Sky Blue
    PrimaryDark = 0xFFD69954,    -- Deeper Blue
    PrimaryLight = 0xFFFFD49F,   -- Light Sky Blue
    
    -- Accent colors
    Accent = 0xFFC0D37D,         -- Soft Teal
    Success = 0xFF7CDB69,        -- Soft Green
    Warning = 0xFF96E5FA,        -- Pale Yellow (very soft)
    Error = 0xFFA29AFF,          -- Soft Pink-Red
    
    -- Text colors
    TextPrimary = 0xFFFFFFFF,
    TextSecondary = 0xBFFFFFFF,
    TextMuted = 0x80FFFFFF,
    
    -- Background colors
    BgDark = 0x1A1A1A,
    BgMedium = 0x2D2D2D,
    BgLight = 0x3A3A3A,
    
    -- Hook/Feel colors
    Legendary = 0xFF7CE8FF,      -- Pale Gold
    Large = 0xFFFAC981,          -- Light Blue
    Small = 0xFFEFD966,          -- Cyan
    Item = 0xFFE7C7B4,           -- Soft Periwinkle
    Monster = 0xFFC88CFF,        -- Soft Pink
    
    -- Feel colors
    Good = 0xFF66CF51,           -- Soft Green
    Bad = 0xFF96E5FA,            -- Pale Yellow
    Terrible = 0xFFA29AFF,       -- Soft Coral
}

-- ================================
-- COLOR THEME PRESETS
-- ================================
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

-- Apply a color theme
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

-- ================================
-- ANIMATION STATE
-- ================================
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
    }
}

local state = {
    Active = false,
    Settings = nil,
    CurrentBait = 'Unknown',
    CurrentBaitType = 'Unknown',
    CurrentRod = 'Unknown',
    
    -- Fishing session tracking
    Hook = nil,
    HookColor = nil,
    Feel = nil,
    FeelColor = nil,
    Fish = nil,
    CatchCount = 1,
    BaitBeforeCast = nil,
    IsItem = false,
    
    -- Auto-close tracking
    CloseTime = nil,
    
    -- Fishing status tracking for auto-close
    LastFishingStatus = nil,
    FishingEndTime = nil,
}

-- Default window position
local windowPosX = 100

-- ================================
-- FONT HELPERS
-- ================================
local function push_font()
    imgui.SetWindowFontScale(state.Settings and state.Settings.FontScale or 1.15)
end

local function pop_font()
    -- SetWindowFontScale resets automatically when the window ends
end
local windowPosY = 100
local windowPosSet = false
local showSettings = false
local showStats = false
local showGuide = false
local activeStatsTab = "Daily"

-- Cache for stats display
local statsCache = {
    dailyDirty = true,
    lifetimeDirty = true,
    dailyData = {},
    lifetimeData = {}
}

-- Stats filtering state
local statsFilters = {
    bait = "All",
    location = "All",
    skillRange = "All",
    showZeroCatch = true,
}

-- Cache for filter options
local filterOptionsCache = {
    baits = {},
    locations = {},
    skillRanges = {
        "All", "0-10", "11-20", "21-30", "31-40", "41-50",
        "51-60", "61-70", "71-80", "81-90", "91-100", "100+"
    },
    dirty = true
}

-- Guide filtering state
local guideFilters = {
    bait = "All",
    location = "All",
    skillRange = "All",
    showUncaught = true,
}

-- Cache for guide filter options
local guideFilterOptionsCache = {
    baits = {},
    locations = {},
    skillRanges = {
        "All", "0-10", "11-20", "21-30", "31-40", "41-50",
        "51-60", "61-70", "71-80", "81-90", "91-100", "100+"
    },
    dirty = true
}

-- Cache for filtered guide results
local guideFilterCache = {
    lastBait = "",
    lastLocation = "",
    lastSkillRange = "",
    lastShowUncaught = true,
    filteredList = {},
    totalFish = 0,
    totalCaught = 0
}

-- Timer for daily reset check
local lastDailyCheck = 0

-- Bait table
local baitTypes = {
    -- Consumable
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
    -- Lures
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

-- Fishing guide data
local fishingGuide = {
	{ name = "Armored Pisces", skill = 108, location = "Oldton Movalpolos", bait = "Frog Lure", rod = "Composite, Lu Shang's" },	
	{ name = "Bastore Bream", skill = 86, location = "Port Windurst, Port Bastok", bait = "Shrimp Lure", rod = "Composite" },	
	{ name = "Bastore Sardine", skill = 9, location = "Any coastal area", bait = "Lugworm, Sabiki Rig", rod = "Halcyon" },	
	{ name = "Bhefhel Marlin", skill = 61, location = "Mhaura/Selbina Ferry", bait = "Slice of Bluetail", rod = "Composite" },	
	{ name = "Bibiki Urchin", skill = 3, location = "Bibiki Bay (Docks), Manaclipper (Purgonorgo Isle)", bait = "Robber Rig, Slice of Bluetail", rod = "Lu Shang's" },	
	{ name = "Bibikibo", skill = 8, location = "Bibiki Bay (Purgonorgo Isle), Manaclipper (Purgonorgo Isle)", bait = "No preference", rod = "Lu Shang's" },	
	{ name = "Black Eel", skill = 47, location = "Zeruhn Mines (river)", bait = "Worm Lure, Trout Ball", rod = "Composite" },	
	{ name = "Black Sole", skill = 96, location = "Qufim Island (Ice Pond), Port Jeuno", bait = "Sinking Minnow, Sliced Cod", rod = "Lu Shang's" },	
	{ name = "Bladefish", skill = 71, location = "S. Gustaberg (sea), E./W. Sarutabaruta (sea)", bait = "Meatball, Slice of Bluetail", rod = "Composite" },	
	{ name = "Blindfish", skill = 28, location = "Oldton Movalpolos", bait = "Insect Ball", rod = "Composite" },	
	{ name = "Bluetail", skill = 55, location = "Qufim Island, W. Sarutabaruta", bait = "Minnow, Sliced Sardine", rod = "Composite", price = 307 },	
	{ name = "Cave Cherax", skill = 110, location = "Kuftal Tunnel, Quicksand Caves (Fountain of Kings)", bait = "Meatball, Rotten Meat", rod = "Lu Shang's" },	
	{ name = "Cheval Salmon", skill = 21, location = "E. Ronfaure (River), Jugner Forest", bait = "Fly Lure", rod = "Halcyon, Hume" },	
	{ name = "Cobalt Jellyfish", skill = 5, location = "Mhaura, Selbina, Qufim Island", bait = "Sabiki Rig, Little Worm", rod = "Halcyon" },	
	{ name = "Cone Calamary", skill = 48, location = "Mhaura/Selbina Ferry, Batallia Downs", bait = "Minnow, Sliced Cod", rod = "Composite", price = 169 },	
	{ name = "Copper Frog", skill = 16, location = "Bastok Mines, Zeruhn Mines, Passhow Marshlands, Eastern Altepa Desert", bait = "Fly Lure", rod = "Halcyon" },	
	{ name = "Coral Butterfly", skill = 40, location = "Kazham", bait = "Worm Lure", rod = "Halcyon" },	
	{ name = "Crayfish", skill = 7, location = "W. Ronfaure (Knightwell), Bastok Mines", bait = "Little Worm, Peeled Crayfish", rod = "Halcyon" },	
	{ name = "Crescent Fish", skill = 69, location = "E. Sarutabaruta (Lake), Dragon's Aery", bait = "Fly Lure, Minnow", rod = "Halcyon" },	
	{ name = "Crystal Bass", skill = 33, location = "Jugner Forest", bait = "Minnow, Sinking Minnow", rod = "Halcyon" },	
	{ name = "Dark Bass", skill = 33, location = "Jugner Forest (Lake), Bastok Markets, The Boyahda Tree, Carpenters' Landing, Davoi (Pond), Giddeus, La Theine Plateau, Lufaise Meadows (Leremieu Lagoon), Misareaux Coast (Cascade Edellaine), Phanauet Channel, Rolanberry Fields (Lake), The Sanctuary of Zi'Tah, West Sarutabaruta (Pond)", bait = "Minnow, Trout Ball", rod = "Halcyon, Composite" },	
	{ name = "Elshimo Frog", skill = 30, location = "Yhoator Jungle", bait = "Fly Lure", rod = "Halcyon, Composite" },	
	{ name = "Elshimo Newt", skill = 60, location = "Yhoator Jungle (pool)", bait = "Frog Lure", rod = "Halcyon" },	
	{ name = "Emperor Fish", skill = 91, location = "Beaucedine Glacier (pond)", bait = "Trout Ball, Peeled Crayfish", rod = "Lu Shang's" },	
	{ name = "Fat Greedie", skill = 24, location = "Selbina", bait = "Peeled Crayfish, Shrimp Lure", rod = "Halcyon" },	
	{ name = "Forest Carp", skill = 20, location = "Yhoator Jungle, Windurst Woods", bait = "Insect Paste, Insect Ball", rod = "Halcyon" },	
	{ name = "Gavial Fish", skill = 81, location = "N. Gustaberg (Drachenfall)", bait = "Frog Lure, Meatball", rod = "Composite, Lu Shang's" },	
	{ name = "Giant Catfish", skill = 31, location = "Zeruhn Mines, Jugner Forest, Bastok Markets, Carpenters' Landing (Central), Davoi (Pond), Giddeus (Pond), La Theine Plateau, Pashhow Marshlands, Phanauet Channel (Emfea Waterway, Newtpool), Rolanberry Fields (Lake), West Ronfaure (Knightwell), West Sarutabaruta (Pond), Western Altepa Desert", bait = "Minnow, Sinking Minnow", rod = "Lu Shang's" },	
	{ name = "Giant Chirai", skill = 110, location = "The Boyahda Tree", bait = "Fly Lure, Lufaise Fly", rod = "Lu Shang's" },	
	{ name = "Giant Donko", skill = 50, location = "Rabao, E. Altepa Desert (oasis)", bait = "Frog Lure, Trout Ball", rod = "Composite" },	
	{ name = "Gigant Squid", skill = 91, location = "Qufim Island (NW Seaside), Beaucedine Glacier (Sea of Shu'meyo)", bait = "Slice of Bluetail", rod = "Lu Shang's" },
	{ name = "Gold Carp", skill = 56, location = "Windurst Waters, E. Sarutabaruta (pond)", bait = "Shrimp Lure, Rogue Rig, Insect Paste, Little Worm", rod = "Halcyon" },	
	{ name = "Gold Lobster", skill = 46, location = "Den of Rancor, E. Sarutabaruta, Sea Serpent Grotto, S. Gustaberg, W. Sarutabaruta", bait = "Sinking Minnow", rod = "Lu Shang's" },	
	{ name = "Greedie", skill = 14, location = "Misareaux Coast, Cape Terrigan, Lufaise Meadows, Selbina, Valkurm Dunes", bait = "Minnow", rod = "Halcyon" },	
	{ name = "Grimmonite", skill = 90, location = "Sea Serpent Grotto", bait = "Shrimp Lure, Crayfish Ball", rod = "Lu Shang's" },	
	{ name = "Gugru Tuna", skill = 41, location = "Mhaura/Selbina Ferry", bait = "Minnow, Shrimp Lure", rod = "Composite" },
	{ name = "Gugrusaurus", skill = 110, location = "Manaclipper (Purgonorgo Isle), Mhaura/Selbina Ferry (Pirates)", bait = "Minnow, Shrimp Lure", rod = "Composite" },
	{ name = "Icefish", skill = 49, location = "Beaucedine Glacier (pond)", bait = "Sabiki Rig", rod = "Halcyon" },	
	{ name = "Jungle Catfish", skill = 80, location = "Yhoator Jungle, Yuhtunga Jungle", bait = "Sinking Minnow, Trout Ball", rod = "Composite" },	
	{ name = "Lik", skill = 110, location = "Lufaise Meadows (Leremieu Lagoon), Phomiuna Aqueducts", bait = "Dwarf Pugil, Minnow, Sinking Minnow", rod = "Lu Shang's" },
	{ name = "Lungfish", skill = 31, location = "Phanauet Channel", bait = "Shrimp Lure", rod = "Halcyon" },
	{ name = "Moat Carp", skill = 11, location = "W. Ronfaure (Knightwell), E. Sarutabaruta (Lake)", bait = "Insect Paste, Little Worm", rod = "Halcyon" },	
	{ name = "Monke-Onke", skill = 51, location = "E. Sarutabaruta (Lake), Giddeus (Spring), Yhoator Jungle (Underground Pool 1), Yuhtunga Jungle (Northeast Pond)", bait = "Shrimp Lure", rod = "Composite" },	
	{ name = "Moorish Idol", skill = 26, location = "Bibiki Bay (Purgonorgo Isle), Manaclipper (All)", bait = "Shrimp Lure, Worm Lure, Peeled Crayfish", rod = "Halcyon" },	
	{ name = "Muddy Siredon", skill = 18, location = "Carpenters' Landing (North)", bait = "Fly Lure, Lufaise Fly", rod = "Halcyon, Composite" },	
	{ name = "Nebimonite", skill = 27, location = "Mhaura/Selbina Ferry", bait = "Shrimp Lure, Crayfish Ball", rod = "Halcyon" },	
	{ name = "Noble Lady", skill = 66, location = "Mhaura/Selbina Ferry", bait = "Minnow, Shrimp Lure", rod = "Composite" },	
	{ name = "Nosteau Herring", skill = 39, location = "Qufim Island (coastal)", bait = "Sardine Ball", rod = "Halcyon" },	
	{ name = "Ogre Eel", skill = 35, location = "S. Gustaberg (sea), E./W. Sarutabaruta (sea)", bait = "Shrimp Lure, Minnow", rod = "Composite" },	
	{ name = "Phanauet Newt", skill = 4, location = "Carpenters' Landing, Phanauet Channel", bait = "Lufaise Fly, Shell Bug", rod = "Halcyon" },	
	{ name = "Pipira", skill = 29, location = "Windurst Waters", bait = "Minnow", rod = "Halcyon" },	
	{ name = "Quus", skill = 19, location = "Bibiki Bay (Purgonorgo Isle), Cape Terrigan, Mhaura/Selbina Ferry, Kazham, Korroloka Tunnel, Lufaise Meadows, Norg, Port Bastok, Port Windurst, Sea Serpent Grotto, Selbina, S. Gustaberg, Valkurm Dunes, W. Sarutabaruta (Sea)", bait = "Sabiki Rig, Robber Rig, Lugworm", rod = "Halcyon" },	
	{ name = "Red Terrapin", skill = 53, location = "W. Ronfaure (Knightwell), Davoi (Pond), Giddeus (Pond), Jugner Forest, La Theine Plateau, Passhow Marshlands, Rolanberry Fields, The Sanctuary of Zi'Tah", bait = "Shell Bug", rod = "Halcyon" },
	{ name = "Ryugu Titan", skill = 100, location = "Mhaura/Selbina Ferry", bait = "Meatball", rod = "Lu Shang's" },	
	{ name = "Sandfish", skill = 50, location = "Rabao, E. Altepa Desert, Korroloka Tunnel, Kuftal Tunnel, W. Altepa Desert", bait = "Worm Lure", rod = "Composite" },	
	{ name = "Sea Zombie", skill = 101, location = "Mhaura/Selbina Ferry (Pirates)", bait = "Meatball, Drill Calamary, Rotten Meat", rod = "Lu Shang's" },	
	{ name = "Shall Shell", skill = 53, location = "Buburimu Peninsula, Bibiki Bay (Purgonorgo Isle)", bait = "Robber Rig, Rogue Rig", rod = "Composite" },	
	{ name = "Shining Trout", skill = 37, location = "E. Ronfaure (River), La Theine Plateau", bait = "Fly Lure, Minnow", rod = "Halcyon" },	
	{ name = "Silver Shark", skill = 76, location = "Mhaura/Selbina Ferry", bait = "Slice of Bluetail", rod = "Lu Shang's" },	
	{ name = "Takitaro", skill = 100, location = "Davoi (Cascade), Misareaux Coast (Cascade Edellaine)", bait = "Fly Lure", rod = "Lu Shang's" },	
	{ name = "Tavnazian Goby", skill = 75, location = "Lufaise Meadows, Misareaux Coast (Cascade Edellaine)", bait = "Minnow, Sinking Minnow", rod = "Halcyon" },
	{ name = "Three-Eyed Fish", skill = 81, location = "Qufim Island (Southeast Shore)", bait = "Minnow, Sliced Cod", rod = "Composite", price = 524 },
	{ name = "Tiger Cod", skill = 29, location = "Qufim Island (coastal), Sauromugue", bait = "Shrimp Lure, Sardine Ball", rod = "Composite" },
	{ name = "Titanic Sawfish", skill = 110, location = "Manaclipper (Maliyakaleya Reef)", bait = "Meatball, Sinking Minnow", rod = "Lu Shang's" },
	{ name = "Titanictus", skill = 104, location = "Mhaura/Selbina Ferry, Manaclipper (Purgonorgo Isle)", bait = "Meatball, Peeled Lobster", rod = "Composite" },
	{ name = "Tricolored Carp", skill = 27, location = "Jugner Forest, Giddeus, Bastok Markets, Bastok Mines, The Boyahda Tree, Davoi, East Ronfaure, Ghelsba Outpost, Gusgen Mines, North Gustaberg, Northern San d'Oria, Palborough Mines, Phanauet Channel, Port San d'Oria, Zeruhn Mines", bait = "Insect Ball, Shrimp Lure", rod = "Halcyon" },	
	{ name = "Tricorn", skill = 110, location = "Phanauet Channel (Newtpool)", bait = "Lufaise Fly, Fly Lure", rod = "Lu Shang's" },
	{ name = "Trilobite", skill = 61, location = "Manaclipper (Dhalmel Rock), Bibiki Bay (Purgonorgo Isle South Inlet)", bait = "Worm Lure", rod = "Composite" },
	{ name = "Vongola Clam", skill = 52, location = "Bibiki Bay (Purgonorgo Isle), Manaclipper (Purgonorgo Isle)", bait = "Robber Rig", rod = "Halcyon" },
	{ name = "Yellow Globe", skill = 17, location = "Mhaura Docks, Selbina", bait = "Sabiki Rig, Crayfish Paste", rod = "Halcyon" },	
	{ name = "Zafmlug Bass", skill = 43, location = "Bibiki Bay, Valkurm Dunes, Selbina, South Gustaberg, Manaclipper (All), Cape Terrigan, Port Bastok", bait = "Minnow", rod = "Lu Shang's" },	
	{ name = "Zebra Eel", skill = 70, location = "Den of Rancor", bait = "Shrimp Lure, Frog Lure", rod = "Composite" },	
}

-- Hook and feel messages
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

-- ================================
-- MODERN UI HELPER FUNCTIONS
-- ================================

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

-- Parse hex color string to ABGR integer
local function parseHexColor(hexString)
    -- Remove any # or 0x prefix
    hexString = hexString:gsub("^#", ""):gsub("^0x", "")
    
    -- Ensure it's 8 characters (RRGGBBAA format from user)
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
    
    -- Convert RGBA to ABGR for ImGui
    return bit.bor(
        bit.lshift(a, 24),
        bit.lshift(b, 16),
        bit.lshift(g, 8),
        r
    )
end

-- Convert ABGR integer to hex string (RRGGBBAA format for user)
local function colorToHexString(color)
    local a = bit.band(bit.rshift(color, 24), 0xFF)
    local b = bit.band(bit.rshift(color, 16), 0xFF)
    local g = bit.band(bit.rshift(color, 8), 0xFF)
    local r = bit.band(color, 0xFF)
    
    return string.format("%02X%02X%02X%02X", r, g, b, a)
end

-- Override game colors with our modern palette
local function getModernColor(originalColor)
    -- Convert the original color to our modern equivalents
    if not originalColor then return Colors.TextPrimary end
    
    -- Check for specific game colors and map to modern palette
    local r = bit.rshift(bit.band(originalColor, 0xFF0000), 16)
    local g = bit.rshift(bit.band(originalColor, 0x00FF00), 8)
    local b = bit.band(originalColor, 0x0000FF)
    
    -- Green (good) -> Soft Green
    if g > 200 and r < 100 and b < 100 then
        return Colors.Good
    end
    
    -- Red (bad/terrible) -> Soft Red
    if r > 200 and g < 100 and b < 100 then
        return Colors.Terrible
    end
    
    -- Yellow/Orange (warning) -> Soft Yellow
    if r > 200 and g > 200 and b < 100 then
        return Colors.Warning
    end
    
    -- Purple/Magenta (epic) -> Soft Purple
    if r > 200 and b > 200 then
        return Colors.Large
    end
    
    -- Cyan (skill) -> Soft Cyan
    if g > 200 and b > 200 and r < 100 then
        return Colors.Accent
    end
    
    -- Default
    return originalColor
end

-- ================================
-- ORIGINAL HELPER FUNCTIONS
-- ================================

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
    guideFilters.showUncaught = true
end

local function invalidate_guide_cache()
    guideFilterCache.lastBait = ""
    guideFilterCache.lastLocation = ""
    guideFilterCache.lastSkillRange = ""
    guideFilterCache.lastShowUncaught = not guideFilters.showUncaught
end

local function get_filtered_guide_enhanced()
    local currentBait = guideFilters.bait
    local currentLocation = guideFilters.location
    local currentSkillRange = guideFilters.skillRange
    local currentShowUncaught = guideFilters.showUncaught
    
    if guideFilterCache.lastBait == currentBait and
       guideFilterCache.lastLocation == currentLocation and
       guideFilterCache.lastSkillRange == currentSkillRange and
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
        
        if passesFilter then
            local caught = false
            local lowerFishName = fish.name:lower()
            for caughtFish, _ in pairs(data.state.lifetime.fishCaught) do
                if caughtFish:lower() == lowerFishName then
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
    guideFilterCache.lastShowUncaught = currentShowUncaught
    guideFilterCache.filteredList = filteredList
    guideFilterCache.totalFish = totalFish
    guideFilterCache.totalCaught = totalCaught
    
    return filteredList, totalFish, totalCaught
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
    windowPosSet = false
    
    statsCache.dailyDirty = true
    statsCache.lifetimeDirty = true
end

-- ================================
-- EVENT HANDLERS
-- ================================

ashita.events.register('load', 'load_cb', function()
    update_player_name()
    state.Settings = settings.load(defaults)
    state.Font = fonts.new(state.Settings.Font)
    
    -- Apply saved color theme
    if state.Settings.ColorTheme then
        if state.Settings.ColorTheme == "Custom" and state.Settings.CustomColors then
            -- Load custom colors
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
    
    build_filter_options()
    build_guide_filter_options()
    
    data.set_daily_reset_callback(function()
        statsCache.dailyDirty = true
        AshitaCore:GetChatManager():QueueCommand(1, '/echo [Anglin] Daily stats have been reset (new day in JST)')
    end)
    
    data.check_daily_reset()
end)

ashita.events.register('unload', 'unload_cb', function()
    if state.Font then
        state.Font:destroy()
        state.Font = nil
    end
    if state.Settings then
        settings.save(state.Settings)
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

        local fishName = cleanMsg:match(playerName .. ' caught an? (.+)')
        if fishName then
            fishName = clean_fish_name(fishName)
            state.Fish = fishName
            state.CatchCount = 1
            data.record_fish(fishName, 1, state.IsItem)
            invalidate_guide_cache()
            AnimState.catchFlash = 1.0
            
            if state.BaitBeforeCast and state.CurrentBaitType and state.CurrentBaitType.consumable then
                data.record_bait_consumed(state.BaitBeforeCast, 1)
            end
            
            state.CloseTime = os.clock() + 3.0
            return
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
        AshitaCore:GetChatManager():QueueCommand(1, '/echo Usage: /anglin stats | /anglin settings | /anglin guide')
        return
    end

    local subcmd = args[2]:lower()
    
    if subcmd == 'stats' then
        showStats = not showStats
        AshitaCore:GetChatManager():QueueCommand(1, '/echo Stats window toggled.')
    
    elseif subcmd == 'settings' then
        showSettings = not showSettings
        AshitaCore:GetChatManager():QueueCommand(1, '/echo Settings window toggled.')
    
    elseif subcmd == 'guide' then
        showGuide = not showGuide
        AshitaCore:GetChatManager():QueueCommand(1, '/echo Fishing guide window toggled.')

    else
        AshitaCore:GetChatManager():QueueCommand(1,
            string.format('/echo Unknown subcommand: %s', args[2])
        )
    end
end)

-- ================================
-- MODERN RENDER FUNCTION
-- ================================

ashita.events.register('d3d_present', 'anglin_render', function()
    -- Update animations
    AnimState.hookPulse = (AnimState.hookPulse + 0.05) % (math.pi * 2)
    if AnimState.catchFlash > 0 then
        AnimState.catchFlash = math.max(0, AnimState.catchFlash - 0.02)
    end
    
    -- Fishing Guide window (modernized)
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
        if imgui.Begin("Fishing Guide", true, ImGuiWindowFlags_NoCollapse) then
            push_font()
            
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
            imgui.TextUnformatted(string.format("Showing %d/%d fish | Total Caught: %d", 
                #filteredList, totalFish, totalCaught))
            imgui.PopStyleColor()
            
            imgui.Spacing()
            
            if imgui.BeginChild("GuideList", { 0, -40 }, true) then
                for _, entry in ipairs(filteredList) do
                    local fish = entry.fish
                    local caught = entry.caught
                    
                    local displayName = string.format("%s (Skill: %d)", fish.name, fish.skill)
                    
                    if not caught then
                        imgui.PushStyleColor(ImGuiCol_Text, 0xFF808080)
                    end
                    
                    if imgui.CollapsingHeader(displayName) then
                        imgui.Indent()
                        
                        if caught then
                            local catchCount = 0
                            for caughtFish, count in pairs(data.state.lifetime.fishCaught) do
                                if caughtFish:lower() == fish.name:lower() then
                                    catchCount = catchCount + count
                                end
                            end
                            imgui.TextColored({0.41, 0.86, 0.49, 1.0}, string.format("[CAUGHT] %d times", catchCount))
                        else
                            imgui.TextColored({1.0, 0.88, 0.4, 1.0}, "[NOT CAUGHT]")
                        end
                        
                        imgui.Separator()
                        imgui.TextWrapped(string.format("Location: %s", fish.location))
                        imgui.TextWrapped(string.format("Bait/Lure: %s", fish.bait))
                        imgui.TextWrapped(string.format("Rod: %s", fish.rod))
                        imgui.Unindent()
                        imgui.Spacing()
                    end
                    
                    if not caught then
                        imgui.PopStyleColor()
                    end
                    
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        imgui.TextUnformatted(fish.name)
                        imgui.Separator()
                        imgui.TextUnformatted(string.format("Skill: %d", fish.skill))
                        imgui.TextUnformatted(string.format("Location: %s", fish.location))
                        imgui.TextUnformatted(string.format("Bait: %s", fish.bait))
                        imgui.TextUnformatted(string.format("Rod: %s", fish.rod))
                        if caught then
                            local catchCount = 0
                            local lowerFishName = fish.name:lower()
                            for caughtFish, count in pairs(data.state.lifetime.fishCaught) do
                                if caughtFish:lower() == lowerFishName then
                                    catchCount = catchCount + count
                                end
                            end
                            imgui.Separator()
                            imgui.TextColored({0.41, 0.86, 0.49, 1.0}, string.format("Caught: %d times", catchCount))
                        end
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
    
    -- Stats window (modernized)
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
        if imgui.Begin("Fishing Statistics", true, ImGuiWindowFlags_NoCollapse) then
            push_font()
            if imgui.BeginTabBar("StatsTabBar") then
                if imgui.BeginTabItem("Daily") then
                    activeStatsTab = "Daily"
                    
                    if statsCache.dailyDirty then
                        build_stats_cache(data.state.daily, statsCache.dailyData)
                        statsCache.dailyDirty = false
                    end
                    
                    local dailyData = statsCache.dailyData
                    
                    drawColoredText("Date (JST):", data.state.daily.date or "Unknown", Colors.Primary)
                    drawSection()
                    
                    if imgui.CollapsingHeader("Fish Caught", ImGuiTreeNodeFlags_DefaultOpen) then
                        drawColoredText("Total Fish:", tostring(dailyData.totalFish), Colors.Success)
                        
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
                    
                    if imgui.CollapsingHeader("Fish Caught", ImGuiTreeNodeFlags_DefaultOpen) then
                        drawColoredText("Total Fish:", tostring(lifetimeData.totalFish), Colors.Success)
                        
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
    
-- Settings window (modernized with color themes)
    if showSettings then
        imgui.PushStyleColor(ImGuiCol_WindowBg, getBackgroundColor(0.95))
        imgui.PushStyleColor(ImGuiCol_TitleBg, Colors.Primary)
        imgui.PushStyleColor(ImGuiCol_TitleBgActive, Colors.PrimaryDark)
        imgui.PushStyleColor(ImGuiCol_Border, Colors.Primary)
        imgui.PushStyleVar(ImGuiStyleVar_WindowRounding, 8)
        imgui.PushStyleVar(ImGuiStyleVar_WindowPadding, { 20, 20 })
        imgui.PushStyleVar(ImGuiStyleVar_WindowBorderSize, 1)
        
        imgui.SetNextWindowSize({ 500, 450 }, ImGuiCond_FirstUseEver)
        if imgui.Begin("Anglin Settings", true, ImGuiWindowFlags_NoCollapse) then
            push_font()
            
            drawSection("Appearance")
            
            -- Transparency Slider
            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
            imgui.TextUnformatted("Window Transparency")
            imgui.PopStyleColor()
            
            local transparency = { state.Settings.WindowTransparency }
            imgui.PushStyleColor(ImGuiCol_SliderGrab, Colors.Primary)
            imgui.PushStyleColor(ImGuiCol_SliderGrabActive, Colors.PrimaryDark)
            imgui.PushStyleVar(ImGuiStyleVar_GrabRounding, 4)
            
            if imgui.SliderFloat("##transparency", transparency, 0.0, 1.0, "%.2f") then
                state.Settings.WindowTransparency = transparency[1]
                settings.save(state.Settings)
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
                settings.save(state.Settings)
            end
            
            imgui.PopStyleVar()
            imgui.PopStyleColor(2)
            
            imgui.Spacing()
            drawColoredText("Current:", string.format("%.2f", state.Settings.FontScale or 1.15), Colors.Primary)
            
            drawSection("Color Theme")
            
            -- Theme selector
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
                        settings.save(state.Settings)
                    end
                    if isSelected then
                        imgui.SetItemDefaultFocus()
                    end
                end
                imgui.EndCombo()
            end
            imgui.PopItemWidth()
            
            -- Custom color inputs (only show if Custom is selected)
            if currentTheme == "Custom" then
                imgui.Spacing()
                imgui.Spacing()
                
                imgui.PushStyleColor(ImGuiCol_Text, Colors.Warning)
                imgui.TextWrapped("Custom Color Format: RRGGBBAA (hexadecimal)")
                imgui.TextWrapped("Example: FF0000FF = Red, 00FF00FF = Green, 0000FFFF = Blue")
                imgui.PopStyleColor()
                
                imgui.Spacing()
                
                -- Ensure CustomColors exists
                if not state.Settings.CustomColors then
                    state.Settings.CustomColors = T{
                        Primary = colorToHexString(Colors.Primary),
                        PrimaryDark = colorToHexString(Colors.PrimaryDark),
                        PrimaryLight = colorToHexString(Colors.PrimaryLight),
                    }
                end
                
                -- Primary Color
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
                        settings.save(state.Settings)
                    end
                end
                imgui.PopItemWidth()
                
                -- Primary Dark Color
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
                        settings.save(state.Settings)
                    end
                end
                imgui.PopItemWidth()
                
                -- Primary Light Color
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
                        settings.save(state.Settings)
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

    if not state.Active then return end

    -- Fishing status check
    local entity = AshitaCore:GetMemoryManager():GetEntity()
    local party = AshitaCore:GetMemoryManager():GetParty()
    
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

    -- Main fishing status window (MODERNIZED!)
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
    imgui.Begin("Anglin", true, bit.bor(ImGuiWindowFlags_NoCollapse, ImGuiWindowFlags_AlwaysAutoResize))

    push_font()

    -- Hook status with animation
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
    
    -- Feel status
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
    
    -- Catch display with flash effect
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
    
    -- Divider
    imgui.Spacing()
    imgui.PushStyleColor(ImGuiCol_Separator, Colors.Primary)
    imgui.Separator()
    imgui.PopStyleColor()
    imgui.Spacing()
    
    -- Equipment info
    drawColoredText("Rod:", state.CurrentRod or "None", Colors.TextPrimary)
    drawColoredText("Bait:", state.CurrentBait or "None", Colors.TextPrimary)
    
    imgui.Spacing()
    imgui.Spacing()

    -- Close button
    if modernButton("Close", -1, 30) then
        reset_fishing_session()
    end

    local posX, posY = imgui.GetWindowPos()
    windowPosX = posX
    windowPosY = posY

    pop_font()
    imgui.End()
    imgui.PopStyleVar(3)
    imgui.PopStyleColor(4)
end)

-- Periodic check for daily reset
ashita.events.register('d3d_present', 'anglin_daily_check', function()
    local currentTime = os.time()
    if currentTime - lastDailyCheck >= 1 then
        lastDailyCheck = currentTime
        data.check_daily_reset()
    end
end)