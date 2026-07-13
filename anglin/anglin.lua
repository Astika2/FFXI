addon.name      = 'anglin'
addon.author    = 'Astika'
addon.version   = '4.0.9'
addon.desc      = 'Like "Fishaid" plugin, with more insight and tracking. Updated for ToAU'
addon.link      = 'https://github.com/Astika2/FFXI/tree/main/addons'

-- Capture before the local `addon` table below shadows the global.
local CURRENT_VERSION = addon.version

require('common')
local timelib = require('ffxi.time')
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
    SkillUpSoundEnabled = true, -- play a sound when fishing skill levels up
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
    SkillUpSoundEnabled = true,
    PlaySkillUpSound = nil, -- assigned once play_skillup_sound is defined
}
-- Plain locals for settings that T{} metatable may silently swallow on write.
-- These are the source of truth; state.Settings is only used for Font/legacy.
local pref_ColorTheme    = "Soft Blue"
local pref_CaughtColor   = "FFFFFFFF"
local pref_UncaughtColor = "808080FF"
local pref_SilentToggle  = false
local pref_Transparency  = 0.92
local pref_FontScale     = 1.15
local pref_CustomColors  = { Primary = "FFB974FF", PrimaryDark = "D69954FF", PrimaryLight = "FFD49FFF" }
local windowPosX = 100
local function push_font()
    imgui.SetWindowFontScale(pref_FontScale)
end

local function pop_font()
end
local windowPosY = 100
local windowPosSet = false
local showSettings = false
local showStats = false
local showGuide = false
local showContest = false

-- Phase durations in seconds (from fishing_contest.lua interval table)
local CONTEST_PHASE_DURATIONS = {
    [0] = 300,        -- Contesting  (5 min)
    [1] = 1500,       -- Opening     (25 min)
    [2] = 1209600,    -- Accepting   (14 days)
    [3] = 1800,       -- Releasing   (30 min)
    [4] = 1206000,    -- Presenting  (~13d 23h)
    [5] = 2100,       -- Hiatus      (35 min)
}
local CONTEST_PHASE_NAMES = {
    [0] = 'Contesting',
    [1] = 'Opening',
    [2] = 'Accepting',
    [3] = 'Releasing',
    [4] = 'Presenting',
    [5] = 'Hiatus',
    [6] = 'Closed',
}
local CONTEST_CRITERIA_NAMES = { [0]='Size (length)', [1]='Weight', [2]='Size + Weight' }
local CONTEST_MEASURE_NAMES  = { [0]='Greatest',      [1]='Smallest' }

-- Cached contest state. Populated by packets 0x34 + 0x5C from Chenon conversation.
-- Saved/loaded from JSON so it persists across sessions.
local contestCache = {
    populated  = false,
    status     = nil,
    fishId     = nil,
    criteria   = nil,
    measure    = nil,
    secsLeft   = nil,   -- seconds remaining in current phase at time of cache
    cachedAt   = nil,   -- os.time() when 0x5C was received
}

-- True while we're waiting for the 0x5C after seeing a 0x34
local contestAwaitingUpdate = false
local contestAwaitTimeout   = 0

local function contest_cache_file()
    if not playerName or playerName == '' then return nil end
    return settings.settings_path() .. playerName .. '-contest.json'
end

local function save_contest_cache()
    if not contestCache.populated then return end
    local path = contest_cache_file()
    if not path then return end
    local t = {
        status   = contestCache.status,
        fishId   = contestCache.fishId,
        criteria = contestCache.criteria,
        measure  = contestCache.measure,
        secsLeft = contestCache.secsLeft,
        cachedAt = contestCache.cachedAt,
    }
    local f = io.open(path, 'w')
    if f then
        f:write(json.encode(t))
        f:close()
    end
end

local function load_contest_cache()
    local path = contest_cache_file()
    if not path then return end
    local f = io.open(path, 'r')
    if not f then return end
    local raw = f:read('*a')
    f:close()
    local ok, t = pcall(json.decode, raw)
    if not ok or type(t) ~= 'table' then return end
    contestCache.populated = true
    contestCache.status    = t.status
    contestCache.fishId    = t.fishId
    contestCache.criteria  = t.criteria
    contestCache.measure   = t.measure
    contestCache.secsLeft  = t.secsLeft
    contestCache.cachedAt  = t.cachedAt
end

-- Compute the projected current phase and time remaining from cached data.
-- Returns: phaseName, secsRemaining, nextPhaseName
-- or nil if cache not populated.
local function get_projected_contest_state()
    if not contestCache.populated then return nil end

    local elapsed  = os.time() - contestCache.cachedAt
    local remaining = (contestCache.secsLeft or 0) - elapsed

    -- Walk forward through phases if we've passed the cached one
    local status = contestCache.status
    while remaining <= 0 and status ~= 6 do
        local dur = CONTEST_PHASE_DURATIONS[status]
        if not dur then break end
        remaining = remaining + dur
        status = (status + 1) % 6
    end

    local nextStatus = (status + 1) % 6
    return
        CONTEST_PHASE_NAMES[status]   or 'Unknown',
        math.max(0, math.floor(remaining)),
        CONTEST_PHASE_NAMES[nextStatus] or 'Unknown',
        status
end

local function format_duration(secs)
    secs = math.max(0, math.floor(secs))
    local d = math.floor(secs / 86400)
    local h = math.floor((secs % 86400) / 3600)
    local m = math.floor((secs % 3600) / 60)
    local s = secs % 60
    if d > 0 then
        return string.format('%dd %dh %dm', d, h, m)
    elseif h > 0 then
        return string.format('%dh %dm', h, m)
    elseif m > 0 then
        return string.format('%dm %ds', m, s)
    else
        return string.format('%ds', s)
    end
end
local activeStatsTab = "Daily"
local activeGuideTab = "Guide"
local guideTabBarId = 0  -- increment to force ImGui to forget tab state

local statsTabNeedsRestore = false
local guideTabNeedsRestore = false  -- unused; kept to avoid errors if prefs reference it
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

FAME9_MULT = 1.025  -- ~2.5% bonus at fame 9 (confirmed on HorizonXI)

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

-- Returns min (fame 1) and max (fame 9) gil totals for a catch
local function calc_gil_value(catchData)
    local minTotal = 0
    local maxTotal = 0
    for name, count in pairs(catchData.fishCaught) do
        local price = get_sell_price(name)
        if price and price > 0 then
            minTotal = minTotal + price * count
            maxTotal = maxTotal + math.floor(price * FAME9_MULT) * count
        end
    end
    return minTotal, maxTotal
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
	{ name = "Gugrusaurus", skill = 140, location = "Manaclipper, Open sea route to Al Zahbi, Open sea route to Mhaura, Ship bound for Mhaura (with Pirates), Ship bound for Selbina (with Pirates)", bait = "Meatball", rod = "Composite Fishing Rod", type = "Fish", keyItem = "Serpent Rumors" },
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
	{ name = "Lik", skill = 140, location = "Lufaise Meadows", bait = "Minnow, Sinking Minnow, Dwarf Pugil", rod = "Composite Fishing Rod", notes = "Lufaise Meadows: Leremieu Lagoon only (not Seaside or river).", type = "Fish", keyItem = "Serpent Rumors" },
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
	{ name = "Tricorn", skill = 128, location = "Phanauet Channel", bait = "Fly Lure, Lufaise Fly", rod = "Composite Fishing Rod", type = "Fish", keyItem = "Frog Fishing" },
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
	{ name = "Cobalt Jellyfish", skill = 5, location = "Batallia Downs, Bibiki Bay, Cape Teriggan, Den of Rancor, Kazham, Lower Jeuno, Lufaise Meadows, Manaclipper, Misareaux Coast, Norg, Open sea route to Al Zahbi, Open sea route to Mhaura, Port Bastok, Port Jeuno, Sea Serpent Grotto, Selbina, South Gustaberg, Valkurm Dunes", bait = "Ball of Crayfish Paste, Ball of Insect Paste, Ball of Sardine Paste, Ball of Trout Paste, Fly Lure, Frog Lure, Little Worm, Lizard Lure, Lufaise Fly, Lugworm, Meatball, Minnow, Peeled Crayfish, Peeled Lobster, Robber Rig, Rogue Rig, Sabiki Rig, Shell Bug, Shrimp Lure, Sinking Minnow, Slice Of Bluetail, Slice Of Carp, Slice Of Cod, Slice of Sardine, Worm Lure", rod = "Halcyon Rod", type = "Item" },
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
    n = n:gsub("%s*%[.-%]%s*$", "") -- strip trailing tags like " [NM]" (guide names include these, actual catch names never do)
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

-- Fish stock restocks at these Vana'diel hours (server-side restock ticks)
local RESTOCK_HOURS = { 0, 4, 6, 7, 17, 18, 20 }

