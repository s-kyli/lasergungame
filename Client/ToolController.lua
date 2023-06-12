local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local createLaser = ReplicatedStorage:WaitForChild("CreateLaser")
local teams = game:GetService("Teams")

-- allows the player to sink input into the gun

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local tool = script.Parent

local function toolEquipped(mouse)
	tool.Equip:Play()
end

local function toolActivated()
	tool.Activate:Play()
	local mouseEndPosition = mouse.Hit.Position
	createLaser:FireServer(mouseEndPosition,tool)
end


tool.Parent.Equipped:Connect(toolEquipped)
tool.Parent.Activated:Connect(toolActivated)
