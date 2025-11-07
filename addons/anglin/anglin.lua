addon.name      = 'anglin'
addon.author    = 'Astika'
addon.version   = '1.1'
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
local guideFilterSkill = 0  -- 0 = All, 1 = 0-10, 2 = 11-20, etc.
local activeStatsTab = "Daily"  -- Track which stats tab is active

-- Cache for filtered guide results
local guideCache = {
    lastFilter = -1,
    filteredList = {}
}

-- Cache for stats display
local statsCache = {
    dailyDirty = true,
    lifetimeDirty = true,
    dailyData = {},
    lifetimeData = {}
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
    { message='You feel something pulling at your line.', hook='Item', color='|cFF999900|', logcolor=141 },
    { message='Something clamps onto your line ferociously!', hook='Monster', color='|cffff0000|', logcolor=167 },
}

local feelMessages = {
    { message='This strength... You get the sense that you are on the verge of an epic catch!', feel='EPIC!', color='|cff0000ff|', logcolor=204 },
    { message='Your keen angler\'s senses tell you that this is the pull of', feel='Great', color='|cFF00FF00|', logcolor=204 },
    { message='You have a good feeling about this one!', feel='Good', color='|cFF00FF00|', logcolor=204 },
    { message='You have a bad feeling about this one.', feel='Bad', color='|cFF999900|', logcolor=141 },
    { message='You have a terrible feeling about this one...', feel='Terrible', color='|cFF8B0000|', logcolor=167 },
    { message='You don\'t know if you have enough skill to reel this one in.', feel='Low Skill', color='|cFF00FF00|', logcolor=204 },
    { message='You\'re fairly sure you don\'t have enough skill to reel this one in.', feel='Very Low Skill', color='|cFF999900|', logcolor=141 },
    { message='You\'re positive you don\'t have enough skill to reel this one in!', feel='Extremely Low Skill', color='|cFF8B0000|', logcolor=167 },
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

-- Helper function to filter fishing guide
local function get_filtered_guide()
    if guideCache.lastFilter == guideFilterSkill then
        return guideCache.filteredList
    end
    
    guideCache.lastFilter = guideFilterSkill
    guideCache.filteredList = {}
    
    for _, fish in ipairs(fishingGuide) do
        local include = false
        if guideFilterSkill == 0 then
            include = true
        elseif guideFilterSkill == 1 and fish.skill >= 0 and fish.skill <= 10 then
            include = true
        elseif guideFilterSkill == 2 and fish.skill >= 11 and fish.skill <= 20 then
            include = true
        elseif guideFilterSkill == 3 and fish.skill >= 21 and fish.skill <= 30 then
            include = true
        elseif guideFilterSkill == 4 and fish.skill >= 31 and fish.skill <= 40 then
            include = true
        elseif guideFilterSkill == 5 and fish.skill >= 41 and fish.skill <= 50 then
            include = true
        elseif guideFilterSkill == 6 and fish.skill >= 51 and fish.skill <= 60 then
            include = true
        elseif guideFilterSkill == 7 and fish.skill >= 61 and fish.skill <= 70 then
            include = true
        elseif guideFilterSkill == 8 and fish.skill >= 71 and fish.skill <= 80 then
            include = true
        elseif guideFilterSkill == 9 and fish.skill >= 81 and fish.skill <= 90 then
            include = true
        elseif guideFilterSkill == 10 and fish.skill >= 91 and fish.skill <= 100 then
            include = true
        elseif guideFilterSkill == 11 and fish.skill > 100 then
            include = true
        end
        
        if include then
            table.insert(guideCache.filteredList, fish)
        end
    end
    
    return guideCache.filteredList
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

-- Convert color code to hex to add color to status window
local function parse_color(colorString)
    if not colorString then return 0xFFFFFFFF end
    local hex = colorString:match("|c(F+%x+)|")
    return hex and tonumber("0x" .. hex) or 0xFFFFFFFF
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
    
    -- Mark stats as dirty so they'll be rebuilt next time
    statsCache.dailyDirty = true
    statsCache.lifetimeDirty = true
end

-- Load & Unload
ashita.events.register('load', 'load_cb', function()
    update_player_name()
    state.Settings = settings.load(defaults)
    state.Font = fonts.new(state.Settings.Font)
    
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
    if e.injected or not playerName then return end
    local msg = e.message

    -- 1. Check for HOOK messages (start of fishing)
    for _, entry in ipairs(hookMessages) do
        if msg:find(entry.message, 1, true) then
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
        if msg:find(entry.message, 1, true) then
            state.Feel = entry.feel
            state.FeelColor = parse_color(entry.color)
            return
        end
    end

    -- 3. Check for CAUGHT messages (what you actually caught)
    if playerName then
        -- Multi-catch: "PlayerName caught 2 FishName"
        local count, fishName = msg:match(playerName .. ' caught (%d+) (.+)')
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
        local fishName = msg:match(playerName .. ' caught an? (.+)')
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
    if msg:find('line snaps', 1, true) or msg:find('lost your catch', 1, true) then
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
    if msg:find('rod breaks', 1, true) then
        if state.CurrentRod and state.CurrentRod ~= 'None' and state.CurrentRod ~= 'Unknown' then
            data.record_rod_break(state.CurrentRod)
        end
        reset_fishing_session()
        return
    end

    -- 6. Check for line snap/break (lost fish)
    if msg:find('line snaps', 1, true) then
        if state.BaitBeforeCast and state.CurrentBaitType then
            if state.CurrentBaitType.consumable then
                data.record_bait_lost(state.BaitBeforeCast, 1)
            end
        end
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
    
    elseif subcmd == 'stats' then
        showStats = not showStats
        AshitaCore:GetChatManager():QueueCommand(1, '/echo Stats window toggled.')
    
    elseif subcmd == 'settings' then
        showSettings = not showSettings
        AshitaCore:GetChatManager():QueueCommand(1, '/echo Settings window toggled.')
    
    elseif subcmd == 'guide' then
        showGuide = not showGuide
        AshitaCore:GetChatManager():QueueCommand(1, '/echo Fishing guide window toggled.')
    -- Add this to your command handler in anglin.lua, in the command event handler:

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
        imgui.SetNextWindowSize({ 700, 600 }, ImGuiCond_FirstUseEver)
        if imgui.Begin("Fishing Guide", true, ImGuiWindowFlags_NoCollapse) then
            imgui.Text("Filter by Skill Cap:")
            imgui.SameLine()
            
            -- Skill filter buttons
            if imgui.Button("All") then guideFilterSkill = 0 end
            imgui.SameLine()
            if imgui.Button("0-10") then guideFilterSkill = 1 end
            imgui.SameLine()
            if imgui.Button("11-20") then guideFilterSkill = 2 end
            imgui.SameLine()
            if imgui.Button("21-30") then guideFilterSkill = 3 end
            imgui.SameLine()
            if imgui.Button("31-40") then guideFilterSkill = 4 end
            imgui.SameLine()
            if imgui.Button("41-50") then guideFilterSkill = 5 end
            
            if imgui.Button("51-60") then guideFilterSkill = 6 end
            imgui.SameLine()
            if imgui.Button("61-70") then guideFilterSkill = 7 end
            imgui.SameLine()
            if imgui.Button("71-80") then guideFilterSkill = 8 end
            imgui.SameLine()
            if imgui.Button("81-90") then guideFilterSkill = 9 end
            imgui.SameLine()
            if imgui.Button("91-100") then guideFilterSkill = 10 end
            imgui.SameLine()
            if imgui.Button("100+") then guideFilterSkill = 11 end
            
            imgui.Separator()
            
            -- Get filtered guide (cached)
            local filteredGuide = get_filtered_guide()
            
            -- Display the filtered guide
            if imgui.BeginChild("GuideList", { 0, -30 }, true) then
                for _, fish in ipairs(filteredGuide) do
                    if imgui.CollapsingHeader(string.format("%s (Skill: %d)", fish.name, fish.skill)) then
                        imgui.Indent()
                        imgui.TextWrapped(string.format("Location: %s", fish.location))
                        imgui.TextWrapped(string.format("Bait/Lure: %s", fish.bait))
                        imgui.TextWrapped(string.format("Rod: %s", fish.rod))
                        imgui.Unindent()
                        imgui.Spacing()
                    end
                end
                
                if #filteredGuide == 0 then
                    imgui.TextDisabled("No fish found in this skill range.")
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
            state.Active = false
            windowPosSet = false
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
        imgui.PushStyleColor(ImGuiCol_Text, state.HookColor or 0xFFFFFFFF)
        imgui.Text(state.Hook)
        imgui.PopStyleColor()
    else
        imgui.Text("Hook Type: Waiting...")
    end
    
    -- Display feeling with color
    if state.Feel then
        imgui.Text("Feeling: ")
        imgui.SameLine()
        imgui.PushStyleColor(ImGuiCol_Text, state.FeelColor or 0xFFFFFFFF)
        imgui.Text(state.Feel)
        imgui.PopStyleColor()
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
        state.Active = false
        windowPosSet = false
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