-- punch.lua
local module = {}

function module.init(player, character, Config, VoiceLines)
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local punchCooldown = 0
    local damageMultiplier = 1

    local range = 10
    local hitboxRadius = 6

    local function getEnemiesInFront()
        local root = humanoidRootPart
        if not root then return {} end

        local origin = root.Position + root.CFrame.LookVector * range * 0.5
        local regionSize = Vector3.new(hitboxRadius, hitboxRadius, range)
        local region = Region3.new(origin - regionSize / 2, origin + regionSize / 2)

        local parts = workspace:FindPartsInRegion3WithIgnoreList(region, {character}, math.huge)
        local hitHumanoids = {}

        for _, part in ipairs(parts) do
            local model = part:FindFirstAncestorOfClass("Model")
            if model and model ~= character then
                local hum = model:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and not hitHumanoids[hum] then
                    hitHumanoids[hum] = true
                end
            end
        end

        local result = {}
        for hum, _ in pairs(hitHumanoids) do
            table.insert(result, hum)
        end
        return result
    end

    local function punch()
        local now = tick()
        if now < punchCooldown then return end
        punchCooldown = now + 0.5

        VoiceLines.onPunch()

        local enemies = getEnemiesInFront()
        local baseDamage = Config.Punch.Damage * damageMultiplier
        local knockback = Config.Punch.Knockback

        for _, hum in ipairs(enemies) do
            hum:TakeDamage(baseDamage)

            local hrp = hum.Parent:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dir = (hrp.Position - humanoidRootPart.Position).Unit
                hrp.Velocity = dir * knockback
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
