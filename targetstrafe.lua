-- Powered by JeffSource AI
-- { SERVICES } --
local PFS = game:GetService("PathfindingService")
local Players = game:GetService("Players")
-- { VARIABLES } --
local LocalPlayer = Players.LocalPlayer
local killerChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local killerHrp = killerChar:WaitForChild("HumanoidRootPart")
local killerHum = killerChar:WaitForChild("Humanoid")
local Knife = killerChar:WaitForChild("Knife")
-- GUI
local Jumpscare = killerChar:WaitForChild("Jumpscare")
-- Behavior
local attackBehavior = 1 -- 1: Chase / 2: Strafe/Dodge 3: Evade
local MaxDist = 1000000
-- Animations
local swingAnim = killerChar:WaitForChild("Swing")
local animDebounce = false
-- Strafing
local bodyGyro = killerHrp:WaitForChild("BodyGyro")
local pivotAngle = 0
local pivotDirection = 1
local pivotDistance = 5
-- Tick
local prevt = tick()
-- { FUNCTIONS } --
function getClosest()
	local closest
	local dist = math.huge
	for _, child in pairs(workspace:GetChildren()) do
		local NPCHum = child:FindFirstChildOfClass("Humanoid")
		local NPCHrp = child:FindFirstChild("HumanoidRootPart")
		if child ~= killerChar and NPCHum and NPCHum.Health > 0 and not NPCHum:FindFirstChild("JeffTheKiller") and NPCHrp and NPCHrp:IsA("BasePart") then
			local dist2 = (NPCHrp.Position - killerHrp.Position).Magnitude
			if dist2 < dist and dist2 <= MaxDist then
				closest = child
				dist = dist2
			end
		end
	end
	
	return closest
end
function createWaypointIndicator(pos)
	local waypointsfolder = workspace:FindFirstChild("JeffTheKillerWaypoints")
	if not waypointsfolder then
		waypointsfolder = Instance.new("Folder", workspace)
		waypointsfolder.Name = "JeffTheKillerWaypoints"
	end
	local part = Instance.new("Part", waypointsfolder)
	part.Size = Vector3.new(0.5,0.5,0.5)
	part.Anchored = true
	part.CanCollide = false
	part.Position = pos
	part.Color = Color3.new(1,1,1)
	part.Material = Enum.Material.Neon
	task.wait(5)
	part:Destroy()
end
function deathEffects(char)
	local player = Players:GetPlayerFromCharacter(char)
	if player then
		local playerGui = player:FindFirstChildOfClass("PlayerGui")
		if playerGui then
			local jumpscareclone = Jumpscare:Clone()
			jumpscareclone.Parent = playerGui
			local jumpscaresound = jumpscareclone:WaitForChild("JumpscareSound")
			jumpscaresound.Enabled = true
			local imageLabel = jumpscareclone:WaitForChild("ImageLabel")
			for i = 1,10,1 do
				imageLabel.Size = UDim2.new(1.3,0,1.3,0)
				task.wait(0.05)
				imageLabel.Size = UDim2.new(1,0,1,0)
				task.wait(0.05)
			end
		end
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local head = char:FindFirstChild("Head")
	if not hum or not hrp or not head then return end
	hum.BreakJointsOnDeath = false
	for i, v in pairs(char:GetDescendants()) do
		if v:IsA("Motor6D") then
			local socket = Instance.new("BallSocketConstraint", v.Parent)
			local a1 = Instance.new("Attachment", v.Part0)
			local a2 = Instance.new("Attachment", v.Part1)
			socket.Attachment0 = a1
			socket.Attachment1 = a2
			socket.LimitsEnabled = true
			socket.TwistLimitsEnabled = true
			a1.CFrame = v.C0
			a2.CFrame = v.C1
			v:Destroy()
		end
	end
	local folder = Instance.new("Folder", char)
	folder.Name = "BloodEffect"
	local bloodpools = {}
	local face = head:FindFirstChild("face")
	if face then
		face.Texture = "rbxassetid://1193464234"
	end
	for i = 1,5,1 do
		local pos = hrp.Position + Vector3.new(math.random(-2000,2000)/1000,0,math.random(-2000,2000)/1000)
		local bloodDroplet = Instance.new("Part", folder)
		bloodDroplet.Shape = Enum.PartType.Ball
		bloodDroplet.Name = "bloodDroplet"
		bloodDroplet.Position = pos
		bloodDroplet.Size = Vector3.new(0.25, 0.25, 0.25)
		bloodDroplet.BrickColor = BrickColor.new("Really red")
		bloodDroplet.CanCollide = false
		local params = RaycastParams.new()
		params.FilterDescendantsInstances = {bloodDroplet,char,killerChar,table.unpack(bloodpools)}
		params.FilterType = Enum.RaycastFilterType.Blacklist
		local groundcheck = workspace:Raycast(pos,Vector3.new(0,-16,0),params)
		if groundcheck then
			local bloodPool = Instance.new("Part", folder)
			bloodPool.Shape = Enum.PartType.Cylinder
			bloodPool.BrickColor = BrickColor.new("Really red")
			bloodPool.Name = "BloodPool"
			bloodPool.Size = Vector3.new(0.25, 0.5, 0.5)
			bloodPool.CFrame = CFrame.new(groundcheck.Position) * CFrame.Angles(0,0,math.pi/2)
			bloodPool.Anchored = true
			bloodPool.CanCollide = false
			table.insert(bloodpools,bloodPool)
			for i = 1,20,1 do
				bloodPool.Size += Vector3.new(0,0.2,0.2)
				task.wait(0.05)
			end
		end
	end
