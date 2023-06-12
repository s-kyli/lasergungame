local playerService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local dataMod = require(script.Parent.Data)
local partFunctionsMod = {}

partFunctionsMod.playerFromHit = function(hit)
	local char = hit:FindFirstAncestorOfClass("Model")
	local player = playerService:GetPlayerFromCharacter(char)
	
	return player,char
end

-- this is a module script, it can only give other scripts the ability to run its functions it doesn't execute things itself

partFunctionsMod.DamageParts = function(part)
	local debounce = false
	local damage = part.Damage.Value

	part.Touched:Connect(function(hit)
		local player, char = partFunctionsMod.playerFromHit(hit)

		if player and not debounce then
			debounce = true
			local hum = char.Humanoid
			hum.Health = hum.Health - damage

			delay(0.1,function()
				debounce = false
			end)
		end
	end)
end

partFunctionsMod.HealthParts = function(part)
	local healingPower = 50
	
	part.Touched:Connect(function(hit)
		local char = hit.Parent
		local humanoid = char:FindFirstChildWhichIsA("Humanoid")
		if humanoid then
			if not part.Used.Value and humanoid.Health ~= 100 then
				humanoid.Health = humanoid.Health + healingPower
				part.Used.Value = true
				part.CanTouch = false
				for i = 1, 10 do
					part.Transparency = i/10
					wait(0.1)
				end
				wait(10)
				part.Used.Value = false
				part.CanTouch = true
				for i = 1, 10 do
					part.Transparency = 1 - i/10
					wait(0.1)
				end
			end

		end
	end)
end

local partGroups = {
	workspace.HealthParts;
	--workspace.DamageParts
}

for i, group in pairs(partGroups) do
	for _, part in pairs(group:GetChildren()) do
		if part:IsA("BasePart") then
			partFunctionsMod[group.Name](part)
		end
	end
end


return partFunctionsMod
