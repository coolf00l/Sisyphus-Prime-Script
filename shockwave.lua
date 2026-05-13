-- shockwave.lua
local module = {}

function module.init(player, character, Config, VoiceLines)
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local shockwaveCooldown = 0
    local damageMultiplier = 1
    local radiusMultiplier = 1

    local function getEnemiesInRadius(radius)
        local root = humanoidRootPart
        if not root then return {} end

        local hitHumanoids = {}
        for _, model in ipairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model ~= character then
                local hum = model:FindFirstChildOfClass("Humanoid")
                local hrp = model:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist <= radius then
                        hitHumanoids[hum] = true
                    end
                end
            end
        end

        local result = {}
        for hum, _ in pairs(hitHumanoids) do
            table.insert(result, hum)
        end
        return result
    end

    local function shockwave()
        local now = tick()
        if now < shockwaveCooldown then return end
        shockwaveCooldown = now + 3

        VoiceLines.onShockwave()

        local baseRadius = Config.Shockwave.Radius * radiusMultiplier
        local baseDamage = Config.Shockwave.Damage * damageMultiplier

        local enemies = getEnemiesInRadius(baseRadius)

        for _, hum in ipairs(enemies) do
            local hrp = hum.Parent:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dir = (hrp.Position - humanoidRootPart.Position).Unit
                hum:TakeDamage(baseDamage)
                hrp.Velocity = dir * 60
            end
        end
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.G then
            if VoiceLines.canUsePostMonologueAbilities() then
                shockwave()
            end
        end
    end)

    function module.setPhase2(mult)
        damageMultiplier = mult
        radiusMultiplier = mult
    end
end

return module
