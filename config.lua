-- config.lua
local Config = {}

Config.Dash = {
    Distance = 30,
    Duration = 0.08,
    Cooldown = 0.4,
}

Config.Punch = {
    Damage = 35,
    Knockback = 40,
}

Config.Shockwave = {
    Damage = 45,
    Radius = 35,
}

Config.Phase2 = {
    TriggerHealthPercent = 0.5,
    WalkSpeedMultiplier = 1.25,
    DashSpeedMultiplier = 1.5,
    PunchDamageMultiplier = 1.4,
}

return Config
