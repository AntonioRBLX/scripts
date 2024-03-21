if not game:IsLoaded() then game.Loaded:Wait() end
repeat task.wait() until game.Players.LocalPlayer

if _G.mm2hacksalreadyloadedbyCITY512 then return end
_G.mm2hacksalreadyloadedbyCITY512 = true

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/modules/main/aimbot.lua"))()

local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")

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
	ShowCalculations = false;
	FOV = 350;
	KillAura = false;
	KillAuraRange = 15;
	FaceTarget = false;

	AutoRemoveLag = false;
	IncludeAccessories = false;
	IncludeLocalPlayer = false;
	ToggleWalkSpeed = false;
	ToggleJumpPower = false;
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
	local lplrchar = LocalPlayer.Character
	local Highlight = Instance.new("Highlight")
	Highlight.Adornee = object
	Highlight.Name = "MM2CHEATSCHAMS"
	Highlight.FillColor = color
	Highlight.FillTransparency = 0.25
	Highlight.OutlineColor = color
	Highlight.DepthMode = configs.HighlightDepthMode

	if not allowparts and object.ClassName == "Model" and Players:FindFirstChild(object.Name) and object ~= lplrchar then
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
	local lplrchar = LocalPlayer.Character
	local lplrhrp = lplrchar.HumanoidRootPart

	local camera = workspace.CurrentCamera
	local closest

	local function getclosestplayertoscreenpoint(point)
		for _, player in pairs(Players:GetChildren()) do
			local character = workspace:FindFirstChild(player.Name)
			if character and character ~= lplrchar then
				local NPCRoot = character:FindFirstChild("HumanoidRootPart")
				if NPCRoot then
					local viewportpoint, onscreen = camera:WorldToScreenPoint(NPCRoot.Position)
					local distance = (Vector2.new(viewportpoint.X,viewportpoint.Y) - point).Magnitude
					local distancefromplayer = (NPCRoot.Position - lplrhrp.Position).Magnitude

					if onscreen and distance <= FOV then
						if not closest or distance < (closest.HumanoidRootPart.Position - lplrhrp.Position).Magnitude and distancefromplayer <= maxdist then
							closest = character
						end
					end
				end
			end
		end
	end
	if configs.AimbotMethod == "ClosestPlayerToCursor" and camera then
		getclosestplayertoscreenpoint(Vector2.new(mouse.X,mouse.Y))
		return closest
	elseif configs.AimbotMethod == "ClosestPlayerToCharacter" then
		for _, player in pairs(Players:GetChildren()) do
			local character = workspace:FindFirstChild(player.Name)
			if character and character ~= lplrchar and character:FindFirstChild("HumanoidRootPart") then
				local distance = (character.HumanoidRootPart.Position - lplrhrp.Position).Magnitude
				if not closest or distance < (closest.HumanoidRootPart.Position - lplrhrp.Position).Magnitude and distance <= maxdist then
					closest = character
				end
			end
		end
		return closest
	elseif configs.AimbotMethod == "ClosestPlayerToScreenCenter" and camera then
		getclosestplayertoscreenpoint(Vector2.new(camera.ViewportSize.X,camera.ViewportSize.Y - 58)/2)
		return closest
	end
	return nil
end

local Window = Library:CreateWindow({
	Name = "Murder Mystery 2";
	LoadingTitle = "Murder Mystery 2 Main";
	LoadingSubtitle = "by CITY512";
	ConfigurationSaving = {
		Enabled = true;
		FolderName = "Murder Mystery 2"; -- Create a custom folder for your hub/game
		FileName = "MM2CHEATSBYCITY512"
	};
	Discord = {
		Enabled = false;
		Invite = "noinvitelink"; -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
		RememberJoins = true -- Set this to false to make them join the discord every time they load it up
	};
	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
		Title = "Untitled";
		Subtitle = "Key System";
		Note = "No method of obtaining the key is provided";
		FileName = "Key"; -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
		SaveKey = true; -- The user's key will be saved, but if you change the key, they will be unable to use your script
		GrabKeyFromSite = false; -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
	}
})

