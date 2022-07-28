function randomString() local length = math.random(10,20) local array = {} for i = 1, length do array[i] = string.char(math.random(32, 126)) end return table.concat(array) end
local function tween(o,i,g) game:GetService('TweenService'):Create(o,i,g):Play() end
local CAS = game:GetService('ContextActionService')
local UIS = game:GetService('UserInputService')

MAX=172
VER='v1.0'
DEB=false
LAST=''

local Holder = Instance.new('ScreenGui')
Holder.Name = randomString()
if (syn) then syn.protect_gui(Holder) end
Holder.IgnoreGuiInset = true
Holder.Parent = game:GetService('CoreGui')

local Host = Instance.new("Frame")
Host.Name = "Host"
Host.AnchorPoint = Vector2.new(0.5, 0)
Host.Size = UDim2.new(0, 1250, 0, 35)
Host.Position = UDim2.new(0.5, 0, 0, -41)
Host.BorderSizePixel = 0
Host.BackgroundColor3 = Color3.fromRGB(26, 1, 22)
Host.Parent = Holder

local Input = Instance.new("TextBox")
Input.Name = "Input"
Input.AnchorPoint = Vector2.new(0, 0.5)
Input.Size = UDim2.new(1, -39, 0, 16)
Input.ClipsDescendants = true
Input.BackgroundTransparency = 1
Input.Position = UDim2.new(0, 37, 0.5, 0)
Input.BorderSizePixel = 0
Input.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Input.FontSize = Enum.FontSize.Size14
Input.TextSize = 14
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.Text = ""
Input.PlaceholderText = "QuickRun - "..VER
Input.CursorPosition = -1
Input.Font = Enum.Font.RobotoMono
Input.TextXAlignment = Enum.TextXAlignment.Left
Input.Parent = Host

local Line = Instance.new("Frame")
Line.Name = "Line"
Line.Size = UDim2.new(0, 0, 0, 5)
Line.Position = UDim2.new(0, 0, 1, 0)
Line.BorderSizePixel = 0
Line.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
Line.Parent = Host

local IconHolder = Instance.new("Frame")
IconHolder.Name = "IconHolder"
IconHolder.Size = UDim2.new(0, 31, 0, 31)
IconHolder.BackgroundTransparency = 1
IconHolder.Position = UDim2.new(0, 2, 0, 2)
IconHolder.BorderSizePixel = 0
IconHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
IconHolder.Parent = Host

local Icon = Instance.new("ImageLabel")
Icon.Name = "Icon"
Icon.AnchorPoint = Vector2.new(0.5, 0.5)
Icon.Size = UDim2.new(0, 20, 0, 20)
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
Icon.BorderSizePixel = 0
Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Icon.ImageColor3 = Color3.fromRGB(255, 105, 180)
Icon.Image = "rbxassetid://6023426912"
Icon.Parent = IconHolder

local function slideIn()
	tween(Host, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, 0, 0, 41)}) -- roblox topbar height 36 + custom padding 5
	spawn(function()
		wait(0.25)
		tween(Line, TweenInfo.new(0.75, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, 5)})
	end)
end

local function slideOut()
	tween(Host, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0, -41)}) -- roblox topbar height 36 + custom padding 5
end

local function runCode(code)
	local s,r = pcall(function()
		loadstring(code)()
	end)
	if not s and _G.OUTPUT then
		warn('\nERROR ====== QuickRun - '..VER..' ====== ERROR\n> Code evaluated:\n'..code..'\n\n> Code error:\n'..r..'\nERROR ====== QuickRun - '..VER..' ====== ERROR')
	end
end

-- CODE
Input:GetPropertyChangedSignal('Text'):Connect(function()
	if string.len(Input.Text) > MAX then
		Input.TextXAlignment = Enum.TextXAlignment.Right
	else
		Input.TextXAlignment = Enum.TextXAlignment.Left
	end
end)

Input.FocusLost:Connect(function(ep)
	if DEB then repeat wait() until DEB==false end
	DEB=true
	if ep then
		LAST = Input.Text
		runCode(Input.Text)
		Input.Text = ''
		Input.PlaceholderText = 'Ran Code'
		tween(Line, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {BackgroundColor3 = Color3.fromRGB(128, 255, 114)})
		wait(0.25)
		tween(Line, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 3)})
	else
		LAST = Input.Text
		Input.Text = ''
		Input.PlaceholderText = 'Unfocused'
		tween(Line, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {BackgroundColor3 = Color3.fromRGB(255, 44, 47)})
		wait(0.25)
		tween(Line, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 3)})
	end
	slideOut()
	wait(0.6)
	Line.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
	Line.Size = UDim2.new(0, 0, 0, 5)
	if LAST == '' then
		Input.PlaceholderText = 'QuickRun - '..VER
	else
		local str
		if string.len(LAST) > MAX - 41 - string.len(VER) then 
			str=string.sub('QuickRun - '..VER..' - Tab to insert last input - '..LAST, 1, MAX - 3)..'...'
		else
			str=string.sub('QuickRun - '..VER..' - Tab to insert last input - '..LAST, 1, MAX - 3)
		end
		Input.PlaceholderText = str
	end
	DEB=false
end)

UIS.InputEnded:Connect(function(Input, IsTyping)
	if IsTyping and Input.KeyCode == Enum.KeyCode.Tab and Host.Input:IsFocused() and string.len(Host.Input.Text) == 1 then
		Host.Input.Text = LAST
		Host.Input.CursorPosition = string.len(LAST)+1
	end
	if IsTyping and Input.KeyCode == Enum.KeyCode.F6 and Host.Input:IsFocused() then
		if DEB then return end
		LAST = Host.Input.Text
		Host.Input:ReleaseFocus()
		Host.Input.Text = ''
		Host.Input.PlaceholderText = 'Unfocused'
		tween(Line, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {BackgroundColor3 = Color3.fromRGB(255, 44, 47)})
		wait(0.25)
		tween(Line, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 3)})
	end
	if IsTyping or DEB then return end
	if Input.KeyCode == Enum.KeyCode.F6 then
		Host.Input:CaptureFocus()
		DEB=true
		slideIn()
		wait(0.6)
		DEB=false
	end
end)
