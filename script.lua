local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/synolope/meepcracked/main/ui-engine.lua"))()

local function loopwrap(func,int)
	local connect = nil
	return function(b)
		if connect then
			connect:Disconnect()
			connect = nil
		end
		if b then
			local i = 0
			connect = game.RunService.Heartbeat:Connect(function()
				i = i + 1
				if tonumber(int) then
					if i%int == 0 then
						func()
					end
				else
					func()
				end
			end)
		end
	end
end

local function checkdir()
    if not isfolder("meepcracked") then
        makefolder("meepcracked")
    end
end

local Window = library:AddWindow("MeepCracked", {
	main_color = Color3.fromRGB(245, 117, 66),
	min_size = Vector2.new(500, 600),
	toggle_key = Enum.KeyCode.RightShift,
	can_resize = true,
})

local Throwing = Window:AddTab("Throwing")
local Action = Window:AddTab("Action Items")
local Local = Window:AddTab("Local")
Local:AddLabel("( This is only for you. No one else can see these changes. )")

local items = {
	["Spitball"] = 1178,
	["Snowball (Cum)"] = 932,
	["Egg"] = 602,
	["Golden Egg"] = 1122
}

local selecteditem = nil

local Dropdown = Throwing:AddDropdown("Throwing Item", function(itemname)
	selecteditem = items[itemname]
end)

for i,v in pairs(items) do
	Dropdown:Add(i)
end

local function hit(player)
	if selecteditem and player.Character and player.Character:FindFirstChild("Head") then
		local targetpos = player.Character.Head.Position
		local Global = require(game:GetService("ReplicatedStorage").Global)
		game:GetService("ReplicatedStorage").ConnectionEvent:FireServer(226, game:GetService("HttpService"):JSONEncode({selecteditem,Global.ConcatenateVector3(targetpos),Global.ConcatenateVector3(targetpos),Global.ConcatenateVector3(targetpos),0}))
	end
end

local function throwall()
	for _,player in pairs(game.Players:GetPlayers()) do
		hit(player)
	end
end

Throwing:AddButton("Throw At All Players",throwall)
Throwing:AddSwitch("Loop Throw At All Players",loopwrap(throwall,10))

Local:AddSwitch("Anti Snowball Screen",loopwrap(function()
	local t = require(game.Players.LocalPlayer.PlayerGui:WaitForChild("ThrowingItemGui"):WaitForChild("ThrowingItemGUI"))
	t.SetHitByContainerEnabled(false)
end))

local actionitems = {}

local selectedaitem = nil

for i,v in pairs(require(game.ReplicatedStorage.AssetList)) do
	if v and v.ActionItemParentAssetId then
		actionitems[v.Title] = i
	end
end

local Dropdown = Action:AddDropdown("Action Item", function(itemname)
	selectedaitem = actionitems[itemname]
end)

for i,v in pairs(actionitems) do
	Dropdown:Add(i)
end

Action:AddButton("Equip Item",function()
	if selectedaitem then
		game.Players.LocalPlayer.VirtualWorldFunctions.RequestActionItem:Invoke(selectedaitem)
	end
end)

Action:AddSwitch("Spam Equip",loopwrap(function()
	if selectedaitem then
		game.Players.LocalPlayer.VirtualWorldFunctions.RequestActionItem:Invoke(selectedaitem)
	end
end))

Local:AddTextBox("Set World Background Music ID",function(id)
    if tonumber(id) then
        checkdir()
        writefile("meepcracked\\bgmusic.txt",id)
        require(game:GetService("ReplicatedStorage").ClientClasses.VirtualWorld).SetBackgroundMusic(id,.5,true)
    end
end)

checkdir()

if isfile("meepcracked\\bgmusic.txt") then
    require(game:GetService("ReplicatedStorage"):WaitForChild("ClientClasses"):WaitForChild("VirtualWorld")).SetBackgroundMusic(readfile("meepcracked\\bgmusic.txt"),.5,true)
end

Throwing:Show()
library:FormatWindows()