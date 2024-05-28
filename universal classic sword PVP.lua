if _G.universalswordscriptalreadyexecuted then return end
_G.universalswordscriptalreadyexecuted = true

local Configs = {
	AutoPlayerLock = false;
	LockRange = 16;
	AttackRange = 12;
}
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

local PhantomForcesWindow = Library:NewWindow("Combat")

local MainCheats = PhantomForcesWindow:NewSection("Main")

MainCheats:CreateToggle("Auto-Player Lock", function(value)
	Configs.AutoPlayerLock = value
end)
MainCheats:CreateSlider("Lock Range", 0, 100, 16, false, function(value)
	Configs.LockRange = value
end)
MainCheats:CreateSlider("Attack Range", 0, 100, 12, false, function(value)
	Configs.AttackRange = value
end)

local lplr = game.Players.LocalPlayer
local lplrchar = lplr.Character or lplr.CharacterAdded:Wait()
local lplrhrp = lplrchar:WaitForChild("HumanoidRootPart")

local mouse = lplr:GetMouse()
local count = 1

function slash(tool)
	if mouse.Icon ~= "rbxasset://textures/GunWaitCursor.png" then
		print("slash")
		tool:Activate()
		task.wait(0.01)
		tool:Activate()
		task.wait(0.049)
	end
end
lplr.CharacterAdded:Connect(function(char)
	lplrchar = char
	lplrhrp = lplrchar:WaitForChild("HumanoidRootPart")
end)
while true do
	if lplrchar and lplrhrp then
		local Tool = lplrchar:FindFirstChildOfClass("Tool")
		if Tool then
			local att = Instance.new("Attachment", lplrhrp)
			att.Position = Vector3.new(1.5, 0.5, 0)

			local closest

			local detectnearest = Instance.new("Part", workspace)
			detectnearest.Anchored = true
			detectnearest.Size = Vector3.new(Configs.LockRange*2,Configs.LockRange*2,Configs.LockRange*2)
			detectnearest.Shape = Enum.PartType.Ball
			detectnearest.Position = lplrhrp.Position

			local tp = detectnearest:GetTouchingParts()
			detectnearest:Destroy()

			for _, i in ipairs(tp) do
				local char = i:FindFirstAncestorOfClass("Model")
				if char and char ~= lplrchar then
					local npchum = char:FindFirstChildOfClass("Humanoid")
					local npchrp = char:FindFirstChild("HumanoidRootPart")
					if npchum and npchrp and npchrp.Health > 0 then
						local distance = (npchrp.Position - lplrhrp.Position).Magnitude
						if (not closest or distance < closest[2]) and distance >= 0.5 then
							closest = {char,distance}
						end
					end
				end
			end

			if closest then
				local npchum = closest[1].Humanoid
				npchrp = closest[1].HumanoidRootPart

				local npcRAatt = Instance.new("Attachment", npchrp)
				npcRAatt.Position = Vector3.new(1.5, 0.5, -1.5)
				local npcHRPatt = Instance.new("Attachment", npchrp)
				npcHRPatt.Position = Vector3.new(0, 0.5, -0.5)
				local npcLAatt = Instance.new("Attachment", npchrp)
				npcLAatt.Position = Vector3.new(-1.5, 0.5, -0.5)
				local att2 = Instance.new("Attachment", lplrhrp)
				att2.Position = Vector3.new(1.5, -1, -3.75)


				if (npchrp.Position - lplrhrp.Position).Magnitude <= Configs.AttackRange then
					local aimpos = npchrp.Position

					local RADist = (npcRAatt.WorldPosition - att2.WorldPosition).Magnitude
					local HRPDist = (npcHRPatt.WorldPosition - att2.WorldPosition).Magnitude
					local LADist = (npcLAatt.WorldPosition - att2.WorldPosition).Magnitude

					if RADist < HRPDist then
						aimpos = npcRAatt.WorldPosition
					else
						if count == 1 and RADist <= 3.5 then
							aimpos = npcRAatt.WorldPosition
						else
							count += 1
						end
						if count == 2 and HRPDist <= 3.5 then
							aimpos = npchrp.Position
						else
							count += 1
						end
						if count == 3 and LADist <= 3.5 then
							aimpos = npcLAatt.Position
						else
							count += 1
						end
						count += 1
						if count >= 3 then
							count = 1
						end
					end

					local CFrameLook = CFrame.new(att.WorldPosition,aimpos * Vector3.new(1,0,1) + att.WorldPosition * Vector3.new(0,1,0))
					lplrhrp.CFrame = CFrame.new(lplrhrp.Position,lplrhrp.Position + CFrameLook.LookVector)

					npchrp.Size = Vector3.new(100,100,100)
					coroutine.wrap(slash)(Tool)
				end
				npcRAatt:Destroy()
				npcHRPatt:Destroy()
				npcLAatt:Destroy()
			end
			att:Destroy()
		end
	end
	task.wait()
	if npchrp then
		npchrp.Size = Vector3.new(2,2,1)
		npchrp = nil
	end
end
