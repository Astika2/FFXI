addon.name      = 'anglin'
addon.author    = 'Astika'
addon.version   = '1.2'
addon.desc      = 'Based off of Thorny\'s "Fishaid" plugin, with more insight and tracking'
addon.link      = 'https://ashitaxi.com/'

require('common')
local fonts = require('fonts')
local settings = require('settings')
local imgui = require('imgui')
local data = require('data_manager')
local json = require('json')
local addon = { name = 'Anglin' }
local playerName = nil

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
    WindowTransparency = 1.0,  -- 0.0 = fully transparent, 1.0 = fully opaque
}

local state = {
    Active = false,
    Settings = nil,  -- Will be loaded
    CurrentBait = 'Unknown',
    CurrentBaitType = 'Unknown',
    CurrentRod = 'Unknown',
    
    -- Fishing session tracking
    Hook = nil,
    HookColor = nil,  -- Store the color for the hook text
    Feel = nil,
    FeelColor = nil,  -- Store the color for the feel text
    Fish = nil,
    CatchCount = 1,
    BaitBeforeCast = nil,
    
    -- Auto-close tracking
    CloseTime = nil,
}

-- Default window position
local windowPosX = 100
local windowPosY = 100
local windowPosSet = false
local showSettings = false
local showStats = false
local showGuide = false
local activeStatsTab = "Daily"  -- Track which stats tab is active

-- Cache for stats display
local statsCache = {
    dailyDirty = true,
    lifetimeDirty = true,
    dailyData = {},
    lifetimeData = {}
}

