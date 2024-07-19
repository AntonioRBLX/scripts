if not game:IsLoaded() then game.Loaded:Wait() end
local StarterGui = game:GetService("StarterGui")
function notify(title,description,icon)
    StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = description;
        Icon = "rbxassetid://"..tostring(icon);
    })
end
if Loading then return end
if game.PlaceId ~= 10449761463 then
    notify("Error","Unsupported Game: "..game.Name, 2592670412)
    return
end
if not hookmetamethod or not getgenv then
    notify("Error","Incompatible Executor!", 2592670412)
    return
end
if TSBMainByCITY512AlreadyExecuted then 
    notify("Error","Already Executed!", 2592670412)
    return
end
getgenv().Loading = true
notify("Info","Loading",14624193192)
local globals = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/scripts/main/The%20Strongest%20Battlegrounds/Scripts/Globals.lua"))
local userinterface = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/scripts/main/The%20Strongest%20Battlegrounds/Scripts/UserInterface.lua"))
local hooks = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/scripts/main/The%20Strongest%20Battlegrounds/Scripts/Hooks.lua"))
local loops = loadstring(game:HttpGet("https://raw.githubusercontent.com/CITY512/scripts/main/The%20Strongest%20Battlegrounds/Scripts/Loops.lua"))
getgenv().Loading = false
if not globals or not userinterface or not hooks or not loops then
    notify("Error","Failed To Load Hub!", 2592670412)
    return
end
globals()
userinterface()
hooks()
loops()
notify("Success","Successfully Loaded.", 17262979664)
getgenv().TSBMainByCITY512AlreadyExecuted = true
