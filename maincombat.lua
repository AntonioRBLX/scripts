local HttpService = game:GetService("HttpService")
local Configs = {
	AutoPlayerLock = false;
	Range = 16;
}
local Library = loadstring(HttpService:GetAsync("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

local PhantomForcesWindow = Library:NewWindow("Combat")

local MainCheats = PhantomForcesWindow:NewSection("Main")

MainCheats:CreateToggle("Auto-Player Lock", function(value)
	Configs.AutoPlayerLock = value
end)

MainCheats:CreateSlider("Range", 0, 100, 0, false, function(value)
	Configs.Range = value
end)

local lplr = game.Players.LocalPlayer

while true do
	if Configs.AutoPlayerLock then
		local lplrchar = lplr.Character or lplr.CharacterAdded:Wait()
		local hrp = lplrchar:WaitForChild("HumanoidRootPart")
		
		local att = Instance.new("Attachment", hrp)
		att.Position = Vector3.new(1.5, 0.5, -1.5)

		local closest

		local detectnearest = Instance.new("Part", workspace)
		detectnearest.Anchored = true
		detectnearest.Size = Vector3.new(Configs.Range*2,Configs.Range*2,Configs.Range*2)
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
			hrp.CFrame = CFrame.new(hrp.Position,hrp.Position + CFrame.new(att.WorldPosition,npchrp.Position * Vector3.new(1,0,1) + att.WorldPosition * Vector3.new(0,1,0)).LookVector)
		end
		att:Destroy()
	end
	task.wait()
end
