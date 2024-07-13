local CoreGui = game:GetService("CoreGui")
local RS = game:GetService("RunService")
local REPS = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

function notify(title,msg)
	StarterGui:SetCore("SendNotification" ,{
		Title = title;
		Text = msg;
	})
end
if not game:IsLoaded() then
	local message = Instance.new("Hint", CoreGui)
	message.Text = "Waiting For Game To Load..."
	game.Loaded:Wait()
	message:Destroy()
end
if not rawget or not hookmetamethod or not setreadonly or not newcclosure or not getnamecallmethod or not getgenv or not firetouchinterest or not keypress or not keyrelease then -- Checks if executor is supported
	notify("Error","Incompatible Executor! Required functions are not supported by this executor.")
	return
end
if game.PlaceId ~= 142823291 and game.PlaceId ~= 636649648 then 
	notify("Error","Unsupported game. Supported Games: Murder Mystery 2 / MM2 Assassin")
	return
end

if MM2MAIN then
	notify("Error","Already Executed!")
	return
end -- Checks if the script is already executed
getgenv().MM2MAIN = true

-- Modules

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/modules/main/Projectile%20Aimbot.lua"))()

repeat task.wait() until game.Players.LocalPlayer -- Waits for LocalPlayer to load in.
-- Variables

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local prevtarget

local configs = { -- Library Configurations
	GunAimbot = false;
	KnifeAimbot = false;
	GunPrediction = 150;
	KnifePrediction = 100;
	Automatic = false;
	AimbotMethod = "Murderer";
	MurdererAimbotMethod = "ClosestPlayerToCursor";
	FOV = 350;
	AutoEquip = false;
	AutoShoot = false;
	KillAura = false;
	KillAuraRange = 15;
	FaceTarget = false;

	AutoRemoveLag = false;
	IncludeAccessories = false;
	IncludeLocalPlayer = false;
	RemoveCoinLag = false;
	ToggleWalkSpeed = false;
	ToggleJumpPower = false;
	WalkSpeed = 16;
	JumpPower = 50;

	CoinFarm = false;
	XPFarm = false;
	AutoUnbox = false;
	AutoUnboxCrate = {};
	AutoFarmSpeed = 1;
	AutoFarmDelay = 0.5;

	AutoGrabGun = false;
	FlingPlayer = nil;

	Chams = false;
	ShowGunDrop = false;
	TrapESP = false;
	MurdererColor = Color3.fromRGB(255, 112, 112);
	TrapColor = Color3.fromRGB(255, 172, 112);
	HeroColor = Color3.fromRGB(255, 231, 112);
	InnocentColor = Color3.fromRGB(143, 255, 112);
	SheriffColor = Color3.fromRGB(112, 136, 255);
	GunDropColor = Color3.fromRGB(141, 112, 255);
	ShowAimbotVisuals = false;
	ShowFOVCircle = false;
}

local players = {}
local visuals = {}

local weapons = {
	Knife = {
		Role = {"Murderer","Target"};
		Speed = {
			Normal = 80;
			Sleight = 100;
		}
	};
	Gun = {
		Role = {"Sheriff","Hero"};
	}
}
local match = {
	SheriffDied = false;
	Map = nil;
}
local powers = {
	Sleight = false;
}
local eventfunctions = {}
local scriptvariables = {
	IsFlinging = false;
	AntiLagAlreadyExecuted = false;
	ExecuteOnTeleport = false;
	TPCheck = false;
	QueueOnTeleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport;
}
local connections = {}
local a = 0

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
	notify("Info","Drawing is not supported on this executor, functions such as ShowFOVCircle and AimbotVisuals will not work.")
end

---------------------------------------------------------------------------
-- Functions

function Draw3D(dictionary) -- dictionary = {StartPoint = (), EndPoint = (), Color = (), LifeTime = ()}
	local line = Drawing.new("Line")
	line.Visible = true
	line.Color = dictionary.Color
	line.Thickness = 1
	line.Transparency = 0

	table.insert(visuals, {Line = line, Spawn = tick(), Properties = {
		StartPoint = dictionary.StartPoint;
		EndPoint = dictionary.EndPoint;
		Color = dictionary.Color;
		LifeTime = dictionary.LifeTime;
	}})
end
function AddChams(object,isacharmodel,chamsettings) -- Adds ESP
	local function AddBoxHandleAdornment(part)
		local BHA = Instance.new("BoxHandleAdornment", part)
		BHA.Name = "MM2CHAMS"
		BHA.Adornee = part
		BHA.Color3 = chamsettings.Color
		BHA.ZIndex = 10
		BHA.AlwaysOnTop = true
		BHA.Size = part.Size
		BHA.Transparency = 0.3
	end
	if isacharmodel then
		if object.ClassName == "Model" and Players:FindFirstChild(object.Name) then
			for _, limb in ipairs(object:GetChildren()) do
				if limb:IsA("BasePart") and limb.Name ~= "HumanoidRootPart" and not limb:FindFirstChild("MM2CHAMS") then
					AddBoxHandleAdornment(limb)
				end
			end
		end
	elseif object:IsA("BasePart") then
		AddBoxHandleAdornment(object)
	end
end
function UpdateChams(object,isacharmodel,chamsettings) -- Updates ESP
	local function changeadornment(BHA)
		BHA.Color3 = chamsettings.Color
	end
	if isacharmodel then
		if object.ClassName == "Model" and Players:FindFirstChild(object.Name) then
			for _, limb in ipairs(object:GetChildren()) do
				local BHA = limb:FindFirstChild("MM2CHAMS")
				if BHA and BHA.ClassName == "BoxHandleAdornment" then
					changeadornment(BHA)
				end
			end
		end
	else
		local BHA = object:FindFirstChild("MM2CHAMS")
		if BHA and BHA.ClassName == "BoxHandleAdornment" then
			changeadornment(BHA)
		end
	end
end
function RemoveChams(object,isacharmodel) -- Destroys ESP
	if isacharmodel then
		if object.ClassName == "Model" and Players:FindFirstChild(object.Name) then
			for _, limb in ipairs(object:GetChildren()) do
				local BHA = limb:FindFirstChild("MM2CHAMS")
				if BHA and BHA.ClassName == "BoxHandleAdornment" then
					BHA:Destroy()
				end
			end
		end
	else
		local BHA = object:FindFirstChild("MM2CHAMS")
		if BHA and BHA.ClassName == "BoxHandleAdornment" then
			BHA:Destroy()
		end
	end
