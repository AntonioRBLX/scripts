repeat game:GetService("RunService").RenderStepped:Wait() until game.Players.LocalPlayer

--// Variables
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local CoreGui = game:GetService('CoreGui')
local RunService = game:GetService('RunService')

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CurrentCamera = workspace.CurrentCamera
local worldToViewportPoint = CurrentCamera.worldToViewportPoint
local HeadOff = Vector3.new(0, 0.5, 0)
local LegOff = Vector3.new(0, 3, 0)

local aa = 0

--// Visuals
local vpgui = Instance.new("ScreenGui")
vpgui.Parent = CoreGui
local vpframe = Instance.new("ViewportFrame")
vpframe.CurrentCamera = workspace.CurrentCamera
vpframe.Parent = vpgui

--// Tables
local Aimbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/modules/main/aimbot.lua"))()
local Client = {}
local Connections = {}
local Drawings = {
	Drawing.new('Circle'),
	Drawing.new('Circle')
}

--// FOV
Drawings[1].Color = Color3.new(1, 0, 1)
Drawings[1].Thickness = 2
Drawings[1].Visible = true
Drawings[1].Radius = 500

Drawings[2].Color = Color3.new(0, 0, 0)
Drawings[2].Thickness = 4
Drawings[2].Visible = true
Drawings[2].Radius = 500
Drawings[2].ZIndex = -1

mx = game.Debris
mx2 = game.Debris.MaxItems

if (mx.MaxItems > 40000) then
	mx.MaxItems = mx2*.75
end

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		Drawings[1].Position = UserInputService:GetMouseLocation()
		Drawings[2].Position = UserInputService:GetMouseLocation()
	end
end)

--// Functions
function IsVisible(position, model)
	local ray = Ray.new(CurrentCamera.CFrame.p, CFrame.new(CurrentCamera.CFrame.p, position).LookVector * 10000)
	local hit, position, normal = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, CurrentCamera})
	if not hit then
		return false
	end
	return hit:IsDescendantOf(model), hit, position, normal
end

--// Loops

RunService.PostSimulation:Connect(function()
	vpframe.CurrentCamera = workspace.CurrentCamera
	local MousePosition = UserInputService:GetMouseLocation()
	Client.Target = nil
	Client.TargetDistance = Drawings[1].Radius
	local players = {}
	
	for _, player in next, Players:GetChildren() do

		local character = workspace:FindFirstChild(player.Name)
		local Humanoid = character and character:FindFirstChildWhichIsA('Humanoid')
		local HumanoidRootPart = character and character:FindFirstChild('HumanoidRootPart')

		if not Humanoid or not HumanoidRootPart then
			continue
		end

		if Humanoid.Health <= 0 then
			continue
		end

		-- if not IsVisible(HumanoidRootPart.Position, player.Character) then
		--     continue
		-- end

		if method == 1 then
			local ScreenPosition, ScreenVisible = CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position)
			local MouseDistance = (MousePosition - Vector2.new(ScreenPosition.X, ScreenPosition.Y)).Magnitude
			if MouseDistance < Client.TargetDistance and player.Name ~= LocalPlayer.Name then
				Client.Target = character
				Client.TargetDistance = MouseDistance
			end
		elseif method == 2 then
			if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				if player ~= LocalPlayer then
					table.insert(players,{(HumanoidRootPart.Position-LocalPlayer.Character.HumanoidRootPart.Position).Magnitude,character})
				end
			end
		end
	end
	if method == 2 then
		if #players > 0 then
			table.sort(players,
				function(a,b)
					return a[1] < b[1]
				end
			)
			Client.Target = players[1][2]
		else
			Client.Target = LocalPlayer.Character
		end
	end
	for _, i in pairs(vpframe:GetChildren()) do
		i:Destroy()
	end
	if Client.Target then
		local vel = Instance.new("Part")
		vel.Parent = vpframe
		vel.Color = Color3.fromRGB(115,121,236)
		vel.Size = Vector3.new(1,1,1)
		local tracer1 = Instance.new("Part")
		tracer1.Shape = Enum.PartType.Cylinder
		tracer1.Parent = vpframe
		tracer1.Color = Color3.fromRGB(115,121,236)
		tracer1.CFrame = CFrame.new((vel.Position+Client.Target.HumanoidRootPart.Position)/2,vel.Position) * CFrame.Angles(0,math.pi/2,0)
		tracer1.Size = Vector3.new((vel.Position-Client.Target.HumanoidRootPart.Position).Magnitude,1,1)
		local movedir = Instance.new("Part")
		movedir.Parent = vpframe
		movedir.Color = Color3.fromRGB(237,116,116) -- #ed7474
		movedir.Size = Vector3.new(1,1,1)
		local tracer2 = Instance.new("Part")
		tracer2.Shape = Enum.PartType.Cylinder
		tracer2.Parent = vpframe
		tracer2.Color = Color3.fromRGB(237,116,116)
		tracer2.CFrame = CFrame.new((movedir.Position+Client.Target.HumanoidRootPart.Position)/2,movedir.Position) * CFrame.Angles(0,math.pi/2,0)
		tracer2.Size = Vector3.new((movedir.Position-Client.Target.HumanoidRootPart.Position).Magnitude,1,1)
	end