-- Stats filtering state
local statsFilters = {
    bait = "All",           -- Current bait filter
    location = "All",       -- Current location filter
    skillRange = "All",     -- Current skill range filter
    showZeroCatch = true,   -- Show fish with 0 catches
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
    bait = "All",           -- Current bait filter
    location = "All",       -- Current location filter
    skillRange = "All",     -- Current skill range filter
    showUncaught = true,    -- Show fish that haven't been caught yet
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

-- Timer for daily reset check (check once per second instead of every frame)
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
    { name = "Phanauet Newt", skill = 4, location = "Carpenters' Landing, Phanauet Channel", bait = "Lufaise Fly, Shell Bug", rod = "Halcyon" },
    --{ name = "Denizanasi", skill = 5, location = "Nashmau, Aht Urhgan Whitegate", bait = "Little Worm, Sabiki Rig", rod = "Halcyon" },
    { name = "Cobalt Jellyfish", skill = 5, location = "Mhaura, Selbina, Qufim Island", bait = "Sabiki Rig, Little Worm", rod = "Halcyon" },
    { name = "Crayfish", skill = 7, location = "W. Ronfaure (Knightwell), Bastok Mines", bait = "Little Worm, Peeled Crayfish", rod = "Halcyon" },
    { name = "Bastore Sardine", skill = 9, location = "Any coastal area", bait = "Lugworm, Sabiki Rig", rod = "Halcyon" },
    --{ name = "Hamsi", skill = 9, location = "Nashmau, Aht Urhgan Whitegate", bait = "Lugworm, Sabiki Rig", rod = "Halcyon" },
    { name = "Moat Carp", skill = 11, location = "W. Ronfaure (Knightwell), E. Sarutabaruta (Lake)", bait = "Insect Paste, Little Worm", rod = "Halcyon" },
    { name = "Yellow Globe", skill = 14, location = "Mhaura Docks, Selbina", bait = "Sabiki Rig, Crayfish Paste", rod = "Halcyon" },
    { name = "Muddy Siredon", skill = 18, location = "Carpenters' Landing (North)", bait = "Fly Lure, Lufaise Fly", rod = "Halcyon, Composite" },
    { name = "Quus", skill = 19, location = "Korroloka Tunnel (pond), Port Windurst", bait = "Sabiki Rig, Lugworm", rod = "Halcyon" },
    { name = "Cheval Salmon", skill = 21, location = "E. Ronfaure (River), Jugner Forest", bait = "Fly Lure", rod = "Halcyon, Hume" },
    { name = "Forest Carp", skill = 21, location = "Yhoator Jungle, Windurst Woods", bait = "Insect Paste, Insect Ball", rod = "Halcyon" },
    { name = "Nebimonite", skill = 27, location = "Mhaura/Selbina Ferry", bait = "Shrimp Lure, Crayfish Ball", rod = "Halcyon" },
    { name = "Tricolored Carp", skill = 27, location = "E. Sarutabaruta (pond), N. Gustaberg", bait = "Insect Ball, Shrimp Lure", rod = "Halcyon" },
    { name = "Pipira", skill = 29, location = "Windurst Waters", bait = "Minnow", rod = "Halcyon" },
    { name = "Tiger Cod", skill = 29, location = "Qufim Island (coastal), Sauromugue", bait = "Shrimp Lure, Sardine Ball", rod = "Composite" },
    { name = "Ogre Eel", skill = 35, location = "S. Gustaberg (sea), E./W. Sarutabaruta (sea)", bait = "Shrimp Lure, Minnow", rod = "Composite" },
    { name = "Shining Trout", skill = 37, location = "E. Ronfaure (River), La Theine Plateau", bait = "Fly Lure, Minnow", rod = "Halcyon" },
    { name = "Nosteau Herring", skill = 39, location = "Qufim Island (coastal)", bait = "Sardine Ball", rod = "Halcyon" },
    { name = "Coral Butterfly", skill = 40, location = "Kazham", bait = "Worm Lure", rod = "Halcyon" },
    { name = "Gugru Tuna", skill = 41, location = "Mhaura/Selbina Ferry", bait = "Minnow, Shrimp Lure", rod = "Composite" },
    { name = "Black Eel", skill = 47, location = "Zeruhn Mines (river)", bait = "Worm Lure, Trout Ball", rod = "Composite" },
    { name = "Cone Calamary", skill = 48, location = "Mhaura/Selbina Ferry, Batallia Downs", bait = "Minnow, Sliced Cod", rod = "Composite" },
    { name = "Icefish", skill = 49, location = "Beaucedine Glacier (pond)", bait = "Sabiki Rig", rod = "Halcyon" },
    { name = "Giant Donko", skill = 50, location = "Rabao, E. Altepa Desert (oasis)", bait = "Frog Lure, Trout Ball", rod = "Composite" },
    { name = "Bluetail", skill = 55, location = "Qufim Island, W. Sarutabaruta", bait = "Minnow, Sliced Sardine", rod = "Composite" },
    { name = "Gold Carp", skill = 56, location = "Windurst Waters, E. Sarutabaruta (pond)", bait = "Insect Paste, Little Worm", rod = "Halcyon" },
    { name = "Elshimo Newt", skill = 60, location = "Yhoator Jungle (pool)", bait = "Frog Lure", rod = "Halcyon" },
    { name = "Bhefhel Marlin", skill = 61, location = "Mhaura/Selbina Ferry", bait = "Slice of Bluetail", rod = "Composite" },
    { name = "Noble Lady", skill = 66, location = "Mhaura/Selbina Ferry", bait = "Minnow, Shrimp Lure", rod = "Composite" },
    { name = "Crescent Fish", skill = 69, location = "E. Sarutabaruta (lake), Dragon's Aery", bait = "Fly Lure, Minnow", rod = "Halcyon" },
    { name = "Zebra Eel", skill = 70, location = "Den of Rancor", bait = "Shrimp Lure, Frog Lure", rod = "Composite" },
    { name = "Bladefish", skill = 71, location = "S. Gustaberg (sea), E./W. Sarutabaruta (sea)", bait = "Meatball, Slice of Bluetail", rod = "Composite" },
    { name = "Silver Shark", skill = 76, location = "Mhaura/Selbina Ferry", bait = "Slice of Bluetail", rod = "Lu Shang's" },
    { name = "Gavial Fish", skill = 81, location = "N. Gustaberg (Drachenfall)", bait = "Frog Lure, Meatball", rod = "Composite, Lu Shang's" },
    { name = "Bastore Bream", skill = 86, location = "Port Windurst, Port Bastok", bait = "Shrimp Lure", rod = "Composite" },
    --{ name = "Mercanbaligi", skill = 86, location = "Nashmau", bait = "Shrimp Lure", rod = "Lu Shang's" },
    --{ name = "Ahtapot", skill = 90, location = "Nashmau", bait = "Shrimp Lure, Lugworm", rod = "Lu Shang's" },
    --{ name = "Gigant Squid", skill = 91, location = "Nashmau", bait = "Lugworm", rod = "Lu Shang's" },
    { name = "Emperor Fish", skill = 91, location = "Beaucedine Glacier (pond)", bait = "Trout Ball, Peeled Crayfish", rod = "Lu Shang's" },
    { name = "Black Sole", skill = 96, location = "Qufim Island (Ice Pond), Port Jeuno", bait = "Sinking Minnow, Sliced Cod", rod = "Lu Shang's" },
    --{ name = "Dil", skill = 96, location = "Talacca Cove", bait = "Sliced Cod", rod = "Lu Shang's" },
    --{ name = "Pterygotus", skill = 99, location = "Nashmau", bait = "Lugworm", rod = "Lu Shang's" },
    { name = "Takitaro", skill = 100, location = "N. Gustaberg, Tahrongi Canyon", bait = "Frog Lure, Minnow", rod = "Lu Shang's" },
    { name = "Ryugu Titan", skill = 100, location = "Mhaura/Selbina Ferry", bait = "Meatball", rod = "Lu Shang's" },
	{ name = "Armored Pisces", skill = 108, location = "Oldton Movalpolos", bait = "Frog Lure", rod = "Composite, Lu Shang's" },
}