end
function GetClosestPlayer(FOV,maxdist)
	local lplrchar = LocalPlayer.Character
	local closest
	local distance
	if lplrchar and players[LocalPlayer.Name] then
		local lplrhrp = lplrchar:FindFirstChild("HumanoidRootPart")
		if lplrhrp and lplrhrp:IsA("BasePart") then
			local function getclosestplayertoscreenpoint(point)
				for _, player in ipairs(Players:GetPlayers()) do
					local character = player.Character
					if character and character ~= lplrchar then
						local NPCRoot = character:FindFirstChild("HumanoidRootPart")
						if NPCRoot and NPCRoot:IsA("BasePart") then
							local viewportpoint, onscreen = camera:WorldToScreenPoint(NPCRoot.Position)
							local distancetemp = (Vector2.new(viewportpoint.X,viewportpoint.Y) - point).Magnitude
							local distancefromplayer = (NPCRoot.Position - lplrhrp.Position).Magnitude

							if onscreen and distancetemp <= FOV then
								if (not closest or distancetemp < distance) and distancefromplayer <= maxdist then
									closest = character
									distance = distancetemp
								end
							end
						end
					end
				end
			end
			local function closestplayertocharacter()
				for _, player in ipairs(Players:GetPlayers()) do
					local character = player.Character
					if character and character ~= lplrchar  then
						local NPCRoot = character:FindFirstChild("HumanoidRootPart")
						if NPCRoot and NPCRoot:IsA("BasePart") then
							local distancetemp = (NPCRoot.Position - lplrhrp.Position).Magnitude

							if (not closest or distancetemp < distance) and distancetemp <= maxdist then
								closest = character
								distance = distancetemp
							end
						end
					end
				end
			end
			if players[LocalPlayer.Name].Role == weapons.Knife.Role[1] then
				if configs.MurdererAimbotMethod == "ClosestPlayerToCursor" then
					getclosestplayertoscreenpoint(Vector2.new(Mouse.X,Mouse.Y))
				elseif configs.MurdererAimbotMethod == "ClosestPlayerToScreenCenter" and camera then
					getclosestplayertoscreenpoint(Vector2.new(camera.ViewportSize.X,camera.ViewportSize.Y)/2)
				elseif configs.MurdererAimbotMethod == "ClosestPlayerToCharacter" then
					closestplayertocharacter()
				end
			else
				if configs.AimbotMethod == "ClosestPlayerToCursor" then
					getclosestplayertoscreenpoint(Vector2.new(Mouse.X,Mouse.Y))
				elseif configs.AimbotMethod == "ClosestPlayerToScreenCenter" and camera then
					getclosestplayertoscreenpoint(Vector2.new(camera.ViewportSize.X,camera.ViewportSize.Y)/2)
				elseif configs.AimbotMethod == "ClosestPlayerToCharacter" then
					closestplayertocharacter()
				elseif configs.AimbotMethod == "Murderer" then
					if game.PlaceId == "636649648" then

					elseif players[LocalPlayer.Name] and players[LocalPlayer.Name].Role == weapons.Knife.Role[1] then
						getclosestplayertoscreenpoint(Vector2.new(Mouse.X,Mouse.Y))
					else
						for _, player in ipairs(Players:GetPlayers()) do
							if players[player.Name] and players[player.Name].Role and players[player.Name].Role == weapons.Knife.Role[1] then
								local character = player.Character
								if character and character ~= lplrchar then
									local NPCRoot = character:FindFirstChild("HumanoidRootPart")
									if NPCRoot and NPCRoot:IsA("BasePart") then
										local distancetemp = (NPCRoot.Position - lplrhrp.Position).Magnitude

										if (not closest or distancetemp < distance) and distancetemp <= maxdist then
											closest = character
											distance = distancetemp
										end
									end
								end
							end
						end
					end
				end
			end
			return closest
		end
	end
	return nil
end
function ChamPlayerRoles() -- Chams Player Using Colors Based On Their Role
	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if character and players[player.Name] and player ~= LocalPlayer then
			local role = players[player.Name].Role
			if role then
				if role == weapons.Knife.Role[1] then
					AddChams(character,true,{
						Color = configs.MurdererColor;
					})
				elseif role == weapons.Gun.Role[1] then
					AddChams(character,true,{
						Color = configs.SheriffColor;
					})
				elseif role == weapons.Gun.Role[2] then
					AddChams(character,true,{
						Color = configs.HeroColor;
					})
				elseif role == "Innocent" then
					AddChams(character,true,{
						Color = configs.InnocentColor;
					})
				end
			end
		end
	end
end
function UnchamPlayers()
	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if character then
			RemoveChams(character,true)
		end
	end
end
function UpdateAllChams()
	for _, child in ipairs(workspace:GetChildren()) do
		local player = Players:GetPlayerFromCharacter(child)
		if player and players[player.Name] and player ~= LocalPlayer then
			local role = players[player.Name].Role
			if role then
				if role == weapons.Knife.Role[1] then
					UpdateChams(child,true,{
						Color = configs.MurdererColor;
					})
				elseif role == weapons.Gun.Role[1] then
					UpdateChams(child,true,{
						Color = configs.SheriffColor;
					})
				elseif role == weapons.Gun.Role[2] then
					UpdateChams(child,true,{
						Color = configs.HeroColor;
					})
				elseif role == "Innocent" then
					UpdateChams(child,true,{
						Color = configs.InnocentColor;
					})
				end
			end
		elseif child:IsA("BasePart") and child.Name == "GunDrop" then
			UpdateChams(child,false,{
				Color = configs.GunDropColor;
			})
		end
	end
end
function RemoveLag(character)
	local function RemoveAccessories(char)
		for _, child in ipairs(char:GetChildren()) do
			if child:IsA("Accessory") or child.Name == "Radio" or child.Name == "Pet" then
				child:Destroy()
			end
		end
	end
	local weapondisplays = workspace:FindFirstChild("WeaponDisplays")
	if weapondisplays and weapondisplays.ClassName == "Folder" then
		if character then
			local uppertorso = character:FindFirstChild("UpperTorso")
			local lowertorso = character:FindFirstChild("LowerTorso")
			if uppertorso and lowertorso then
				local knifebelt = uppertorso:FindFirstChild("KnifeBack") or lowertorso:FindFirstChild("KnifeBelt")
				local gunbelt = lowertorso:FindFirstChild("GunBelt")
				if knifebelt and gunbelt then
					local knifefound
					local gunfound
					local spawn = tick()
					repeat
						for _, v in ipairs(weapondisplays:GetChildren()) do
							local rconst = v:FindFirstChildOfClass("RigidConstraint")
							if rconst then
								if rconst.Attachment0 == gunbelt or rconst.Attachment1 == gunbelt then
									v:Destroy()
									gunfound = true
								elseif rconst.Attachment0 == knifebelt or rconst.Attachment1 == knifebelt then
									v:Destroy()
									knifefound = true
								end
							end
						end
						task.wait()
					until knifefound and gunfound or spawn + 5 <= tick()
				end
			end
		else
			for _, v in ipairs(weapondisplays:GetChildren()) do
				v:Destroy()
			end
		end
	end
	if configs.IncludeAccessories then
		if character then
			RemoveAccessories(character)
		else
			for _, plr in ipairs(Players:GetChildren()) do
				if configs.IncludeLocalPlayer or plr ~= LocalPlayer then
					local char = plr.Character
					if char then
						RemoveAccessories(char)
					end
				end
			end
		end
	end