end)

function addesp(plr)
	function esp(plr2)
		local box = Drawing.new('Square')
		box.ZIndex = -2
		box.Visible = false
		box.Color = Color3.new(1,1,1)
		box.Thickness = 1
		box.Transparency = 1
		box.Filled = false
		
		local boxoutline = Drawing.new('Square')
		boxoutline.ZIndex = -3
		boxoutline.Visible = false
		boxoutline.Color = Color3.new(0,0,0)
		boxoutline.Thickness = 3
		boxoutline.Transparency = 1
		boxoutline.Filled = false
		
		aa = aa + 2
		
		local func_id = aa
		local func_id2 = aa - 1
		
		Connections[func_id2] = workspace.ChildRemoved:Connect(function(child)
			if child == plr2 then
				boxoutline.Visible = false
				box.Visible = false
				Connections[func_id]:Disconnect()
				Connections[func_id2]:Disconnect()
			end
		end)
		Connections[func_id] = RunService.RenderStepped:Connect(function()
			if ESP then
				if workspace:FindFirstChild(plr2.Name) then
					if plr2 and plr2:IsA("Model") and plr2:FindFirstChildWhichIsA("Humanoid") and plr2:FindFirstChild("HumanoidRootPart") and plr2:FindFirstChild("Head") and plr2.Humanoid.Health > 0 and plr2.Name ~= LocalPlayer.Name then
						local Vector, onScreen = CurrentCamera:worldToViewportPoint(plr2.HumanoidRootPart.Position)
						
						local RootPart = plr2.HumanoidRootPart
						local Head = plr2.Head
						local RootPosition, RootVisible = worldToViewportPoint(CurrentCamera, RootPart.Position)
						local HeadPosition = worldToViewportPoint(CurrentCamera, Head.Position + HeadOff)
						local LegPosition = worldToViewportPoint(CurrentCamera, RootPart.Position - LegOff)
						
						if onScreen then
							boxoutline.Size = Vector2.new(1000 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
							boxoutline.Position = Vector2.new(RootPosition.X - boxoutline.Size.X / 2, RootPosition.Y - boxoutline.Size.Y / 2)
							boxoutline.Visible = true
							
							box.Size = Vector2.new(1000 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
							box.Position = Vector2.new(RootPosition.X - box.Size.X / 2, RootPosition.Y - box.Size.Y / 2)
							box.Visible = true
						else
							boxoutline.Visible = false
							box.Visible = false
						end
					else
						boxoutline.Visible = false
						box.Visible = false
						Connections[func_id]:Disconnect()
						Connections[func_id2]:Disconnect()
					end
				else
					boxoutline.Visible = false
					box.Visible = false
					Connections[func_id]:Disconnect()
					Connections[func_id2]:Disconnect()
				end
			else
				boxoutline.Visible = false
				box.Visible = false
				Connections[func_id]:Disconnect()
				Connections[func_id2]:Disconnect()
			end
		end)
	end
	if plr then
		coroutine.wrap(esp)(plr)
	else
		for i,v in pairs(workspace:GetChildren()) do
			coroutine.wrap(esp)(v)
		end
	end
end
workspace.ChildAdded:Connect(function(m)
	if ESP then
		if m:IsA("Model") and m.Name ~= LocalPlayer.Name and Players:FindFirstChild(m.Name) then
			wait(0.1)
			addesp(m)
		end
	end
end)

--// Hooks
--local namecall
--namecall = hookmetamethod(game, '__namecall', function(self,...)
	--local args = {...}
	--local method = getnamecallmethod()
	--if enabled and not checkcaller() and tostring(self) == "ThrowKnife" and method == "FireServer" then
		--args[1] = getleadshot(LocalPlayer.Character.Knife.Handle,Client.Target.HumanoidRootPart)
		--return namecall(self,unpack(args))
	--end
	--return namecall(self,...)
--end)
local index ; index = hookmetamethod(game, '__index', newcclosure(function(obj, idx)
	if enabled then
		if idx:lower() == 'unitray' and Client.Target and Client.Target:FindFirstChild("Humanoid") and Client.Target:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Knife") and LocalPlayer.Character.Knife:FindFirstChild("Handle") then
			print("unitray knife throw index method called")
			local aimpos = Aimbot:ComputePathAsync(LocalPlayer.Character.Knife.Handle,Client.Target.HumanoidRootPart,290,60,{},true,LocalPlayer:GetNetworkPing()*2,0,false)
			local origin = index(obj, idx)
			return {
				Origin = origin.Origin,
				Direction = CFrame.new(origin.Origin,aimpos).LookVector
			}
		end
	end
	return index(obj, idx)
end))

game.StarterGui:SetCore('SendNotification', {
	Title = 'Loaded';
	Text = 'Made by Luc#9803 / RBLX - inkvy';
	Duration = 3;
})
