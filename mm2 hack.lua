if _G.mm2hacksalreadyloadedbyCITY512 then return end
_G.mm2hacksalreadyloadedbyCITY512 = true

local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

if not game:IsLoaded() then game.Loaded:Wait() end

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
local antilagalreadyexecuted = false

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

	Chams = false;
	ShowGunDrop = false;
	HighlightDepthMode = Enum.HighlightDepthMode.Occluded;
	MurdererColor = Color3.fromRGB(255, 112, 112);
	HeroColor = Color3.fromRGB(255, 231, 112);
	InnocentColor = Color3.fromRGB(143, 255, 112);
	SheriffColor = Color3.fromRGB(112, 136, 255);
	GunDropColor = Color3.fromRGB(141, 112, 255);
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

function GetRole(player)

end

function AddChams(object,color,allowparts)
	local Highlight = Instance.new("Highlight")
	Highlight.Adornee = object
	Highlight.Name = "MM2CHEATSCHAMS"
	Highlight.FillColor = color
	Highlight.FillTransparency = 0.25
	Highlight.OutlineColor = color
	Highlight.DepthMode = configs.HighlightDepthMode

	if not allowparts and object.ClassName == "Model" and Players:FindFirstChild(object.Name) and object ~= LocalPlayer.Character then
		Highlight.Parent = object
	elseif allowparts then
		Highlight.Parent = object
	end
end

