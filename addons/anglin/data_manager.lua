---------------------------------------------------------------------------------------------------
-- data_manager.lua for Anglin Addon
---------------------------------------------------------------------------------------------------

local json = require('json') -- make sure you have a JSON library available
local AshitaCore = AshitaCore -- available in HorizonXI Lua

local data = {}

-- ==============================
-- Persistent state
-- ==============================
local state = {
    daily = {
        date = nil,
        fishCaught = {},
        itemCaught = {},  -- NEW: Track items separately
        baitUsed = {},
        baitConsumed = {},
        baitLost = {},
        lureLost = {},
        rodBreaks = {},
    },
    lifetime = {
        fishCaught = {},
        itemCaught = {},  -- NEW: Track items separately
        baitUsed = {},
        baitConsumed = {},
        baitLost = {},
        lureLost = {},
        rodBreaks = {},
    }
}

-- ==============================
-- Player name tracking
-- ==============================
local currentPlayerName = nil

-- ==============================
-- Paths (dynamic based on player name)
-- ==============================
local addonPath = string.format('%s\\addons\\anglin\\data\\', AshitaCore:GetInstallPath())
local dailyFile = nil
local lifetimeFile = nil

-- ==============================
-- Daily reset callback (to be set by main addon)
-- ==============================
local daily_reset_callback = nil

local function set_daily_reset_callback(callback)
    daily_reset_callback = callback
end

-- ==============================
-- Helper: Get current JST date correctly
-- ==============================
local function get_jst_date()
    -- Get UTC time
    local utc_time = os.time(os.date("!*t"))
    -- Add 9 hours for JST (32400 seconds)
    local jst_time = utc_time + (9 * 3600)
    -- Return date in JST
    return os.date('%Y-%m-%d', jst_time)
end

-- ==============================
-- Helper: Update file paths based on player name
-- ==============================
local function update_file_paths(playerName)
    if not playerName or playerName == '' then
        dailyFile = addonPath .. 'daily.json'
        lifetimeFile = addonPath .. 'lifetime.json'
    else
        dailyFile = addonPath .. playerName .. '-daily.json'
        lifetimeFile = addonPath .. playerName .. '-lifetime.json'
    end
end

-- ==============================
-- Helper: Get current player name
-- ==============================
local function get_player_name()
    local partyMgr = AshitaCore:GetMemoryManager():GetParty()
    if partyMgr then
        local pname = partyMgr:GetMemberName(0)
        if pname and pname ~= '' then
            return pname
        end
    end
    return nil
end

-- ==============================
-- Helper: Initialize player-specific data
-- (Forward declaration, actual implementation below)
-- ==============================
local initialize_player_data

-- ==============================
-- Helper: Recursively sort a table by key
-- ==============================
local function sort_table(tbl)
    if type(tbl) ~= "table" then return tbl end
    local sorted = {}
    local keys = {}
    for k in pairs(tbl) do table.insert(keys, k) end
    table.sort(keys)  -- sort alphabetically
    for _, k in ipairs(keys) do
        sorted[k] = sort_table(tbl[k])  -- recursive sort
    end
    return sorted
end

-- ==============================
-- Helper: Ensure all tables exist
-- ==============================
local function ensure_tables()
    -- Daily
    state.daily = state.daily or {}
    state.daily.fishCaught   = state.daily.fishCaught   or {}
    state.daily.itemCaught   = state.daily.itemCaught   or {}  -- NEW
    state.daily.baitUsed     = state.daily.baitUsed     or {}
    state.daily.baitConsumed = state.daily.baitConsumed or {}
    state.daily.baitLost     = state.daily.baitLost     or {}
    state.daily.lureLost     = state.daily.lureLost     or {}
    state.daily.rodBreaks    = state.daily.rodBreaks    or {}
    state.daily.date         = state.daily.date or get_jst_date()

    -- Lifetime
    state.lifetime = state.lifetime or {}
    state.lifetime.fishCaught   = state.lifetime.fishCaught   or {}
    state.lifetime.itemCaught   = state.lifetime.itemCaught   or {}  -- NEW
    state.lifetime.baitUsed     = state.lifetime.baitUsed     or {}
    state.lifetime.baitConsumed = state.lifetime.baitConsumed or {}
    state.lifetime.baitLost     = state.lifetime.baitLost     or {}
    state.lifetime.lureLost     = state.lifetime.lureLost     or {}
    state.lifetime.rodBreaks    = state.lifetime.rodBreaks    or {}
end

-- ==============================
-- Helper: Load/Save JSON
-- ==============================
local function load_json(path)
    local f = io.open(path, 'r')
    if not f then return nil end
    local content = f:read('*a')
    f:close()
    local ok, tbl = pcall(json.decode, content)
    if ok and type(tbl) == 'table' then
        return tbl
    end
    return nil
end

-- Force empty tables to be encoded as objects instead of arrays
local function prepare_table_for_json(tbl)
    if type(tbl) ~= "table" then return tbl end
    for k,v in pairs(tbl) do
        tbl[k] = prepare_table_for_json(v)
    end
    return tbl
end

local function save_json_sorted_pretty(path, tbl)
    local f = io.open(path, 'w')
    if not f then return end

    -- Sort and prepare table
    local sorted_tbl = sort_table(tbl)
    local prepared_tbl = prepare_table_for_json(sorted_tbl)

    -- Encode to JSON
    local json_text
    if json and json.encode_pretty then
        json_text = json.encode_pretty(prepared_tbl)
    else
        json_text = json.encode(prepared_tbl)

        -- Fallback simple pretty-print
        json_text = json_text:gsub(',"%s*"', ',\n  "')
        json_text = json_text:gsub('{', '{\n  ')
        json_text = json_text:gsub('}', '\n}')
    end

    f:write(json_text)
    f:close()
