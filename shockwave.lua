local module = {}

function module.init(player, character, Config, VoiceLines)
    local UserInputService = game:GetService("UserInputService")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local shockwaveCooldown = 0
    local damageMultiplier = 1
    local radiusMultiplier = 1

    local function shockwave()
        local now = tick()
        if now < shockwaveCooldown then return end
        shockwaveCooldown = now + 3

        VoiceLines.onShockwave()

        local radius = Config.Shockwave.Radius * radiusMultiplier
        local damage = Config.Shockwave.Damage * damageMultiplier

        for _, model in ipairs(workspace:GetChildren()) do
            local hum = model:FindFirstChildOfClass("Humanoid")
            local hrp = model:FindFirstChild("HumanoidRootPart")
            if hum and hrp and model ~= character then
                local dist = (hrp.Position - humanoidRootPart.Position).Magnitude
                if dist <= radius then
                    hum:TakeDamage(damage)
                    hrp.Velocity = (hrp.Position - humanoidRootPart.Position).Unit * 60
                end
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
