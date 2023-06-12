--loading stuff
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local createLaser = ReplicatedStorage:WaitForChild("CreateLaser")
local playerService = game:GetService("Players")
local dataMod = require(script.Parent.ServerHandler.Data)
local teams = game:GetService("Teams")
local serverStorage = game:GetService("ServerStorage")
local clientLaser = ReplicatedStorage:WaitForChild("ClientLaser")

--kills the hitPlayer player
local function killPlayer(player, hitPlayer, laserBeam)
	laserBeam:SetAttribute("hitSomething",true)
	print("original health: " .. hitPlayer.Character.Humanoid.Health)
	if hitPlayer.Character.Humanoid.Health-15 <= 0 then
		dataMod.increment(player,"Score",10)
		dataMod.increment(player,"Kills", 1)
	else
		dataMod.increment(player,"Score",1)
	end
	hitPlayer.Character.Humanoid.Health -= 15
	print("decreased health: " .. hitPlayer.Character.Humanoid.Health)

end

--server event fired from the client, calls this anonymous function, creates laser beam
createLaser.OnServerEvent:Connect(function(player, mouseEndPosition,tool)
	if mouseEndPosition then
		local laserBeam = serverStorage.LaserBeam:Clone()
		
		--changing properties of laserBeam
		laserBeam.Name = "LaserBeam"
		if player.Team == teams.Red then
			laserBeam.BrickColor = BrickColor.new("Really red")
		else
			laserBeam.BrickColor = BrickColor.new("Electric blue")
		end
		laserBeam.CFrame = CFrame.new((tool.CFrame*CFrame.new(0,0.2,-2)).Position,mouseEndPosition)
		laserBeam.Parent = workspace

		local antiGravForce = Instance.new("BodyForce")
		antiGravForce.Parent = laserBeam
		local requiredForce = laserBeam:GetMass()*workspace.Gravity
		antiGravForce.Force = Vector3.new(0,requiredForce,0)

		local projectileVelocity = 235
		local moverVelocity = laserBeam.CFrame.LookVector * projectileVelocity
		laserBeam.AssemblyLinearVelocity = moverVelocity
		
		clientLaser:FireAllClients(laserBeam)
		
		--if laserbeam hits something then this happens. hit is the object that the laserbeam hit
		laserBeam.Touched:Connect(function(hit)
			local char = hit:FindFirstAncestorOfClass("Model")
			local playerHit = playerService:GetPlayerFromCharacter(char)

			if hit.CollisionGroup == "Obstacles" then
				print("hit obstacle")
				laserBeam:Destroy()
			end
			
			-- if hit player of other team
			if playerHit and playerHit.Team ~= player.Team and not laserBeam.hitSomething.Value then
				print("hit player")
				laserBeam.hitSomething.Value = true
				killPlayer(player,playerHit,laserBeam)
				laserBeam:Destroy()
			end
		end)
		wait(3)
		--destroy laserbeam if not destroyed already
		if laserBeam then
			laserBeam:Destroy()
		end
	end
end)