end
function RemoveCoinLag(coin)
	if coin.Name == "Coin_Server" then
		local visualeffect = coin:WaitForChild("CoinVisual", 5)
		if visualeffect then
			visualeffect:Destroy()
		end
		coin.Transparency = 0
	end
end
function GrabGunFunction(gundrop)
	local lplrchar = LocalPlayer.Character
	if lplrchar then
		local lplrhrp = lplrchar:FindFirstChild("HumanoidRootPart")
		if lplrhrp then
			local prevCFrame = lplrhrp.CFrame
			lplrhrp.CFrame = CFrame.new(gundrop.Position)
			task.wait(0.5)
			lplrhrp.CFrame = prevCFrame
		end
	end
end
function eventfunctions.Initialize(player)
	players[player.Name] = {Role = "Innocent";}

	local backpack = player:WaitForChild("Backpack")
	local character = player.Character or player.CharacterAdded:Wait()

	a += 4
	local b = a

	players[player.Name].Disconnect = function()
		if connections[b] then
			connections[b]:Disconnect()
		end
		if connections[b - 1] then
			connections[b - 1]:Disconnect()
		end
		if connections[b - 2] then
			connections[b - 2]:Disconnect()
		end
	end
	local function HumanoidDiedEvent(humanoid)
		if connections[b] then
			connections[b]:Disconnect()
		end
		connections[b] = humanoid.Died:Connect(function()
			if players[player.Name].Role == weapons.Gun.Role[1] then
				match.SheriffDied = true
			end
			players[player.Name].Role = "Innocent"
		end)
	end
	local function AssignRole(Tool)
		if Tool.Name == "Knife" then
			players[player.Name].Role = weapons.Knife.Role[1]
			if configs.Chams and player ~= LocalPlayer then
				UpdateChams(character,true,{
					Color = configs.MurdererColor;
				})
			end
		elseif Tool.Name == "Gun" then
			if match.SheriffDied then
				players[player.Name].Role = weapons.Gun.Role[2]
				if configs.Chams and player ~= LocalPlayer then
					UpdateChams(character,true,{
						Color = configs.HeroColor;
					})
				end
			else
				players[player.Name].Role = weapons.Gun.Role[1]
				if configs.Chams and player ~= LocalPlayer then
					UpdateChams(character,true,{
						Color = configs.SheriffColor;
					})
				end
			end
		end
	end
	local function CharacterAdded(char)
		character = char
		players[player.Name].Role = "Innocent"

		local bp = player:WaitForChild("Backpack")
		backpack = bp
		local NPCHum = char:WaitForChild("Humanoid")
		if NPCHum.ClassName == "Humanoid" then
			if player == LocalPlayer then
				if configs.ToggleWalkSpeed then
					NPCHum.WalkSpeed = configs.WalkSpeed
				end
				if configs.ToggleJumpPower then
					NPCHum.JumpPower = configs.JumpPower
				end
			end
			HumanoidDiedEvent(NPCHum)
		end
		if configs.AutoRemoveLag and (configs.IncludeLocalPlayer or player ~= LocalPlayer) then
			coroutine.wrap(RemoveLag)(char)
		end
		if configs.Chams and player ~= LocalPlayer then
			AddChams(char,true,{
				Color = configs.InnocentColor;
			})
		end
		if connections[b - 1] then
			connections[b - 1]:Disconnect()
		end
		connections[b - 1] = bp.ChildAdded:Connect(function(child)
			if child.ClassName == "Tool" then
				AssignRole(child)
			end
		end)
		connections[b - 3] = char.ChildAdded:Connect(function(child)
			if child.ClassName == "Tool" and configs.AutoRemoveLag and player ~= LocalPlayer then
				for _, v in ipairs(child:GetDescendants()) do
					if v:IsA("Decal") or v:IsA("DataModelMesh") then
						v:Destroy()
					end
				end
			end
		end)
	end

	connections[b - 2] = player.CharacterAdded:Connect(function(character)
		CharacterAdded(character)
	end)
	CharacterAdded(character)

	for _, child in ipairs(backpack:GetChildren()) do
		if child.ClassName == "Tool" then
			AssignRole(child)
		end
	end
	for _, child in ipairs(character:GetChildren()) do
		if child.ClassName == "Tool" then
			AssignRole(child)
		end
	end
end
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
function AimbotVisuals(startpos,endpos,path)
	task.wait()
	if Drawing then
		local prevpos
		for _, v in path do
			if prevpos then
				Draw3D({
					StartPoint = prevpos;
					EndPoint = v; 
					Color = Color3.new(0,0,1); 
					LifeTime = 5;
				})
			end
			prevpos = v
		end
		Draw3D({
			StartPoint = startpos;
			EndPoint = endpos; 
			Color = Color3.new(1,1,1); 
			LifeTime = 5;
		})
	end
end
function GetAimVector(lplrchar,typ)
	local p = (LocalPlayer:GetNetworkPing() * 2) + 175
	if typ == 1 then
		local closest = GetClosestPlayer(configs.FOV,500)

		if not closest then return end

		local lplrhrp = lplrchar.HumanoidRootPart
		local attachment = Instance.new("Attachment", lplrhrp)
		attachment.Position = Vector3.new(1.6, 1.2, -3)

		if not configs.Automatic then
			p = configs.GunPrediction
		end

		local path, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,100,0,{
			IgnoreList = nil;
			Ping = p;
			PredictSpamJump = true;
			IsAGun = true;
		})
		if configs.ShowAimbotVisuals and aimpos then
			coroutine.wrap(AimbotVisuals)(attachment.WorldPosition,aimpos,path)
		end
		attachment:Destroy()

		return aimpos
	elseif typ == 2 then
		local closest = GetClosestPlayer(configs.FOV,500)

		if not closest then return end

		local lplrhrp = lplrchar.HumanoidRootPart
		local attachment = Instance.new("Attachment", lplrhrp)
		attachment.Position = Vector3.new(1.5, 1.9, 1)

		if not configs.Automatic then
			p = configs.KnifePrediction
		end

		local path, aimpos
		if powers.Sleight then
			path, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,weapons.Knife.Speed.Normal,0,{
				IgnoreList = nil;
				Ping = p;
				PredictSpamJump = true;
				IsAGun = false;
			})
		else
			path, aimpos = Aimbot:ComputePathAsync(attachment.WorldPosition,closest,weapons.Knife.Speed.Sleight,0,{
				IgnoreList = nil;
				Ping = p;
				PredictSpamJump = true;
				IsAGun = false;
			})
		end
		if configs.ShowAimbotVisuals and aimpos then
			coroutine.wrap(AimbotVisuals)(attachment.WorldPosition,aimpos,path)
		end

		powers.Sleight = false
		attachment:Destroy()

		return aimpos
	end