-- Returns the next restock Vana'diel hour and the real-world seconds until it occurs.
-- Each Vana'diel hour = 144 real seconds (a full VDay = 24 VHours = 57.6 real minutes).
local function update_restock_cache()
    local ok, vHour, vMin = pcall(function()
        return timelib.get_game_hours(), timelib.get_game_minutes()
    end)
    if not ok or not vHour then return nil end

    -- Seconds remaining in the current Vana'diel hour
    local secsIntoHour = vMin * 2.4  -- 1 VMinute = 2.4 real seconds
    local secsLeftInHour = 144 - secsIntoHour

    -- Find the next restock hour strictly after the current one
    local nextHour = nil
    for _, h in ipairs(RESTOCK_HOURS) do
        if h > vHour then
            nextHour = h
            break
        end
    end
    -- Wrap to the first restock hour of the next Vana'diel day
    if not nextHour then
        nextHour = RESTOCK_HOURS[1]
    end

    -- Hours between current hour (exclusive) and next restock hour, wrapping at 24
    local hourDiff = nextHour - vHour
    if hourDiff <= 0 then hourDiff = hourDiff + 24 end
    -- We already accounted for the remainder of the current hour above,
    -- so subtract 1 full hour from the diff before converting.
    local fullHoursBetween = hourDiff - 1
    local secsTotal = secsLeftInHour + (fullHoursBetween * 144)

    statsCache.restockHour = nextHour
    statsCache.restockSecs = math.floor(secsTotal)
    statsCache.restockCachedAt = os.time()
end

local function get_fishing_skill()
    local ok, result = pcall(function()
        return AshitaCore:GetMemoryManager():GetPlayer():GetCraftSkill(0):GetSkill()
    end)
    if ok and result then return result end
    return nil
end

-- Ashita's Player interface has no memory value for gear-derived skill bonuses
-- (GetCraftSkill only exposes the raw/base skill), so the only way to detect a
-- Fishing Skill bonus is to scan equipped gear against a list of known items.
-- This list is the complete set of FISH (mod 127) items pulled directly from the
-- server's item_mods.sql dump, so it should be exhaustive for this server.
local FISHING_SKILL_GEAR = {
    ["Fisherman's Tunica"] = 1,
    ["Angler's Tunica"]    = 1,
    ["Fisherman's Gloves"] = 1,
    ["Angler's Gloves"]    = 1,
    ["Fisherman's Hose"]   = 1,
    ["Angler's Hose"]      = 1,
    ["Fisherman's Boots"]  = 1,
    ["Angler's Boots"]     = 1,
    ["Waders"]             = 2,
    ["Fisherman's Smock"]  = 1,
    ["Fisher's Torque"]    = 2,
}

-- Items whose bonus only applies conditionally (per item_latents.sql). Trainee's
-- Spectacles grants Fishing +1, but only while base Fishing skill is under 40.
local FISHING_SKILL_GEAR_CONDITIONAL = {
    ["Trainee's Spectacles"] = { bonus = 1, maxSkill = 40 },
}

-- Key item ID 523 = MOGHANCEMENT_FISHING (Mog Garden active effect), confirmed
-- straight from the server source (src/map/items/item_furnishing.h):
--   MOGHANCEMENT_FISHING      = 523, // Increases your fishing skill by 1
--   MOGHANCEMENT_FISHING_ITEM = 534, // Increases the chances of finding items when fishing
-- CCharEntity::UpdateMoghancement() (charentity.cpp) casts these values straight to
-- KeyItem and adds them via charutils::addKeyItem, so HasKeyItem(523) is correct here.
-- (534 is the item-find variant and does not affect skill -- not used.)
local MOGHANCEMENT_FISHING_KEY_ITEM_ID = 523
local MOGHANCEMENT_FISHING_BONUS = 1

-- NOTE: intentionally global (not local) -- the main render function already sits at
-- LuaJIT's 60-upvalue-per-function ceiling, and adding another local here would push
-- it over that limit and fail to load. Globals don't consume upvalue slots.
function anglin_get_fishing_skill_bonus()
    local ok, result = pcall(function()
        local inv = AshitaCore:GetMemoryManager():GetInventory()
        if not inv then return 0 end

        local baseSkill = get_fishing_skill() or 0
        local total = 0
        for slot = 0, 15 do
            local eitem = inv:GetEquippedItem(slot)
            if eitem and eitem.Index ~= 0 then
                local container = bit.rshift(eitem.Index, 8)
                local index = bit.band(eitem.Index, 0xFF)
                local item = inv:GetContainerItem(container, index)
                if item and item.Id ~= 0 then
                    local resItem = AshitaCore:GetResourceManager():GetItemById(item.Id)
                    if resItem and resItem.Name and resItem.Name[1] then
                        local name = resItem.Name[1]
                        local itemBonus = FISHING_SKILL_GEAR[name]
                        if itemBonus then
                            total = total + itemBonus
                        end
                        local conditional = FISHING_SKILL_GEAR_CONDITIONAL[name]
                        if conditional and baseSkill < conditional.maxSkill then
                            total = total + conditional.bonus
                        end
                    end
                end
            end
        end

        if MOGHANCEMENT_FISHING_KEY_ITEM_ID then
            local player = AshitaCore:GetMemoryManager():GetPlayer()
            if player and player:HasKeyItem(MOGHANCEMENT_FISHING_KEY_ITEM_ID) then
                total = total + MOGHANCEMENT_FISHING_BONUS
            end
        end

        return total
    end)
    if ok and result then return result end
    return 0
end

-- Formats a skill value with its gear bonus, e.g. "100 + 4" (or just "100" with no bonus)
function anglin_format_skill_with_bonus(skillVal)
    local bonus = anglin_get_fishing_skill_bonus()
    if bonus and bonus ~= 0 then
        return string.format("%d + %d", skillVal, bonus)
    end
    return string.format("%d", skillVal)
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
local UPDATE_CHANGELOG_URL = 'https://raw.githubusercontent.com/Astika2/FFXI/main/anglin/CHANGELOG.md'
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

local function parse_ver(v)
    local parts = {}
    for n in v:gmatch('%d+') do table.insert(parts, tonumber(n)) end
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

local function echo(msg)
    AshitaCore:GetChatManager():QueueCommand(1, '/echo [Anglin] ' .. msg)
end

-- ============================================================
-- Fishing Skill-Up Sound Alert
-- ============================================================
-- Uses a custom sounds\skillup.wav next to the addon if the user drops one
-- in, otherwise falls back to a stock Windows chime (no bundled file needed).
local function resolve_skillup_sound()
    local custom = string.format('%s\\addons\\anglin\\sounds\\skillup.wav', AshitaCore:GetInstallPath())
    local f = io.open(custom, 'rb')
    if f then
        f:close()
        return custom
    end
    local winDir = os.getenv('SystemRoot') or os.getenv('WINDIR') or 'C:\\Windows'
    return winDir .. '\\Media\\tada.wav'
end
local SKILLUP_SOUND_FILE = resolve_skillup_sound()
local skillUpLastAlertTime = 0

-- Plays the skill-up chime, respecting the user's preference and a short
-- debounce so a single chat line can't trigger it more than once.
local function play_skillup_sound(force)
    if not force and not state.SkillUpSoundEnabled then return end
    local now = os.clock()
    if not force and (now - skillUpLastAlertTime) < 2.0 then return end
    skillUpLastAlertTime = now
    pcall(ashita.misc.play_sound, SKILLUP_SOUND_FILE)
end
-- Exposed on `state` (already an upvalue everywhere it's needed, including the
-- large render function) so callers don't need play_skillup_sound as a fresh upvalue.
state.PlaySkillUpSound = play_skillup_sound

-- Detects fishing skill-ups by polling the character's own craft-skill memory
-- value directly, rather than matching chat text. This is what actually makes
-- it reliable: chat text (e.g. "X's fishing skill reaches level 42.") can be
-- typed by any player in a visible channel, but this value can only change
-- when *your own* skill genuinely goes up.
local lastKnownFishingSkill = nil
local lastSkillCheckTime = 0
local function check_fishing_skillup()
    local now = os.time()
    if now - lastSkillCheckTime < 1 then return end
    lastSkillCheckTime = now

    local currentSkill = get_fishing_skill()
    if not currentSkill or currentSkill <= 0 then return end

    if lastKnownFishingSkill then
        local delta = currentSkill - lastKnownFishingSkill
        -- Only treat small positive jumps as a real skill-up; large jumps are
        -- more likely a data resync (e.g. zoning) than an actual level gain.
        if delta > 0 and delta <= 10 then
            play_skillup_sound()
        end
    end
    lastKnownFishingSkill = currentSkill
end

local updateMessageDelay  = nil
local changelogMessages   = nil
local changelogDelay      = nil

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

    if ver_gt(remote, CURRENT_VERSION) then
        updateAvailable = true
        updateMessageDelay = os.clock() + 2
    end
end

