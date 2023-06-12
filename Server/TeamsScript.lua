wait(2)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local teams = game:GetService("Teams")
local playerService = game:GetService("Players")
local players = playerService:GetPlayers()
local intermissionEvent = ReplicatedStorage:WaitForChild("IntermissionTimer")
local gameStart = ReplicatedStorage:WaitForChild("GameStart")
local serverStorage = game:GetService("ServerStorage")


local function shuffle(array)
	local n = #array
	for i = 1, n do
		-- Get a random index between i and n inclusive
		local j = math.random(i, n)
		-- Swap array[i] with array[j]
		array[i], array[j] = array[j], array[i]
	end
	return array
end

local function intermission()

	for _, player in ipairs(players) do
		if player.Team ~= teams.Neutral then
			if player.Backpack:FindFirstChildWhichIsA("Tool") then
				player.Backpack:FindFirstChildWhichIsA("Tool"):Destroy()
			end
			
			if player.Character:FindFirstChildOfClass("Tool") then
				player.Backpack:FindFirstChildWhichIsA("Tool"):Destroy()
			end
			player.Team = teams.Neutral
			player:LoadCharacter()
		end
	end

	local countFrom = 30
	wait(1)
	repeat
		intermissionEvent:FireAllClients(countFrom,"Intermission")		
		countFrom -= 1		
		wait(1)	
	until
	countFrom < 0

	local shuffledPlayers = shuffle(game.Players:GetChildren())


	for i, player in ipairs(shuffledPlayers) do
		if player then
			if i%2 == 0 then
				player.Team = teams.Blue
			else
				player.Team = teams.Red
			end
		end
	end

	countFrom = 5

	repeat
		intermissionEvent:FireAllClients(countFrom,"Spawning")
		countFrom -= 1
		wait(1)
	until countFrom < 0

	for _, player in ipairs(game.Players:GetChildren()) do
		if player.Team ~= teams.Neutral then
			player.CharacterAdded:Connect(function(char)
				
				
				local backpack = player:WaitForChild("Backpack")
				local tool = serverStorage.Gun:Clone()
				tool.Parent = backpack
				print("gave player tool")
			end)
		end
		player:LoadCharacter()
	end
	gameStart:FireAllClients("Classic")

	countFrom = 200

	repeat
		intermissionEvent:FireAllClients(countFrom,"Playing")
		countFrom -= 1
		wait(1)
	until countFrom < 0

end

while true do
	intermission()
end