-- Hook and feel messages
local hookMessages = {
    { message='Something caught the hook!!!', hook='Large Fish', color='|cFF00FF00|', logcolor=204 },
    { message='Something caught the hook!', hook='Small Fish', color='|cFF00FF00|', logcolor=204 },
    { message='You feel something pulling at your line.', hook='Item', color='|cFFFFFF00|', logcolor=141 },
    { message='Something clamps onto your line ferociously!', hook='Monster', color='|cFFFF0000|', logcolor=167 },
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

-- Helper function to build stats cache
local function build_stats_cache(sourceData, cacheData)
    -- Fish caught
    cacheData.totalFish = 0
    cacheData.fishList = {}
    for fish, count in pairs(sourceData.fishCaught) do
        cacheData.totalFish = cacheData.totalFish + count
        table.insert(cacheData.fishList, {name = fish, count = count})
    end
    table.sort(cacheData.fishList, function(a, b) return a.count > b.count end)
    
    -- Bait used
    cacheData.baitList = {}
    for bait, count in pairs(sourceData.baitUsed) do
        table.insert(cacheData.baitList, {name = bait, count = count})
    end
    table.sort(cacheData.baitList, function(a, b) return a.count > b.count end)
end

local function build_filter_options()
    if not filterOptionsCache.dirty then
        return
    end
    
    -- Reset
    filterOptionsCache.baits = {"All"}
    filterOptionsCache.locations = {"All"}
    local baitSet = {}
    local locationSet = {}
    
    -- Extract unique baits and locations from fishing guide
    for _, fish in ipairs(fishingGuide) do
        -- Parse baits (comma-separated)
        for bait in fish.bait:gmatch("[^,]+") do
            bait = bait:match("^%s*(.-)%s*$") -- trim
            if not baitSet[bait] then
                baitSet[bait] = true
                table.insert(filterOptionsCache.baits, bait)
            end
        end
        
        -- Parse locations (comma-separated)
        for location in fish.location:gmatch("[^,]+") do
            location = location:match("^%s*(.-)%s*$") -- trim
            if not locationSet[location] then
                locationSet[location] = true
                table.insert(filterOptionsCache.locations, location)
            end
        end
    end
    
    -- Sort alphabetically
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

-- Build guide filter options
local function build_guide_filter_options()
    if not guideFilterOptionsCache.dirty then
        return
    end
    
    -- Reset
    guideFilterOptionsCache.baits = {"All"}
    guideFilterOptionsCache.locations = {"All"}
    local baitSet = {}
    local locationSet = {}
    
    -- Extract unique baits and locations from fishing guide
    for _, fish in ipairs(fishingGuide) do
        -- Parse baits (comma-separated)
        for bait in fish.bait:gmatch("[^,]+") do
            bait = bait:match("^%s*(.-)%s*$") -- trim
            if not baitSet[bait] then
                baitSet[bait] = true
                table.insert(guideFilterOptionsCache.baits, bait)
            end
        end
        
        -- Parse locations (comma-separated)
        for location in fish.location:gmatch("[^,]+") do
            location = location:match("^%s*(.-)%s*$") -- trim
            if not locationSet[location] then
                locationSet[location] = true
                table.insert(guideFilterOptionsCache.locations, location)
            end
        end
    end
    
    -- Sort alphabetically
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

-- Check if fish has been caught
local function has_caught_fish(fishName)
    -- Check exact match first
    if data.state.lifetime.fishCaught[fishName] and data.state.lifetime.fishCaught[fishName] > 0 then
        return true
    end
    
    -- Try case-insensitive match
    local lowerFishName = fishName:lower()
    for caughtFish, count in pairs(data.state.lifetime.fishCaught) do
        if caughtFish:lower() == lowerFishName and count > 0 then
            return true
        end
    end
    
    return false
end

-- Check if fish matches skill range filter
local function matches_skill_range(skill, range)
    if range == "All" then return true end
    
    if range == "0-10" then return skill >= 0 and skill <= 10
    elseif range == "11-20" then return skill >= 11 and skill <= 20
    elseif range == "21-30" then return skill >= 21 and skill <= 30
    elseif range == "31-40" then return skill >= 31 and skill <= 40
    elseif range == "41-50" then return skill >= 41 and skill <= 50
    elseif range == "51-60" then return skill >= 51 and skill <= 60
    elseif range == "61-70" then return skill >= 61 and skill <= 70
    elseif range == "71-80" then return skill >= 71 and skill <= 80
    elseif range == "81-90" then return skill >= 81 and skill <= 90
    elseif range == "91-100" then return skill >= 91 and skill <= 100
    elseif range == "100+" then return skill > 100
    end
    
    return false
end

-- Get filtered guide with all filters applied
local function get_filtered_guide_enhanced()
    -- Check if cache is valid
    if guideFilterCache.lastBait == guideFilters.bait and
       guideFilterCache.lastLocation == guideFilters.location and
       guideFilterCache.lastSkillRange == guideFilters.skillRange and
       guideFilterCache.lastShowUncaught == guideFilters.showUncaught then
        return guideFilterCache.filteredList, guideFilterCache.totalFish, guideFilterCache.totalCaught
    end
    
    -- Update cache keys
    guideFilterCache.lastBait = guideFilters.bait
    guideFilterCache.lastLocation = guideFilters.location
    guideFilterCache.lastSkillRange = guideFilters.skillRange
    guideFilterCache.lastShowUncaught = guideFilters.showUncaught
    guideFilterCache.filteredList = {}
    guideFilterCache.totalFish = #fishingGuide
    guideFilterCache.totalCaught = 0
    
    for _, fish in ipairs(fishingGuide) do
        local include = true
        local caught = has_caught_fish(fish.name)
        
        -- Count total caught
        if caught then
            guideFilterCache.totalCaught = guideFilterCache.totalCaught + 1
        end
        
        -- Check bait filter
        if guideFilters.bait ~= "All" then
            if not fish.bait:find(guideFilters.bait, 1, true) then
                include = false
            end
        end
        
        -- Check location filter
        if include and guideFilters.location ~= "All" then
            if not fish.location:find(guideFilters.location, 1, true) then
                include = false
            end
        end
        
        -- Check skill range filter
        if include and guideFilters.skillRange ~= "All" then
            if not matches_skill_range(fish.skill, guideFilters.skillRange) then
                include = false
            end
        end
        
        -- Check show uncaught filter
        if include and not guideFilters.showUncaught and not caught then
            include = false
        end
        
        if include then
            table.insert(guideFilterCache.filteredList, {
                fish = fish,
                caught = caught
            })
        end
    end
    
    return guideFilterCache.filteredList, guideFilterCache.totalFish, guideFilterCache.totalCaught
end

-- Reset all guide filters
local function reset_guide_filters()
    guideFilters.bait = "All"
    guideFilters.location = "All"
    guideFilters.skillRange = "All"
    guideFilters.showUncaught = true
end

-- Render dropdown combo for ImGui
local function render_combo(label, options, currentValue, onSelect)
    if imgui.BeginCombo(label, currentValue) then
        for _, option in ipairs(options) do
            local isSelected = (currentValue == option)
            if imgui.Selectable(option, isSelected) then
                onSelect(option)
            end
            if isSelected then
                imgui.SetItemDefaultFocus()
            end
        end
        imgui.EndCombo()
    end
end

-- Get fish info from guide
local function get_fish_info(fishName)
    for _, fish in ipairs(fishingGuide) do
        if fish.name == fishName then
            return fish
        end
    end
    return nil
end

-- Check if fish matches current filters
local function fish_matches_filters(fishName)
    local fishInfo = get_fish_info(fishName)
    
    -- If fish not in guide, only show if "All" is selected for everything
    if not fishInfo then
        return statsFilters.bait == "All" and 
               statsFilters.location == "All" and 
               statsFilters.skillRange == "All"
    end
    
    -- Check bait filter
    if statsFilters.bait ~= "All" then
        if not fishInfo.bait:find(statsFilters.bait, 1, true) then
            return false
        end
    end
    
    -- Check location filter
    if statsFilters.location ~= "All" then
        if not fishInfo.location:find(statsFilters.location, 1, true) then
            return false
        end
    end
    
    -- Check skill range filter
    if statsFilters.skillRange ~= "All" then
        local skill = fishInfo.skill
        local range = statsFilters.skillRange
        
        if range == "0-10" and (skill < 0 or skill > 10) then return false
        elseif range == "11-20" and (skill < 11 or skill > 20) then return false
        elseif range == "21-30" and (skill < 21 or skill > 30) then return false
        elseif range == "31-40" and (skill < 31 or skill > 40) then return false
        elseif range == "41-50" and (skill < 41 or skill > 50) then return false
        elseif range == "51-60" and (skill < 51 or skill > 60) then return false
        elseif range == "61-70" and (skill < 61 or skill > 70) then return false
        elseif range == "71-80" and (skill < 71 or skill > 80) then return false
        elseif range == "81-90" and (skill < 81 or skill > 90) then return false
        elseif range == "91-100" and (skill < 91 or skill > 100) then return false
        elseif range == "100+" and skill <= 100 then return false
        end
    end
    
    return true
end


local function clean_fish_name(fishname)
    if not fishname then return "" end

    -- Remove control characters (non-printable ASCII)
    local cleaned = fishname:gsub("[%z\1-\31\127]", "")

    -- Remove game formatting leftovers like "!1", "!2", "!1", etc.
    cleaned = cleaned:gsub("!%p?%d+", "")
    cleaned = cleaned:gsub("!%d+", "")

    -- Trim spaces and punctuation from both ends
    cleaned = cleaned:gsub("^%s+", "")
    cleaned = cleaned:gsub("%s+$", "")
    cleaned = cleaned:gsub("[!?.]+$", "")

    return cleaned
end

-- Convert color code to ImGui ABGR format
local function parse_color(colorString)
    if not colorString then return 0xFFFFFFFF end
    local hex = colorString:match("|c(F+%x+)|")
    if not hex then return 0xFFFFFFFF end
    
    -- Parse ARGB format (what's in your color strings)
    local num = tonumber("0x" .. hex)
    if not num then return 0xFFFFFFFF end
    
    -- Extract ARGB components
    local a = bit.band(bit.rshift(num, 24), 0xFF)
    local r = bit.band(bit.rshift(num, 16), 0xFF)
    local g = bit.band(bit.rshift(num, 8), 0xFF)
    local b = bit.band(num, 0xFF)
    
    -- Convert to ImGui ABGR format
    return bit.bor(
        bit.lshift(a, 24),
        bit.lshift(b, 16),
        bit.lshift(g, 8),
        r
    )
end

-- Update playerName with character name
local function update_player_name()
    local partyMgr = AshitaCore:GetMemoryManager():GetParty()
    if partyMgr then
        local pname = partyMgr:GetMemberName(0)
        if pname and pname ~= '' then playerName = pname end
    end
end

-- Detect Equipped Bait
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

-- Detect Equipped Rod
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

-- Reset fishing session
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
    windowPosSet = false
    
    -- Mark stats as dirty so they'll be rebuilt next time
    statsCache.dailyDirty = true
    statsCache.lifetimeDirty = true
end

-- Load & Unload
ashita.events.register('load', 'load_cb', function()
    update_player_name()
    state.Settings = settings.load(defaults)
    state.Font = fonts.new(state.Settings.Font)
    
    -- Build filter options on startup
    build_filter_options()
    build_guide_filter_options()
    
    -- Set up callback to mark cache as dirty when daily reset occurs
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

-- Text handling
ashita.events.register('text_in', 'anglin_HandleText', function(e)
    if e.injected then return end
    
    -- Update player name if needed
    if not playerName then
        update_player_name()
    end
    
    local msg = e.message
    
    -- Strip any color codes or special characters for matching
    local cleanMsg = msg:gsub("|[cC]%x+|", ""):gsub("[%z\1-\31\127]", "")

    -- 1. Check for HOOK messages (start of fishing)
    for _, entry in ipairs(hookMessages) do
        if cleanMsg:find(entry.message, 1, true) then
            state.Hook = entry.hook
            state.HookColor = parse_color(entry.color)
            state.Active = true
            detect_bait()
            detect_rod()
            state.BaitBeforeCast = state.CurrentBait
            if state.CurrentBait and state.CurrentBait ~= 'None' and state.CurrentBait ~= 'Unknown' then
                data.record_bait_used(state.CurrentBait, 1)
            end
            return
        end
    end

    -- 2. Check for FEEL messages (difficulty indicator)
    for _, entry in ipairs(feelMessages) do
        if cleanMsg:find(entry.message, 1, true) then
            state.Feel = entry.feel
            state.FeelColor = parse_color(entry.color)
            return
        end
    end

    -- 3. Check for CAUGHT messages (what you actually caught)
    if playerName then
        -- Multi-catch: "PlayerName caught 2 FishName"
        local count, fishName = cleanMsg:match(playerName .. ' caught (%d+) (.+)')
        if count and fishName then
            fishName = clean_fish_name(fishName)
            state.Fish = fishName
            state.CatchCount = tonumber(count)
            data.record_fish(fishName, state.CatchCount)
            
            if state.BaitBeforeCast and state.CurrentBaitType and state.CurrentBaitType.consumable then
                data.record_bait_consumed(state.BaitBeforeCast, state.CatchCount)
            end
            
            state.CloseTime = os.clock() + 3.0
            return
        end

        -- Single catch: "PlayerName caught a FishName" or "PlayerName caught an FishName"
        local fishName = cleanMsg:match(playerName .. ' caught an? (.+)')
        if fishName then
            fishName = clean_fish_name(fishName)
            state.Fish = fishName
            state.CatchCount = 1
            data.record_fish(fishName, 1)
            
            if state.BaitBeforeCast and state.CurrentBaitType and state.CurrentBaitType.consumable then
                data.record_bait_consumed(state.BaitBeforeCast, 1)
            end
            
            state.CloseTime = os.clock() + 3.0
            return
        end
    end

    -- 4. Check for bait/lure lost messages
    if cleanMsg:find('line snaps', 1, true) or cleanMsg:find('lost your catch', 1, true) then
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

    -- 5. Check for rod break messages
    if cleanMsg:find('rod breaks', 1, true) then
        if state.CurrentRod and state.CurrentRod ~= 'None' and state.CurrentRod ~= 'Unknown' then
            data.record_rod_break(state.CurrentRod)
        end
        reset_fishing_session()
        return
    end

    -- 6. Check for line snap/break (lost fish)
    if cleanMsg:find('line snaps', 1, true) then
        if state.BaitBeforeCast and state.CurrentBaitType then
            if state.CurrentBaitType.consumable then
                data.record_bait_lost(state.BaitBeforeCast, 1)
            end
        end
        reset_fishing_session()
        return
    end

    -- 7. Check for cancelled cast
    if cleanMsg:find('You didn\'t catch anything', 1, true) or 
       cleanMsg:find('You give up fishing', 1, true) or
       cleanMsg:find('The fish got away', 1, true) then
        reset_fishing_session()
        return
    end
	
end)

-- Command handler
ashita.events.register('command', 'anglin_command', function(e)
    local args = e.command:args()
    if (#args == 0 or args[1]:lower() ~= '/anglin') then return end
    e.blocked = true

    if (#args == 1) then
        AshitaCore:GetChatManager():QueueCommand(1, '/echo Usage: /anglin test | /anglin stats | /anglin settings | /anglin guide')
        return
    end

    local subcmd = args[2]:lower()
    
    if subcmd == 'test' then
        detect_bait()
        detect_rod()
        AshitaCore:GetChatManager():QueueCommand(1, string.format(
            '/echo Current Bait: %s | Rod: %s', state.CurrentBait or 'Unknown', state.CurrentRod or 'Unknown'))
    
    elseif subcmd == 'debug' then
        AshitaCore:GetChatManager():QueueCommand(1, '/echo === Caught Fish (Lifetime) ===')
        local count = 0
        for fishName, fishCount in pairs(data.state.lifetime.fishCaught) do
            AshitaCore:GetChatManager():QueueCommand(1, string.format('/echo [%s] = %d', fishName, fishCount))
            count = count + 1
        end
        if count == 0 then
            AshitaCore:GetChatManager():QueueCommand(1, '/echo No fish caught yet')
        end
    
    elseif subcmd == 'stats' then
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

-- ImGui Render
ashita.events.register('d3d_present', 'anglin_render', function()
    
    -- Fishing Guide window
    if showGuide then
        build_guide_filter_options()
        
        imgui.SetNextWindowSize({ 800, 700 }, ImGuiCond_FirstUseEver)
        if imgui.Begin("Fishing Guide", true, ImGuiWindowFlags_NoCollapse) then
            
            -- Filter Controls Section
            imgui.Text("Filters:")
            imgui.Separator()
            
            -- Row 1: Bait and Location dropdowns
            imgui.Text("Bait:")
            imgui.SameLine()
            imgui.PushItemWidth(200)
            render_combo("##BaitFilter", guideFilterOptionsCache.baits, guideFilters.bait, function(selected)
                guideFilters.bait = selected
            end)
            imgui.PopItemWidth()
            
            imgui.SameLine()
            imgui.Dummy({20, 0})
            imgui.SameLine()
            
            imgui.Text("Location:")
            imgui.SameLine()
            imgui.PushItemWidth(200)
            render_combo("##LocationFilter", guideFilterOptionsCache.locations, guideFilters.location, function(selected)
                guideFilters.location = selected
            end)
            imgui.PopItemWidth()
            
            -- Row 2: Skill Range and Show Uncaught
            imgui.Text("Skill Range:")
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
            
            -- Row 3: Reset button
            if imgui.Button("Reset Filters") then
                reset_guide_filters()
            end
            
            imgui.Separator()
            
            -- Get filtered results
            local filteredList, totalFish, totalCaught = get_filtered_guide_enhanced()
            
            -- Filter Status Display
            imgui.Text(string.format("Showing %d/%d fish (Total Caught: %d)", 
                #filteredList, totalFish, totalCaught))
            
            imgui.Separator()
            
            -- Scrollable Fish List
            if imgui.BeginChild("GuideList", { 0, -40 }, true) then
                for _, entry in ipairs(filteredList) do
                    local fish = entry.fish
                    local caught = entry.caught
                    
                    -- Display fish name with skill, gray out if uncaught
                    local displayName = string.format("%s (Skill: %d)", fish.name, fish.skill)
                    
                    if not caught then
                        imgui.PushStyleColor(ImGuiCol_Text, 0xFF808080) -- Gray for uncaught
                    end
                    
                    if imgui.CollapsingHeader(displayName) then
                        imgui.Indent()
                        
                        -- Show catch count if caught
                         -- Show catch count if caught
                        if caught then
                            -- Try exact match first, then try all stored fish names
                            local catchCount = 0
                            for caughtFish, count in pairs(data.state.lifetime.fishCaught) do
                                if caughtFish:lower() == fish.name:lower() then
                                    catchCount = catchCount + count
                                end
                            end
                            imgui.TextColored({0.0, 1.0, 0.0, 1.0}, string.format("Caught: %d times", catchCount))
                        else
                            imgui.TextColored({1.0, 0.5, 0.0, 1.0}, "Not yet caught")
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
                    
                    -- Tooltip on hover
                    if imgui.IsItemHovered() then
                        imgui.BeginTooltip()
                        imgui.Text(fish.name)
                        imgui.Separator()
                        imgui.Text(string.format("Skill: %d", fish.skill))
                        imgui.Text(string.format("Location: %s", fish.location))
                        imgui.Text(string.format("Bait: %s", fish.bait))
                        imgui.Text(string.format("Rod: %s", fish.rod))
                        if caught then
                            local catchCount = data.state.lifetime.fishCaught[fish.name] or 0
                            imgui.Separator()
                            imgui.TextColored({0.0, 1.0, 0.0, 1.0}, string.format("Caught: %d times", catchCount))
                        end
                        imgui.EndTooltip()
                    end
                end
                
                if #filteredList == 0 then
                    imgui.TextDisabled("No fish match the current filters.")
                end
                
                imgui.EndChild()
            end
            
            imgui.Separator()
            if imgui.Button("Close") then
                showGuide = false
            end
            
            imgui.End()
        else
            showGuide = false
        end
    end
    
    -- Stats window
    if showStats then
        imgui.SetNextWindowSize({ 500, 600 }, ImGuiCond_FirstUseEver)
        if imgui.Begin("Anglin Statistics", true, ImGuiWindowFlags_NoCollapse) then
            if imgui.BeginTabBar("StatsTabBar") then
                -- Daily Stats Tab
                if imgui.BeginTabItem("Daily") then
                    activeStatsTab = "Daily"
                    -- Build cache if dirty
                    if statsCache.dailyDirty then
                        build_stats_cache(data.state.daily, statsCache.dailyData)
                        statsCache.dailyDirty = false
                    end
                    
                    local dailyData = statsCache.dailyData
                    
                    imgui.Text(string.format("Date: %s", data.state.daily.date or "Unknown"))
                    imgui.Separator()
                    
                    -- Fish Caught
                    if imgui.CollapsingHeader("Fish Caught", ImGuiTreeNodeFlags_DefaultOpen) then
                        imgui.Text(string.format("Total: %d", dailyData.totalFish))
                        imgui.Separator()
                        for _, entry in ipairs(dailyData.fishList) do
                            imgui.BulletText(string.format("%s: %d", entry.name, entry.count))
                        end
                        if dailyData.totalFish == 0 then
                            imgui.TextDisabled("No fish caught today")
                        end
                    end
                    
                    -- Bait Used
                    if imgui.CollapsingHeader("Bait Used") then
                        for _, entry in ipairs(dailyData.baitList) do
                            local consumed = data.state.daily.baitConsumed[entry.name] or 0
                            local lost = data.state.daily.baitLost[entry.name] or 0
                            imgui.BulletText(string.format("%s: %d casts (%d consumed, %d lost)", 
                                entry.name, entry.count, consumed, lost))
                        end
                        if #dailyData.baitList == 0 then
                            imgui.TextDisabled("No bait used today")
                        end
                    end
                    
                    -- Lures Lost
                    if imgui.CollapsingHeader("Lures Lost") then
                        local hasLures = false
                        for lure, count in pairs(data.state.daily.lureLost) do
                            imgui.BulletText(string.format("%s: %d", lure, count))
                            hasLures = true
                        end
                        if not hasLures then
                            imgui.TextDisabled("No lures lost today")
                        end
                    end
                    
                    -- Rods Broken
                    if imgui.CollapsingHeader("Rods Broken") then
                        local hasRods = false
                        for rod, count in pairs(data.state.daily.rodBreaks) do
                            imgui.BulletText(string.format("%s: %d", rod, count))
                            hasRods = true
                        end
                        if not hasRods then
                            imgui.TextDisabled("No rods broken today")
                        end
                    end
                    
                    imgui.EndTabItem()
                end
                
                -- Lifetime Stats Tab
                if imgui.BeginTabItem("Lifetime") then
                    activeStatsTab = "Lifetime"
                    -- Build cache if dirty
                    if statsCache.lifetimeDirty then
                        build_stats_cache(data.state.lifetime, statsCache.lifetimeData)
                        statsCache.lifetimeDirty = false
                    end
                    
                    local lifetimeData = statsCache.lifetimeData
                    
                    -- Fish Caught
                    if imgui.CollapsingHeader("Fish Caught", ImGuiTreeNodeFlags_DefaultOpen) then
                        imgui.Text(string.format("Total: %d", lifetimeData.totalFish))
                        imgui.Separator()
                        for _, entry in ipairs(lifetimeData.fishList) do
                            imgui.BulletText(string.format("%s: %d", entry.name, entry.count))
                        end
                        if lifetimeData.totalFish == 0 then
                            imgui.TextDisabled("No fish caught yet")
                        end
                    end
                    
                    -- Bait Used
                    if imgui.CollapsingHeader("Bait Used") then
                        for _, entry in ipairs(lifetimeData.baitList) do
                            local consumed = data.state.lifetime.baitConsumed[entry.name] or 0
                            local lost = data.state.lifetime.baitLost[entry.name] or 0
                            imgui.BulletText(string.format("%s: %d casts (%d consumed, %d lost)", 
                                entry.name, entry.count, consumed, lost))
                        end
                        if #lifetimeData.baitList == 0 then
                            imgui.TextDisabled("No bait used yet")
                        end
                    end
                    
                    -- Lures Lost
                    if imgui.CollapsingHeader("Lures Lost") then
                        local hasLures = false
                        for lure, count in pairs(data.state.lifetime.lureLost) do
                            imgui.BulletText(string.format("%s: %d", lure, count))
                            hasLures = true
                        end
                        if not hasLures then
                            imgui.TextDisabled("No lures lost yet")
                        end
                    end
                    
                    -- Rods Broken
                    if imgui.CollapsingHeader("Rods Broken") then
                        local hasRods = false
                        for rod, count in pairs(data.state.lifetime.rodBreaks) do
                            imgui.BulletText(string.format("%s: %d", rod, count))
                            hasRods = true
                        end
                        if not hasRods then
                            imgui.TextDisabled("No rods broken yet")
                        end
                    end
                    
                    imgui.EndTabItem()
                end
                
                imgui.EndTabBar()
            end
            
            imgui.Separator()
            
            -- Bottom buttons row
            if imgui.Button("Close", { 100, 0 }) then
                showStats = false
            end
            
            imgui.SameLine()
            
            -- Show reset button based on active tab
            imgui.PushStyleColor(ImGuiCol_Button, 0xFF0000AA)
            imgui.PushStyleColor(ImGuiCol_ButtonHovered, 0xFF0000CC)
            imgui.PushStyleColor(ImGuiCol_ButtonActive, 0xFF0000FF)
            
            if activeStatsTab == "Daily" then
                if imgui.Button("Reset Daily", { 100, 0 }) then
                    data.reset_daily_stats()
                    statsCache.dailyDirty = true
                    AshitaCore:GetChatManager():QueueCommand(1, '/echo Daily stats have been reset!')
                end
            elseif activeStatsTab == "Lifetime" then
                if imgui.Button("Reset Lifetime", { 100, 0 }) then
                    data.reset_lifetime_stats()
                    statsCache.lifetimeDirty = true
                    AshitaCore:GetChatManager():QueueCommand(1, '/echo Lifetime stats have been reset!')
                end
            end
            
            imgui.PopStyleColor(3)
            
            imgui.End()
        else
            showStats = false
        end
    end
    
    -- Settings window
    if showSettings then
        imgui.SetNextWindowSize({ 300, 150 }, ImGuiCond_FirstUseEver)
        if imgui.Begin("Anglin Settings", true, ImGuiWindowFlags_NoCollapse) then
            imgui.Text("Window Transparency")
            local transparency = { state.Settings.WindowTransparency }
            if imgui.SliderFloat("##transparency", transparency, 0.0, 1.0, "%.2f") then
                state.Settings.WindowTransparency = transparency[1]
                settings.save(state.Settings)
            end
            
            imgui.Spacing()
            imgui.TextWrapped("0.0 = Fully Transparent\n1.0 = Fully Opaque")
            imgui.Spacing()
            imgui.Text(string.format("Current: %.2f", state.Settings.WindowTransparency))
            
            imgui.Spacing()
            if imgui.Button("Close Settings") then
                showSettings = false
            end
            
            imgui.End()
        else
            showSettings = false
        end
        
        -- Show preview window when settings are open
        local bgAlpha = state.Settings.WindowTransparency
        local bgColor = bit.bor(
            bit.lshift(math.floor(bgAlpha * 255), 24),
            0x00000000
        )
        imgui.PushStyleColor(ImGuiCol_WindowBg, bgColor)
        imgui.PushStyleColor(ImGuiCol_Text, 0xFFFFFFFF)
        
        imgui.SetNextWindowSize({ 300, 0 }, ImGuiCond_Always)
        imgui.Begin("Anglin Status (Preview)", true, bit.bor(ImGuiWindowFlags_NoCollapse, ImGuiWindowFlags_AlwaysAutoResize, ImGuiWindowFlags_NoFocusOnAppearing))

        imgui.PushFont(nil)
        imgui.SetWindowFontScale(1.2)

        imgui.Text("Hook Type: Large Fish")
        imgui.Text("Feeling: Good")
        imgui.Text("Caught: Example Fish")
        
        imgui.Separator()
        imgui.Text("Rod: Lu Shang's Fishing Rod")
        imgui.Text("Bait: Lugworm")

        imgui.PopFont()

        imgui.End()
        imgui.PopStyleColor(2)
    end

    if not state.Active then return end

    -- Check if it's time to auto-close after catching a fish
    if state.CloseTime and state.Fish then
        local currentTime = os.clock()
        if currentTime >= state.CloseTime then
            reset_fishing_session()
            return
        end
    end

    -- Set window alpha based on user settings
    local bgAlpha = state.Settings.WindowTransparency
    local bgColor = bit.bor(
        bit.lshift(math.floor(bgAlpha * 255), 24),
        0x00000000
    )
    imgui.PushStyleColor(ImGuiCol_WindowBg, bgColor)
    imgui.PushStyleColor(ImGuiCol_Text, 0xFFFFFFFF)
    
    if not windowPosSet then
        imgui.SetNextWindowPos({ windowPosX, windowPosY })
        windowPosSet = true
    end

    imgui.SetNextWindowSize({ 300, 0 }, ImGuiCond_Always)
    imgui.Begin("Anglin Status", true, bit.bor(ImGuiWindowFlags_NoCollapse, ImGuiWindowFlags_AlwaysAutoResize))

    imgui.PushFont(nil)
    imgui.SetWindowFontScale(1.2)

    -- Display hook type with color
    if state.Hook then
        imgui.Text("Hook Type: ")
        imgui.SameLine()
        if state.HookColor then
            imgui.PushStyleColor(ImGuiCol_Text, state.HookColor)
        end
        imgui.Text(state.Hook)
        if state.HookColor then
            imgui.PopStyleColor()
        end
    else
        imgui.Text("Hook Type: Waiting...")
    end
    
    -- Display feeling with color
    if state.Feel then
        imgui.Text("Feeling: ")
        imgui.SameLine()
        if state.FeelColor then
            imgui.PushStyleColor(ImGuiCol_Text, state.FeelColor)
        end
        imgui.Text(state.Feel)
        if state.FeelColor then
            imgui.PopStyleColor()
        end
    else
        imgui.Text("Feeling: Waiting...")
    end
    
    if state.Fish then
        local displayFish = clean_fish_name(state.Fish)
        
        if state.CatchCount > 1 then
            imgui.Text(string.format("Caught: %dx %s", state.CatchCount, displayFish))
        else
            imgui.Text(string.format("Caught: %s", displayFish))
        end
    else
        imgui.Text("Caught: Fishing...")
    end
    
    imgui.Separator()
    imgui.Text(string.format("Rod: %s", state.CurrentRod or "None"))
    imgui.Text(string.format("Bait: %s", state.CurrentBait or "None"))

    if imgui.Button("Close") then
        reset_fishing_session()
    end

    imgui.PopFont()

    local posX, posY = imgui.GetWindowPos()
    windowPosX = posX
    windowPosY = posY

    imgui.End()
    imgui.PopStyleColor(2)
end)

-- Periodic check for daily reset
ashita.events.register('d3d_present', 'anglin_daily_check', function()
    local currentTime = os.time()
    if currentTime - lastDailyCheck >= 1 then
        lastDailyCheck = currentTime
        data.check_daily_reset()
    end
end)