local function perform_update()
    local ok, body, code = pcall(function()
        return https.request(UPDATE_VERSION_URL .. '?t=' .. os.time())
    end)

    if not ok or code ~= 200 or not body then
        echo('Could not reach GitHub to check for updates.')
        return
    end

    local remote = body:match("addon%.version%s*=%s*'([^']+)'")
    if not remote then
        remote = body:match('addon%.version%s*=%s*"([^"]+)"')
    end

    if not remote then
        echo('Could not determine remote version.')
        return
    end

    latestVersion = remote

    if not ver_gt(remote, CURRENT_VERSION) then
        echo(string.format('Already up to date. (v%s)', CURRENT_VERSION))
        return
    end

    local allOk = true
    local previousVersion = CURRENT_VERSION  -- capture before files are overwritten
    local messages = { string.format('Downloading v%s...', remote) }
    changelogMessages = nil
    changelogDelay    = nil

    for _, f in ipairs(UPDATE_FILES) do
        local fok, fbody, fcode = pcall(function()
            return https.request(f.url .. '?t=' .. os.time())
        end)

        if not fok or fcode ~= 200 or not fbody or fbody == '' then
            table.insert(messages, string.format('Failed to download %s (HTTP %s). Update aborted.', f.label, tostring(fcode)))
            allOk = false
            break
        end

        local out = io.open(f.path, 'wb')
        if not out then
            table.insert(messages, string.format('Cannot write %s. Check file permissions. Update aborted.', f.path))
            allOk = false
            break
        end
        out:write(fbody)
        out:close()
        table.insert(messages, string.format('Updated %s.', f.label))
    end

    if allOk then
        table.insert(messages, string.format('Update to v%s complete! Type: /addon reload anglin', remote))
        updateAvailable = false
        updateMessageDelay = nil
    end

    for _, msg in ipairs(messages) do
        echo(msg)
    end

    if allOk then
        -- Fetch changelog and show all versions newer than what the player had
        local cok, cbody, ccode = pcall(function()
            return https.request(UPDATE_CHANGELOG_URL .. '?t=' .. os.time())
        end)
        if cok and ccode == 200 and cbody then
            -- Parse all sections from changelog
            -- Format: "VERSION X.X.X" header lines, "* note" bullet lines
            local sections = {}
            local currentSection = nil
            for line in cbody:gmatch('[^\r\n]+') do
                local cleanLine = line:gsub('\r', '')
                
                local ver = cleanLine:match('^VERSION%s+([%d%.]+)%s*$')
                if ver then
                    if currentSection then
                        table.insert(sections, currentSection)
                    end
                    currentSection = { version = ver, notes = {} }
                elseif currentSection and cleanLine:match('^%s*%*') then
                    table.insert(currentSection.notes, '  ' .. cleanLine:match('^%s*%*%s*(.+)'))
                end
            end
            if currentSection then
                table.insert(sections, currentSection)
            end

            local collected = {}
            for _, section in ipairs(sections) do
                if ver_gt(section.version, previousVersion) then
                    table.insert(collected, section)
                end
            end

            if #collected > 0 then
                changelogMessages = {}
                table.insert(changelogMessages, string.format("Changes since v%s:", previousVersion))
                for _, section in ipairs(collected) do
                    table.insert(changelogMessages, " ")
                    table.insert(changelogMessages, string.format("  v%s:", section.version))
                    for _, note in ipairs(section.notes) do
                        table.insert(changelogMessages, note)
                    end
                end
                changelogDelay = os.clock() + 0.5
            end
        end
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

-- Save/load all user-facing settings (plus window position) directly to a file,
-- completely independent of the settings library.  The settings library has known
-- issues with boolean false values and nested subtables, so we bypass it entirely
-- for everything the user can change in the Settings UI.
local function get_prefs_file()
    return settings.settings_path() .. 'anglin_prefs.lua'
end

-- Migrate from the old window_pos.lua file if it exists and the new one doesn't.
local function migrate_window_pos()
    local oldPath = settings.settings_path() .. 'window_pos.lua'
    local newPath = get_prefs_file()
    local newF = io.open(newPath, 'r')
    if newF then newF:close(); return end   -- new file already exists, nothing to do
    local oldF = io.open(oldPath, 'r')
    if not oldF then return end             -- nothing to migrate
    oldF:close()
    local ok, result = pcall(dofile, oldPath)
    if ok and type(result) == 'table' then
        windowPosX = result.x or windowPosX
        windowPosY = result.y or windowPosY
    end
end

local function save_prefs()
    if not state.Settings then return end
    local path = get_prefs_file()
    local f = io.open(path, 'w')
    if not f then return end
    -- Serialise every user-facing setting as plain Lua literals so that
    -- no value (including boolean false) can be silently dropped.
    local cc = pref_CustomColors
    f:write('return {\n')
    f:write(string.format('  window_x          = %d,\n',    windowPosX))
    f:write(string.format('  window_y          = %d,\n',    windowPosY))
    f:write(string.format('  WindowTransparency = %.4f,\n', pref_Transparency))
    f:write(string.format('  FontScale          = %.4f,\n', pref_FontScale))
    f:write(string.format('  ColorTheme         = %q,\n',   pref_ColorTheme))
    f:write(string.format('  CaughtColor        = %q,\n',   pref_CaughtColor))
    f:write(string.format('  UncaughtColor      = %q,\n',   pref_UncaughtColor))
    f:write(string.format('  SilentToggle       = %s,\n',   tostring(pref_SilentToggle == true)))
    f:write(string.format('  SkillUpSoundEnabled = %s,\n',  tostring(state.SkillUpSoundEnabled == true)))
    f:write(string.format('  activeStatsTab     = %q,\n',   activeStatsTab))
    f:write('  CustomColors = {\n')
    f:write(string.format('    Primary      = %q,\n', cc.Primary      or 'FFB974FF'))
    f:write(string.format('    PrimaryDark  = %q,\n', cc.PrimaryDark  or 'D69954FF'))
    f:write(string.format('    PrimaryLight = %q,\n', cc.PrimaryLight or 'FFD49FFF'))
    f:write('  },\n')
    f:write('}\n')
    f:close()
end

-- save_window_pos is kept as an alias so the existing call-sites still work.
local function save_window_pos()
    save_prefs()
end

local function load_prefs()
    migrate_window_pos()
    local path = get_prefs_file()
    local fCheck = io.open(path, 'r')
    if not fCheck then return end
    fCheck:close()
    local ok, result = pcall(dofile, path)
    if not (ok and type(result) == 'table') then return end

    windowPosX = result.window_x or windowPosX
    windowPosY = result.window_y or windowPosY

    if result.WindowTransparency ~= nil then
        pref_Transparency = result.WindowTransparency
    end
    if result.FontScale ~= nil then
        pref_FontScale = result.FontScale
    end
    if result.ColorTheme ~= nil then
        pref_ColorTheme = result.ColorTheme
    end
    if result.CaughtColor ~= nil then
        pref_CaughtColor = result.CaughtColor
    end
    if result.UncaughtColor ~= nil then
        pref_UncaughtColor = result.UncaughtColor
    end
    -- boolean: the file writes "true"/"false" as Lua literals, dofile returns them as booleans
    if result.SilentToggle ~= nil then
        pref_SilentToggle = (result.SilentToggle == true)
    end
    if result.SkillUpSoundEnabled ~= nil then
        state.SkillUpSoundEnabled = (result.SkillUpSoundEnabled == true)
    end
    if result.activeStatsTab ~= nil then
        activeStatsTab = result.activeStatsTab
    end
    if type(result.CustomColors) == 'table' then
        if result.CustomColors.Primary      ~= nil then pref_CustomColors.Primary      = result.CustomColors.Primary      end
        if result.CustomColors.PrimaryDark  ~= nil then pref_CustomColors.PrimaryDark  = result.CustomColors.PrimaryDark  end
        if result.CustomColors.PrimaryLight ~= nil then pref_CustomColors.PrimaryLight = result.CustomColors.PrimaryLight end
    end
end

local function apply_prefs()
    if pref_ColorTheme then
        if pref_ColorTheme == "Custom" then
            local primary = parseHexColor(pref_CustomColors.Primary)
            local primaryDark = parseHexColor(pref_CustomColors.PrimaryDark)
            local primaryLight = parseHexColor(pref_CustomColors.PrimaryLight)
            if primary then Colors.Primary = primary end
            if primaryDark then Colors.PrimaryDark = primaryDark end
            if primaryLight then Colors.PrimaryLight = primaryLight end
        else
            applyColorTheme(pref_ColorTheme)
        end
    end
    if pref_CaughtColor then
        for _, c in ipairs(guideColorOptions) do
            if c.hex:upper() == pref_CaughtColor:upper() then
                Colors.CaughtColor = c.value
                break
            end
        end
    end
    if pref_UncaughtColor then
        for _, c in ipairs(guideColorOptions) do
            if c.hex:upper() == pref_UncaughtColor:upper() then
                Colors.UncaughtColor = c.value
                break
            end
        end
    end