function UpdateChams()
	for _, player in pairs(Players:GetChildren()) do
		local character = workspace:FindFirstChild(player.Name)
		if character then
			local Highlight = character:FindFirstChildOfClass("Highlight") 
			if Highlight and Highlight.Name == "MM2CHEATSCHAMS" then
				Highlight.FillColor = Color3.fromRGB(255,255,255)
				Highlight.DepthMode = configs.HighlightDepthMode
			end
		end
	end
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
		for _, player in pairs(Players:GetChildren()) do
			local character = workspace:FindFirstChild(player.Name)
			if character and character ~= LocalPlayer.Character then
				local NPCRoot = character:FindFirstChild("HumanoidRootPart")
				if NPCRoot then
					local viewportpoint, onscreen = camera:WorldToScreenPoint(NPCRoot.Position)
					local distance = (Vector2.new(viewportpoint.X,viewportpoint.Y) - Vector2.new(mouse.X,mouse.Y)).Magnitude
					local distancefromplayer = (NPCRoot.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

					if onscreen and distance <= FOV then
						if (not closest or distance < closest[2]) and distancefromplayer <= maxdist then
							closest = {character,distance}
						end
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

Visuals:CreateToggle("Player Chams", function(value)
	configs.Chams = value
	for _, player in pairs(Players:GetChildren()) do
		local character = workspace:FindFirstChild(player.Name)
		if character and character ~= LocalPlayer.Character then
			local Highlight = character:FindFirstChildOfClass("Highlight")
			if configs.Chams and not Highlight then
				AddChams(character,Color3.fromRGB(255,255,255),false)
			elseif Highlight and Highlight.Name == "MM2CHEATSCHAMS" then
				Highlight:Destroy()
			end
		end
	end
end)
Visuals:CreateToggle("Show Gun Drop", function(value)
	configs.ShowGunDrop = true
end)
Visuals:CreateColorPicker("Murderer", configs.MurdererColor, function(value)
	configs.MurdererColor = value
	UpdateChams()
end)
Visuals:CreateColorPicker("Hero", configs.HeroColor, function(value)
	configs.HeroColor = value
	UpdateChams()
end)
Visuals:CreateColorPicker("Innocents", configs.InnocentColor, function(value)
	configs.InnocentColor = value
	UpdateChams()
end)
Visuals:CreateColorPicker("Sheriff", configs.SheriffColor, function(value)
	configs.SheriffColor = value
	UpdateChams()
end)
Visuals:CreateColorPicker("Gun Drop Color", configs.GunDropColor, function(value)
	configs.MurdererColor = value
	UpdateChams()
end)
Visuals:CreateToggle("AlwaysOnTop", function(value)
	if value then
		configs.HighlightDepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	else
		configs.HighlightDepthMode = Enum.HighlightDepthMode.Occluded
	end
	UpdateChams()
end)
if Drawing then
	Visuals:CreateToggle("Show FOV Circle", function(value)
		Drawing1.Visible = value
		Drawing2.Visible = value
	end)
end
Visuals:CreateButton("Remove Map Lag", function()
	if not antilagalreadyexecuted then
		antilagalreadyexecuted = true

		local Terrain = workspace.Terrain
		Terrain.WaterWaveSize = 0
		Terrain.WaterWaveSpeed = 0
		Terrain.WaterReflectance = 0
		Terrain.WaterTransparency = 0

		local Lighting = game.Lighting
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		settings().Rendering.QualityLevel = 1

		local function RemoveLagFromObject(object)
			if not object:FindFirstAncestorOfClass("Model") or not object:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid") then
				if object:IsA("MeshPart") then
					object.Material = Enum.Material.SmoothPlastic
					object.TextureID = ""
				elseif object:IsA("UnionOperation") then
					object.Material = Enum.Material.SmoothPlastic
				elseif object:IsA("Decal") then
					object:Destroy()
				elseif object.ClassName == "SpecialMesh" and object.MeshType == Enum.MeshType.FileMesh then
					object.TextureId = ""
				elseif object:IsA("ParticleEmitter") or object:IsA("Trail") then
					object:Destroy()
				elseif object:IsA("BasePart") then
					object.Material = Enum.Material.SmoothPlastic
					object.Reflectance = 0
					object.TopSurface = Enum.SurfaceType.Smooth
					object.BottomSurface = Enum.SurfaceType.Smooth
					object.FrontSurface = Enum.SurfaceType.Smooth
					object.BackSurface = Enum.SurfaceType.Smooth
					object.LeftSurface = Enum.SurfaceType.Smooth
					object.RightSurface = Enum.SurfaceType.Smooth
				end
			end
		end
		for _, child in pairs(Lighting:GetChildren()) do
			if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("DepthOfFieldEffect") then
				child:Destroy()
			end
		end
		for _, descendant in pairs(workspace:GetDescendants()) do
			RemoveLagFromObject(descendant)
		end
		workspace.DescendantAdded:Connect(function(descendant)
			RemoveLagFromObject(descendant)
		end)
	end
end)
Visuals:CreateButton("Remove Accessory Lag", function()
	for _, player in pairs(Players:GetChildren()) do
		local character = workspace:FindFirstChild(player.Name)
		if character and (configs.IncludeLocalPlayer or character ~= LocalPlayer.Character) then
			RemoveDisplays(character)
		end
	end
end)
Visuals:CreateToggle("Auto Remove Lag", function(value)
	configs.AutoRemoveLag = value
end)
Visuals:CreateToggle("Include Hats", function(value)
	configs.IncludeOtherAccessories = value
end)
Visuals:CreateToggle("Include LocalPlayer", function(value)
	configs.IncludeLocalPlayer = value
end)

Others:CreateButton("Dupe", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/scripts/main/mm2%20dupe"))()
end)
Others:CreateButton("Rejoin", function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)
Others:CreateButton("Unload", function()
	_G.mm2hacksalreadyloadedbyCITY512 = false
	scriptactivated = false
end)

workspace.ChildAdded:Connect(function(child)
	coroutine.wrap(function()
		if scriptactivated and child.ClassName == "Model" and Players:FindFirstChild(child.Name) then
			if configs.Chams and child ~= LocalPlayer.Character then
				AddChams(child,Color3.fromRGB(255,255,255),false)
			end
			if configs.AutoRemoveLag and (configs.IncludeLocalPlayer or child ~= LocalPlayer.Character) and child:WaitForChild("KnifeDisplay", 1) and child:WaitForChild("GunDisplay", 1) then
				RemoveDisplays(child)
			end
		elseif configs.ShowGunDrop and child.ClassName == "Part" and child.Name == "GunDrop" then
			AddChams(child,configs.GunDropColor)
		end
	end)()
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
				for _, player in pairs(Players:GetChildren()) do
					local character = workspace:FindFirstChild(player.Name)
					if character and character ~= Character then
						local NPCRoot = character:FindFirstChild("HumanoidRootPart")
						if NPCRoot then
							local distance = (NPCRoot.Position - HumanoidRootPart.Position).Magnitude
							if distance < configs.KillAuraRange then
								if not closest or distance < closest[2] then
									closest = {character,distance}
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
					TargetRoot.Size = Vector3.new(configs.KillAuraRange * 2,configs.KillAuraRange * 2,configs.KIllAuraRange * 2)
					Knife:Activate()
				end
			end
		end
	end
	task.wait()
end
