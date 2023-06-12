local playerService = game:GetService("Players")
local dataService = game:GetService("DataStoreService")
local store = dataService:GetDataStore("DataStoreV1")

local sessionData = {}
local dataMod = {}

dataMod.recursiveCopy = function(dataTable)
	local tableCopy = {}
	
	for i, value in pairs(dataTable) do
		if type(value) == "table" then
			value = dataMod.recursiveCopy(value)
		end
		
		tableCopy[i] = value
	end
	
	return tableCopy
end

local defaultData = {
	Kills = 0;
	Score = 0;
}

dataMod.load = function(player)
	local key = player.UserId
	print()
	local data = store:GetAsync(key)
	
	return data
end


dataMod.setupData = function(player)
	local key = player.UserId
	local data = dataMod.load(player)

	sessionData[key] = dataMod.recursiveCopy(defaultData)
	
	if data then
		for i, value in pairs(data) do
			dataMod.set(player, i, value)
		end
		
		print(player.Name.. "'s data has been loaded!")
		
	else
		print(player.Name.. " is a new player!")
	end
end

playerService.PlayerAdded:Connect(function(player)
	
	local folder = Instance.new("Folder")
	folder.Name = "leaderstats"
	folder.Parent = player
	
	local kills = Instance.new("IntValue")
	kills.Name = "Kills"
	kills.Parent = folder
	kills.Value = defaultData.Kills
	
	local score = Instance.new("IntValue")
	score.Name = "Score"
	score.Parent = folder
	score.Value = defaultData.Score
	
	dataMod.setupData(player)
end)

dataMod.set = function(player,stat,value)
	local key = player.UserId
	sessionData[key][stat] = value
	player.leaderstats[stat].Value = value
end

dataMod.increment = function(player,stat,value)
	local key = player.UserId
	sessionData[key][stat] = dataMod.get(player,stat) + value
	player.leaderstats[stat].Value = dataMod.get(player,stat)
end

dataMod.get = function(player,stat)
	local key = player.UserId
	return sessionData[key][stat]
end

dataMod.save = function(player)
	local key = player.UserId
	local data = dataMod.recursiveCopy(sessionData[key])
	
	local success, err = pcall(function()
		store:SetAsync(key,data)
	end)
	
	if success then
		print(player.Name.."'s data has been saved")
		
	else
		dataMod.save(player)
	end	
end

dataMod.removeSessionData = function(player)
	local key = player.UserId
	sessionData[key] = nil
end

playerService.playerRemoving:Connect(function(player)
	dataMod.save(player)
	dataMod.removeSessionData(player)
end)

local AUTOSAVE_INTERVAL = 120

local function autoSave()
	while wait(AUTOSAVE_INTERVAL) do
		print("autosaving for all players")
		for key, dataTable in pairs(sessionData) do 
			local player = playerService:GetPlayerByUserId(key)
			dataMod.save(player)
		end
	end
end

game:BindToClose(function()
	for _, player in pairs(playerService:GetPlayers()) do
		dataMod.save(player)
		player:Kick("Shutting down game. All data saved.")
	end
end)

return dataMod
