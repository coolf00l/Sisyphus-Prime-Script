local module = {}

function module.init(player, character, Config, VoiceLines)
    local UserInputService = game:GetService("UserInputService")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local punchCooldown = 0
    local damageMultiplier = 1

    local function punch()
        local now = tick()
        if now < punchCooldown then return end
        punchCooldown = now + 0.5

        VoiceLines.onPunch()

        local baseDamage = Config.Punch.Damage * damageMultiplier
        local knockback = Config.Punch.Knockback

        for _, model in ipairs(workspace:GetChildren()) do
            local hum = model:FindFirstChildOfClass("Humanoid")
            local hrp = model:FindFirstChild("HumanoidRootPart")
            if hum and hrp and model ~= character then
                local dist = (hrp.Position - humanoidRootPart.Position).Magnitude
                if dist <= 10 then
                    hum:TakeDamage(baseDamage)
                    hrp.Velocity = (hrp.Position - humanoidRootPart.Position).Unit * knockback
                end
            end
        end
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.F then
            if VoiceLines.canUsePostMonologueAbilities() then
                punch()
            end
        end
    end)

    function module.setPhase2(mult)
        damageMultiplier = mult
    end
end

return module
