local HttpService = game:GetService("HttpService")
local Configs = {
	AutoPlayerLock = false;
	LockRange = 16;
	AttackRange = 12;
}
local Library = loadstring(HttpService:GetAsync("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

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
local mouse = lplr:GetMouse()

function slash(tool)
	if mouse.Icon ~= "rbxasset://textures/GunWaitCursor.png" then
		print("slash")
		tool:Activate()
		task.wait(0.01)
		tool:Activate()
		task.wait(0.049)
	end
end
while true do
	if Configs.AutoPlayerLock then
		local lplrchar = lplr.Character
		if lplrchar then
			local Tool = lplrchar:FindFirstChildOfClass("Tool")
			local hrp = lplrchar:FindFirstChild("HumanoidRootPart")
			if Tool and hrp then
				local att = Instance.new("Attachment", hrp)
				att.Position = Vector3.new(1.5, 0.5, -1.5)

				local closest

				local detectnearest = Instance.new("Part", workspace)
				detectnearest.Anchored = true
				detectnearest.Size = Vector3.new(Configs.LockRange*2,Configs.LockRange*2,Configs.LockRange*2)
				detectnearest.Shape = Enum.PartType.Ball
				detectnearest.Position = hrp.Position

				local tp = detectnearest:GetTouchingParts()
				detectnearest:Destroy()

				for _, i in ipairs(tp) do
					local char = i:FindFirstAncestorOfClass("Model")
					if char and char ~= lplrchar then
						local npchum = char:FindFirstChildOfClass("Humanoid")
						local npchrp = char:FindFirstChild("HumanoidRootPart")
						if npchum and npchrp then
							local distance = (npchrp.Position - hrp.Position).Magnitude
							if (not closest or distance < closest[2]) and distance >= 0.5 then
								closest = {char,distance}
							end
						end
					end
				end

				if closest then
					local npchum = closest[1].Humanoid
					local npchrp = closest[1].HumanoidRootPart
					if (npchrp.Position - hrp.Position).Magnitude <= Configs.AttackRange and npchum.Health > 0 then
						hrp.CFrame = CFrame.new(hrp.Position,hrp.Position + CFrame.new(att.WorldPosition,(npchrp.Position + npchum.MoveDirection * npchum.WalkSpeed * lplr:GetNetworkPing()) * Vector3.new(1,0,1) + att.WorldPosition * Vector3.new(0,1,0)).LookVector)
						coroutine.wrap(slash)(Tool)
					end
				end
				
				att:Destroy()
			end
		end
	end
	task.wait()
end
