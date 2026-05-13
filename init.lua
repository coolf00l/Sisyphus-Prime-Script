local base = "https://raw.githubusercontent.com/coolf00l/Sisyphus-Prime-Script/main/"

local function loadModule(path)
    return loadstring(game:HttpGet(base .. path))()
end

local Config     = loadModule("config.lua")
local VoiceLines = loadModule("voicelines.lua")
local Monologue  = loadModule("monologue.lua")
local Dash       = loadModule("dash.lua")
local Phase2     = loadModule("phase2.lua")
local Punch      = loadModule("punch.lua")
local Shockwave  = loadModule("shockwave.lua")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

VoiceLines.init(player, character, Config)
Monologue.init(player, character, Config, VoiceLines)
Dash.init(player, character, Config, VoiceLines)
Punch.init(player, character, Config, VoiceLines)
Shockwave.init(player, character, Config, VoiceLines)
Phase2.init(player, character, Config, VoiceLines, Dash, Punch, Shockwave)