local Main = Window:CreateTab("Main", 4483362458) -- Title, Image
local LocalPlayerTab = Window:CreateTab("LocalPlayer", 4483362458) -- Title, Image
local Visuals = Window:CreateTab("Visuals", 4483362458) -- Title, Image
local Others = Window:CreateTab("Others", 4483362458) -- Title, Image

local Section = Main:CreateSection("Aimbot", true) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local GunAimbot = Main:CreateToggle({
	Name = "Gun Aimbot";
	CurrentValue = false;
	Flag = "Gun Aimbot"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.GunAimbot = value
	end;
})
local KnifeAimbot = Main:CreateToggle({
	Name = "Knife Aimbot";
	CurrentValue = false;
	Flag = "Knife Aimbot"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.KnifeAimbot = value
	end;
})
local PingPrediction = Main:CreateSlider({
	Name = "Ping Prediction";
	Range = {0, 1000};
	Increment = 1;
	Suffix = "ms";
	CurrentValue = 50;
	Flag = "Ping Prediction"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.Prediction = value
	end;
})
local Dropdown = Main:CreateDropdown({
	Name = "Aimbot Method";
	Options = {"ClosestPlayerToCursor","ClosestPlayerToCharacter","ClosestPlayerToScreenCenter"};
	CurrentOption = "ClosestPlayerToCursor";
	MultiSelection = false; -- If MultiSelections is allowed
	Flag = "Aimbot Method"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(option)
		configs.AimbotMethod = option
	end,
})
local ShowCalculations = Main:CreateToggle({
	Name = "Show Calculations";
	CurrentValue = false;
	Flag = "Show Calculations"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.ShowCalculations = value
	end;
})
local FOV = Main:CreateSlider({
	Name = "FOV";
	Range = {0, 1000};
	Increment = 1;
	Suffix = "";
	CurrentValue = 350;
	Flag = "FOV"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.FOV = value
		if Drawing then
			Drawing1.Radius = configs.FOV
			Drawing2.Radius = configs.FOV
		end
	end;
})

local Section = Main:CreateSection("Kill Aura", true) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local KillAura = Main:CreateToggle({
	Name = "Kill Aura";
	CurrentValue = false;
	Flag = "Kill Aura"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.KillAura = value
	end;
})
local KillAuraRange = Main:CreateSlider({
	Name = "Kill Aura Range";
	Range = {0, 100};
	Increment = 0.1;
	Suffix = "studs";
	CurrentValue = 15;
	Flag = "FOV"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.KillAuraRange = value
	end;
})
local FaceTarget = Main:CreateToggle({
	Name = "Face Target";
	CurrentValue = false;
	Flag = "Face Target"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.FaceTarget = value
	end;
})
local WalkSpeedToggle = LocalPlayerTab:CreateToggle({
	Name = "Toggle WalkSpeed";
	CurrentValue = false;
	Flag = "Toggle WalkSpeed"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.ToggleWalkSpeed = value
	end;
})
local JumpPowerToggle = LocalPlayerTab:CreateToggle({
	Name = "Toggle JumpPower";
	CurrentValue = false;
	Flag = "Toggle JumpPower"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.ToggleJumpPower = value
	end;
})
local WalkSpeed = LocalPlayerTab:CreateSlider({
	Name = "WalkSpeed";
	Range = {0, 100};
	Increment = 1;
	Suffix = "";
	CurrentValue = 16;
	Flag = "WalkSpeed"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.WalkSpeed = value
	end;
})
local JumpPower = LocalPlayerTab:CreateSlider({
	Name = "JumpPower";
	Range = {0, 100};
	Increment = 1;
	Suffix = "";
	CurrentValue = 50;
	Flag = "JumpPower"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.JumpPower = value
	end;
})

