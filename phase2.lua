local module = {}

function module.init(player, character, Config, VoiceLines, Dash, Punch, Shockwave)
    local humanoid = character:WaitForChild("Humanoid")
    local phase2 = false

    humanoid.HealthChanged:Connect(function(newHealth)
        if phase2 then return end
        if newHealth <= humanoid.MaxHealth * Config.Phase2.TriggerHealthPercent then
            phase2 = true
            VoiceLines.onPhase2()

            humanoid.WalkSpeed = humanoid.WalkSpeed * Config.Phase2.WalkSpeedMultiplier
            Dash.setPhase2(Config.Phase2.DashSpeedMultiplier)
            Punch.setPhase2(Config.Phase2.PunchDamageMultiplier)
            Shockwave.setPhase2(1.2)
        end
    end)
end

return module