end

ashita.events.register('load', 'load_cb', function()
    update_player_name()
    state.Settings = settings.load(defaults)
    state.Font = fonts.new(state.Settings.Font)
    windowPosX = 100
    windowPosY = 100
    -- Register a callback so load_prefs runs again once the character is known
    -- and settings_path() returns the character-specific folder.
    settings.register('settings', 'anglin_prefs_cb', function()
        -- Fire once when character becomes known so settings_path() is correct.
        settings.unregister('settings', 'anglin_prefs_cb')
        load_prefs()
        apply_prefs()
        save_prefs()
        load_contest_cache()
    end)
    -- Also run immediately in case the player is already logged in.
    load_prefs()
    -- Ensure the saved tabs are restored when windows are first opened after load.
    statsTabNeedsRestore = true
    apply_prefs()

    build_filter_options()
    build_guide_filter_options()
    
    data.set_daily_reset_callback(function()
        statsCache.dailyDirty = true
        AshitaCore:GetChatManager():QueueCommand(1, '/echo [Anglin] Daily stats have been reset (new day in JST)')
    end)

    -- Init data: resolves path, migrates from old location if needed, then loads
    data.init(playerName)
    
    data.check_daily_reset()

    -- Always write the prefs file on load so it exists even on first run.
    save_prefs()
end)

ashita.events.register('unload', 'unload_cb', function()
    if state.Font then
        state.Font:destroy()
        state.Font = nil
    end
    save_prefs()
    data.save_state()
end)