local Section = Visuals:CreateSection("Chams", true) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local PlayerChams = Visuals:CreateToggle({
	Name = "Player Chams";
	CurrentValue = false;
	Flag = "Player Chams"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.Chams = value
		local lplrchar = LocalPlayer.Character
		for _, player in pairs(Players:GetChildren()) do
			local character = workspace:FindFirstChild(player.Name)
			if character and character ~= lplrchar then
	local Highlight = character:FindFirstChildOfClass("Highlight")
	if configs.Chams and not Highlight then
		AddChams(character,Color3.fromRGB(255,255,255),false)
	elseif Highlight and Highlight.Name == "MM2CHEATSCHAMS" then
		Highlight:Destroy()
	end
end
end
end;
})
local ShowGunDrop = Visuals:CreateToggle({
	Name = "Show Gun Drop";
	CurrentValue = false;
	Flag = "Show Gun Drop"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.ShowGunDrop = value
	end;
})
local AlwaysOnTop = Visuals:CreateToggle({
	Name = "Always On Top";
	CurrentValue = false;
	Flag = "Always On Top"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		if value then
			configs.HighlightDepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		else
			configs.HighlightDepthMode = Enum.HighlightDepthMode.Occluded
		end
		UpdateChams()
	end;
})
local MurdererColor = Visuals:CreateColorPicker({
	Name = "Murderer Color";
	Color = configs.MurdererColor;
	Flag = "Murderer Color"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.MurdererColor = value
		UpdateChams()
	end
})
local HeroColor = Visuals:CreateColorPicker({
	Name = "Hero Color";
	Color = configs.HeroColor;
	Flag = "Hero Color"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.HeroColor = value
		UpdateChams()
	end
})
local InnocentColor = Visuals:CreateColorPicker({
	Name = "Innocent Color";
	Color = configs.InnocentColor;
	Flag = "Innocent Color"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.InnocentColor = value
		UpdateChams()
	end
})
local SheriffColor = Visuals:CreateColorPicker({
	Name = "Sheriff Color";
	Color = configs.SheriffColor;
	Flag = "Sheriff Color"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.SheriffColor = value
		UpdateChams()
	end
})
local GunDropColor = Visuals:CreateColorPicker({
	Name = "Gun Drop Color";
	Color = configs.GunDropColor;
	Flag = "Gun Drop Color"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.GunDropColor = value
		UpdateChams()
	end
})
if Drawing then
	local ShowFOVCircle = Visuals:CreateToggle({
		Name = "Show FOV Circle";
		CurrentValue = false;
		Flag = "Show FOV Circle"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
		Callback = function(value)
			Drawing1.Visible = value
			Drawing2.Visible = value
		end;
	})
end

local Section = Visuals:CreateSection("World", true) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local RemoveMapLag = Visuals:CreateButton({
	Name = "Remove Map Lag";
	Callback = function()
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
	end;
})
local RemoveAccessoryLag = Visuals:CreateButton({
	Name = "Remove Accessory Lag";
	Callback = function()
		local lplrchar = LocalPlayer.Character
		for _, player in pairs(Players:GetChildren()) do
			local character = workspace:FindFirstChild(player.Name)
			if character and (configs.IncludeLocalPlayer or character ~= lplrchar) then
	RemoveDisplays(character)
end
end
end;
})
local AutoRemoveLag = Visuals:CreateToggle({
	Name = "Auto Remove Lag";
	CurrentValue = false;
	Flag = "Auto Remove Lag"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.AutoRemoveLag = value
	end;
})
local IncludeHats = Visuals:CreateToggle({
	Name = "Include Hats";
	CurrentValue = false;
	Flag = "Include Hats"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.IncludeAccessories = value
	end;
})
local IncludeLocalPlayer = Visuals:CreateToggle({
	Name = "Include LocalPlayer";
	CurrentValue = false;
	Flag = "Include LocalPlayer"; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(value)
		configs.IncludeLocalPlayer = value
	end;
})
local Dupe = Others:CreateButton({
	Name = "Dupe";
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/scripts/main/mm2%20dupe"))()
	end;
})
local Rejoin = Others:CreateButton({
	Name = "Rejoin";
	Callback = function()
		game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
	end;
})
local Unload = Others:CreateButton({
	Name = "Unload";
	Callback = function()
		_G.mm2hacksalreadyloadedbyCITY512 = false
		scriptactivated = false
		Library:Destroy()
	end;
})

