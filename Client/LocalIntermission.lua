local ReplicatedStorage = game:GetService("ReplicatedStorage")
local teams = game:GetService("Teams")
local playerService = game:GetService("Players")
local players = playerService:GetPlayers()
local intermissionTimer = ReplicatedStorage:WaitForChild("IntermissionTimer")
local gameStart = ReplicatedStorage:WaitForChild("GameStart")

-- changes the intermission gui to display whatever is needed to display

local intermissionScreen = script.Parent
local intermissionLabel = intermissionScreen.IntermissionLabel

intermissionTimer.OnClientEvent:Connect(function(countFrom,typeOf)
	if intermissionScreen.Enabled == false then
		intermissionScreen.Enabled = true
	end
	local message = ""
	if typeOf == "Spawning" then
		message = "Spawning in: "
	elseif typeOf == "Intermission" then
		message = "Intermission: "
	elseif typeOf == "Playing" then
		message = "Time left: "
	end
	intermissionLabel.Text = message .. countFrom
	
end)

gameStart.OnClientEvent:Connect(function(gameMode)
	intermissionScreen.Enabled = false
end)
