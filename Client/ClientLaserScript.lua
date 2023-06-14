local RL = game:GetService("ReplicatedStorage")
local CL = RL:WaitForChild("ClientLaser")

-- creates a new laser beam on client side that has no functionality, but is just for the looks and makes the laser beam move smoother since this is a localscript and it is being run on client script.

CL.OnClientEvent:Connect(function(laser:Part)

	local newLaser = laser:Clone()
	newLaser.Parent = workspace
	laser:Destroy()

	newLaser.Touched:Connect(function(hit)

		if hit.CollisionGroup == "Obstacles" then
			newLaser:Destroy()
		end
	end)
	wait(3)
	--destroy laserbeam if not destroyed already
	if newLaser then
		newLaser:Destroy()
	end

end)