workspace.ChildAdded:Connect(function(child)
	local lplrchar = LocalPlayer.Character
	if scriptactivated and child.ClassName == "Model" and Players:FindFirstChild(child.Name) then
		if configs.Chams and child ~= lplrchar then
	AddChams(child,Color3.fromRGB(255,255,255),false)
end
if configs.AutoRemoveLag and (configs.IncludeLocalPlayer or child.Name ~= LocalPlayer.Name) and child:WaitForChild("KnifeDisplay", 10) and child:WaitForChild("GunDisplay", 10) then
	RemoveDisplays(child)
end
elseif configs.ShowGunDrop and child.ClassName == "Part" and child.Name == "GunDrop" then
	AddChams(child,configs.GunDropColor)
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

				local path, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,100,0,nil,true,configs.Prediction,nil,true)
				attachment:Destroy()

				if aimpos then
					spawn(function()
						if configs.ShowCalculations then
							local hue = 0
							local prevatt
							local container = Instance.new("Part", workspace)
							container.Anchored = true
							container.CanCollide = false
							container.Transparency = 1
							for _, i in pairs(path) do
								local att = Instance.new("Attachment", container)
								att.WorldPosition = i

								if prevatt then
									local beam = Instance.new("Beam", container)
									beam.Attachment0 = prevatt
									beam.Attachment1 = att
									beam.FaceCamera = true
									beam.Width0 = 0.1
									beam.Width1 = 0.1
									beam.Segments = 1
									beam.Transparency = 0
									beam.Color = ColorSequence.new(Color3.fromHSV(hue/360, 0.443137, 1))
								end

								hue += 3
								if hue >= 360 then
									hue = 0
								end

								prevatt = att
							end
							task.wait(3)
							container:Destroy()
						end
					end)
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

				local path, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,100,0,nil,true,configs.Prediction,nil,false)
				attachment:Destroy()

				if aimpos then
					spawn(function()
						if configs.ShowCalculations then
							local hue = 0
							local prevatt
							local container = Instance.new("Part", workspace)
							container.Anchored = true
							container.CanCollide = false
							container.Transparency = 1
							for _, i in pairs(path) do
								local att = Instance.new("Attachment", container)
								att.WorldPosition = i

								if prevatt then
									local beam = Instance.new("Beam", container)
									beam.Attachment0 = prevatt
									beam.Attachment1 = att
									beam.FaceCamera = true
									beam.Width0 = 0.1
									beam.Width1 = 0.1
									beam.Segments = 1
									beam.Transparency = 0
									beam.Color = ColorSequence.new(Color3.fromHSV(hue/360, 0.443137, 1))
								end

								hue += 3
								if hue >= 360 then
									hue = 0
								end

								prevatt = att
							end
							task.wait(3)
							container:Destroy()
						end
					end)
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
			if configs.ToggleWalkSpeed then
				Humanoid.WalkSpeed = configs.WalkSpeed
			end
			if configs.ToggleJumpPower then
				Humanoid.JumpPower = configs.JumpPower
			end
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
					TargetRoot.Size = Vector3.new(configs.KillAuraRange,configs.KillAuraRange,configs.KillAuraRange)
					Knife:Activate()
				end
			end
		end
	end
	task.wait()
end