end

-- ==============================
-- Save state
-- ==============================
local function save_state()
    initialize_player_data()  -- Ensure we have current player data
    if not dailyFile or not lifetimeFile then
        return  -- Can't save without file paths
    end
    ensure_tables()
    save_json_sorted_pretty(dailyFile, state.daily)
    save_json_sorted_pretty(lifetimeFile, state.lifetime)
end

-- ==============================
-- Load existing data
-- ==============================
local function load_state()
    if not dailyFile or not lifetimeFile then
        update_file_paths(get_player_name())
        if not dailyFile or not lifetimeFile then
            return  -- Still no file paths, can't load
        end
    end

    local dailyData = load_json(dailyFile)
    if dailyData then state.daily = dailyData end

    local lifetimeData = load_json(lifetimeFile)
    if lifetimeData then state.lifetime = lifetimeData end

    ensure_tables()
end

-- ==============================
-- Helper: Initialize player-specific data
-- (Now defined after load_state)
-- ==============================
initialize_player_data = function()
    local playerName = get_player_name()
    if playerName and playerName ~= currentPlayerName then
        currentPlayerName = playerName
        update_file_paths(playerName)
        -- Load data for this player
        load_state()
    end
end

-- ==============================
-- Helper: Increment counts safely
-- ==============================
local function inc(tbl, key, amount)
    amount = amount or 1
    tbl[key] = (tbl[key] or 0) + amount
end

-- ==============================
-- Daily reset (Japan midnight, UTC+9)
-- Automatically called periodically to check for new day
-- ==============================
local function check_daily_reset()
    initialize_player_data()  -- Ensure we have current player data
    
    local today = get_jst_date()

    if state.daily.date ~= today then
        state.daily.fishCaught   = {}
        state.daily.itemCaught   = {}  -- NEW
        state.daily.baitUsed     = {}
        state.daily.baitConsumed = {}
        state.daily.baitLost     = {}
        state.daily.lureLost     = {}
        state.daily.rodBreaks    = {}
        state.daily.date         = today
        save_state()
        
        -- Notify the main addon that daily reset occurred
        if daily_reset_callback then
            daily_reset_callback()
        end
        
        return true  -- Reset occurred
    end
    return false  -- No reset needed
end

-- ==============================
-- Reset daily stats only
-- ==============================
local function reset_daily_stats()
    local today = get_jst_date()
    
    state.daily.fishCaught   = {}
    state.daily.itemCaught   = {}  -- NEW
    state.daily.baitUsed     = {}
    state.daily.baitConsumed = {}
    state.daily.baitLost     = {}
    state.daily.lureLost     = {}
    state.daily.rodBreaks    = {}
    state.daily.date         = today
    
    save_state()
end

-- ==============================
-- Reset lifetime stats only
-- ==============================
local function reset_lifetime_stats()
    state.lifetime.fishCaught   = {}
    state.lifetime.itemCaught   = {}  -- NEW
    state.lifetime.baitUsed     = {}
    state.lifetime.baitConsumed = {}
    state.lifetime.baitLost     = {}
    state.lifetime.lureLost     = {}
    state.lifetime.rodBreaks    = {}
    
    save_state()
end

-- ==============================
-- Record Functions
-- ==============================
local function record_fish(name, amount, isItem)
    initialize_player_data()  -- Ensure we have current player data
    amount = amount or 1
    isItem = isItem or false
    
    -- Always add to fishCaught for backward compatibility
    inc(state.daily.fishCaught, name, amount)
    inc(state.lifetime.fishCaught, name, amount)
    
    -- If it's an item, also mark it in itemCaught
    if isItem then
        inc(state.daily.itemCaught, name, amount)
        inc(state.lifetime.itemCaught, name, amount)
    end
    
    save_state()
end

local function record_bait_used(name, amount)
    initialize_player_data()  -- Ensure we have current player data
    amount = amount or 1
    inc(state.daily.baitUsed, name, amount)
    inc(state.lifetime.baitUsed, name, amount)
    save_state()
end

local function record_bait_consumed(name, amount)
    initialize_player_data()  -- Ensure we have current player data
    amount = amount or 1
    inc(state.daily.baitConsumed, name, amount)
    inc(state.lifetime.baitConsumed, name, amount)
    save_state()
end

local function record_bait_lost(name, amount)
    initialize_player_data()  -- Ensure we have current player data
    amount = amount or 1
    inc(state.daily.baitLost, name, amount)
    inc(state.lifetime.baitLost, name, amount)
    save_state()
end

local function record_lure_lost(name)
    initialize_player_data()  -- Ensure we have current player data
    inc(state.daily.lureLost, name, 1)
    inc(state.lifetime.lureLost, name, 1)
    save_state()
end

local function record_rod_break(name)
    initialize_player_data()  -- Ensure we have current player data
    inc(state.daily.rodBreaks, name, 1)
    inc(state.lifetime.rodBreaks, name, 1)
    save_state()
end

-- ==============================
-- Expose functions
-- ==============================
data.state = state
data.ensure_tables = ensure_tables
data.check_daily_reset = check_daily_reset
data.reset_daily_stats = reset_daily_stats
data.reset_lifetime_stats = reset_lifetime_stats
data.save_state = save_state
data.load_state = load_state
data.record_fish = record_fish
data.record_bait_used = record_bait_used
data.record_bait_consumed = record_bait_consumed
data.record_bait_lost = record_bait_lost
data.record_lure_lost = record_lure_lost
data.record_rod_break = record_rod_break
data.initialize_player_data = initialize_player_data
data.set_daily_reset_callback = set_daily_reset_callback
data.get_jst_date = get_jst_date  -- Expose for debugging

-- Initialize on load
initialize_player_data()

return data