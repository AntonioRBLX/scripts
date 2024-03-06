if _G.mm2hacksalreadyloadedbyCITY512 then return end
_G.mm2hacksalreadyloadedbyCITY512 = true

local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

if not game:IsLoaded() then game.Loaded:Wait() end

-- check for supported commands
if not hookmetamethod or not setreadonly or not newcclosure or not getnamecallmethod then
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
	KillAura = false;
	KillAuraRange = 15;
	FaceTarget = false;

	AutoRemoveLag = false;
	IncludeAccessories = false;
	IncludeLocalPlayer = false;
	WalkSpeed = 16;
	JumpPower = 50;

	ESP = false;
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
function AddESP(character,color)
	local Highlight = Instance.new("Highlight", character)
	Highlight.FillColor = color
	Highlight.FillTransparency = 0.25
	Highlight.OutlineColor = color
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end
function RemoveDisplays(character)
	local KnifeDisplay = character:FindFirstChild("KnifeDisplay")
	local GunDisplay = character:FindFirstChild("GunDisplay")

	if configs.IncludeAccessories then
		for _, child in pairs(character:GetChildren()) do
			if child:IsA("Accessory") or child.Name == "Radio" or child.Name == "Pet" then
				child:Destroy()
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
	
	if camera then
		for _, child in pairs(workspace:GetChildren()) do
			if Players:GetPlayerFromCharacter(child) and child ~= LocalPlayer.Character and child:FindFirstChild("HumanoidRootPart") then
				local viewportpoint, onscreen = camera:WorldToScreenPoint(child.HumanoidRootPart.Position)
				local distance = (Vector2.new(viewportpoint.X,viewportpoint.Y) - Vector2.new(mouse.X,mouse.Y)).Magnitude
				local distancefromplayer = (child.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
	
				if onscreen and distance <= FOV then
					if (not closest or distance < closest[2]) and distancefromplayer <= maxdist then
						closest = {child,distance}
					end
				end
			end
		end
		if closest then
			return closest[1]
		end
	end
	return nil
end
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/modules/main/aimbot.lua"))()

local PhantomForcesWindow = Library:NewWindow("Combat")

local Main = PhantomForcesWindow:NewSection("Main")
local LocalPlayerTab = PhantomForcesWindow:NewSection("LocalPlayer")
local Visuals = PhantomForcesWindow:NewSection("Visuals")
local Others = PhantomForcesWindow:NewSection("Others")

Main:CreateToggle("Gun Aimbot", function(value)
	configs.GunAimbot = value
end)
Main:CreateToggle("Knife Aimbot", function(value)
	configs.KnifeAimbot = value
end)
Main:CreateSlider("Ping Prediction", 0, 1000, 50, false, function(value)
	configs.Prediction = value
end)
Main:CreateSlider("FOV", 0, 1000, 350, false, function(value)
	configs.FOV = value
	if Drawing then
		Drawing1.Radius = configs.FOV
		Drawing2.Radius = configs.FOV
	end
end)

Main:CreateToggle("Kill Aura", function(value)
	configs.KillAura = value
end)
Main:CreateSlider("Kill Aura Range", 0, 100, 15, true, function(value)
	configs.KillAuraRange = value
	print(configs.KillAuraRange)
end)
Main:CreateToggle("Face Target", function(value)
	configs.FaceTarget = value
end)
LocalPlayerTab:CreateSlider("WalkSpeed", 0, 100, 16, false, function(value)
	configs.WalkSpeed = value
end)
LocalPlayerTab:CreateSlider("JumpPower", 0, 100, 50, false, function(value)
	configs.JumpPower = value
end)

Visuals:CreateToggle("ESP", function(value)
	configs.ESP = value
	for _, child in pairs(workspace:GetChildren()) do
		if configs.ESP then
			if Players:GetPlayerFromCharacter(child) and child ~= LocalPlayer.Character then
				AddESP(child,Color3.new(255,255,255))
			end
		elseif child:FindFirstChildOfClass("Highlight") then
			child:FindFirstChildOfClass("Highlight"):Destroy()
		end
	end
end)
if Drawing then
	Visuals:CreateToggle("Show FOV Circle", function(value)
		Drawing1.Visible = value
		Drawing2.Visible = value
	end)
end
Visuals:CreateButton("Remove Lag", function()
	for _, child in pairs(workspace:GetChildren()) do
		if Players:GetPlayerFromCharacter(child) and (configs.IncludeLocalPlayer or child ~= LocalPlayer.Character) then
			RemoveDisplays(child)
		end
	end
end)
Visuals:CreateToggle("Auto Remove Lag", function(value)
	configs.AutoRemoveLag = value
end)
Visuals:CreateToggle("Include Accessories", function(value)
	configs.IncludeAccessories = value
end)
Visuals:CreateToggle("Include LocalPlayer", function(value)
	configs.IncludeLocalPlayer = value
end)

Others:CreateButton("Dupe (patched)", function()
	
end)
Others:CreateButton("Rejoin", function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)
Others:CreateButton("Unload", function()
	_G.mm2hacksalreadyloadedbyCITY512 = false
	scriptactivated = false
end)

workspace.ChildAdded:Connect(function(child)
	if scriptactivated and Players:FindFirstChild(child.Name) then
		if configs.ESP and child ~= LocalPlayer.Character then
			AddESP(child,Color3.new(255,255,255))
		end
		if configs.AutoRemoveLag and (configs.IncludeLocalPlayer or child ~= LocalPlayer.Character) and child:WaitForChild("KnifeDisplay", 1) and child:WaitForChild("GunDisplay", 1) then
			RemoveDisplays(child)
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

local namecall
namecall = hookmetamethod(game,"__namecall",function(self,...)
	local args = {...}
	local method = getnamecallmethod()
	if scriptactivated and not checkcaller() and LocalPlayer.Character then
		if configs.GunAimbot and tostring(self) == "ShootGun" and tostring(method) == "InvokeServer" then
			local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
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
			local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
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

StarterGui:SetCore("SendNotification" ,{
	Title = "Info";
	Text = "Successfully Loaded!";
})

local prevtarget
while true do
	if prevtarget and prevtarget:FindFirstChild("HumanoidRootPart") then
		local PrevTargetRoot = prevtarget.HumanoidRootPart
		PrevTargetRoot.CanCollide = true
		PrevTargetRoot.Size = Vector3.new(2,2,1)
		prevtarget = nil
	end
	if not scriptactivated then break end
	
	local Character = LocalPlayer.Character
	if Character then
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		if Humanoid then
			Humanoid.WalkSpeed = configs.WalkSpeed
			Humanoid.JumpPower = configs.JumpPower
		end
		if configs.KillAura then
			local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			local Knife = Character:FindFirstChild("Knife")
			if HumanoidRootPart and Knife and Knife.ClassName == "Tool" then
				local closest
				for _, child in pairs(workspace:GetChildren()) do
					if child.ClassName == "Model" and Players:GetPlayerFromCharacter(child) and child ~= Character then
						local NPCRoot = child:FindFirstChild("HumanoidRootPart")
						if NPCRoot then
							local distance = (NPCRoot.Position - HumanoidRootPart.Position).Magnitude
							if distance < configs.KillAuraRange then
								if not closest or distance < closest[2] then
									closest = {child,distance}
								end
							end
						end
					end
				end
				if closest then
					prevtarget = closest[1]
					
					local TargetRoot = prevtarget.HumanoidRootPart
					if configs.FaceTarget then
						HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position,TargetRoot.Position * Vector3.new(1,0,1) + HumanoidRootPart.Position * Vector3.new(0,1,0))
					end
					TargetRoot.CanCollide = false
					TargetRoot.Size = Vector3.new(250,250,250)
					Knife:Activate()
				end
			end
		end
	end
	task.wait()
end