ashita.events.register('text_in', 'anglin_HandleText', function(e)
    if e.injected then return end
    
    if not playerName then
        update_player_name()
    end
    
    local msg = e.message
    local cleanMsg = msg:gsub("|[cC]%x+|", ""):gsub("[%z\1-\31\127]", "")

    -- Trigger update check when the server welcome message appears
    if cleanMsg:find('Welcome to HorizonXI', 1, true) then
        check_for_update()
    end

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

-- ============================================================
-- FISHING CONTEST PACKET INTERCEPTOR
-- Packet 0x34 (GP_SERV_COMMAND_EVENTNUM) carries event params.
-- EventPara == 10006 identifies the Fish Ranking NPC conversation.
-- Packet layout (all little-endian):
--   bytes 01-04 : UniqueNo  (uint32)
--   bytes 05-08 : num[0]    (int32) = status
--   bytes 09-12 : num[1]    (int32) = fishId
--   bytes 13-16 : num[2]    (int32) = criteria
--   bytes 17-20 : num[3]    (int32) = measure
--   bytes 21-24 : num[4]    (int32) = isRewardAvailable
--   bytes 25-28 : num[5]    (int32) = days remaining
--   bytes 29-32 : num[6]    (int32) = hours remaining
--   bytes 33-36 : num[7]    (int32) = minutes remaining
--   bytes 37-38 : ActIndex  (uint16)
--   bytes 39-40 : EventNum  (uint16)
--   bytes 41-42 : EventPara (uint16) = 10006 for fishing contest
-- ============================================================
local function read_int32(data, offset)
    local b0 = string.byte(data, offset)     or 0
    local b1 = string.byte(data, offset + 1) or 0
    local b2 = string.byte(data, offset + 2) or 0
    local b3 = string.byte(data, offset + 3) or 0
    local val = b0 + b1 * 256 + b2 * 65536 + b3 * 16777216
    -- Convert from unsigned to signed int32
    if val >= 2147483648 then val = val - 4294967296 end
    return val
end

local function read_uint16(data, offset)
    local b0 = string.byte(data, offset)     or 0
    local b1 = string.byte(data, offset + 1) or 0
    return b0 + b1 * 256
end

ashita.events.register('packet_in', 'anglin_packet_in', function(e)
    -- 0x34: Event start — captures status, fishId, criteria, measure
    if e.id == 0x34 then
        if not e.data or #e.data < 46 then return end
        local eventPara = read_uint16(e.data, 45)
        if eventPara ~= 10006 then return end
        local status = read_int32(e.data, 9)
        if status < 0 or status > 6 then return end
        contestCache.status   = status
        contestCache.fishId   = read_int32(e.data, 13)
        contestCache.criteria = read_int32(e.data, 17)
        contestCache.measure  = read_int32(e.data, 21)
        -- Flag that we're waiting for the 0x5C with time remaining
        contestAwaitingUpdate = true
        contestAwaitTimeout   = os.clock() + 30
        return
    end

    -- 0x5C: PendingNum update — carries days/hours/mins remaining
    if e.id == 0x5C then
        if not contestAwaitingUpdate then return end
        if os.clock() > contestAwaitTimeout then
            contestAwaitingUpdate = false
            return
        end
        if not e.data or #e.data < 34 then return end
        -- Only accept the first 0x5C that has a non-zero time (the "time remaining" update)
        local days  = read_int32(e.data, 25)
        local hours = read_int32(e.data, 29)
        local mins  = read_int32(e.data, 33)
        -- Guard: must match the status we got from 0x34
        local pktStatus = read_int32(e.data, 5)
        if pktStatus ~= contestCache.status then return end
        -- Accept zero time too — contest may genuinely be at 0
        local secsLeft = (days * 86400) + (hours * 3600) + (mins * 60)
        contestCache.secsLeft   = secsLeft
        contestCache.cachedAt   = os.time()
        contestCache.populated  = true
        contestAwaitingUpdate   = false
        save_contest_cache()
        showContest = true
        return
    end
end)


-- ============================================================

-- Contest fish data sourced from fishing_fish.sql (contest=1).
-- min_length / max_length in ilms. weight_min/max estimated from
-- server code: weight = length * random(4.65, 5.15), so we show
-- the theoretical range at min and max length.
-- hour_pattern / moon_pattern descriptions from fishingutils.cpp.
local contestFish = {
    { id=4316, name="Armored Pisces",  skill=108, minLen=50,  maxLen=125, water="Fresh", location="Oldton Movalpolos",                                              bait="Frog Lure, Meatball, Minnow, Sinking Minnow", rod="Composite Fishing Rod", hour="No bonus",    moon="No bonus"       },
    { id=4479, name="Bhefhel Marlin",  skill=61,  minLen=60,  maxLen=140, water="Salt",  location="Ships (Selbina/Mhaura routes)",                                  bait="Slice of Bluetail",                           rod="Composite Fishing Rod", hour="Night",        moon="New+Full Moon"  },
    { id=4471, name="Bladefish",       skill=71,  minLen=40,  maxLen=120, water="Fresh", location="Bhaflau Thickets, Mamook, Wajaom Woodlands",                     bait="Minnow, Sinking Minnow",                      rod="Composite Fishing Rod", hour="No bonus",    moon="New+Full Moon"  },
    { id=4309, name="Cave Cherax",     skill=130, minLen=115, maxLen=235, water="Fresh", location="Korroloka Tunnel",                                                bait="Minnow, Sinking Minnow",                      rod="Composite Fishing Rod", hour="No bonus",    moon="New+Full Moon", legendary=true },
    { id=4454, name="Emperor Fish",    skill=91,  minLen=60,  maxLen=180, water="Fresh", location="Ru'Aun Gardens",                                                  bait="Peeled Lobster, Shrimp Lure",                 rod="Composite Fishing Rod", hour="No bonus",    moon="New+Full Moon"  },
    { id=4477, name="Gavial Fish",     skill=81,  minLen=40,  maxLen=130, water="Fresh", location="Bhaflau Thickets, Mamook, Wajaom Woodlands",                     bait="Meatball, Minnow",                            rod="Composite Fishing Rod", hour="No bonus",    moon="New Moon"       },
    { id=4469, name="Giant Catfish",   skill=31,  minLen=40,  maxLen=130, water="Fresh", location="Jugner Forest, Pashhow Marshlands, Rolanberry Fields",            bait="Minnow, Sinking Minnow",                      rod="Halcyon Rod",           hour="High Tide",   moon="New+Full Moon"  },
    { id=4308, name="Giant Chirai",    skill=110, minLen=75,  maxLen=170, water="Fresh", location="Aht Urhgan Whitegate (waterway)",                                 bait="Minnow, Sinking Minnow",                      rod="Composite Fishing Rod", hour="No bonus",    moon="New+Full Moon", legendary=true },
    { id=4306, name="Giant Donko",     skill=50,  minLen=45,  maxLen=150, water="Fresh", location="Bastok Mines, Bastok Markets, North Gustaberg",                   bait="Minnow, Sinking Minnow",                      rod="Halcyon Rod",           hour="No bonus",    moon="New Moon"       },
    { id=4474, name="Gigant Squid",    skill=91,  minLen=80,  maxLen=170, water="Salt",  location="Bibiki Bay, Manaclipper",                                         bait="Peeled Lobster",                              rod="Composite Fishing Rod", hour="No bonus",    moon="New+Full Moon"  },
    { id=4304, name="Grimmonite",      skill=90,  minLen=55,  maxLen=145, water="Fresh", location="Carpenter's Landing, Jugner Forest, Meriphataud Mountains",       bait="Fly Lure",                                    rod="Composite Fishing Rod", hour="No bonus",    moon="New+Full Moon"  },
    { id=4480, name="Gugru Tuna",      skill=41,  minLen=40,  maxLen=120, water="Salt",  location="Bibiki Bay, Manaclipper",                                         bait="Sabiki Rig",                                  rod="Composite Fishing Rod", hour="New+Full Moon", moon="No bonus"     },
    { id=5127, name="Gugrusaurus",     skill=140, minLen=145, maxLen=425, water="Salt",  location="Ships (Selbina/Mhaura routes, with Pirates), Open sea routes",    bait="Meatball",                                    rod="Composite Fishing Rod", hour="No bonus",    moon="New+Full Moon", legendary=true, keyItem="Serpent Rumors" },
    { id=4307, name="Jungle Catfish",  skill=80,  minLen=40,  maxLen=110, water="Fresh", location="Bhaflau Thickets, Mamook, Wajaom Woodlands",                     bait="Minnow, Sinking Minnow",                      rod="Composite Fishing Rod", hour="High Tide",   moon="New+Full Moon"  },
    { id=5129, name="Lik",             skill=140, minLen=185, maxLen=465, water="Fresh", location="Lufaise Meadows (Leremieu Lagoon only)",                          bait="Minnow, Sinking Minnow, Dwarf Pugil",         rod="Composite Fishing Rod", hour="No bonus",    moon="New+Full Moon", legendary=true, keyItem="Serpent Rumors" },
    { id=4462, name="Monke-Onke",      skill=51,  minLen=45,  maxLen=115, water="Fresh", location="Jugner Forest, Meriphataud Mountains, Sauromugue Champaign",      bait="Minnow, Sinking Minnow",                      rod="Halcyon Rod",           hour="No bonus",    moon="New+Full Moon"  },
    { id=4305, name="Ryugu Titan",     skill=150, minLen=200, maxLen=490, water="Salt",  location="Bibiki Bay (BB side piers)",                                      bait="Peeled Lobster",                              rod="Composite Fishing Rod", hour="No bonus",    moon="New+Full Moon", legendary=true },
    { id=4475, name="Sea Zombie",      skill=100, minLen=80,  maxLen=195, water="Salt",  location="Caedarva Mire, Arrapago Reef",                                    bait="Peeled Lobster, Shrimp Lure",                 rod="Composite Fishing Rod", hour="High Tide",   moon="New+Full Moon", legendary=true },
    { id=4463, name="Takitaro",        skill=101, minLen=55,  maxLen=130, water="Fresh", location="Beaucedine Glacier, Fei'Yin, Ranguemont Pass, Uleguerand Range",  bait="Minnow, Sinking Minnow",                      rod="Composite Fishing Rod", hour="No bonus",    moon="New Moon"       },
    { id=4478, name="Three-Eyed Fish", skill=79,  minLen=50,  maxLen=120, water="Fresh", location="Al'Taieu, Ru'Aun Gardens, Grand Palace of Hu'Xzoi",               bait="Minnow, Sinking Minnow",                      rod="Composite Fishing Rod", hour="No bonus",    moon="New Moon"       },
    { id=5120, name="Titanic Sawfish", skill=125, minLen=75,  maxLen=210, water="Salt",  location="Bibiki Bay (BB side), Manaclipper",                               bait="Peeled Lobster, Shrimp Lure",                 rod="Composite Fishing Rod", hour="No bonus",    moon="New+Full Moon", legendary=true },
    { id=4476, name="Titanictus",      skill=101, minLen=75,  maxLen=210, water="Salt",  location="Caedarva Mire, Arrapago Reef",                                    bait="Peeled Lobster, Shrimp Lure",                 rod="Composite Fishing Rod", hour="No bonus",    moon="New Moon",      legendary=true },
    { id=4319, name="Tricorn",         skill=128, minLen=105, maxLen=210, water="Fresh", location="Phanauet Channel",                                                bait="Fly Lure, Lufaise Fly",                       rod="Composite Fishing Rod", hour="No bonus",    moon="New Moon",      legendary=true, keyItem="Frog Fishing" },
}

-- Build lookup by item ID for fast inventory scanning
local contestFishById = {}
for _, cf in ipairs(contestFish) do
    contestFishById[cf.id] = cf
end

-- ItemType::Fish = 3 (Ashita SDK enums.h)
local ITEM_TYPE_FISH = 3

-- Read fish length/weight from item Extra bytes (confirmed byte layout).
-- Returns { length, weight, isRanked } or nil if not a sized fish.
local function read_fish_exdata(item)
    if not item or type(item.Extra) ~= 'string' or #item.Extra < 5 then return nil end
    local length = (string.byte(item.Extra, 1) or 0) + ((string.byte(item.Extra, 2) or 0) * 256)
    local weight = (string.byte(item.Extra, 3) or 0) + ((string.byte(item.Extra, 4) or 0) * 256)
    local isRanked = ((string.byte(item.Extra, 5) or 0) % 2) == 1
    if length == 0 then return nil end
    return { length=length, weight=weight, isRanked=isRanked }
end

-- Scan inventory for sized fish and update personal bests.
-- Called after each catch event (container update).
local function scan_for_personal_bests()
    local inv = AshitaCore:GetMemoryManager():GetInventory()
    local res = AshitaCore:GetResourceManager()
    if not inv or not res then return end

    for container = 0, 12 do
        for slot = 0, 80 do
            local item = inv:GetContainerItem(container, slot)
            if item and item.Id and item.Id > 0 then
                local resItem = res:GetItemById(item.Id)
                if resItem and resItem.Type == ITEM_TYPE_FISH then
                    local exdata = read_fish_exdata(item)
                    if exdata then
                        local name = (resItem.Name and resItem.Name[1]) or tostring(item.Id)
                        local newRecords = data.record_personal_best(name, exdata.length, exdata.weight)
                        if #newRecords > 0 then
                            echo(string.format(
                                "New personal best! %s: %d ilms / %d Pz  [%s]",
                                name, exdata.length, exdata.weight,
                                table.concat(newRecords, ", ")))
                        end
                    end
                end
            end
        end
    end
end

-- Track container update counter to detect inventory changes
local lastContainerUpdate = 0
local contestCacheLoadAttempted = false

-- Estimate weight range from length range (server formula: length * 4.65 to 5.15)
local function est_weight(length)
    return math.floor(length * 4.65), math.floor(length * 5.15)
end

-- ============================================================
-- Contest window renderer
-- ============================================================
local function render_contest_window()
    if not showContest then return end

    imgui.PushStyleVar(ImGuiStyleVar_WindowRounding, 8)
    imgui.PushStyleVar(ImGuiStyleVar_FrameRounding, 4)
    imgui.PushStyleVar(ImGuiStyleVar_WindowPadding, { 12, 12 })
    imgui.PushStyleColor(ImGuiCol_WindowBg, getBackgroundColor(pref_Transparency))
    imgui.PushStyleColor(ImGuiCol_TitleBg, Colors.Primary)
    imgui.PushStyleColor(ImGuiCol_TitleBgActive, Colors.PrimaryDark)
    imgui.PushStyleColor(ImGuiCol_Border, Colors.Primary)

    imgui.SetNextWindowSize({ 580, 560 }, ImGuiCond_FirstUseEver)
    local contestOpen = { showContest }
    if imgui.Begin("Fishing Contest##anglin_contest", contestOpen) then
        showContest = contestOpen[1]
        push_font()

        -- --------------------------------------------------------
        -- LIVE PHASE STATUS PANEL
        -- --------------------------------------------------------
        local phaseName, secsRemaining, nextPhaseName, currentStatus = get_projected_contest_state()

        if phaseName then
            -- Phase status box
            imgui.PushStyleColor(ImGuiCol_ChildBg, getBackgroundColor(0.6))
            if imgui.BeginChild("ContestStatus", { 0, 95 }, true) then

                -- Current phase
                imgui.PushStyleColor(ImGuiCol_Text, Colors.Accent)
                imgui.TextUnformatted("Current Phase:")
                imgui.PopStyleColor()
                imgui.SameLine()
                imgui.PushStyleColor(ImGuiCol_Text, Colors.Primary)
                imgui.TextUnformatted(phaseName)
                imgui.PopStyleColor()

                -- Time remaining
                imgui.PushStyleColor(ImGuiCol_Text, Colors.Accent)
                imgui.TextUnformatted("Time Remaining:")
                imgui.PopStyleColor()
                imgui.SameLine()
                imgui.PushStyleColor(ImGuiCol_Text, Colors.Warning)
                imgui.TextUnformatted(secsRemaining > 0 and format_duration(secsRemaining) or "Phase ending soon")
                imgui.PopStyleColor()

                -- Next phase
                imgui.PushStyleColor(ImGuiCol_Text, Colors.Accent)
                imgui.TextUnformatted("Next Phase:")
                imgui.PopStyleColor()
                imgui.SameLine()
                imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
                imgui.TextUnformatted(nextPhaseName)
                imgui.PopStyleColor()

                -- Current fish + contest details (only during Accepting/Presenting)
                if currentStatus == 2 or currentStatus == 4 then
                    imgui.Separator()
                    local res = AshitaCore:GetResourceManager()
                    local fishName = "Unknown"
                    if contestCache.fishId and contestCache.fishId > 0 then
                        local resItem = res:GetItemById(contestCache.fishId)
                        if resItem and resItem.Name then
                            fishName = resItem.Name[1] or fishName
                        end
                    end
                    local criteriaStr = CONTEST_CRITERIA_NAMES[contestCache.criteria] or "?"
                    local measureStr  = CONTEST_MEASURE_NAMES[contestCache.measure]   or "?"
                    imgui.PushStyleColor(ImGuiCol_Text, Colors.Accent)
                    imgui.TextUnformatted("Current Fish:")
                    imgui.PopStyleColor()
                    imgui.SameLine()
                    imgui.PushStyleColor(ImGuiCol_Text, Colors.Warning)
                    imgui.TextUnformatted(string.format("%s  [%s / %s]", fishName, criteriaStr, measureStr))
                    imgui.PopStyleColor()
                end

                imgui.EndChild()
            end
            imgui.PopStyleColor()

            -- Stale data warning
            if contestCache.cachedAt then
                local staleSecs = os.time() - contestCache.cachedAt
                if staleSecs > 86400 then
                    imgui.PushStyleColor(ImGuiCol_Text, Colors.Warning)
                    imgui.TextUnformatted(string.format("(Last synced %s ago — visit Chenon to refresh)", format_duration(staleSecs)))
                    imgui.PopStyleColor()
                end
            end
        else
            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextMuted)
            imgui.TextWrapped("No contest data yet. Talk to Chenon in Selbina to sync.")
            imgui.PopStyleColor()
        end

        drawSection()

        -- Legend
        imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
        imgui.TextUnformatted("[L]egendary  [KI] Key Item Required  [S]alt  [F]resh")
        imgui.PopStyleColor()
        imgui.Spacing()

        -- --------------------------------------------------------
        -- CONTEST FISH LIST
        -- --------------------------------------------------------
        if imgui.BeginChild("ContestList", { 0, -40 }, false) then
            for _, cf in ipairs(contestFish) do
                local pb = data.state.personalBests and data.state.personalBests[cf.name]

                -- Highlight the active contest fish
                local isActive = contestCache.populated and contestCache.fishId == cf.id
                    and (currentStatus == 2 or currentStatus == 4)
                local rowColor = isActive and Colors.Warning
                             or (pb and Colors.Success or Colors.TextSecondary)
                imgui.PushStyleColor(ImGuiCol_Text, rowColor)

                local tags = ""
                if cf.legendary then tags = tags .. "[L]" end
                if cf.keyItem   then tags = tags .. "[KI]" end
                if isActive     then tags = tags .. " [ACTIVE]" end
                local waterTag = cf.water == "Salt" and "[S]" or "[F]"
                local headerLabel = string.format("%s %s%s  (Skill: %d)", cf.name, waterTag, tags, cf.skill)

                if imgui.CollapsingHeader(headerLabel) then
                    imgui.Indent()
                    imgui.PopStyleColor()

                    local wMin, _    = est_weight(cf.minLen)
                    local _,    wMax = est_weight(cf.maxLen)
                    drawColoredText("Length Range:", string.format("%d - %d ilms", cf.minLen, cf.maxLen), Colors.Primary)
                    drawColoredText("Weight Range:", string.format("~%d - ~%d", wMin, wMax), Colors.Primary)

                    if pb then
                        imgui.PushStyleColor(ImGuiCol_Text, Colors.Success)
                        imgui.TextUnformatted("Personal Bests:")
                        imgui.PopStyleColor()
                        if pb.longest then
                            imgui.TextUnformatted(string.format(
                                "  Longest:   %d ilms / %d Pz  (%.1f%% of max length)",
                                pb.longest.length, pb.longest.weight,
                                (pb.longest.length / cf.maxLen) * 100))
                        end
                        if pb.shortest then
                            imgui.TextUnformatted(string.format(
                                "  Shortest:  %d ilms / %d Pz  (%.1f%% of min length)",
                                pb.shortest.length, pb.shortest.weight,
                                (cf.minLen / pb.shortest.length) * 100))
                        end
                        if pb.heaviest then
                            imgui.TextUnformatted(string.format(
                                "  Heaviest:  %d ilms / %d Pz  (%.1f%% of max weight)",
                                pb.heaviest.length, pb.heaviest.weight,
                                (pb.heaviest.weight / wMax) * 100))
                        end
                        if pb.lightest then
                            imgui.TextUnformatted(string.format(
                                "  Lightest:  %d ilms / %d Pz  (%.1f%% of min weight)",
                                pb.lightest.length, pb.lightest.weight,
                                (wMin / pb.lightest.weight) * 100))
                        end
                    else
                        imgui.PushStyleColor(ImGuiCol_Text, Colors.TextMuted)
                        imgui.TextUnformatted("Personal Best:  None recorded yet")
                        imgui.PopStyleColor()
                    end

                    imgui.Separator()
                    imgui.TextWrapped(string.format("Location: %s", cf.location))
                    imgui.TextWrapped(string.format("Bait/Lure: %s", cf.bait))
                    imgui.TextUnformatted(string.format("Rod: %s", cf.rod))
                    imgui.Separator()
                    drawColoredText("Best Hour:", cf.hour, Colors.Accent)
                    drawColoredText("Best Moon:", cf.moon, Colors.Accent)

                    if cf.keyItem then
                        imgui.PushStyleColor(ImGuiCol_Text, Colors.Warning)
                        imgui.TextUnformatted(string.format("[KEY ITEM REQUIRED] %s", cf.keyItem))
                        imgui.PopStyleColor()
                    end

                    imgui.Unindent()
                    imgui.Spacing()
                else
                    imgui.PopStyleColor()

                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        imgui.PushTextWrapPos(imgui.GetFontSize() * 28)
                        imgui.PushStyleColor(ImGuiCol_Text, Colors.Primary)
                        imgui.TextUnformatted(cf.name)
                        imgui.PopStyleColor()
                        imgui.Separator()
                        local wLo, _ = est_weight(cf.minLen)
                        local _, wHi = est_weight(cf.maxLen)
                        imgui.TextUnformatted(string.format("Length: %d - %d ilms", cf.minLen, cf.maxLen))
                        imgui.TextUnformatted(string.format("Est. Weight: ~%d - ~%d", wLo, wHi))
                        if pb then
                            imgui.Separator()
                            imgui.PushStyleColor(ImGuiCol_Text, Colors.Success)
                            imgui.TextUnformatted("Personal Bests:")
                            imgui.PopStyleColor()
                            if pb.longest  then imgui.TextUnformatted(string.format("  Longest:  %d ilms / %d Pz", pb.longest.length,  pb.longest.weight))  end
                            if pb.shortest then imgui.TextUnformatted(string.format("  Shortest: %d ilms / %d Pz", pb.shortest.length, pb.shortest.weight)) end
                            if pb.heaviest then imgui.TextUnformatted(string.format("  Heaviest: %d ilms / %d Pz", pb.heaviest.length, pb.heaviest.weight)) end
                            if pb.lightest then imgui.TextUnformatted(string.format("  Lightest: %d ilms / %d Pz", pb.lightest.length, pb.lightest.weight)) end
                        end
                        if cf.keyItem then
                            imgui.Separator()
                            imgui.PushStyleColor(ImGuiCol_Text, Colors.Warning)
                            imgui.TextUnformatted(string.format("Key Item Required: %s", cf.keyItem))
                            imgui.PopStyleColor()
                        end
                        imgui.TextUnformatted(string.format("Best Hour: %s  |  Best Moon: %s", cf.hour, cf.moon))
                        imgui.PopTextWrapPos()
                        imgui.EndTooltip()
                    end
                end
            end
            imgui.EndChild()
        end

        imgui.Spacing()
        if modernButton("Close", -1, 30) then
            showContest = false
        end

        pop_font()
        imgui.End()
    else
        showContest = contestOpen[1]
    end

    imgui.PopStyleVar(3)
    imgui.PopStyleColor(4)
