local enabled = false
local enabled2 = false

local gui = Instance.new("ScreenGui")
gui.Parent = game:GetService("CoreGui")
local button = Instance.new("TextButton")
button.Parent = gui
button.Text = "Include Hats: OFF"
button.BackgroundColor3 = Color3.fromRGB(255,255,255)
button.Size = UDim2.new(0,125,0,25)
button.Position = UDim2.new(0,0,0,0)
local button2 = Instance.new("TextButton")
button2.Parent = gui
button2.Text = "Remove Lag"
button2.BackgroundColor3 = Color3.fromRGB(255,255,255)
button2.Size = UDim2.new(0,125,0,50)
button2.Position = UDim2.new(0,0,0,25)
local button3 = Instance.new("TextButton")
button3.Parent = gui
button3.Text = "Auto Remove Lag: OFF"
button3.BackgroundColor3 = Color3.fromRGB(255,255,255)
button3.Size = UDim2.new(0,125,0,25)
button3.Position = UDim2.new(0,0,0,75)

function removelag(player,includehats)
	if player then
		if player.Name ~= game.Players.LocalPlayer.Name then
			local kd = player:WaitForChild("KnifeDisplay")
	       	local gd = player:WaitForChild("GunDisplay")
	       	local r = player:WaitForChild("Radio",0.1)
	       	local p = player:WaitForChild("Pet",0.1)
	       	if kd and gd then
		       	kd:Destroy()
		       	gd:Destroy()
		    end
		    if r then
	        	r:Destroy()
	        end
	        if p then
	        	p:Destroy()
	        end
	        if includehats then
	        	for _, i in pairs(player:GetChildren()) do
		            if i:IsA("Accessory") then
		                i:Destroy()
		            end
		        end
	        end
	    end
	else
		for _, i in pairs(workspace:GetChildren()) do
			if i:IsA("Model") and i:FindFirstChild("Humanoid") and game.Players:FindFirstChild(i.Name) and i.Name ~= game.Players.LocalPlayer.Name then
		       	local kd = i:FindFirstChild("KnifeDisplay")
		       	local gd = i:FindFirstChild("GunDisplay")
		       	local r = i:FindFirstChild("Radio")
		       	local p = i:FindFirstChild("Pet")
		       	if kd and gd then
			       	kd:Destroy()
			       	gd:Destroy()
			    end
		        if r then
		        	r:Destroy()
		        end
		        if p then
		        	p:Destroy()
		        end
		        if includehats then
		        	for _, v in pairs(i:GetChildren()) do
			            if v:IsA("Accessory") then
			                v:Destroy()
			            end
			        end
		        end
		    end
	    end
	end
end
button3.MouseButton1Click:Connect(function()
    if enabled2 == false then
        enabled2 = true
        button3.Text = "Auto Remove Lag: ON"
    else
        enabled2 = false
        button3.Text = "Auto Remove Lag: OFF"
    end
end)
button.MouseButton1Click:Connect(function()
    if enabled == false then
        enabled = true
        button.Text = "Include Hats: ON"
    else
        enabled = false
        button.Text = "Include Hats: OFF"
    end
end)
button2.MouseButton1Click:Connect(function()
  	removelag(nil,enabled)
end)
game.Workspace.ChildAdded:Connect(function(i)
	if enabled2 == true then
		if i:IsA("Model") and game.Players:FindFirstChild(i.Name) then
			removelag(i,enabled)
		end
	end
end)
local rs = game:GetService("RunService")
local i = 0
while rs.Heartbeat:Wait() do
    i = i + 2
    if i >= 360 then
        i = 0
    end
    button2.BackgroundColor3 = Color3.fromHSV(i/360,0.5,1)
end
