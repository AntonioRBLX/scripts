local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

if _G.Loaded then return end
_G.Loaded = true

if not game:IsLoaded() then game.Loaded:Wait() end

-- check for supported commands
if not getrawmetatable or not setreadonly or not newcclosure or not getnamecallmethod then
	StarterGui:SetCore("SendNotification" ,{
		Title = "Error";
		Text = "Incompatible Executor!: Certain functions are not supported by this executor.";
	})
	return
end

local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()

local scriptactivated = true
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

local Drawing1
local Drawing2

if Drawing then
	Drawing1 = Drawing.new("Circle")
	Drawing1.Color = Color3.fromRGB(255, 89, 89)
	Drawing1.Thickness = 2
	Drawing1.Visible = false
	Drawing1.Radius = configs.FOV
	Drawing1.Filled = false
	
	Drawing2 = Drawing.new("Circle")
	Drawing2.Thickness = 4
	Drawing2.Visible = false
	Drawing2.Radius = configs.FOV
	Drawing2.ZIndex = -1
	Drawing2.Filled = false
else
	StarterGui:SetCore("SendNotification" ,{
		Title = "Info";
		Text = "Drawing is not supported on this executor, ShowFOVCircle will not work.";
	})
end

function RemoveDisplays(character)
	local KnifeDisplay = character:FindFirstChild("KnifeDisplay")
	local GunDisplay = character:FindFirstChild("GunDisplay")

	if configs.IncludeAccessories then
		for _, i in pairs(character:GetChildren()) do
			if i:IsA("Accessory") or i.Name == "Radio" or i.Name == "Pet" then
				i:Destroy()
			end
		end
	end

	if not KnifeDisplay then return end
	KnifeDisplay:Destroy()
	if not GunDisplay then return end
	GunDisplay:Destroy()
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
local LocalPlayerTab = PhantomForcesWindow:NewSection("LocalPlayer")
local Others = PhantomForcesWindow:NewSection("Others")

Main:CreateToggle("Gun Aimbot", function(value)
	configs.GunAimbot = value
end)
Main:CreateToggle("Knife Aimbot", function(value)
	configs.KnifeAimbot = value
end)
Main:CreateSlider("Prediction", 0, 1000, 50, false, function(value)
	configs.Prediction = value
end)
Main:CreateSlider("FOV", 0, 1000, 350, false, function(value)
	configs.FOV = value
	if Drawing then
		Drawing1.Radius = configs.FOV
		Drawing2.Radius = configs.FOV
	end
end)
if Drawing then
	Main:CreateToggle("Show FOV Circle", function(value)
		Drawing1.Visible = value
		Drawing2.Visible = value
	end)
end
LocalPlayerTab:CreateButton("Remove Lag", function()
	for _, i in pairs(workspace:GetChildren()) do
		if i.ClassName == "Model" and i:FindFirstChildOfClass("Humanoid") and (configs.IncludeLocalPlayer or i.Name ~= LocalPlayer.Name) then
			RemoveDisplays(i)
		end
	end
end)
LocalPlayerTab:CreateToggle("Auto Remove Lag", function(value)
	configs.AutoRemoveLag = value
end)
LocalPlayerTab:CreateToggle("Include Accessories", function(value)
	configs.IncludeAccessories = value
end)
LocalPlayerTab:CreateToggle("Include LocalPlayer", function(value)
	configs.IncludeLocalPlayer = value
end)
LocalPlayerTab:CreateSlider("WalkSpeed", 0, 100, 16, false, function(value)
	configs.WalkSpeed = value
end)
LocalPlayerTab:CreateSlider("JumpPower", 0, 100, 50, false, function(value)
	configs.JumpPower = value
end)

Others:CreateButton("Rejoin", function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)
Others:CreateButton("Unload", function()
	_G.Loaded = false
	scriptactivated = false
end)

workspace.ChildAdded:Connect(function(character)
	if scriptactivated and configs.AutoRemoveLag and character.ClassName == "Model" and character:WaitForChild("Humanoid", 1) and (configs.IncludeLocalPlayer or i.Name ~= LocalPlayer.Name) and character:WaitForChild("KnifeDisplay", 1) and character:WaitForChild("GunDisplay", 1) then
		if configs.IncludeLocalPlayer or i.Name ~= LocalPlayer.Name then
			RemoveDisplays(character)
		end
	end
end)

if Drawing then
	UserInputService.InputChanged:Connect(function(input)
		if scriptactivated and input.UserInputType == Enum.UserInputType.MouseMovement then
			local mouselocation = UserInputService:GetMouseLocation()
			Drawing1.Position = mouselocation
			Drawing2.Position = mouselocation
		end
	end)
end

local mt = getrawmetatable(game)
local namecall = mt.__namecall
setreadonly(mt,false)

mt.__namecall = newcclosure(function(self,...)
	local args = {...}
	local method = getnamecallmethod()
	if scriptactivated and LocalPlayer.Character then
		local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
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

StarterGui:SetCore("SendNotification" ,{
	Title = "Info";
	Text = "Successfully Loaded!";
})

while true do
	if not scriptactivated then break end

	local Character = LocalPlayer.Character
	if Character then
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then
			Humanoid.WalkSpeed = configs.WalkSpeed
			Humanoid.JumpPower = configs.JumpPower
		end
	end
	task.wait()
end