end


ashita.events.register('command', 'anglin_command', function(e)
    local args = e.command:args()
    if (#args == 0 or args[1]:lower() ~= '/anglin') then return end
    e.blocked = true

    if (#args == 1) then
        AshitaCore:GetChatManager():QueueCommand(1, '/echo Usage: /anglin stats | /anglin settings | /anglin guide | /anglin suggest | /anglin contest | /anglin update')
        return
    end

    local subcmd = args[2]:lower()
    
    if subcmd == 'stats' then
        showStats = not showStats
        if showStats then statsTabNeedsRestore = true end
        if not pref_SilentToggle then
            AshitaCore:GetChatManager():QueueCommand(1, '/echo Stats window toggled.')
        end
    
    elseif subcmd == 'settings' then
        showSettings = not showSettings
        if not pref_SilentToggle then
            AshitaCore:GetChatManager():QueueCommand(1, '/echo Settings window toggled.')
        end
    
    elseif subcmd == 'guide' then
        if showGuide and activeGuideTab == "Guide" then
            showGuide = false
        else
            activeGuideTab = "Guide"
            guideTabBarId = guideTabBarId + 1
            showGuide = true
        end
        if not pref_SilentToggle then
            AshitaCore:GetChatManager():QueueCommand(1, '/echo Fishing guide window toggled.')
        end

    elseif subcmd == 'suggest' then
        if showGuide and activeGuideTab == "Skillups" then
            showGuide = false
        else
            activeGuideTab = "Skillups"
            guideTabBarId = guideTabBarId + 1  -- new ID = fresh tab state
            showGuide = true
        end
        if not pref_SilentToggle then
            AshitaCore:GetChatManager():QueueCommand(1, '/echo Fishing guide window toggled.')
        end

    elseif subcmd == 'update' then
        perform_update()

    elseif subcmd == 'contest' then
        showContest = not showContest
        if not pref_SilentToggle then
            AshitaCore:GetChatManager():QueueCommand(1, '/echo Contest window toggled.')
        end

    else
        AshitaCore:GetChatManager():QueueCommand(1,
            string.format('/echo Unknown subcommand: %s', args[2])
        )
    end
end)

ashita.events.register('d3d_present', 'anglin_render', function()
    -- Load contest cache and run update check as soon as playerName becomes available
    if not contestCacheLoadAttempted and playerName and playerName ~= '' then
        contestCacheLoadAttempted = true
        if not contestCache.populated then
            load_contest_cache()
        end
        -- Check for updates in case addon was loaded manually after login
        -- (welcome message trigger won't fire in this case)
        check_for_update()
    end

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
        
        imgui.PushStyleColor(ImGuiCol_WindowBg, getBackgroundColor(pref_Transparency))
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

            if imgui.BeginTabBar("GuideTabBar" .. guideTabBarId) then

                -- Render the saved active tab first; ImGui always selects
                -- the first tab it sees when the window initializes.
                local function render_guide_tab()
                    if imgui.BeginTabItem("Guide") then
                        activeGuideTab = "Guide"
            
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
                    local kiTag = fish.keyItem and " [KI]" or ""
                    local displayName = fish.name .. typeTag .. kiTag .. skillStr
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
                                imgui.TextUnformatted(string.format("Sell Price: %d - %d gil", sp, math.floor(sp * FAME9_MULT)))
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
                        if fish.keyItem then
                            imgui.PushStyleColor(ImGuiCol_Text, Colors.Warning)
                            imgui.TextUnformatted(string.format("[KEY ITEM REQUIRED] %s", fish.keyItem))
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
                        if fish.keyItem then
                            imgui.Separator()
                            imgui.PushStyleColor(ImGuiCol_Text, Colors.Warning)
                            imgui.TextUnformatted(string.format("Key Item Required: %s", fish.keyItem))
                            imgui.PopStyleColor()
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
                    end
                end
                local function render_skillups_tab()
                    if imgui.BeginTabItem("Skillups") then
                        activeGuideTab = "Skillups"
                    local playerSkill = get_fishing_skill()

                    if not playerSkill then
                        imgui.TextColored({1,0.4,0.4,1}, "Skill data unavailable.")
                    else
                        imgui.PushStyleColor(ImGuiCol_Text, Colors.Accent)
                        imgui.TextUnformatted(string.format("Your Fishing Skill: %s", anglin_format_skill_with_bonus(playerSkill)))
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
                    end
                end

                if activeGuideTab == "Skillups" then
                    render_skillups_tab()
                    render_guide_tab()
                else
                    render_guide_tab()
                    render_skillups_tab()
                end

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
        imgui.PushStyleColor(ImGuiCol_WindowBg, getBackgroundColor(pref_Transparency))
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
                local dailyTabFlags = (statsTabNeedsRestore and activeStatsTab == "Daily") and ImGuiTabItemFlags_SetSelected or 0
                if imgui.BeginTabItem("Daily", nil, dailyTabFlags) then
                    activeStatsTab = "Daily"
                    statsTabNeedsRestore = false
                    
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
                    local nextRestockHour = statsCache.restockHour
                    local restockSecs = statsCache.restockSecs
                    if nextRestockHour and restockSecs and statsCache.restockCachedAt then
                        local elapsed = os.time() - statsCache.restockCachedAt
                        restockSecs = math.max(0, restockSecs - elapsed)
                    end
                    if nextRestockHour then
                        restockSecs = math.floor(restockSecs)
                        local r_h = math.floor(restockSecs / 3600)
                        local r_m = math.floor((restockSecs % 3600) / 60)
                        local r_s = restockSecs % 60
                        local countdown_str
                        if r_h > 0 then
                            countdown_str = string.format('%d:%02d:%02d', r_h, r_m, r_s)
                        else
                            countdown_str = string.format('%02d:%02d', r_m, r_s)
                        end
                        local restock_str = string.format('%d:00 - %s remaining', nextRestockHour, countdown_str)
                        drawColoredText("Next Restock:", restock_str, Colors.Accent)
                    end
                    local skillVal = get_fishing_skill()
                    if skillVal then
                        drawColoredText("Fishing Skill:", anglin_format_skill_with_bonus(skillVal), Colors.Accent)
                    end
                    drawSection()
                    
                    if imgui.CollapsingHeader("Fish Caught", ImGuiTreeNodeFlags_DefaultOpen) then
                        drawColoredText("Total Fish:", tostring(dailyData.totalFish), Colors.Success)
                        local dailyGilMin, dailyGilMax = calc_gil_value(data.state.daily)
                        if dailyGilMin > 0 then
                            drawColoredText("Est. Gil Value:", string.format("%d - %d gil", dailyGilMin, dailyGilMax), Colors.Warning)
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
                        imgui.OpenPopup("Reset Daily Stats?")
                    end

                    if imgui.BeginPopupModal("Reset Daily Stats?", nil, ImGuiWindowFlags_AlwaysAutoResize) then
                        imgui.TextUnformatted("Are you sure you want to reset today's stats?")
                        imgui.PushStyleColor(ImGuiCol_Text, Colors.TextMuted)
                        imgui.TextUnformatted("This cannot be undone.")
                        imgui.PopStyleColor()
                        imgui.Spacing()
                        if modernButton("Yes, Reset", 120, 30) then
                            data.reset_daily_stats()
                            statsCache.dailyDirty = true
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        if modernButton("Cancel", 120, 30) then
                            imgui.CloseCurrentPopup()
                        end
                        imgui.EndPopup()
                    end

                    imgui.EndTabItem()
                end
                
                local lifetimeTabFlags = (statsTabNeedsRestore and activeStatsTab == "Lifetime") and ImGuiTabItemFlags_SetSelected or 0
                if imgui.BeginTabItem("Lifetime", nil, lifetimeTabFlags) then
                    activeStatsTab = "Lifetime"
                    statsTabNeedsRestore = false
                    
                    if statsCache.lifetimeDirty then
                        build_stats_cache(data.state.lifetime, statsCache.lifetimeData)
                        statsCache.lifetimeDirty = false
                    end
                    
                    local lifetimeData = statsCache.lifetimeData

                    local skillVal = get_fishing_skill()
                    if skillVal then
                        drawColoredText("Fishing Skill:", anglin_format_skill_with_bonus(skillVal), Colors.Accent)
                        drawSection()
                    end

                    if imgui.CollapsingHeader("Fish Caught", ImGuiTreeNodeFlags_DefaultOpen) then
                        drawColoredText("Total Fish:", tostring(lifetimeData.totalFish), Colors.Success)
                        local lifetimeGilMin, lifetimeGilMax = calc_gil_value(data.state.lifetime)
                        if lifetimeGilMin > 0 then
                            drawColoredText("Est. Gil Value:", string.format("%d - %d gil", lifetimeGilMin, lifetimeGilMax), Colors.Warning)
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
                        imgui.OpenPopup("Reset Lifetime Stats?")
                    end

                    if imgui.BeginPopupModal("Reset Lifetime Stats?", nil, ImGuiWindowFlags_AlwaysAutoResize) then
                        imgui.TextUnformatted("Are you sure you want to reset your lifetime stats?")
                        imgui.PushStyleColor(ImGuiCol_Text, Colors.TextMuted)
                        imgui.TextUnformatted("This cannot be undone.")
                        imgui.PopStyleColor()
                        imgui.Spacing()
                        if modernButton("Yes, Reset", 120, 30) then
                            data.reset_lifetime_stats()
                            statsCache.lifetimeDirty = true
                            imgui.CloseCurrentPopup()
                        end
                        imgui.SameLine()
                        if modernButton("Cancel", 120, 30) then
                            imgui.CloseCurrentPopup()
                        end
                        imgui.EndPopup()
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
            
            local transparency = { pref_Transparency }
            imgui.PushStyleColor(ImGuiCol_SliderGrab, Colors.Primary)
            imgui.PushStyleColor(ImGuiCol_SliderGrabActive, Colors.PrimaryDark)
            imgui.PushStyleVar(ImGuiStyleVar_GrabRounding, 4)
            
            if imgui.SliderFloat("##transparency", transparency, 0.0, 1.0, "%.2f") then
                pref_Transparency = transparency[1]
                save_prefs()
            end
            
            imgui.PopStyleVar()
            imgui.PopStyleColor(2)
            
            imgui.Spacing()
            drawColoredText("Current:", string.format("%.2f", pref_Transparency), Colors.Primary)
            
            drawSection("Font Scale")
            
            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
            imgui.TextUnformatted("UI Font Scale")
            imgui.PopStyleColor()
            
            local fontScale = { pref_FontScale }
            imgui.PushStyleColor(ImGuiCol_SliderGrab, Colors.Primary)
            imgui.PushStyleColor(ImGuiCol_SliderGrabActive, Colors.PrimaryDark)
            imgui.PushStyleVar(ImGuiStyleVar_GrabRounding, 4)
            
            if imgui.SliderFloat("##fontscale", fontScale, 0.8, 2.0, "%.2f") then
                pref_FontScale = fontScale[1]
                save_prefs()
            end
            
            imgui.PopStyleVar()
            imgui.PopStyleColor(2)
            
            imgui.Spacing()
            drawColoredText("Current:", string.format("%.2f", pref_FontScale), Colors.Primary)
            
            drawSection("Color Theme")
            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
            imgui.TextUnformatted("Select Theme:")
            imgui.PopStyleColor()
            
            local themeNames = {"Soft Blue", "Ocean Teal", "Purple Dream", "Forest Green", "Sunset Orange", "Cool Gray", "Custom"}
            local currentTheme = pref_ColorTheme
            
            imgui.PushItemWidth(200)
            if imgui.BeginCombo("##ThemeSelector", currentTheme) then
                for _, themeName in ipairs(themeNames) do
                    local isSelected = (themeName == currentTheme)
                    if imgui.Selectable(themeName, isSelected) then
                        pref_ColorTheme = themeName
                        if themeName ~= "Custom" then
                            applyColorTheme(themeName)
                        end
                        save_prefs()
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
                imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
                imgui.TextUnformatted("Primary Color:")
                imgui.PopStyleColor()
                imgui.SameLine()
                
                local primaryBuf = { pref_CustomColors.Primary }
                imgui.PushItemWidth(150)
                if imgui.InputText("##PrimaryColor", primaryBuf, 9) then
                    pref_CustomColors.Primary = primaryBuf[1]
                    local parsed = parseHexColor(primaryBuf[1])
                    if parsed then
                        Colors.Primary = parsed
                        ColorThemes["Custom"].Primary = parsed
                        save_prefs()
                    end
                end
                imgui.PopItemWidth()
                imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
                imgui.TextUnformatted("Primary Dark:")
                imgui.PopStyleColor()
                imgui.SameLine()
                
                local primaryDarkBuf = { pref_CustomColors.PrimaryDark }
                imgui.PushItemWidth(150)
                if imgui.InputText("##PrimaryDark", primaryDarkBuf, 9) then
                    pref_CustomColors.PrimaryDark = primaryDarkBuf[1]
                    local parsed = parseHexColor(primaryDarkBuf[1])
                    if parsed then
                        Colors.PrimaryDark = parsed
                        ColorThemes["Custom"].PrimaryDark = parsed
                        save_prefs()
                    end
                end
                imgui.PopItemWidth()
                imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
                imgui.TextUnformatted("Primary Light:")
                imgui.PopStyleColor()
                imgui.SameLine()
                
                local primaryLightBuf = { pref_CustomColors.PrimaryLight }
                imgui.PushItemWidth(150)
                if imgui.InputText("##PrimaryLight", primaryLightBuf, 9) then
                    pref_CustomColors.PrimaryLight = primaryLightBuf[1]
                    local parsed = parseHexColor(primaryLightBuf[1])
                    if parsed then
                        Colors.PrimaryLight = parsed
                        ColorThemes["Custom"].PrimaryLight = parsed
                        save_prefs()
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

            local currentCaughtName = guideColorNameFromHex(pref_CaughtColor)
            imgui.PushItemWidth(140)
            if imgui.BeginCombo("##CaughtColorDrop", currentCaughtName) then
                for _, c in ipairs(guideColorOptions) do
                    local isSelected = (c.name == currentCaughtName)
                    local r = bit.band(c.value, 0xFF) / 255
                    local g = bit.rshift(bit.band(c.value, 0xFF00), 8) / 255
                    local b = bit.rshift(bit.band(c.value, 0xFF0000), 16) / 255
                    imgui.PushStyleColor(ImGuiCol_Text, c.value)
                    if imgui.Selectable(c.name, isSelected) then
                        pref_CaughtColor = c.hex
                        Colors.CaughtColor = c.value
                        save_prefs()
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

            local currentUncaughtName = guideColorNameFromHex(pref_UncaughtColor)
            imgui.PushItemWidth(140)
            if imgui.BeginCombo("##UncaughtColorDrop", currentUncaughtName) then
                for _, c in ipairs(guideColorOptions) do
                    local isSelected = (c.name == currentUncaughtName)
                    imgui.PushStyleColor(ImGuiCol_Text, c.value)
                    if imgui.Selectable(c.name, isSelected) then
                        pref_UncaughtColor = c.hex
                        Colors.UncaughtColor = c.value
                        save_prefs()
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
                pref_CaughtColor   = "FFFFFFFF"
                pref_UncaughtColor = "808080FF"
                save_prefs()
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
            local silentToggle = { pref_SilentToggle }
            if imgui.Checkbox("Suppress window toggle messages", silentToggle) then
                pref_SilentToggle = silentToggle[1]
                save_prefs()
            end
            if imgui.IsItemHovered() then
                imgui.SetTooltip("When enabled, '/anglin stats|settings|guide' will not print a confirmation message in chat.")
            end

            imgui.Spacing()
            imgui.Spacing()

            -- Skill-up sound alert option
            imgui.PushStyleColor(ImGuiCol_Text, Colors.TextSecondary)
            imgui.TextUnformatted("Fishing Skill-Up Alert:")
            imgui.PopStyleColor()
            imgui.Spacing()
            local skillUpSound = { state.SkillUpSoundEnabled }
            if imgui.Checkbox("Play a sound when fishing skill levels up", skillUpSound) then
                state.SkillUpSoundEnabled = skillUpSound[1]
                save_prefs()
            end
            if imgui.IsItemHovered() then
                imgui.SetTooltip("Plays a sound file when your fishing skill reaches a new level. Customize this by adding your own skillup.wav sound to the Sounds folder.")
            end
            imgui.SameLine()
            if modernButton("Test Sound", 100, 22) then
                state.PlaySkillUpSound(true)
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

    render_contest_window()

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
    imgui.PushStyleColor(ImGuiCol_WindowBg, getBackgroundColor(pref_Transparency))
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

ashita.events.register('d3d_present', 'anglin_changelog_flush', function()
    if changelogDelay and os.clock() >= changelogDelay and changelogMessages then
        for _, msg in ipairs(changelogMessages) do
            echo(msg)
        end
        changelogMessages = nil
        changelogDelay    = nil
    end
end)

ashita.events.register('d3d_present', 'anglin_skillup_check', function()
    check_fishing_skillup()
end)

-- Scans inventory for new personal-best fish independently of whether
-- the contest window is open, so records are caught even when closed.
ashita.events.register('d3d_present', 'anglin_pb_scan', function()
    local inv = AshitaCore:GetMemoryManager():GetInventory()
    if not inv then return end
    local cu = inv:GetContainerUpdateCounter()
    if cu ~= lastContainerUpdate then
        lastContainerUpdate = cu
        scan_for_personal_bests()
    end
end)

local lastRestockUpdate = 0
ashita.events.register('d3d_present', 'anglin_restock_update', function()
    local now = os.time()
    if now - lastRestockUpdate >= 10 then
        lastRestockUpdate = now
        update_restock_cache()
    end
end)