end
function checkDist(targetHrp)
	return (targetHrp.Position - killerHrp.Position).Magnitude
end
function facePosition(pos)
	bodyGyro.MaxTorque = Vector3.new(0,math.huge,0)
	bodyGyro.CFrame = CFrame.new(killerHrp.Position,pos)
end
-- { EVENTS } --
killerHum.Died:Connect(function()
	coroutine.wrap(deathEffects)(killerChar)
end)
-- { LOOPS } --
while true do
	killerHrp:SetNetworkOwner(nil)
	prevt = tick()
	task.wait()
	local t = tick()
	bodyGyro.MaxTorque = Vector3.new(0,0,0)
	if killerHum.Health <= 0 then break end
	if math.random(1,6) == 1 then
		pivotDirection = -pivotDirection
	end
	if pivotDistance >= 3 and math.random(1,4) == 1 then
		pivotDistance = math.random(1000,2500)/1000
	elseif math.random(1,8) == 1 then
		pivotDistance = math.random(1000,5000)/1000
	end
	pivotAngle += (pivotDirection * 2 * math.pi * pivotDistance) / killerHum.WalkSpeed * 360
	local targetChar = getClosest()
	if targetChar then
		local targetHrp = targetChar.HumanoidRootPart
		local targetHum = targetChar.Humanoid
		local dist = checkDist(targetHrp)
		killerHum:MoveTo(targetHrp.Position)
		local params = RaycastParams.new()
		params.FilterDescendantsInstances = {targetChar,killerChar}
		params.FilterType = Enum.RaycastFilterType.Blacklist
		local wallcheck = workspace:Raycast(killerHrp.Position,targetHrp.Position - killerHrp.Position,params)
		if wallcheck or dist > 18 then
			local agentParams = {
				AgentRadius = 2;
				AgentHeight = 5;
				AgentCanJump = true;
				AgentCanClimb = true;
				WaypointSpacing = 6;
			}
			local path = PFS:CreatePath(agentParams)
			local suc = pcall(function()
				path:ComputeAsync(killerHrp.Position,targetHrp.Position)
			end)
			if suc and path.Status == Enum.PathStatus.Success then
				local waypoints = path:GetWaypoints()
				if waypoints and #waypoints > 1 then
					for i, waypoint in waypoints do
						local newtarget = getClosest()
						if newtarget and newtarget ~= targetChar then
							targetHrp = newtarget.HumanoidRootPart
							targetHum = newtarget.Humanoid
							params.FilterDescendantsInstances = {newtarget,killerChar}
						end
						local wallcheck = workspace:Raycast(killerHrp.Position,targetHrp.Position - killerHrp.Position,params)
						if not wallcheck and checkDist(targetHrp) <= 18 then break end
						--coroutine.wrap(createWaypointIndicator)(waypoint.Position)
						killerHum:MoveTo(waypoint.Position)
						if waypoint.Action == Enum.PathWaypointAction.Jump then
							killerHum.Jump = true
						end
						killerHum.MoveToFinished:Wait()
						local newpath = PFS:CreatePath(agentParams)
						local suc = pcall(function()
							newpath:ComputeAsync(killerHrp.Position,targetHrp.Position)
						end)
						if suc and newpath.Status == Enum.PathStatus.Success then
							local newwaypoints = newpath:GetWaypoints()
							if #newwaypoints > 1 then
								waypoints[i + 1] = newwaypoints[i + 1]
							end
						end
					end
				else
					break
				end
			end
		else
			if dist <= 4 and not animDebounce then
				animDebounce = true
				spawn(function()
					local swingAnimTrack = killerHum:LoadAnimation(swingAnim)
					swingAnimTrack:Play()
					swingAnimTrack:AdjustSpeed(3)
					spawn(function()
						Knife.Swing:Play()
						task.wait(0.3)
						local dist = (targetHrp.Position - killerHrp.Position).Magnitude
						if dist <= 4 and killerHum.Health > 0 then
							targetHum:TakeDamage(20)
							Knife["Hit"..math.random(1,3)]:Play()
							if targetHum.Health <= 0 then
								coroutine.wrap(deathEffects)(targetChar)
								Knife.Kill:Play()
							end
						end
						animDebounce = false
					end)
				end)
			end
			local predictedpos = targetHrp.Position + (targetHrp.Velocity * Vector3.new(1,0,1) * dist / killerHum.WalkSpeed)
			if dist > 13 and (predictedpos - killerHrp.Position).Magnitude <= 5 then
				attackBehavior = 3
			elseif dist <= 13 then
				attackBehavior = 1
			elseif dist <= 18 then
				attackBehavior = 2
			end
			if attackBehavior == 1 then
				if dist <= 8 then
					killerHum:MoveTo(predictedpos + CFrame.Angles(0,math.rad(pivotAngle),0).LookVector * pivotDistance)
					local vel = targetHrp.Velocity.Unit * 5
					if vel ~= vel then
						vel = Vector3.zero
					end
					facePosition(targetHrp.Position + vel)
				elseif dist <= 13 then
					killerHum:MoveTo(predictedpos)
					facePosition(predictedpos)
				else
					killerHum:MoveTo(targetHrp.Position)
					facePosition(targetHrp.Position)
				end
			elseif attackBehavior == 2 then
				killerHum.Jump = true
				killerHum:MoveTo(predictedpos + CFrame.Angles(0,math.rad(pivotAngle),0).LookVector * 20)
				local groundcheck = workspace:Raycast(killerHrp.Position,Vector3.yAxis * -(killerHum.JumpHeight - 1.6),params)
				if not groundcheck and math.random(1,4) == 1 then
					pivotDirection = -pivotDirection
				elseif groundcheck and math.random(1,2) == 1 then
					pivotDirection = -pivotDirection
				end
				facePosition(targetHrp.Position)
			elseif attackBehavior == 3 then
				facePosition(targetHrp.Position)
				if dist <= 9 then
					killerHum:MoveTo(killerHrp.Position - predictedpos + CFrame.Angles(0,math.rad(pivotAngle),0).LookVector * 5)
				else
					killerHum:MoveTo(predictedpos)
				end
			end
		end
	end
end
LocalPlayer.CharacterAdded:Connect(function(char)
	killerChar = char
	killerHum = char:WaitForChild("Humanoid")
	killerHrp = char:WaitForChild("HumanoidRootPart")
end)
