local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local lplr = Players.LocalPlayer
local mouse = lplr:GetMouse()
local playermodule = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"))
local controls = playermodule:GetControls()
local char = lplr.Character or lplr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local pivotangle = 0
local pivotdirection = 1
local pivotdistance = 7
local prevroot
lplr.CharacterAdded:Connect(function(newchar)
	char = newchar
	hum = newchar:WaitForChild("Humanoid")
	hrp = newchar:WaitForChild("HumanoidRootPart")
end)
function slash(tool)
	if mouse.Icon ~= "rbxasset://textures/GunWaitCursor.png" then
		tool:Activate()
		task.wait(0.01)
		tool:Activate()
		task.wait(0.049)
	end
end
function getClosest()
	local closest
	local closestdistance = math.huge
	for i, v in ipairs(Players:GetPlayers()) do
		local enemychar = v.Character
		if v ~= lplr and enemychar then
			local enemyhrp = enemychar:FindFirstChild("HumanoidRootPart")
			local enemyhum = enemychar:FindFirstChildOfClass("Humanoid")
			if enemyhum and enemyhum.Health > 0 and enemyhrp then
				local distance = (enemyhrp.Position - hrp.Position).Magnitude
				if distance < closestdistance then
					closest = enemychar
					closestdistance = distance
				end
			end
		end
	end
	return closest
end
RS.Stepped:Connect(function(_,delta)
	local target = getClosest()
	if target then
		controls:Disable()
		if prevroot then
			prevroot.Size = Vector3.new(2,2,1)
		end
		local targethrp = target.HumanoidRootPart
		local targethum = target.Humanoid
		targethrp.Size = Vector3.new(4.5,4.5,4.5)
		prevroot = targethrp
		local att = Instance.new("Attachment", hrp)
		att.Position = Vector3.new(1.49,0,0)
		local Look = CFrame.new(att.WorldPosition,targethrp.Position * Vector3.new(1,0,1) + att.WorldPosition * Vector3.new(0,1,0))
		hrp.CFrame = CFrame.new(hrp.Position,hrp.Position + Look.LookVector)
		if math.random(1,20) == 1 then
			pivotdistance = math.random(7,11)
		end
		if math.random(1,4) == 1 then
			if math.random(1,2) == 1 then
				pivotdirection = -pivotdirection
				if math.random(1,3) == 1 then
					hum.Jump = true
				end
			end
		end
		local circumference = 2 * math.pi * pivotdistance
		pivotangle += 360 / (circumference / hum.WalkSpeed) * delta * pivotdirection
		if pivotangle >= 360 or pivotangle <= -360 then
			pivotangle = 0
		end
		local distance = (targethrp.Position - hrp.Position).Magnitude
		local predictedpos = targethrp.Position + targethrp.Velocity * (distance / hum.WalkSpeed)
		if distance <= 11 then
			local tool = char:FindFirstChildOfClass("Tool")
			if tool then
				slash(tool)
			end
			hum:MoveTo(predictedpos + CFrame.Angles(0,math.rad(pivotangle),0).LookVector * pivotdistance)
			if distance <= 7 then
				hum.Jump = true
			end
		elseif distance <= 35 then
			hum:MoveTo(predictedpos)
		end
	else
		controls:Enable()
	end
end)