end

---------------------------------------------------------------------------
-- GUI

local ScreenGui = Instance.new("ScreenGui")
local TextButton = Instance.new("TextButton")

ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

TextButton.Parent = ScreenGui
TextButton.AnchorPoint = Vector2.new(0.5, 0)
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundTransparency = 0.500
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.5, 0, 0, 0)
TextButton.Size = UDim2.new(0, 200, 0, 20)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "Open GUI"
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 14.000

TextButton.MouseButton1Click:Connect(function()
	keypress(0xA1)
	task.wait()
	keyrelease(0xA1)
end)

---------------------------------------------------------------------------
-- Library

local Window = Library:CreateWindow({
	Name = "🏖️ Murder Mystery 2 🏖️";
	LoadingTitle = "Murder Mystery 2 Main";
	LoadingSubtitle = "by CITY512";
	ConfigurationSaving = {
		Enabled = true;
		FolderName = "CITY512 - MM2 Main"; -- Create a custom folder for your hub/game
		FileName = "configdata"
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

local Main = Window:CreateTab("Main", 10814531047) -- Title, Image
local LocalPlayerTab = Window:CreateTab("LocalPlayer", 4483362458) -- Title, Image
local Visuals = Window:CreateTab("Visuals", 13080349149) -- Title, Image
local Blatant = Window:CreateTab("Blatant", 10653372160) -- Title, Image
local AutoFarm = Window:CreateTab("Auto Farm", 12966420667) -- Title, Image
local Others = Window:CreateTab("Others", 11385220704) -- Title, Image

---------------------------------------------------------------------------
local AimbotSection = Main:CreateSection("Aimbot", false) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local GunAimbot = Main:CreateToggle({
	Name = "Gun Aimbot";
	CurrentValue = false;
	SectionParent = AimbotSection;
	Flag = "Gun Aimbot";
	Callback = function(value)
		configs.GunAimbot = value
	end;
})
local KnifeAimbot = Main:CreateToggle({
	Name = "Knife Aimbot";
	CurrentValue = false;
	SectionParent = AimbotSection;
	Flag = "Knife Aimbot";
	Callback = function(value)
		configs.KnifeAimbot = value
	end;
})
local GunPrediction = Main:CreateSlider({
	Name = "Gun Prediction";
	Range = {0, 1000};
	Increment = 1;
	Suffix = "ms";
	CurrentValue = 150;
	SectionParent = AimbotSection;
	Flag = "Gun Prediction";
	Callback = function(value)
		configs.GunPrediction = value
	end;
})
local KnifePrediction = Main:CreateSlider({
	Name = "Knife Prediction";
	Range = {0, 1000};
	Increment = 1;
	Suffix = "ms";
	CurrentValue = 100;
	SectionParent = AimbotSection;
	Flag = "Knife Prediction";
	Callback = function(value)
		configs.KnifePrediction = value
	end;
})
local Automatic = Main:CreateToggle({
	Name = "Automatic";
	CurrentValue = false;
	Flag = "Automatic";
	SectionParent = AimbotSection;
	Callback = function(value)
		configs.Automatic = value
	end;
})
local Dropdown = Main:CreateDropdown({
	Name = "Sheriff Aimbot Method";
	Options = {"ClosestPlayerToCursor","ClosestPlayerToCharacter","ClosestPlayerToScreenCenter","Murderer"};
	CurrentOption = "Murderer";
	MultiSelection = false; -- If MultiSelections is allowed
	SectionParent = AimbotSection;
	Flag = "Aimbot Method";
	Callback = function(option)
		configs.AimbotMethod = option
	end,
})
local Dropdown = Main:CreateDropdown({
	Name = "Murderer Aimbot Method";
	Options = {"ClosestPlayerToCursor","ClosestPlayerToCharacter","ClosestPlayerToScreenCenter"};
	CurrentOption = "ClosestPlayerToCursor";
	MultiSelection = false; -- If MultiSelections is allowed
	SectionParent = AimbotSection;
	Flag = "Aimbot Method";
	Callback = function(option)
		configs.MurdererAimbotMethod = option
	end,
})
local FOV = Main:CreateSlider({
	Name = "FOV";
	Range = {0, 1000};
	Increment = 1;
	Suffix = "";
	CurrentValue = 350;
	SectionParent = AimbotSection;
	Flag = "FOV";
	Callback = function(value)
		configs.FOV = value
		if Drawing then
			Drawing1.Radius = configs.FOV
			Drawing2.Radius = configs.FOV
		end
	end;
})

local GunModsSection = Main:CreateSection("Gun Mods", false) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local AutoEquip = Main:CreateToggle({
	Name = "Auto Equip";
	CurrentValue = false;
	SectionParent = GunModsSection;
	Flag = "Auto Equip";
	Callback = function(value)
		configs.AutoEquip = value
	end;
})
local AutoShoot = Main:CreateToggle({
	Name = "Auto Shoot";
	CurrentValue = false;
	SectionParent = GunModsSection;
	Flag = "Auto Shoot";
	Callback = function(value)
		configs.AutoShoot = value
	end;
})

local KillAuraSection = Main:CreateSection("Kill Aura", false) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local KillAura = Main:CreateToggle({
	Name = "Kill Aura";
	CurrentValue = false;
	SectionParent = KillAuraSection;
	Flag = "Kill Aura";
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
	SectionParent = KillAuraSection;
	Flag = "Kill Aura Range";
	Callback = function(value)
		configs.KillAuraRange = value
	end;
})
local FaceTarget = Main:CreateToggle({
	Name = "Face Target";
	CurrentValue = false;
	SectionParent = KillAuraSection;
	Flag = "Face Target";
	Callback = function(value)
		configs.FaceTarget = value
	end;
})

---------------------------------------------------------------------------
local WalkSpeedToggle = LocalPlayerTab:CreateToggle({
	Name = "Toggle WalkSpeed";
	CurrentValue = false;
	Flag = "Toggle WalkSpeed";
	Callback = function(value)
		configs.ToggleWalkSpeed = value
		if not configs.ToggleWalkSpeed and LocalPlayer.Character then
			local lplrhum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if lplrhum then
				lplrhum.WalkSpeed = 16
			end
		end
	end;
})
local JumpPowerToggle = LocalPlayerTab:CreateToggle({
	Name = "Toggle JumpPower";
	CurrentValue = false;
	Flag = "Toggle JumpPower";
	Callback = function(value)
		configs.ToggleJumpPower = value
		if not configs.ToggleJumpPower and LocalPlayer.Character then
			local lplrhum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if lplrhum then
				lplrhum.JumpPower = 50
			end
		end
	end;
})
local WalkSpeed = LocalPlayerTab:CreateSlider({
	Name = "WalkSpeed";
	Range = {0, 100};
	Increment = 1;
	Suffix = "";
	CurrentValue = 16;
	Flag = "WalkSpeed";
	Callback = function(value)
		configs.WalkSpeed = value
		if configs.ToggleWalkSpeed and LocalPlayer.Character then
			local lplrhum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if lplrhum then
				lplrhum.WalkSpeed = configs.WalkSpeed
			end
		end
	end;
})
local JumpPower = LocalPlayerTab:CreateSlider({
	Name = "JumpPower";
	Range = {0, 100};
	Increment = 1;
	Suffix = "";
	CurrentValue = 50;
	Flag = "JumpPower";
	Callback = function(value)
		configs.JumpPower = value
		if configs.ToggleJumpPower and LocalPlayer.Character then
			local lplrhum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if lplrhum then
				lplrhum.JumpPower = configs.JumpPower
			end
		end
	end;
})
---------------------------------------------------------------------------
local ChamsSection = Visuals:CreateSection("Chams", false) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local PlayerChams = Visuals:CreateToggle({
	Name = "Player Chams";
	CurrentValue = false;
	SectionParent = ChamsSection;
	Flag = "Player Chams";
	Callback = function(value)
		configs.Chams = value
		if value then
			ChamPlayerRoles()
		else
			UnchamPlayers()				
		end
	end;
})
local ShowGunDrop = Visuals:CreateToggle({
	Name = "Show Gun Drop";
	CurrentValue = false;
	SectionParent = ChamsSection;
	Flag = "Show Gun Drop";
	Callback = function(value)
		configs.ShowGunDrop = value
		for _, child in ipairs(workspace:GetChildren()) do
			if child:IsA("BasePart") and child.Name == "GunDrop" then
				if configs.ShowGunDrop then
					AddChams(child,false,{
						Color = configs.GunDropColor;
					})
				else
					RemoveChams(child,false)
				end
			end
		end
	end;
})
local ShowTraps = Visuals:CreateToggle({
	Name = "Show Traps";
	CurrentValue = false;
	SectionParent = ChamsSection;
	Flag = "Show Traps";
	Callback = function(value)
		configs.TrapESP = value
		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant:IsA("BasePart") and descendant.Name == "Trap" then
				if configs.TrapESP then
					AddChams(descendant,false,{
						Color = configs.TrapColor;
					})
				else
					RemoveChams(descendant,false)
				end
			end
		end
	end;
})
local MurdererColor = Visuals:CreateColorPicker({
	Name = "Murderer Color";
	Color = configs.MurdererColor;
	SectionParent = ChamsSection;
	Flag = "Murderer Color";
	Callback = function(value)
		configs.MurdererColor = value
		UpdateAllChams()
	end
})
local TrapColor = Visuals:CreateColorPicker({
	Name = "Trap Color";
	Color = configs.TrapColor;
	SectionParent = ChamsSection;
	Flag = "Trap Color";
	Callback = function(value)
		configs.TrapColor = value
		UpdateAllChams()
	end
})
local HeroColor = Visuals:CreateColorPicker({
	Name = "Hero/Target Color";
	Color = configs.HeroColor;
	SectionParent = ChamsSection;
	Flag = "Hero/Target Color";
	Callback = function(value)
		configs.HeroColor = value
		UpdateAllChams()
	end
})
local InnocentColor = Visuals:CreateColorPicker({
	Name = "Innocent Color";
	Color = configs.InnocentColor;
	SectionParent = ChamsSection;
	Flag = "Innocent Color";
	Callback = function(value)
		configs.InnocentColor = value
		UpdateAllChams()
	end
})
local SheriffColor = Visuals:CreateColorPicker({
	Name = "Sheriff Color";
	Color = configs.SheriffColor;
	SectionParent = ChamsSection;
	Flag = "Sheriff Color";
	Callback = function(value)
		configs.SheriffColor = value
		UpdateAllChams()
	end
})
local GunDropColor = Visuals:CreateColorPicker({
	Name = "Gun Drop Color";
	Color = configs.GunDropColor;
	SectionParent = ChamsSection;
	Flag = "Gun Drop Color";
	Callback = function(value)
		configs.GunDropColor = value
		UpdateAllChams()
	end
})
local AimbotVisualsSection = Visuals:CreateSection("Aimbot Visuals", false) -- The 2nd argument is to tell if its only a Title and doesnt contain element
if Drawing then
	local ShowFOVCircle = Visuals:CreateToggle({
		Name = "Show FOV Circle";
		CurrentValue = false;
		SectionParent = AimbotVisualsSection;
		Flag = "Show FOV Circle";
		Callback = function(value)
			configs.ShowFOVCircle = value
		end;
	})
end
local ShowAimbotVisuals = Visuals:CreateToggle({
	Name = "Show Aimbot Visuals";
	CurrentValue = false;
	SectionParent = AimbotVisualsSection;
	Flag = "Show Aimbot Visuals";
	Callback = function(value)
		configs.ShowAimbotVisuals = value
	end;
})

local AntiLagSection = Visuals:CreateSection("Anti-Lag", false) -- The 2nd argument is to tell if its only a Title and doesnt contain element

local RemoveMapLag = Visuals:CreateButton({
	Name = "Remove Map Lag";
	SectionParent = AntiLagSection;
	Callback = function()
		if not scriptvariables.AntiLagAlreadyExecuted then
			scriptvariables.AntiLagAlreadyExecuted = true

			local Terrain = workspace.Terrain
			Terrain.WaterWaveSize = 0
			Terrain.WaterWaveSpeed = 0
			Terrain.WaterReflectance = 0
			Terrain.WaterTransparency = 0

			local Lighting = game.Lighting
			Lighting.GlobalShadows = false
			Lighting.FogEnd = 9e9
			settings().Rendering.QualityLevel = 1

			for _, child in ipairs(Lighting:GetChildren()) do
				if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("DepthOfFieldEffect") then
					child:Destroy()
				end
			end
			for _, descendant in ipairs(workspace:GetDescendants()) do
				RemoveLagFromObject(descendant)
			end
		end
	end
})
local RemoveAccessoryLag = Visuals:CreateButton({
	Name = "Remove Accessory Lag";
	SectionParent = AntiLagSection;
	Callback = function()
		local lplrchar = LocalPlayer.Character
		RemoveLag()
	end;
})
local AutoRemoveLag = Visuals:CreateToggle({
	Name = "Auto Remove Lag";
	CurrentValue = false;
	SectionParent = AntiLagSection;
	Flag = "Auto Remove Lag";
	Callback = function(value)
		configs.AutoRemoveLag = value
	end;
})
local IncludeHats = Visuals:CreateToggle({
	Name = "Include Hats";
	CurrentValue = false;
	SectionParent = AntiLagSection;
	Flag = "Include Hats";
	Callback = function(value)
		configs.IncludeAccessories = value
	end;
})
local IncludeLocalPlayer = Visuals:CreateToggle({
	Name = "Include LocalPlayer";
	CurrentValue = false;
	SectionParent = AntiLagSection;
	Flag = "Include LocalPlayer";
	Callback = function(value)
		configs.IncludeLocalPlayer = value
	end;
})
local RemoveCoinLagToggle = Visuals:CreateToggle({
	Name = "Remove Coin Lag";
	CurrentValue = false;
	SectionParent = AntiLagSection;
	Flag = "Remove Coin Lag";
	Callback = function(value)
		configs.RemoveCoinLag = value
		if configs.RemoveCoinLag and match.Map then
			if match.Map:FindFirstChild("CoinContainer") then
				for _, coin in ipairs(match.Map.CoinContainer:GetChildren()) do
					coroutine.wrap(RemoveCoinLag)(coin)
				end
				if not eventfunctions.CoinAdded then
					eventfunctions.CoinAdded = match.Map.CoinContainer.ChildAdded:Connect(function(coin)
						RemoveCoinLag(coin)
					end)
				end
			end
		elseif eventfunctions.CoinAdded then
			eventfunctions.CoinAdded:Disconnect()
		end
	end;
})
---------------------------------------------------------------------------
local AnnounceRoles = Blatant:CreateButton({
	Name = "Announce Roles";
	Callback = function()
		local murderer = "nobody"
		local sheriff = "nobody"
		for _, player in ipairs(Players:GetPlayers()) do
			if players[player.Name] then
				if players[player.Name].Role == weapons.Knife.Role[1] then
					murderer = player.Name
				elseif players[player.Name].Role == weapons.Gun.Role[1] or players[player.Name].Role == weapons.Gun.Role[2] then
					sheriff = player.Name
				end
			end
		end
		local args = {
			[1] = "The murderer is "..murderer.." and the sheriff is "..sheriff;
			[2] = "normalchat"
		}
		REPS:WaitForChild("DefaultChatSystemEvents"):WaitForChild("SayMessageRequest"):FireServer(table.unpack(args))
	end,
})
local GrabGun = Blatant:CreateButton({
	Name = "Grab Gun",
	Callback = function()
		for _, v in ipairs(workspace:GetChildren()) do
			if v:IsA("BasePart") and v.Name == "GunDrop" then
				GrabGunFunction(v)
			end
		end
	end,
})
local AutoGrabGun = Blatant:CreateToggle({
	Name = "Auto Grab Gun";
	CurrentValue = false;
	Flag = "Auto Grab Gun";
	Callback = function(value)
		configs.AutoGrabGun = value
	end;
})
local KillAll = Blatant:CreateButton({
	Name = "Kill All";
	Callback = function()
		-- The function that takes place when the keybind is pressed
		-- The variable (Keybind) is a boolean for whether the keybind is being held or not (HoldToInteract needs to be true)
	end;
})

local FlingSection = Blatant:CreateSection("Fling", false)

local FlingPlayerType = Blatant:CreateDropdown({
	Name = "Player",
	Options = {},
	CurrentOption = nil;
	MultiSelection = false; -- If MultiSelections is allowed
	SectionParent = FlingSection;
	Flag = nil; -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Option)
		configs.FlingPlayer = Option
	end;
})
local FlingPlayer = Blatant:CreateButton({
	Name = "Fling Player";
	SectionParent = FlingSection;
	Callback = function()
		local function AddBodyFling(basepart)
			local bav = Instance.new("BodyAngularVelocity", basepart)
			bav.Name = "Flinger"
			bav.AngularVelocity = Vector3.new(0,99999,0)
			bav.MaxTorque = Vector3.new(0,math.huge,0)
			bav.P = math.huge
		end

		local lplrchar = LocalPlayer.Character
		if not scriptvariables.IsFlinging and configs.FlingPlayer and lplrchar then
			local lplrhrp = lplrchar:FindFirstChild("HumanoidRootPart")
			if lplrhrp then
				local player = Players:FindFirstChild(configs.FlingPlayer)
				if player then
					local character = player.Character
					if character then
						local NPCRoot = character:FindFirstChild("HumanoidRootPart")
						if NPCRoot then
							local prevCFrame = lplrhrp.CFrame
							scriptvariables.IsFlinging = true

							AddBodyFling(lplrhrp)

							while true do
								if not scriptvariables.IsFlinging or not Players:FindFirstChild(configs.FlingPlayer) then 
									scriptvariables.IsFlinging = false
									for _, v in ipairs(lplrchar:GetChildren()) do
										if v:IsA("BasePart") then
											v.CanCollide = true
											v.Massless = false
											v.AssemblyAngularVelocity = Vector3.new(0,0,0)
											v.AssemblyLinearVelocity = Vector3.new(0,0,0)
											v.Velocity = Vector3.new(0,0,0)
										end
									end
									local bav = lplrhrp:FindFirstChild("Flinger")
									if bav then
										bav:Destroy()
									end
									lplrhrp.CFrame = prevCFrame
									break
								end
								if lplrchar.Parent then -- if localplayer character has not been destroyed
									for _, v in ipairs(lplrchar:GetChildren()) do
										if v:IsA("BasePart") then
											v.CanCollide = false
											v.Massless = true
											v.Velocity = Vector3.new(0,0,0)
										end
									end
									if character.Parent then -- if character has not been destroyed
										if lplrhrp.Parent then -- if localplayer root has not been destroyed
											if NPCRoot.Parent then -- if npc root has not been destroyed
												lplrhrp.CFrame = CFrame.new(NPCRoot.Position)
											else
												local NPCRoottemp = character:FindFirstChild("HumanoidRootPart")
												if NPCRoottemp then
													NPCRoot = NPCRoottemp
												end
											end
										else
											local lplrhrptemp = lplrchar:FindFirstChild("HumanoidRootPart")
											if lplrhrptemp then
												lplrhrp = lplrhrptemp
												AddBodyFling(lplrhrp)
											end
										end
									elseif player.Character then
										character = player.Character
									end
								elseif LocalPlayer.Character then
									lplrchar = LocalPlayer.Character
								end
								task.wait()
							end
						end
					end
				end
			end
		end
	end;
})
local StopFlinging = Blatant:CreateButton({
	Name = "Stop Flinging";
	SectionParent = FlingSection;
	Callback = function()
		scriptvariables.IsFlinging = false
	end;
})
---------------------------------------------------------------------------
local AutoFarmSection = Blatant:CreateSection("Auto Farm", false)

local CoinFarm = AutoFarm:CreateToggle({
	Name = "Coin Farm";
	CurrentValue = false;
	SectionParent = AutoFarmSection;
	Flag = "Coin Farm";
	Callback = function(value)
		configs.CoinFarm = value
		if configs.CoinFarm then
			local lplrhrp
			while true do
				if not configs.CoinFarm then 
					if lplrhrp then 
						lplrhrp.Anchored = false 
					end 
					break 
				end
				local lplrchar = LocalPlayer.Character
				if lplrchar then
					local lplrhrptemp = lplrchar:FindFirstChild("HumanoidRootPart")
					if lplrhrptemp and match.Map then
						lplrhrp = lplrhrptemp
						lplrhrp.Anchored = true
						local coins = match.Map:FindFirstChild("CoinContainer")
						if coins then
							local closest
							local distance
							for _, v in ipairs(coins:GetChildren()) do
								local TouchInterest = v:FindFirstChildWhichIsA("TouchTransmitter")
								if TouchInterest and v:IsA("BasePart") and v.Name == "Coin_Server" and v.Transparency ~= 1 then
									local distancetemp = (v.Position - lplrhrp.Position).Magnitude
									if not closest or distancetemp < distance then
										closest = v
										distance = distancetemp
									end
								end
							end
							if closest then
								lplrhrp.CanCollide = false
								lplrhrp.Anchored = false
								local info = TweenInfo.new(configs.AutoFarmSpeed,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,0,false)
								local tween = TweenService:Create(lplrhrp,info,{CFrame = CFrame.new(closest.Position - Vector3.new(0,4,0))})
								tween:Play()
								tween.Completed:Wait()
								task.spawn(function()
									firetouchinterest(closest, lplrhrp, 1)
									wait()
									firetouchinterest(closest, lplrhrp, 0)
								end)
								lplrhrp.CanCollide = true
								lplrhrp.Anchored = true
							end
						end
					end
				end
				task.wait(configs.AutoFarmDelay)
			end
		end
	end;
})
local XPFarm = AutoFarm:CreateToggle({
	Name = "XP Farm";
	CurrentValue = false;
	SectionParent = AutoFarmSection;
	Flag = "XP Farm";
	Callback = function(value)
		configs.XPFarm = value
	end;
})
local AutoUnbox = AutoFarm:CreateToggle({
	Name = "Auto Unbox";
	CurrentValue = false;
	SectionParent = AutoFarmSection;
	Flag = "Auto Unbox";
	Callback = function(value)
		configs.AutoUnbox = value
	end;
})
local AutoUnboxCrate = AutoFarm:CreateDropdown({
	Name = "Auto Unbox Crate";
	Options = {"Crate #1","Crate #2","Crate #3"};
	CurrentOption = "Crate #1";
	MultiSelection = true; -- If MultiSelections is allowed
	SectionParent = AutoFarmSection;
	Flag = "Auto Unbox Crate";
	Callback = function(option)
		configs.AutoUnboxCrate = option
	end,
})

local AutoFarmSettingsSection = Blatant:CreateSection("Auto Farm Settings", false)

local AutoFarmSpeed = AutoFarm:CreateSlider({
	Name = "Auto Farm Speed";
	Range = {0, 5};
	Increment = 0.1;
	Suffix = "s";
	CurrentValue = 1;
	SectionParent = AutoFarmSettingsSection;
	Flag = "Auto Farm Speed";
	Callback = function(value)
		configs.AutoFarmSpeed = value
	end;
})
local AutoFarmDelay = AutoFarm:CreateSlider({
	Name = "Auto Farm Delay";
	Range = {0, 5};
	Increment = 0.1;
	Suffix = "s";
	CurrentValue = 0.5;
	SectionParent = AutoFarmSettingsSection;
	Flag = "Auto Farm Delay";
	Callback = function(value)
		configs.AutoFarmDelay = value
	end;
})
---------------------------------------------------------------------------
local Dupe = Others:CreateButton({
	Name = "Dupe V2";
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/scripts/main/mm2%20dupe"))()
	end;
})
local FreeAnimations = Others:CreateButton({
	Name = "Free Animations";
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/scripts/main/freeanims.lua"))()
	end;
})
local Rejoin = Others:CreateButton({
	Name = "Rejoin";
	Callback = function()
		Library:Notify({
			Title = "Info";
			Content = "Rejoining";
			Duration = 5;
			Image = "";
			Actions = {};
		})
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end;
})
local KeepGUI = Others:CreateToggle({
	Name = "Keep GUI";
	CurrentValue = false;
	Flag = "Keep GUI";
	Callback = function(value)
		if scriptvariables.QueueOnTeleport then
			scriptvariables.ExecuteOnTeleport = value
		else
			Library:Notify({
				Title = "Error";
				Content = 'The function "queue_on_teleport" is not supported on this executor';
				Duration = 5;
				Image = "";
				Actions = {};
			})
		end
	end;
})

---------------------------------------------------------------------------
-- Events

eventfunctions.WorkspaceChildAdded = workspace.ChildAdded:Connect(function(instance)
	if instance:IsA("BasePart") and instance.Name == "ThrowingKnife" then
		task.wait(10)
		instance:Destroy()
	elseif instance:IsA("Model") and not instance:FindFirstChildOfClass("Humanoid") and instance.Name == "Normal" then
		match.SheriffDied = false
		match.Map = instance
		eventfunctions.MapChildAdded = match.Map.ChildAdded:Connect(function(child)
			if child:IsA("BasePart") and child.Name == "GunDrop" then
				AddChams(child,false,{
					Color = configs.GunDropColor;
				})
				if configs.AutoGrabGun and (not players[LocalPlayer.Name] or not players[LocalPlayer.Name].Role == weapons.Knife.Role[1]) then
					GrabGunFunction(child)
				end
			end
		end)
		if configs.RemoveCoinLag then
			local cc = instance:WaitForChild("CoinContainer")
			eventfunctions.CoinAdded = cc.ChildAdded:Connect(function(coin)
				RemoveCoinLag(coin)
			end)
		end
	end
end)
eventfunctions.WorkspaceChildRemoved = workspace.ChildRemoved:Connect(function(instance)
	if instance:IsA("Model") and not instance:FindFirstChildOfClass("Humanoid") and instance.Name == "Normal" then
		match.SheriffDied = false
		match.Map = nil
		if eventfunctions.MapChildAdded then
			eventfunctions.MapChildAdded:Disconnect()
		end
		if eventfunctions.CoinAdded then
			eventfunctions.CoinAdded:Disconnect()
		end
	end
end)
eventfunctions.DescendantAdded = workspace.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("BasePart") and descendant.Name == "Trap" then
		AddChams(descendant,false,{
			Color = configs.TrapColor;
		})
	elseif scriptvariables.AntiLagAlreadyExecuted then
		RemoveLagFromObject(descendant)
	end
end)
eventfunctions.OnTeleport = LocalPlayer.OnTeleport:Connect(function()
	if not scriptvariables.TPCheck and scriptvariables.QueueOnTeleport and scriptvariables.ExecuteOnTeleport then
		scriptvariables.TPCheck = true
		scriptvariables.QueueOnTeleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/scripts/main/mm2%20hack.lua"))()')
	end
end)
eventfunctions.PlayerAdded = Players.PlayerAdded:Connect(function(player)
	FlingPlayerType:Add(player.Name)
	eventfunctions.Initialize(player)
end)
eventfunctions.PlayerRemoved = Players.PlayerRemoving:Connect(function(removedplayer)
	if players[removedplayer.Name] then
		players[removedplayer.Name].Disconnect()
		players[removedplayer.Name] = nil
	end
	FlingPlayerType:Remove(removedplayer.Name)
end)
eventfunctions.Stepped = RS.Stepped:Connect(function()
	if prevtarget then
		local PrevTargetRoot = prevtarget:FindFirstChild("HumanoidRootPart")
		if PrevTargetRoot and PrevTargetRoot:IsA("BasePart") then
			local PrevTargetRoot = prevtarget.HumanoidRootPart
			PrevTargetRoot.Size = Vector3.new(2,2,1)
		end
		prevtarget = nil
	end
	if Drawing then
		Drawing1.Visible = configs.ShowFOVCircle
		Drawing2.Visible = configs.ShowFOVCircle
		if configs.ShowFOVCircle then
			local mousepos = Vector2.new(Mouse.X,Mouse.Y)
			Drawing1.Position = mousepos
			Drawing2.Position = mousepos
		end
	end

	local lplrchar = LocalPlayer.Character
	if lplrchar then
		local lplrhrp = lplrchar:FindFirstChild("HumanoidRootPart")
		local lplrhum = lplrchar:FindFirstChildOfClass("Humanoid")
		if lplrhum and lplrhrp and lplrhum.Health > 0 and lplrhrp:IsA("BasePart") then
			if configs.KillAura then
				local Knife = lplrchar:FindFirstChild("Knife")
				if Knife and Knife.ClassName == "Tool" then
					local closest
					for _, player in ipairs(Players:GetPlayers()) do
						local character = player.Character
						if character and character ~= lplrchar then
							local NPCRoot = character:FindFirstChild("HumanoidRootPart")
							if NPCRoot and NPCRoot:IsA("BasePart") then
								local distance = (NPCRoot.Position - lplrhrp.Position).Magnitude
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
							lplrhrp.CFrame = CFrame.new(lplrhrp.Position,TargetRoot.Position * Vector3.new(1,0,1) + lplrhrp.Position * Vector3.new(0,1,0))
						end
						TargetRoot.CanCollide = false
						TargetRoot.Size = Vector3.new(configs.KillAuraRange,configs.KillAuraRange,configs.KillAuraRange)
						Knife:Activate()
					end
				end
			end
			if players[LocalPlayer.Name] and (players[LocalPlayer.Name].Role == weapons.Gun.Role[1] or players[LocalPlayer.Name].Role == weapons.Gun.Role[2]) and not lplrchar:FindFirstChild("Gun") then
				local Gun = lplrchar:FindFirstChild("Gun")
				if configs.AutoEquip and (not Gun or Gun.ClassName ~= "Tool") then
					local bp = LocalPlayer:FindFirstChild("Backpack")
					if bp then
						for _, child in ipairs(bp:GetChildren()) do
							if child.ClassName == "Tool" and child.Name == "Gun" then
								lplrhum:EquipTool(child)
							end
						end
					end
				end
				if configs.AutoShoot and Gun and Gun.ClassName == "Tool" and Gun:FindFirstChild("Handle") and Gun:FindFirstChild("KnifeServer") and Gun.KnifeServer:FindFirstChild("ShootGun") then
					for _, player in ipairs(Players:GetPlayers()) do
						local character = player.Character
						if character then
							local NPCRoot = character:FindFirstChild("HumanoidRootPart") 
							if NPCRoot and NPCRoot:IsA("BasePart") and players[player.Name] and players[player.Name].Role == weapons.Knife.Role[1] then
								local startpos = lplrchar.Gun.Handle.Position

								local params = RaycastParams.new()
								params.FilterDescendantsInstances = {character,lplrchar}
								params.FilterType = Enum.RaycastFilterType.Exclude

								local raycast = workspace:Raycast(startpos, NPCRoot.Position - startpos, params)
								if not raycast or not raycast.Position then
									local aimpos = GetAimVector(lplrchar,1)
									if aimpos then
										local args = {
											[1] = 1;
											[2] = aimpos;
											[3] = "AH"
										}
										lplrchar.Gun.KnifeServer.ShootGun:InvokeServer(table.unpack(args))
									end
								end
							end
						end
					end
				end
			end
		end
	end
	for i, v in ipairs(visuals) do
		local properties = v.Properties
		local line = v.Line
		local spawn = v.Spawn

		local pos1, onscreen1 = camera:WorldToViewportPoint(properties.StartPoint)
		local pos2, onscreen2 = camera:WorldToViewportPoint(properties.EndPoint)

		line.From = Vector2.new(pos1.X,pos1.Y)
		line.To = Vector2.new(pos2.X,pos2.Y)
		
		if onscreen1 and onscreen2 then
			line.Transparency = 1
		else
			line.Transparency = 0
		end

		if spawn + properties.LifeTime < tick() then
			line:Remove()
			visuals[i] = nil
		end
	end
end)

---------------------------------------------------------------------------
-- Hooks

local namecall
namecall = hookmetamethod(game, "__namecall", function(self,...)
	local args = {...}
	local method = getnamecallmethod()

	if not checkcaller() and LocalPlayer.Character then
		local lplrchar = LocalPlayer.Character
		if configs.GunAimbot and tostring(method) == "InvokeServer" then
			local script = rawget(getfenv(2), "script")
			local aimpos
			if script.Name == "KnifeLocal" then
				aimpos = GetAimVector(lplrchar,1)
				args[2] = aimpos
			end
			return aimpos and self.InvokeServer(self,table.unpack(args)) or self.InvokeServer(self,...)
		elseif configs.KnifeAimbot and tostring(self) == "Throw" and tostring(method) == "FireServer" then
			local aimpos = GetAimVector(lplrchar,2)
			args[1] = CFrame.new(aimpos)

			return aimpos and self.FireServer(self,table.unpack(args)) or self.FireServer(self,...)
		end
	end
	return namecall(self,...)
end)

---------------------------------------------------------------------------
-- Loops

for _, player in ipairs(Players:GetPlayers()) do
	FlingPlayerType:Add(player.Name)
	eventfunctions.Initialize(player)
end
for _, v in ipairs(workspace:GetChildren()) do
	if v.Name == "Normal" and not v:FindFirstChildOfClass("Humanoid") then
		match.Map = v
	end
end
