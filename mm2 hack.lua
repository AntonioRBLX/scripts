if _G.AlreadyExecuted then return end
_G.AlreadyExecuted = true

local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game.Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()

local configs = {
	GunAimbot = false;
	KnifeAimbot = false;
	Prediction = 50;
	FOV = 350;

	AutoRemoveLag = false;
	IncludeAccessories = false;
	IncludeLocalPlayer = false;
	WalkSpeed = 16;
	JumpPower = 50;
}



local Drawing1 = Drawing.new("Circle")
Drawing1.Color = Color3.fromRGB(255, 89, 89)
Drawing1.Thickness = 2
Drawing1.Visible = false
Drawing1.Radius = configs.FOV
Drawing1.Filled = false

local Drawing2 = Drawing.new("Circle")
Drawing2.Thickness = 4
Drawing2.Visible = false
Drawing2.Radius = configs.FOV
Drawing2.ZIndex = -1
Drawing2.Filled = false

function RemoveDisplays(character)
	local KnifeDisplay = character:WaitForChild("KnifeDisplay", 5)
	local GunDisplay = character:WaitForChild("GunDisplay", 5)

	if not KnifeDisplay or not GunDisplay then return end

	KnifeDisplay:Destroy()
	GunDisplay:Destroy()

	if configs.IncludeAccessories then
		for _, i in pairs(character:GetChildren()) do
			if i:IsA("Accessory") or i.Name == "Radio" or i.Name == "Pet" then
				i:Destroy()
			end
		end
	end
end
function GetClosestPlayer(FOV,maxdist)
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	
	local camera = workspace.CurrentCamera
	local closest
	
	for _, i in pairs(workspace:GetChildren()) do
		if i.ClassName == "Model" and i:FindFirstChildOfClass("Humanoid") and i:FindFirstChild("HumanoidRootPart") then
			if i ~= LocalPlayer.Character then
				local viewportpoint, onscreen = camera:WorldToScreenPoint(i.HumanoidRootPart.Position)
				local distance = (Vector2.new(viewportpoint.X,viewportpoint.Y) - Vector2.new(mouse.X,mouse.Y)).Magnitude
				local distancefromplayer = (i.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

				if onscreen and distance <= FOV / 2 then
					if (not closest or distance < closest[2]) and distancefromplayer <= maxdist then
						closest = {i,distance}
					end
				end
			end
		end
	end
	if closest then
		return closest[1]
	end
	return nil
end
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/modules/main/aimbot.lua"))()

local PhantomForcesWindow = Library:NewWindow("Combat")

local Main = PhantomForcesWindow:NewSection("Main")
local LocalPlayer = PhantomForcesWindow:NewSection("LocalPlayer")

Main:CreateToggle("Gun Aimbot", function(value)
	configs.GunAimbot = value
end)
Main:CreateToggle("Knife Aimbot", function(value)
	configs.KnifeAimbot = value
end)
Main:CreateSlider("Prediction", 0, 1000, 0, false, function(value)
	configs.Prediction = value
end)
Main:CreateSlider("FOV", 0, 1000, 0, false, function(value)
	configs.FOV = value
	Drawing1.Radius = configs.FOV
	Drawing2.Radius = configs.FOV
end)
Main:CreateToggle("Show FOV Circle", function(value)
	Drawing1.Visible = value
	Drawing2.Visible = value
end)

LocalPlayer:CreateButton("Remove Lag", function()
	for _, i in pairs(workspace:GetChildren()) do
		if i.ClassName == "Model" and i:FindFirstChildOfClass("Humanoid") then
			if not configs.IncludeLocalPlayer and LocalPlayer.Character and i == LocalPlayer.Character then return end
			RemoveDisplays(i)
		end
	end
end)
LocalPlayer:CreateToggle("Auto Remove Lag", function(value)
	configs.AutoRemoveLag = value
end)
LocalPlayer:CreateToggle("Include Accessories", function(value)
	configs.IncludeAccessories = value
end)
LocalPlayer:CreateToggle("Include LocalPlayer", function(value)
	configs.IncludeLocalPlayer = value
end)
LocalPlayer:CreateSlider("WalkSpeed", 0, 100, 16, false, function(value)
	configs.WalkSpeed = value
end)
LocalPlayer:CreateSlider("JumpPower", 0, 100, 16, false, function(value)
	configs.JumpPower = value
end)

workspace.ChildAdded:Connect(function(character)
	if configs.AutoRemoveLag and character.ClassName == "Model" then
		if not configs.IncludeLocalPlayer and LocalPlayer.Character and character == LocalPlayer.Character then return end
		RemoveDisplays(character)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		Drawing1.Position = UserInputService:GetMouseLocation()
		Drawing2.Position = UserInputService:GetMouseLocation()
	end
end)

local mt = getrawmetatable(game)
local namecall = mt.__namecall
setreadonly(mt,false)
mt.__namecall = newcclosure(function(self,...)
	local args = {...}
	local method = getnamecallmethod()
	
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local HumanoidRootPart =  LocalPlayer.Character.HumanoidRootPart
		if configs.GunAimbot and tostring(self) == "ShootGun" and tostring(method) == "InvokeServer" then
			local closest = GetClosestPlayer(configs.FOV,500)
			if closest then
				local attachment = Instance.new("Attachment", HumanoidRootPart)
				attachment.Position = Vector3.new(1.6, 1.2, -3)
				
				local _, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,50,0,nil,true,configs.Prediction,nil,true)
				attachment:Destroy()
				
				if aimpos then
					args[2] = aimpos
					return self.InvokeServer(self,table.unpack(args))
				end
			end
		elseif configs.KnifeAimbot and tostring(self) == "Throw" and tostring(method) == "FireServer" then
			local closest = GetClosestPlayer(configs.FOV,500)
			if closest then
				local attachment = Instance.new("Attachment", HumanoidRootPart)
				attachment.Position = Vector3.new(1.5, 1.9, 1)
				
				local _, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,50,0,nil,true,configs.Prediction,nil,false)
				attachment:Destroy()
				
				if aimpos then
					args[1] = CFrame.new(aimpos,aimpos)
					return self.FireServer(self,table.unpack(args))
				end
			end
		end
	end
	return namecall(self,...)
end)
setreadonly(mt,true)

while true do
	local character = LocalPlayer.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = configs.WalkSpeed
			humanoid.JumpPower = configs.JumpPower
		end
	end
	task.wait()
end
