-- shockwave.lua
local module = {}

function module.init(player, character, Config, VoiceLines)
    local UserInputService = game:GetService("UserInputService")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local shockwaveCooldown = 0
    local damageMultiplier = 1
    local radiusMultiplier = 1

    local function getEnemiesInRadius(radius)
        local root = humanoidRootPart
        if not root then return {} end

        local hitHumanoids = {}

        for _, inst in ipairs(workspace:GetDescendants()) do
            if inst:IsA("Model") and inst ~= character then
                local hum = inst:FindFirstChildOfClass("Humanoid")
                local hrp = inst:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist <= radius then
                        hitHumanoids[hum] = hrp
                    end
                end
            end
        end

        return hitHumanoids
    end

    local function shockwave()
        local now = tick()
        if now < shockwaveCooldown then return end
        shockwaveCooldown = now + 3

        VoiceLines.onShockwave()

        local radius = Config.Shockwave.Radius * radiusMultiplier
        local damage = Config.Shockwave.Damage * damageMultiplier

        local enemies = getEnemiesInRadius(radius)

        for hum, hrp in pairs(enemies) do
            hum:TakeDamage(damage)
            local dir = (hrp.Position - humanoidRootPart.Position).Unit
            hrp.Velocity = dir * 60
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
