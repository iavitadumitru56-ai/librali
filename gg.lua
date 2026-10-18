local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ExecutorEnvironment = _G
if type(getgenv) == "function" then
	local success, environment = pcall(getgenv)
	if success and type(environment) == "table" then
		ExecutorEnvironment = environment
	end
end

local function getExecutorFunction(name)
	local fn = ExecutorEnvironment[name] or _G[name] or (getfenv and getfenv()[name])
	return type(fn) == "function" and fn or nil
end

local GuiParent = PlayerGui
local getHiddenUi = getExecutorFunction("gethui")
if getHiddenUi then
	local success, hiddenUi = pcall(getHiddenUi)
	if success and typeof(hiddenUi) == "Instance" then
		GuiParent = hiddenUi
	end
else
	pcall(function() GuiParent = CoreGui:FindFirstChild("RobloxGui") or CoreGui end)
end

local fileApi = {
	isfolder = getExecutorFunction("isfolder"),
	makefolder = getExecutorFunction("makefolder"),
	isfile = getExecutorFunction("isfile"),
	writefile = getExecutorFunction("writefile"),
	readfile = getExecutorFunction("readfile"),
	delfile = getExecutorFunction("delfile"),
	listfiles = getExecutorFunction("listfiles"),
}

local Theme = {
	Background = Color3.fromRGB(14, 16, 21),
	SideBar = Color3.fromRGB(11, 13, 17),
	HeaderBackground = Color3.fromRGB(16, 19, 25),
	CardBackground = Color3.fromRGB(17, 20, 27),
	CardStroke = Color3.fromRGB(27, 32, 43),
	NavActive = Color3.fromRGB(22, 26, 35),
	NavHover = Color3.fromRGB(18, 22, 30),
	NavText = Color3.fromRGB(135, 144, 162),
	NavTextActive = Color3.fromRGB(255, 255, 255),
	AccentBlue = Color3.fromRGB(245, 247, 252),
	AccentWhite = Color3.fromRGB(245, 247, 252),
	AccentDark = Color3.fromRGB(12, 14, 20),
	AccentRed = Color3.fromRGB(245, 56, 75),
	TextPrimary = Color3.fromRGB(240, 243, 250),
	TextSecondary = Color3.fromRGB(105, 115, 134),
	ToggleOff = Color3.fromRGB(26, 30, 40),
	ToggleKnob = Color3.fromRGB(140, 148, 165),
	SliderTrack = Color3.fromRGB(20, 24, 33),
	FontRegular = Enum.Font.Gotham,
	FontMedium = Enum.Font.GothamMedium,
	FontSemiBold = Enum.Font.GothamBold,
	FontBold = Enum.Font.GothamBold,
}

local MidnightUI = {
	IsOpen = true,
	ToggleKey = Enum.KeyCode.RightShift,
	ToggleKeyAlt = Enum.KeyCode.Insert,
	Alive = true,
	Connections = {},
	Cleanups = {},
	PointerSerial = 0,
	ResponsiveScale = 1,
	MenuRestPosition = UDim2.new(0.5, 0, 0.5, 0),
	MobileLogoMode = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled,
	MascotAnimationId = 0,
	HudAnimationSerial = 0,
	CurrentLanguage = "en",
	ConfigFolder = "midnight_configs",
	Theme = Theme,
	Layout = {
		WindowWidth = 680,
		WindowHeight = 560,
		MinWindowWidth = 600,
		MinWindowHeight = 450,
		SidebarWidth = 167,
		CardWidth = 230,
		RightColumnX = 267,
		TallCardHeight = 468,
	},
	Icons = {
		Brand = "rbxthumb://type=Asset&id=99988955124052&w=150&h=150",
		Search = "rbxassetid://7734052925",
		Close = "rbxassetid://10747384394",
		Keyboard = "rbxassetid://10723416765",
		Sliders = "rbxassetid://85538382643347",
		Settings = "rbxassetid://8997386997",
		Palette = "rbxassetid://7734021595",
		Configs = "rbxassetid://8997386062",
		Arrow = "rbxassetid://10709791437",
	},
	KeybindPopup = {},
	DragState = {},
	ResizeState = nil,
	ActiveCloseDropdown = nil,
	I18n = {
		Dict = {
			["GENERAL"] = "ОБЩИЕ",
			["SETTINGS"] = "НАСТРОЙКИ",
			["MISC"] = "РАЗНОЕ",
			["Interface"] = "Интерфейс",
			["Configs"] = "Конфиги",
			["HUD Widget"] = "Виджет HUD",
			["Show Mascot"] = "Показывать маскота",
			["Browse Configs"] = "Обзор конфигов",
			["Save Config"] = "Сохранить конфиг",
			["Load Typed"] = "Загрузить имя",
			["Search..."] = "Поиск...",
			["Language"] = "Язык",
		},
		Reverse = {}
	}
}

for en, ru in pairs(MidnightUI.I18n.Dict) do
	MidnightUI.I18n.Reverse[ru] = en
end

function MidnightUI:Connect(signal, callback, once)
	if not self.Alive then return nil end
	local connection
	connection = signal:Connect(function(...)
		if once and connection then connection:Disconnect() end
		if self.Alive then callback(...) end
	end)
	table.insert(self.Connections, connection)
	return connection
end

function MidnightUI:AddCleanup(callback)
	if not self.Alive then
		pcall(callback)
		return
	end
	table.insert(self.Cleanups, callback)
end

function MidnightUI:Destroy()
	if not self.Alive then return end
	self.Alive = false
	self:CancelPointerDrags()

	for _, connection in ipairs(self.Connections) do
		pcall(function() connection:Disconnect() end)
	end
	table.clear(self.Connections)

	for index = #self.Cleanups, 1, -1 do
		pcall(self.Cleanups[index])
	end
	table.clear(self.Cleanups)

	if self.Gui then
		self.Gui:Destroy()
		self.Gui = nil
	end
end

function MidnightUI:CancelPointerDrags()
	self.PointerSerial += 1
	if self.DragState then
		self.DragState.Active = false
		self.DragState.Smooth = false
	end
	if self.ResizeState then
		self.ResizeState.Active = false
	end
end

local function isPointerActive(input, serial)
	return MidnightUI.Alive and input ~= nil and serial == MidnightUI.PointerSerial
		and input.UserInputState ~= Enum.UserInputState.End
		and input.UserInputState ~= Enum.UserInputState.Cancel
end

local function isPointerMovement(input, activeInput, serial)
	return isPointerActive(activeInput, serial) and (input == activeInput
		or (activeInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement))
end

function MidnightUI:GetGuiViewportSize()
	if self.Gui and self.Gui.AbsoluteSize.X > 0 and self.Gui.AbsoluteSize.Y > 0 then
		return self.Gui.AbsoluteSize
	end
	return Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
end

function MidnightUI:ClampGuiPosition(gui, position, size)
	local viewport = self:GetGuiViewportSize()
	size = size or gui.AbsoluteSize
	local anchor = gui.AnchorPoint
	local minX, maxX = 6 + size.X * anchor.X, viewport.X - 6 - size.X * (1 - anchor.X)
	local minY, maxY = 6 + size.Y * anchor.Y, viewport.Y - 6 - size.Y * (1 - anchor.Y)
	local x = position.X.Scale * viewport.X + position.X.Offset
	local y = position.Y.Scale * viewport.Y + position.Y.Offset
	x = maxX >= minX and math.clamp(x, minX, maxX) or viewport.X * 0.5 + size.X * (anchor.X - 0.5)
	y = maxY >= minY and math.clamp(y, minY, maxY) or viewport.Y * 0.5 + size.Y * (anchor.Y - 0.5)
	return UDim2.new(position.X.Scale, x - position.X.Scale * viewport.X, position.Y.Scale, y - position.Y.Scale * viewport.Y)
end

-- ==========================================================
-- СИСТЕМА КОНФИГУРАЦИЙ (FILE API + JSON)
-- ==========================================================
local function sanitizeConfigName(name)
	local clean = tostring(name or "default"):gsub("%.json$", ""):gsub("[^%w_%-%s]", ""):gsub("^%s+", ""):gsub("%s+$", ""):gsub("%s+", "_")
	return clean == "" and "default" or clean:sub(1, 48)
end

function MidnightUI:EnsureConfigFolder()
	if not fileApi.makefolder then return false end
	if fileApi.isfolder then
		local ok, exists = pcall(fileApi.isfolder, self.ConfigFolder)
		if ok and exists then return true end
	end
	return pcall(fileApi.makefolder, self.ConfigFolder)
end

local function encodeConfig(value)
	if typeof(value) == "Color3" then
		return { __type = "Color3", r = math.round(value.R * 255), g = math.round(value.G * 255), b = math.round(value.B * 255) }
	elseif type(value) == "table" then
		local t = {}
		for k, v in pairs(value) do t[k] = encodeConfig(v) end
		return t
	end
	return value
end

local function decodeConfig(value)
	if type(value) ~= "table" then return value end
	if value.__type == "Color3" then
		return Color3.fromRGB(math.clamp(tonumber(value.r) or 255, 0, 255), math.clamp(tonumber(value.g) or 255, 0, 255), math.clamp(tonumber(value.b) or 255, 0, 255))
	end
	local t = {}
	for k, v in pairs(value) do t[k] = decodeConfig(v) end
	return t
end

function MidnightUI:SaveConfig(name, settingsTable)
	if not fileApi.writefile or not self:EnsureConfigFolder() then return false, "File API Unavailable" end
	local clean = sanitizeConfigName(name)
	local path = self.ConfigFolder .. "/" .. clean .. ".json"
	local ok, err = pcall(function()
		local payload = { Version = 1, SavedAt = os.time(), Data = encodeConfig(settingsTable or {}) }
		fileApi.writefile(path, HttpService:JSONEncode(payload))
	end)
	if self.RefreshConfigPicker then self.RefreshConfigPicker() end
	return ok, ok and clean or err
end

function MidnightUI:LoadConfig(name)
	if not fileApi.readfile or not fileApi.isfile then return nil, "File API Unavailable" end
	local clean = sanitizeConfigName(name)
	local path = self.ConfigFolder .. "/" .. clean .. ".json"
	local existsOk, exists = pcall(fileApi.isfile, path)
	if not existsOk or not exists then return nil, "File not found" end
	local ok, text = pcall(fileApi.readfile, path)
	if not ok then return nil, "Read error" end
	local dok, decoded = pcall(function() return HttpService:JSONDecode(text) end)
	if not dok or type(decoded) ~= "table" then return nil, "Decode error" end
	return decodeConfig(decoded.Data or decoded), clean
end

function MidnightUI:DeleteConfig(name)
	if not fileApi.delfile or not fileApi.isfile then return false end
	local clean = sanitizeConfigName(name)
	local path = self.ConfigFolder .. "/" .. clean .. ".json"
	local ok = pcall(fileApi.delfile, path)
	if self.RefreshConfigPicker then self.RefreshConfigPicker() end
	return ok
end

-- ==========================================================
-- ЛОКАЛИЗАЦИЯ (I18N)
-- ==========================================================
function MidnightUI:SetLanguage(lang)
	self.CurrentLanguage = (lang == "ru" or lang == 2) and "ru" or "en"
	local isRu = (self.CurrentLanguage == "ru")
	if not self.MainFrame then return end
	for _, inst in ipairs(self.MainFrame:GetDescendants()) do
		if inst:IsA("TextLabel") or inst:IsA("TextButton") then
			local cur = inst.Text
			if cur and cur ~= "" and inst.Name ~= "EN" and inst.Name ~= "RU" and inst.Name ~= "UserAvatar" then
				if isRu then
					local ru = self.I18n.Dict[cur] or self.I18n.Dict[self.I18n.Reverse[cur]]
					if ru then inst.Text = ru end
				else
					local en = self.I18n.Reverse[cur]
					if en then inst.Text = en end
				end
			end
		elseif inst:IsA("TextBox") and inst.Name == "SearchInput" then
			inst.PlaceholderText = isRu and "Поиск..." or "Search..."
		end
	end
end

-- ==========================================================
-- СОЗДАНИЕ ГЛАВНОГО ОКНА
-- ==========================================================
function MidnightUI:CreateWindow(windowConfig)
	windowConfig = windowConfig or {}
	local Title = windowConfig.Title or "Midnight"
	local Subtitle = windowConfig.Subtitle or "interface framework"
	self.ConfigFolder = windowConfig.ConfigFolder or "midnight_configs"

	if windowConfig.ToggleKey then self.ToggleKey = windowConfig.ToggleKey end
	if windowConfig.ToggleKeyAlt then self.ToggleKeyAlt = windowConfig.ToggleKeyAlt end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "MidnightGui_" .. Title:gsub("%s+", "")
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = windowConfig.Parent or GuiParent
	self.Gui = ScreenGui
	self:Connect(ScreenGui.Destroying, function() self:Destroy() end, true)

	local MainFrame = Instance.new("CanvasGroup")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, self.Layout.WindowWidth, 0, self.Layout.WindowHeight)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.BackgroundColor3 = Theme.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.Active = true
	MainFrame.ClipsDescendants = false
	MainFrame.GroupTransparency = 0
	MainFrame.ZIndex = 2
	MainFrame.Parent = ScreenGui
	self.MainFrame = MainFrame

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 8)
	MainCorner.Parent = MainFrame

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color = Theme.CardStroke
	MainStroke.Thickness = 1
	MainStroke.Parent = MainFrame

	local MainScale = Instance.new("UIScale")
	MainScale.Name = "ResponsiveScale"
	MainScale.Parent = MainFrame
	self.MainScale = MainScale

	self.GetResponsiveScale = function()
		local viewport = self:GetGuiViewportSize()
		return math.clamp(math.min(
			math.max(1, viewport.X - 24) / math.max(1, MainFrame.Size.X.Offset),
			math.max(1, viewport.Y - 24) / math.max(1, MainFrame.Size.Y.Offset)
		), 0.01, 1)
	end

	local function updateMainScale()
		if not self.Alive then return end
		self.ResponsiveScale = self.GetResponsiveScale()
		if self.IsOpen and not (self.ResizeState and self.ResizeState.Active) then
			MainScale.Scale = self.ResponsiveScale
			MainFrame.Position = self:ClampGuiPosition(MainFrame, MainFrame.Position, Vector2.new(MainFrame.Size.X.Offset, MainFrame.Size.Y.Offset) * self.ResponsiveScale)
			self.MenuRestPosition = MainFrame.Position
			self.DragState.TargetPosition = MainFrame.Position
		end
		if self.HudWidget then
			self.HudWidget.Position = self:ClampGuiPosition(self.HudWidget, self.HudWidget.Position)
		end
		if self.FloatingLogo then
			self.FloatingLogo.Position = self:ClampGuiPosition(self.FloatingLogo, self.FloatingLogo.Position)
		end
	end

	self:Connect(Workspace:GetPropertyChangedSignal("CurrentCamera"), updateMainScale)
	self:Connect(ScreenGui:GetPropertyChangedSignal("AbsoluteSize"), function()
		self:CancelPointerDrags()
		updateMainScale()
	end)
	self:Connect(MainFrame:GetPropertyChangedSignal("Size"), updateMainScale)
	self.RefreshGuiLayout = updateMainScale

	-- Ресайз за нижний правый угол
	local ResizeHandle = Instance.new("TextButton")
	ResizeHandle.Name = "ResizeHandle"
	ResizeHandle.Size = UDim2.new(0, 24, 0, 24)
	ResizeHandle.Position = UDim2.new(1, -24, 1, -24)
	ResizeHandle.BackgroundTransparency = 1
	ResizeHandle.Text = ""
	ResizeHandle.AutoButtonColor = false
	ResizeHandle.ZIndex = 100
	ResizeHandle.Parent = MainFrame
	self.ResizeHandle = ResizeHandle

	self.ResizeState = {
		Active = false,
		StartInput = nil,
		StartSize = Vector2.new(self.Layout.WindowWidth, self.Layout.WindowHeight),
		StartPosition = MainFrame.Position,
	}

	self:Connect(ResizeHandle.InputBegan, function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		if not self.IsOpen then return end
		self:CancelPointerDrags()
		self.ResizeState.Active = true
		self.ResizeState.Input = input
		self.ResizeState.Serial = self.PointerSerial
		self.ResizeState.Scale = MainScale.Scale
		self.ResizeState.StartInput = input.Position
		self.ResizeState.StartSize = Vector2.new(MainFrame.Size.X.Offset, MainFrame.Size.Y.Offset)
		self.ResizeState.StartPosition = MainFrame.Position
	end)

	self:Connect(UserInputService.InputChanged, function(input)
		if not self.ResizeState.Active then return end
		if not isPointerMovement(input, self.ResizeState.Input, self.ResizeState.Serial) then return end

		local scale = self.ResizeState.Scale
		local rawDelta = input.Position - self.ResizeState.StartInput
		local delta = Vector3.new(rawDelta.X / scale, rawDelta.Y / scale, 0)
		local viewport = self:GetGuiViewportSize()
		local maxWidth = math.max(self.Layout.MinWindowWidth, (viewport.X - 24) / scale)
		local maxHeight = math.max(self.Layout.MinWindowHeight, (viewport.Y - 24) / scale)
		local width = math.clamp(self.ResizeState.StartSize.X + delta.X, self.Layout.MinWindowWidth, maxWidth)
		local height = math.clamp(self.ResizeState.StartSize.Y + delta.Y, self.Layout.MinWindowHeight, maxHeight)
		local sizeDelta = Vector2.new(width - self.ResizeState.StartSize.X, height - self.ResizeState.StartSize.Y)

		MainFrame.Size = UDim2.new(0, width, 0, height)
		MainFrame.Position = self:ClampGuiPosition(MainFrame, UDim2.new(
			self.ResizeState.StartPosition.X.Scale,
			self.ResizeState.StartPosition.X.Offset + sizeDelta.X * scale * 0.5,
			self.ResizeState.StartPosition.Y.Scale,
			self.ResizeState.StartPosition.Y.Offset + sizeDelta.Y * scale * 0.5
		), Vector2.new(width, height) * scale)
	end)

	self:Connect(UserInputService.InputEnded, function(input)
		if input == self.ResizeState.Input then
			self.ResizeState.Active = false
			self.ResizeState.Input = nil
			self.RefreshGuiLayout()
		end
	end)

	-- Sidebar
	local SideBar = Instance.new("Frame")
	SideBar.Name = "SideBar"
	SideBar.Size = UDim2.new(0, self.Layout.SidebarWidth, 1, 0)
	SideBar.Position = UDim2.new(0, 0, 0, 0)
	SideBar.BackgroundColor3 = Theme.SideBar
	SideBar.BorderSizePixel = 0
	SideBar.ZIndex = 3
	SideBar.Parent = MainFrame

	local SideBarCorner = Instance.new("UICorner")
	SideBarCorner.CornerRadius = UDim.new(0, 8)
	SideBarCorner.Parent = SideBar

	local SideBarDivider = Instance.new("Frame")
	SideBarDivider.Name = "Divider"
	SideBarDivider.Size = UDim2.new(0, 1, 1, 0)
	SideBarDivider.Position = UDim2.new(1, -1, 0, 0)
	SideBarDivider.BackgroundColor3 = Theme.CardStroke
	SideBarDivider.BorderSizePixel = 0
	SideBarDivider.ZIndex = 4
	SideBarDivider.Parent = SideBar

	local SideLogo = Instance.new("ImageButton")
	SideLogo.Name = "SideLogo"
	SideLogo.Size = UDim2.new(0, 40, 0, 40)
	SideLogo.Position = UDim2.new(0, 9, 0, 8)
	SideLogo.BackgroundColor3 = Color3.fromRGB(132, 142, 162)
	SideLogo.BackgroundTransparency = 0
	SideLogo.BorderSizePixel = 0
	SideLogo.AutoButtonColor = false
	SideLogo.Image = windowConfig.Logo or self.Icons.Brand
	SideLogo.ScaleType = Enum.ScaleType.Fit
	SideLogo.ZIndex = 4
	SideLogo.Parent = SideBar
	self.SideLogo = SideLogo

	local SideLogoCorner = Instance.new("UICorner")
	SideLogoCorner.CornerRadius = UDim.new(0, 10)
	SideLogoCorner.Parent = SideLogo

	local SideLogoStroke = Instance.new("UIStroke")
	SideLogoStroke.Color = Theme.AccentBlue
	SideLogoStroke.Thickness = 1.25
	SideLogoStroke.Transparency = 0.58
	SideLogoStroke.Parent = SideLogo

	local BrandLabel = Instance.new("TextLabel")
	BrandLabel.Name = "BrandLabel"
	BrandLabel.Size = UDim2.new(1, -61, 0, 24)
	BrandLabel.Position = UDim2.new(0, 55, 0, 8)
	BrandLabel.BackgroundTransparency = 1
	BrandLabel.Text = Title
	BrandLabel.Font = Theme.FontBold
	BrandLabel.TextSize = 18
	BrandLabel.TextColor3 = Color3.new(1, 1, 1)
	BrandLabel.TextXAlignment = Enum.TextXAlignment.Left
	BrandLabel.ZIndex = 5
	BrandLabel.Parent = SideBar

	local BrandSubtitle = Instance.new("TextLabel")
	BrandSubtitle.Name = "BrandSubtitle"
	BrandSubtitle.Size = UDim2.new(1, -61, 0, 12)
	BrandSubtitle.Position = UDim2.new(0, 56, 0, 31)
	BrandSubtitle.BackgroundTransparency = 1
	BrandSubtitle.Text = Subtitle
	BrandSubtitle.Font = Theme.FontBold
	BrandSubtitle.TextSize = 8
	BrandSubtitle.TextColor3 = Color3.fromRGB(82, 98, 126)
	BrandSubtitle.TextXAlignment = Enum.TextXAlignment.Left
	BrandSubtitle.ZIndex = 5
	BrandSubtitle.Parent = SideBar

	-- Mobile Floating Logo
	local FloatingLogo = Instance.new("ImageButton")
	FloatingLogo.Name = "FloatingLogo"
	FloatingLogo.Size = UDim2.new(0, 40, 0, 40)
	FloatingLogo.AnchorPoint = Vector2.new(0.5, 0.5)
	FloatingLogo.Position = UDim2.new(0, 40, 0, 40)
	FloatingLogo.BackgroundColor3 = Color3.fromRGB(132, 142, 162)
	FloatingLogo.BackgroundTransparency = 1
	FloatingLogo.BorderSizePixel = 0
	FloatingLogo.AutoButtonColor = false
	FloatingLogo.Image = windowConfig.Logo or self.Icons.Brand
	FloatingLogo.ScaleType = Enum.ScaleType.Fit
	FloatingLogo.ZIndex = 1000
	FloatingLogo.Visible = false
	FloatingLogo.Parent = ScreenGui
	self.FloatingLogo = FloatingLogo

	local FloatingLogoCorner = Instance.new("UICorner")
	FloatingLogoCorner.CornerRadius = UDim.new(0, 10)
	FloatingLogoCorner.Parent = FloatingLogo

	local FloatingLogoStroke = Instance.new("UIStroke")
	FloatingLogoStroke.Color = Theme.AccentBlue
	FloatingLogoStroke.Thickness = 1.25
	FloatingLogoStroke.Transparency = 1
	FloatingLogoStroke.Parent = FloatingLogo

	local FloatingLogoScale = Instance.new("UIScale")
	FloatingLogoScale.Scale = 1
	FloatingLogoScale.Parent = FloatingLogo
	self.FloatingLogoScale = FloatingLogoScale

	self:Connect(SideLogo.Activated, function()
		if self.MobileLogoMode and self.IsOpen then
			self:ToggleMenu()
		end
	end)

	local floatingDragInput, floatingDragSerial
	local floatingDragMoved = false
	local floatingDragStart = Vector3.zero
	local floatingStartPosition = FloatingLogo.Position

	self:Connect(FloatingLogo.InputBegan, function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		if isPointerActive(floatingDragInput, floatingDragSerial) then return end
		floatingDragInput = input
		floatingDragSerial = self.PointerSerial
		floatingDragMoved = false
		floatingDragStart = input.Position
		floatingStartPosition = FloatingLogo.Position
	end)

	self:Connect(UserInputService.InputChanged, function(input)
		if not FloatingLogo.Visible or not isPointerMovement(input, floatingDragInput, floatingDragSerial) then return end
		local delta = input.Position - floatingDragStart
		if delta.Magnitude > 5 then floatingDragMoved = true end
		FloatingLogo.Position = self:ClampGuiPosition(FloatingLogo, UDim2.fromOffset(
			floatingStartPosition.X.Offset + delta.X,
			floatingStartPosition.Y.Offset + delta.Y
		))
	end)

	self:Connect(UserInputService.InputEnded, function(input)
		if input == floatingDragInput then floatingDragInput = nil end
	end)

	self:Connect(FloatingLogo.Activated, function()
		if not self.MobileLogoMode or floatingDragMoved or self.IsOpen then return end
		self:ToggleMenu()
	end)

	-- Header
	local Header = Instance.new("Frame")
	Header.Name = "Header"
	Header.Size = UDim2.new(1, -self.Layout.SidebarWidth, 0, 48)
	Header.Position = UDim2.new(0, self.Layout.SidebarWidth, 0, 0)
	Header.BackgroundColor3 = Theme.HeaderBackground
	Header.BorderSizePixel = 0
	Header.Active = true
	Header.ZIndex = 2
	Header.Parent = MainFrame

	local HeaderCorner = Instance.new("UICorner")
	HeaderCorner.CornerRadius = UDim.new(0, 8)
	HeaderCorner.Parent = Header

	local HeaderDivider = Instance.new("Frame")
	HeaderDivider.Name = "Divider"
	HeaderDivider.Size = UDim2.new(1, 0, 0, 1)
	HeaderDivider.Position = UDim2.new(0, 0, 1, -1)
	HeaderDivider.BackgroundColor3 = Theme.CardStroke
	HeaderDivider.BorderSizePixel = 0
	HeaderDivider.ZIndex = 3
	HeaderDivider.Parent = Header

	local Breadcrumb = Instance.new("TextLabel")
	Breadcrumb.Name = "Breadcrumb"
	Breadcrumb.Size = UDim2.new(0, 180, 1, 0)
	Breadcrumb.Position = UDim2.new(0, 16, 0, 0)
	Breadcrumb.BackgroundTransparency = 1
	Breadcrumb.Text = Title
	Breadcrumb.Font = Theme.FontMedium
	Breadcrumb.TextSize = 13
	Breadcrumb.TextColor3 = Theme.TextSecondary
	Breadcrumb.TextXAlignment = Enum.TextXAlignment.Left
	Breadcrumb.ZIndex = 3
	Breadcrumb.Parent = Header

	-- Search Input
	local SearchContainer = Instance.new("Frame")
	SearchContainer.Name = "SearchContainer"
	SearchContainer.Size = UDim2.new(0, 160, 0, 28)
	SearchContainer.Position = UDim2.new(1, -214, 0.5, -14)
	SearchContainer.BackgroundColor3 = Color3.fromRGB(24, 28, 36)
	SearchContainer.BorderSizePixel = 0
	SearchContainer.ZIndex = 4
	SearchContainer.Parent = Header

	local SearchCorner = Instance.new("UICorner")
	SearchCorner.CornerRadius = UDim.new(0, 6)
	SearchCorner.Parent = SearchContainer

	local SearchStroke = Instance.new("UIStroke")
	SearchStroke.Color = Theme.CardStroke
	SearchStroke.Thickness = 1
	SearchStroke.Parent = SearchContainer

	local SearchIcon = Instance.new("ImageLabel")
	SearchIcon.Name = "SearchIcon"
	SearchIcon.Size = UDim2.new(0, 14, 0, 14)
	SearchIcon.Position = UDim2.new(0, 8, 0.5, -7)
	SearchIcon.BackgroundTransparency = 1
	SearchIcon.Image = self.Icons.Search
	SearchIcon.ImageColor3 = Theme.TextSecondary
	SearchIcon.ZIndex = 5
	SearchIcon.Parent = SearchContainer

	local SearchInput = Instance.new("TextBox")
	SearchInput.Name = "SearchInput"
	SearchInput.Size = UDim2.new(1, -30, 1, 0)
	SearchInput.Position = UDim2.new(0, 26, 0, 0)
	SearchInput.BackgroundTransparency = 1
	SearchInput.Text = ""
	SearchInput.PlaceholderText = "Search..."
	SearchInput.PlaceholderColor3 = Color3.fromRGB(90, 98, 114)
	SearchInput.TextColor3 = Theme.TextPrimary
	SearchInput.Font = Theme.FontRegular
	SearchInput.TextSize = 12
	SearchInput.TextXAlignment = Enum.TextXAlignment.Left
	SearchInput.ClearTextOnFocus = false
	SearchInput.ZIndex = 5
	SearchInput.Parent = SearchContainer

	local UserAvatar = Instance.new("ImageLabel")
	UserAvatar.Name = "UserAvatar"
	UserAvatar.Size = UDim2.new(0, 26, 0, 26)
	UserAvatar.Position = UDim2.new(1, -40, 0.5, -13)
	UserAvatar.BackgroundColor3 = Color3.fromRGB(24, 28, 36)
	UserAvatar.BorderSizePixel = 0
	UserAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=48&h=48"
	UserAvatar.ZIndex = 4
	UserAvatar.Parent = Header

	local AvatarCorner = Instance.new("UICorner")
	AvatarCorner.CornerRadius = UDim.new(1, 0)
	AvatarCorner.Parent = UserAvatar

	local AvatarStroke = Instance.new("UIStroke")
	AvatarStroke.Color = Color3.fromRGB(36, 42, 54)
	AvatarStroke.Thickness = 1
	AvatarStroke.Parent = UserAvatar

	-- Nav Container
	local NavContainer = Instance.new("ScrollingFrame")
	NavContainer.Name = "NavContainer"
	NavContainer.Size = UDim2.new(1, -16, 1, -84)
	NavContainer.Position = UDim2.new(0, 8, 0, 68)
	NavContainer.BackgroundTransparency = 1
	NavContainer.BorderSizePixel = 0
	NavContainer.ScrollBarThickness = 2
	NavContainer.ScrollBarImageColor3 = Theme.AccentBlue
	NavContainer.ScrollingDirection = Enum.ScrollingDirection.Y
	NavContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
	NavContainer.CanvasSize = UDim2.new()
	NavContainer.ZIndex = 4
	NavContainer.Parent = SideBar

	local NavLayout = Instance.new("UIListLayout")
	NavLayout.FillDirection = Enum.FillDirection.Vertical
	NavLayout.Padding = UDim.new(0, 3)
	NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
	NavLayout.Parent = NavContainer

	-- Фоновая сетка
	local ContentBg = Instance.new("Frame")
	ContentBg.Size = UDim2.new(1, -self.Layout.SidebarWidth, 1, -48)
	ContentBg.Position = UDim2.new(0, self.Layout.SidebarWidth, 0, 48)
	ContentBg.BackgroundTransparency = 1
	ContentBg.ClipsDescendants = true
	ContentBg.ZIndex = 1
	ContentBg.Parent = MainFrame

	for i = 0, 16 do
		local vLine = Instance.new("Frame")
		vLine.Size = UDim2.new(0, 1, 1, 0)
		vLine.Position = UDim2.new(0, i * 32, 0, 0)
		vLine.BackgroundColor3 = Color3.fromRGB(180, 195, 220)
		vLine.BackgroundTransparency = 0.97
		vLine.BorderSizePixel = 0
		vLine.Parent = ContentBg
	end
	for j = 0, 18 do
		local hLine = Instance.new("Frame")
		hLine.Size = UDim2.new(1, 0, 0, 1)
		hLine.Position = UDim2.new(0, 0, 0, j * 32)
		hLine.BackgroundColor3 = Color3.fromRGB(180, 195, 220)
		hLine.BackgroundTransparency = 0.97
		hLine.BorderSizePixel = 0
		hLine.Parent = ContentBg
	end

	local PagesContainer = Instance.new("Frame")
	PagesContainer.Name = "PagesContainer"
	PagesContainer.Size = UDim2.new(1, -self.Layout.SidebarWidth, 1, -48)
	PagesContainer.Position = UDim2.new(0, self.Layout.SidebarWidth, 0, 48)
	PagesContainer.BackgroundTransparency = 1
	PagesContainer.ClipsDescendants = true
	PagesContainer.ZIndex = 2
	PagesContainer.Parent = MainFrame

	-- Инерционный драг
	self.DragState = {
		Active = false,
		Smooth = false,
		StartInput = nil,
		StartPosition = MainFrame.Position,
		TargetPosition = MainFrame.Position,
	}

	Header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self.DragState.Active = true
			self.DragState.Smooth = true
			self.DragState.StartInput = input.Position
			self.DragState.StartPosition = MainFrame.Position
			self.DragState.TargetPosition = MainFrame.Position
		end
	end)

	self:Connect(UserInputService.InputChanged, function(input)
		if self.DragState.Active and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local scale = MainScale.Scale or 1
			local delta = input.Position - self.DragState.StartInput
			local startPosition = self.DragState.StartPosition
			local targetX = startPosition.X.Offset + delta.X / scale
			local targetY = startPosition.Y.Offset + delta.Y / scale

			local camera = Workspace.CurrentCamera
			if camera then
				local vp = camera.ViewportSize
				local halfW = (self.Layout.WindowWidth * 0.5)
				local halfH = (self.Layout.WindowHeight * 0.5)
				local minX = (-vp.X * 0.5 + 40) / scale + halfW
				local maxX = (vp.X * 0.5 - 40) / scale - halfW
				local minY = (-vp.Y * 0.5 + 20) / scale + halfH
				local maxY = (vp.Y * 0.5 - 40) / scale - halfH
				if minX < maxX then targetX = math.clamp(targetX, minX, maxX) end
				if minY < maxY then targetY = math.clamp(targetY, minY, maxY) end
			end

			self.DragState.TargetPosition = UDim2.new(startPosition.X.Scale, targetX, startPosition.Y.Scale, targetY)
		end
	end)

	self:Connect(RunService.RenderStepped, function(deltaTime)
		if not self.DragState.Smooth then return end
		local target = self.DragState.TargetPosition
		local alpha = 1 - math.exp(-math.clamp(deltaTime, 0, 0.1) * 22)
		MainFrame.Position = MainFrame.Position:Lerp(target, alpha)

		if not self.DragState.Active
			and math.abs(MainFrame.Position.X.Offset - target.X.Offset) < 0.25
			and math.abs(MainFrame.Position.Y.Offset - target.Y.Offset) < 0.25
		then
			MainFrame.Position = target
			self.DragState.Smooth = false
		end
	end)

	self:Connect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self.DragState.Active = false
		end
	end)

	self:Connect(UserInputService.InputBegan, function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == self.ToggleKey or input.KeyCode == self.ToggleKeyAlt then
			self:ToggleMenu()
		end
	end)

	local Window = {
		MainFrame = MainFrame,
		Header = Header,
		Breadcrumb = Breadcrumb,
		NavContainer = NavContainer,
		PagesContainer = PagesContainer,
		SearchInput = SearchInput,
		Tabs = {},
		ActiveTab = nil,
		TabOrder = 0,
	}

	-- 1. Ватермарка (HUD Widget)
	function Window:CreateWatermark(wCfg)
		wCfg = wCfg or {}
		local textPrefix = wCfg.Title or Title
		local textAccent = wCfg.Accented or "UI"

		local HudWidget = Instance.new("Frame")
		HudWidget.Name = "MidnightWatermark"
		HudWidget.Size = UDim2.new(0, 310, 0, 36)
		HudWidget.Position = wCfg.Position or UDim2.new(0.5, 0, 0.82, 0)
		HudWidget.AnchorPoint = Vector2.new(0.5, 0.5)
		HudWidget.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
		HudWidget.BorderSizePixel = 0
		HudWidget.Visible = true
		HudWidget.Active = true
		HudWidget.ZIndex = 50
		HudWidget.Parent = ScreenGui
		MidnightUI.HudWidget = HudWidget

		local hudCorner = Instance.new("UICorner")
		hudCorner.CornerRadius = UDim.new(0, 18)
		hudCorner.Parent = HudWidget

		local hudStroke = Instance.new("UIStroke")
		hudStroke.Color = Color3.fromRGB(40, 43, 50)
		hudStroke.Thickness = 1.2
		hudStroke.Parent = HudWidget

		local hudLabel = Instance.new("TextLabel")
		hudLabel.Size = UDim2.new(1, -48, 1, 0)
		hudLabel.Position = UDim2.new(0, 16, 0, 0)
		hudLabel.BackgroundTransparency = 1
		hudLabel.Font = Theme.FontMedium
		hudLabel.TextSize = 13
		hudLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		hudLabel.TextXAlignment = Enum.TextXAlignment.Left
		hudLabel.RichText = true
		hudLabel.Text = string.format('%s<font color="rgb(107,181,235)">%s</font>   0 ms   60 fps   --:--', textPrefix, textAccent)
		hudLabel.ZIndex = 51
		hudLabel.Parent = HudWidget

		local hudAvatar = Instance.new("ImageLabel")
		hudAvatar.Size = UDim2.new(0, 24, 0, 24)
		hudAvatar.Position = UDim2.new(1, -30, 0.5, -12)
		hudAvatar.BackgroundTransparency = 1
		hudAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=100&h=100"
		hudAvatar.ZIndex = 52
		hudAvatar.Parent = HudWidget

		local hudAvatarCorner = Instance.new("UICorner")
		hudAvatarCorner.CornerRadius = UDim.new(1, 0)
		hudAvatarCorner.Parent = hudAvatar

		local hDrag, hStart, hPos
		MidnightUI:Connect(HudWidget.InputBegan, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				hDrag = true
				hStart = input.Position
				hPos = HudWidget.Position
			end
		end)
		MidnightUI:Connect(UserInputService.InputChanged, function(input)
			if hDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local d = input.Position - hStart
				HudWidget.Position = MidnightUI:ClampGuiPosition(HudWidget, UDim2.new(hPos.X.Scale, hPos.X.Offset + d.X, hPos.Y.Scale, hPos.Y.Offset + d.Y))
			end
		end)
		MidnightUI:Connect(UserInputService.InputEnded, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				hDrag = false
			end
		end)

		local fpsCount = 0
		local fpsTimer = os.clock()
		local liveFps = 60
		local lastUpdate = 0

		MidnightUI:Connect(RunService.RenderStepped, function()
			fpsCount = fpsCount + 1
			local now = os.clock()
			if now - fpsTimer >= 0.5 then
				liveFps = math.clamp(math.round(fpsCount / math.max(0.001, now - fpsTimer)), 1, 999)
				fpsCount = 0
				fpsTimer = now
			end

			if HudWidget.Visible and now - lastUpdate >= 0.25 then
				lastUpdate = now
				local ping = 0
				pcall(function() ping = math.round(LocalPlayer:GetNetworkPing() * 1000) end)
				local lt = DateTime.now():ToLocalTime()
				local clock = string.format("%02d:%02d", lt.Hour, lt.Minute)
				hudLabel.Text = string.format('%s<font color="rgb(107,181,235)">%s</font>   %d ms   %d fps   %s', textPrefix, textAccent, ping, liveFps, clock)
			end
		end)

		return {
			SetVisible = function(v) HudWidget.Visible = v end,
			Widget = HudWidget,
		}
	end

	-- 2. Маскот (Mascot)
	function Window:CreateMascot(mCfg)
		mCfg = mCfg or {}
		local assetId = mCfg.AssetId or "rbxthumb://type=Asset&id=74604987948058&w=420&h=420"

		local MascotImage = Instance.new("ImageLabel")
		MascotImage.Name = "Mascot"
		MascotImage.Size = UDim2.new(0, 129, 0, 215)
		MascotImage.AnchorPoint = Vector2.new(0.5, 1)
		MascotImage.BackgroundTransparency = 1
		MascotImage.Image = assetId
		MascotImage.ScaleType = Enum.ScaleType.Fit
		MascotImage.ZIndex = 1
		MascotImage.Parent = ScreenGui
		MidnightUI.MascotImage = MascotImage

		local MascotClick = Instance.new("TextButton")
		MascotClick.Name = "MascotClick"
		MascotClick.Text = ""
		MascotClick.BackgroundTransparency = 1
		MascotClick.AnchorPoint = Vector2.new(0.5, 1)
		MascotClick.ZIndex = 3
		MascotClick.Parent = ScreenGui

		local HeightScale = Instance.new("NumberValue")
		HeightScale.Value = 1
		HeightScale.Parent = MascotImage

		local animSerial = 0
		local function playAnimation()
			animSerial = animSerial + 1
			local cur = animSerial
			HeightScale.Value = 1
			local squeeze = TweenService:Create(HeightScale, TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Value = 0.58 })
			squeeze:Play()
			task.delay(0.09, function()
				if cur ~= animSerial then return end
				TweenService:Create(HeightScale, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Value = 1 }):Play()
			end)
		end
		MascotClick.Activated:Connect(playAnimation)

		local function updateMascot()
			if not MidnightUI.Alive or not MainFrame then return end
			local scale = (MidnightUI.MainScale and MidnightUI.MainScale.Scale) or 1
			local fPos = MainFrame.AbsolutePosition
			local fSize = MainFrame.AbsoluteSize
			local mH = math.max(80, math.floor(215 * scale))
			local mW = math.floor(mH * 0.6)
			local curH = mH * HeightScale.Value
			local hiddenOffset = math.floor(45 * scale)

			MascotImage.Size = UDim2.fromOffset(mW, curH)
			MascotImage.Position = UDim2.fromOffset(fPos.X + fSize.X - 134 * scale, fPos.Y + hiddenOffset)
			MascotImage.Visible = MainFrame.Visible

			MascotClick.Size = UDim2.fromOffset(mW + 48 * scale, math.max(1, curH - hiddenOffset))
			MascotClick.Position = UDim2.fromOffset(fPos.X + fSize.X - 134 * scale, fPos.Y)
			MascotClick.Visible = MainFrame.Visible
		end

		MidnightUI:Connect(MainFrame:GetPropertyChangedSignal("AbsolutePosition"), updateMascot)
		MidnightUI:Connect(MainFrame:GetPropertyChangedSignal("AbsoluteSize"), updateMascot)
		MidnightUI:Connect(HeightScale.Changed, updateMascot)
		updateMascot()

		return {
			SetVisible = function(v)
				MascotImage.Visible = v
				MascotClick.Visible = v
			end,
			PlayAnimation = playAnimation
		}
	end

	-- Переключение вкладок
	local tabTransitionSerial = 0
	function Window:SwitchTab(tabName)
		local targetTab = self.Tabs[tabName]
		if not targetTab or self.ActiveTab == targetTab then return end

		if MidnightUI.CloseColorPicker then MidnightUI.CloseColorPicker(true) end
		if MidnightUI.CloseSliderPopover then MidnightUI.CloseSliderPopover(true) end
		if MidnightUI.CloseKeybindPopup then MidnightUI.CloseKeybindPopup(false) end
		if MidnightUI.CloseConfigPicker then MidnightUI.CloseConfigPicker(true) end

		tabTransitionSerial = tabTransitionSerial + 1
		local currentSerial = tabTransitionSerial

		self.ActiveTab = targetTab
		Breadcrumb.Text = Title .. " / " .. (targetTab.Label or tabName)

		for name, t in pairs(self.Tabs) do
			local isActive = (t == targetTab)
			local targetBg = isActive and Theme.NavActive or Color3.fromRGB(12, 14, 18)
			local targetText = isActive and Theme.NavTextActive or Theme.NavText
			local targetIcon = isActive and Theme.AccentBlue or Theme.NavText

			TweenService:Create(t.Button, TweenInfo.new(0.18, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { BackgroundColor3 = targetBg }):Play()
			if t.LabelLabel then
				TweenService:Create(t.LabelLabel, TweenInfo.new(0.18, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { TextColor3 = targetText }):Play()
			end
			if t.IconLabel then
				TweenService:Create(t.IconLabel, TweenInfo.new(0.18, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { ImageColor3 = targetIcon }):Play()
			end
			if t.Indicator then
				TweenService:Create(t.Indicator, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					Size = isActive and UDim2.new(0, 3, 0, 16) or UDim2.new(0, 3, 0, 0),
					Position = isActive and UDim2.new(0, 0, 0.5, -8) or UDim2.new(0, 0, 0.5, 0),
				}):Play()
			end

			if isActive then
				t.Page.Visible = true
				t.Page.GroupTransparency = 1
				t.Page.Position = UDim2.new(0, 8, 0, 0)
				TweenService:Create(t.Page, TweenInfo.new(0.22, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
					Position = UDim2.new(0, 0, 0, 0),
					GroupTransparency = 0,
				}):Play()
			elseif t.Page.Visible then
				TweenService:Create(t.Page, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Position = UDim2.new(0, -6, 0, 0),
					GroupTransparency = 1,
				}):Play()
				task.delay(0.15, function()
					if currentSerial == tabTransitionSerial and self.ActiveTab ~= t then
						t.Page.Visible = false
						t.Page.Position = UDim2.new(0, 0, 0, 0)
					end
				end)
			end
		end
	end

	SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
		local q = SearchInput.Text:lower():gsub("[%s_%-]+", "")
		if q == "" then return end
		for tabName, t in pairs(Window.Tabs) do
			if tabName:lower():find(q) or (t.Label and t.Label:lower():find(q)) then
				Window:SwitchTab(tabName)
				return
			end
		end
	end)

	function Window:AddNavSection(title)
		self.TabOrder = self.TabOrder + 1
		local secLabel = Instance.new("TextLabel")
		secLabel.Size = UDim2.new(1, -8, 0, self.TabOrder == 1 and 18 or 26)
		secLabel.BackgroundTransparency = 1
		secLabel.Text = string.upper(title)
		secLabel.Font = Theme.FontBold
		secLabel.TextSize = 10
		secLabel.TextColor3 = Color3.fromRGB(80, 90, 110)
		secLabel.TextXAlignment = Enum.TextXAlignment.Left
		secLabel.TextYAlignment = Enum.TextYAlignment.Bottom
		secLabel.LayoutOrder = self.TabOrder
		secLabel.Parent = NavContainer
		return secLabel
	end

	function Window:CreateTab(name, icon, label)
		self.TabOrder = self.TabOrder + 1
		local tabLabelText = label or name

		local btn = Instance.new("TextButton")
		btn.Name = name .. "Btn"
		btn.Size = UDim2.new(1, 0, 0, 32)
		btn.BackgroundColor3 = Color3.fromRGB(12, 14, 18)
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.LayoutOrder = self.TabOrder
		btn.Parent = NavContainer

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = btn

		local indicator = Instance.new("Frame")
		indicator.Size = UDim2.new(0, 3, 0, 0)
		indicator.Position = UDim2.new(0, 0, 0.5, 0)
		indicator.BackgroundColor3 = Theme.AccentBlue
		indicator.BorderSizePixel = 0
		indicator.Parent = btn

		local indCorner = Instance.new("UICorner")
		indCorner.CornerRadius = UDim.new(1, 0)
		indCorner.Parent = indicator

		local iconLabel = Instance.new("ImageLabel")
		iconLabel.Size = UDim2.new(0, 17, 0, 17)
		iconLabel.Position = UDim2.new(0, 13, 0.5, -8)
		iconLabel.BackgroundTransparency = 1
		iconLabel.Image = icon or ""
		iconLabel.ImageColor3 = Theme.NavText
		iconLabel.Parent = btn

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, -44, 1, 0)
		textLabel.Position = UDim2.new(0, 40, 0, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = tabLabelText
		textLabel.Font = Theme.FontMedium
		textLabel.TextSize = 13
		textLabel.TextColor3 = Theme.NavText
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.Parent = btn

		local page = Instance.new("CanvasGroup")
		page.Size = UDim2.new(1, 0, 1, 0)
		page.Position = UDim2.new(0, 0, 0, 0)
		page.BackgroundTransparency = 1
		page.Visible = false
		page.GroupTransparency = 1
		page.Parent = PagesContainer

		local Tab = {
			Name = name,
			Label = tabLabelText,
			Button = btn,
			Page = page,
			Indicator = indicator,
			IconLabel = iconLabel,
			LabelLabel = textLabel,
		}

		btn.MouseEnter:Connect(function()
			if Window.ActiveTab ~= Tab then
				TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Theme.NavHover }):Play()
				TweenService:Create(textLabel, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(200, 208, 225) }):Play()
				TweenService:Create(iconLabel, TweenInfo.new(0.15), { ImageColor3 = Color3.fromRGB(200, 208, 225) }):Play()
			end
		end)

		btn.MouseLeave:Connect(function()
			if Window.ActiveTab ~= Tab then
				TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(12, 14, 18) }):Play()
				TweenService:Create(textLabel, TweenInfo.new(0.15), { TextColor3 = Theme.NavText }):Play()
				TweenService:Create(iconLabel, TweenInfo.new(0.15), { ImageColor3 = Theme.NavText }):Play()
			end
		end)

		btn.MouseButton1Click:Connect(function()
			Window:SwitchTab(name)
		end)

		function Tab:CreateCard(cardTitle, size, position)
			return MidnightUI:CreateCard(page, cardTitle, size, position)
		end

		Window.Tabs[name] = Tab
		if not Window.ActiveTab then
			Window:SwitchTab(name)
		end

		return Tab
	end

	self:_InitPopups(MainFrame)
	updateMainScale()
	return Window
end

-- ==========================================================
-- МЕНЮ И МОБИЛЬНЫЙ ТОГГЛ
-- ==========================================================
function MidnightUI:ToggleMenu()
	if not self.Alive or not self.MainFrame then return end
	self.IsOpen = not self.IsOpen
	self:CancelPointerDrags()

	if not self.MobileLogoMode then
		if self.FloatingLogo then self.FloatingLogo.Visible = false end
		if self.IsOpen then
			local rest = self.MenuRestPosition
			local folded = UDim2.new(rest.X.Scale, rest.X.Offset, rest.Y.Scale, rest.Y.Offset + 20)
			self.MainScale.Scale = self.GetResponsiveScale()
			self.MainFrame.Visible = true
			self.MainFrame.Position = folded
			self.MainFrame.GroupTransparency = 1
			local tween = TweenService:Create(self.MainFrame, TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				Position = rest,
				GroupTransparency = 0,
			})
			tween:Play()
			self:Connect(tween.Completed, function() self.MainFrame.Position = rest end, true)
		else
			local rest = self.MainFrame.Position
			local folded = UDim2.new(rest.X.Scale, rest.X.Offset, rest.Y.Scale, rest.Y.Offset + 20)
			self.MenuRestPosition = rest
			if self.CloseColorPicker then self.CloseColorPicker(true) end
			if self.CloseSliderPopover then self.CloseSliderPopover(false) end
			if self.CloseKeybindPopup then self.CloseKeybindPopup(false) end
			if self.CloseConfigPicker then self.CloseConfigPicker(true) end
			local tween = TweenService:Create(self.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
				Position = folded,
				GroupTransparency = 1,
			})
			tween:Play()
			self:Connect(tween.Completed, function()
				self.MainFrame.Visible = false
				self.MainFrame.Position = rest
			end, true)
		end
		return
	end

	local fLogo = self.FloatingLogo
	local fScale = self.FloatingLogoScale
	local collapsedScale = math.clamp(math.min(
		fLogo.AbsoluteSize.X / math.max(self.MainFrame.Size.X.Offset, 1),
		fLogo.AbsoluteSize.Y / math.max(self.MainFrame.Size.Y.Offset, 1)
	), 0.025, 0.08)

	if self.IsOpen then
		local rest = self.MenuRestPosition
		local respScale = self.GetResponsiveScale()
		self.MainFrame.Visible = true
		self.MainFrame.Position = fLogo.Position
		self.MainScale.Scale = collapsedScale
		self.MainFrame.GroupTransparency = 1
		TweenService:Create(self.MainFrame, TweenInfo.new(0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = rest, GroupTransparency = 0 }):Play()
		TweenService:Create(self.MainScale, TweenInfo.new(0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Scale = respScale }):Play()
		TweenService:Create(fLogo, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { BackgroundTransparency = 1, ImageTransparency = 1 }):Play()
		task.delay(0.38, function()
			self.MainFrame.Position = rest
			fLogo.Visible = false
		end)
	else
		local rest = self.MainFrame.Position
		self.MenuRestPosition = rest
		local renderedSize = self.SideLogo.AbsoluteSize
		local logoCenter = self.SideLogo.AbsolutePosition + renderedSize * 0.5
		fLogo.Size = UDim2.fromOffset(renderedSize.X, renderedSize.Y)
		fLogo.Position = UDim2.fromOffset(logoCenter.X, logoCenter.Y)
		fLogo.Visible = true
		fLogo.BackgroundTransparency = 1
		fLogo.ImageTransparency = 1
		if fScale then fScale.Scale = 1 end

		if self.CloseColorPicker then self.CloseColorPicker(true) end
		if self.CloseSliderPopover then self.CloseSliderPopover(false) end
		if self.CloseKeybindPopup then self.CloseKeybindPopup(false) end
		if self.CloseConfigPicker then self.CloseConfigPicker(true) end

		TweenService:Create(self.MainFrame, TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Position = fLogo.Position, GroupTransparency = 1 }):Play()
		TweenService:Create(self.MainScale, TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Scale = collapsedScale }):Play()
		TweenService:Create(fLogo, TweenInfo.new(0.26, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundTransparency = 0, ImageTransparency = 0 }):Play()
		task.delay(0.34, function()
			self.MainFrame.Visible = false
			self.MainFrame.Position = rest
		end)
	end
end

-- ==========================================================
-- КАРТОЧКИ И ЭЛЕМЕНТЫ УПРАВЛЕНИЯ
-- ==========================================================
function MidnightUI:CreateCard(parent, title, size, position)
	local card = Instance.new("Frame")
	card.Name = title:gsub("%s+", "") .. "Card"
	if size and size.X.Scale == 0 and size.X.Offset == self.Layout.CardWidth then
		card.Size = UDim2.new(0.5, -26, size.Y.Scale, size.Y.Offset)
		if position and position.X.Scale == 0 and position.X.Offset == self.Layout.RightColumnX then
			card.Position = UDim2.new(0.5, 10, position.Y.Scale, position.Y.Offset)
		else
			card.Position = position or UDim2.new()
		end
	else
		card.Size = size or UDim2.new(0.5, -26, 0, 200)
		card.Position = position or UDim2.new()
	end

	if size and size.Y.Scale == 0 and size.Y.Offset == self.Layout.TallCardHeight then
		card.Size = UDim2.new(card.Size.X.Scale, card.Size.X.Offset, 1, -44)
	end

	card.BackgroundColor3 = Theme.CardBackground
	card.BorderSizePixel = 0
	card.Parent = parent

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 6)
	cardCorner.Parent = card

	local cardStroke = Instance.new("UIStroke")
	cardStroke.Color = Theme.CardStroke
	cardStroke.Thickness = 1
	cardStroke.Parent = card

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -20, 0, 28)
	titleLabel.Position = UDim2.new(0, 10, 0, 6)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.Font = Theme.FontSemiBold
	titleLabel.TextSize = 12
	titleLabel.TextColor3 = Theme.TextPrimary
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = card

	local titleDivider = Instance.new("Frame")
	titleDivider.Name = "Divider"
	titleDivider.Size = UDim2.new(1, -20, 0, 1)
	titleDivider.Position = UDim2.new(0, 10, 0, 36)
	titleDivider.BackgroundColor3 = Theme.CardStroke
	titleDivider.BorderSizePixel = 0
	titleDivider.Parent = card

	local CardWrapper = { Frame = card }

	function CardWrapper:CreateSection(sectionTitle, posY, onToggle)
		return MidnightUI:CreateCardSection(card, sectionTitle, posY, onToggle)
	end
	function CardWrapper:AddToggle(labelText, posY, defaultVal, callback)
		return MidnightUI:CreateToggle(card, labelText, posY, defaultVal, callback)
	end
	function CardWrapper:AddButton(text, posY, callback)
		return MidnightUI:CreateButton(card, text, posY, callback)
	end
	function CardWrapper:AddSlider(labelText, posY, minVal, maxVal, defaultVal, unit, callback, step)
		return MidnightUI:CreateSlider(card, labelText, posY, minVal, maxVal, defaultVal, unit, callback, step)
	end
	function CardWrapper:AddToggleWithSlider(labelText, posY, defaultToggle, minVal, maxVal, defaultSlider, unit, onToggle, onSlider, step)
		return MidnightUI:CreateToggleWithSlider(card, labelText, posY, defaultToggle, minVal, maxVal, defaultSlider, unit, onToggle, onSlider, step)
	end
	function CardWrapper:AddToggleWithColor(labelText, posY, defaultToggle, defaultColor, onToggle, onColor)
		return MidnightUI:CreateToggleWithColor(card, labelText, posY, defaultToggle, defaultColor, onToggle, onColor)
	end
	function CardWrapper:AddToggleWithColorAndSlider(labelText, posY, defaultToggle, defaultColor, minVal, maxVal, defaultSlider, unit, onToggle, onColor, onSlider, step)
		return MidnightUI:CreateToggleWithColorAndSlider(card, labelText, posY, defaultToggle, defaultColor, minVal, maxVal, defaultSlider, unit, onToggle, onColor, onSlider, step)
	end
	function CardWrapper:AddToggleWithKeybind(labelText, posY, defaultVal, defaultKey, onToggle, onBind)
		return MidnightUI:CreateToggleWithKeybind(card, labelText, posY, defaultVal, defaultKey, onToggle, onBind)
	end
	function CardWrapper:AddDropdown(selectorTitle, posY, choices, currentVal, callback)
		return MidnightUI:CreateChoiceSelector(card, selectorTitle, posY, choices, currentVal, callback)
	end

	return CardWrapper
end

function MidnightUI:CreateCardSection(parent, title, posY, onToggle)
	local sectionFrame = Instance.new("Frame")
	sectionFrame.Name = title:gsub("%s+", "") .. "Section"
	sectionFrame.Size = UDim2.new(1, -20, 0, 22)
	sectionFrame.Position = UDim2.new(0, 10, 0, posY)
	sectionFrame.BackgroundTransparency = 1
	sectionFrame.Parent = parent

	local label = Instance.new("TextLabel")
	label.Name = "Title"
	label.Size = UDim2.new(1, -30, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = string.upper(title)
	label.Font = Theme.FontBold
	label.TextSize = 10
	label.TextColor3 = Theme.TextSecondary
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = sectionFrame

	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, -28, 0, 1)
	line.Position = UDim2.new(0, 0, 1, -1)
	line.BackgroundColor3 = Theme.CardStroke
	line.BorderSizePixel = 0
	line.Parent = sectionFrame

	local arrowBtn = Instance.new("TextButton")
	arrowBtn.Size = UDim2.new(0, 20, 0, 20)
	arrowBtn.Position = UDim2.new(1, -20, 0.5, -10)
	arrowBtn.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
	arrowBtn.BorderSizePixel = 0
	arrowBtn.Text = ""
	arrowBtn.AutoButtonColor = false
	arrowBtn.Parent = sectionFrame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 4)
	btnCorner.Parent = arrowBtn

	local arrowIcon = Instance.new("ImageLabel")
	arrowIcon.Size = UDim2.new(0, 12, 0, 12)
	arrowIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
	arrowIcon.BackgroundTransparency = 1
	arrowIcon.Image = self.Icons.Arrow
	arrowIcon.ImageColor3 = Color3.fromRGB(150, 160, 180)
	arrowIcon.Parent = arrowBtn

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 0)
	container.Position = UDim2.new(0, 0, 0, posY + 26)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	container.Visible = false
	container.Parent = parent

	local isExpanded = false
	local function setExpanded(expanded, animated)
		isExpanded = expanded == true
		local targetRot = isExpanded and 90 or 0
		local targetColor = isExpanded and Theme.AccentWhite or Color3.fromRGB(150, 160, 180)
		local targetBg = isExpanded and Color3.fromRGB(28, 34, 48) or Color3.fromRGB(18, 22, 30)
		if animated then
			TweenService:Create(arrowIcon, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Rotation = targetRot, ImageColor3 = targetColor }):Play()
			TweenService:Create(arrowBtn, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundColor3 = targetBg }):Play()
			TweenService:Create(label, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { TextColor3 = isExpanded and Theme.TextPrimary or Theme.TextSecondary }):Play()
		else
			arrowIcon.Rotation = targetRot
			arrowIcon.ImageColor3 = targetColor
			arrowBtn.BackgroundColor3 = targetBg
			label.TextColor3 = isExpanded and Theme.TextPrimary or Theme.TextSecondary
		end
		if onToggle then onToggle(isExpanded, animated) end
	end

	arrowBtn.MouseButton1Click:Connect(function() setExpanded(not isExpanded, true) end)

	return {
		Frame = sectionFrame,
		Container = container,
		SetExpanded = setExpanded,
		IsExpanded = function() return isExpanded end,
		Arrow = arrowIcon,
		Button = arrowBtn,
	}
end

function MidnightUI:CreateButton(parent, text, posY, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 28)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(20, 24, 32)
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.Font = Theme.FontMedium
	btn.TextSize = 13
	btn.TextColor3 = Theme.TextPrimary
	btn.AutoButtonColor = false
	btn.Parent = parent

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn

	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = Theme.CardStroke
	btnStroke.Thickness = 1
	btnStroke.Parent = btn

	local btnScale = Instance.new("UIScale")
	btnScale.Scale = 1
	btnScale.Parent = btn

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(26, 32, 42), TextColor3 = Theme.AccentBlue }):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(20, 24, 32), TextColor3 = Theme.TextPrimary }):Play()
		TweenService:Create(btnScale, TweenInfo.new(0.12, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), { Scale = 1 }):Play()
	end)
	btn.MouseButton1Down:Connect(function()
		TweenService:Create(btnScale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 0.96 }):Play()
	end)
	btn.MouseButton1Up:Connect(function()
		TweenService:Create(btnScale, TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
	end)
	btn.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)

	return btn
end

function MidnightUI:CreateToggle(parent, labelText, posY, defaultVal, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -20, 0, 24)
	row.Position = UDim2.new(0, 10, 0, posY)
	row.BackgroundTransparency = 1
	row.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -44, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.Font = Theme.FontMedium
	label.TextSize = 13
	label.TextColor3 = Theme.TextPrimary
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Size = UDim2.new(0, 36, 0, 18)
	toggleBtn.Position = UDim2.new(1, -36, 0.5, -9)
	toggleBtn.BackgroundColor3 = defaultVal and Theme.AccentBlue or Theme.ToggleOff
	toggleBtn.BorderSizePixel = 0
	toggleBtn.Text = ""
	toggleBtn.AutoButtonColor = false
	toggleBtn.Parent = row

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggleBtn

	local toggleStroke = Instance.new("UIStroke")
	toggleStroke.Color = Theme.CardStroke
	toggleStroke.Thickness = 1
	toggleStroke.Parent = toggleBtn

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 12, 0, 12)
	knob.Position = defaultVal and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
	knob.BackgroundColor3 = defaultVal and Theme.AccentDark or Theme.ToggleKnob
	knob.BorderSizePixel = 0
	knob.Parent = toggleBtn

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local isToggled = defaultVal == true
	local function renderToggle(animated)
		local targetBg = isToggled and Theme.AccentBlue or Theme.ToggleOff
		local targetKnob = isToggled and Theme.AccentDark or Theme.ToggleKnob
		local targetPos = isToggled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
		if animated then
			TweenService:Create(toggleBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = targetBg }):Play()
			TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = targetPos, BackgroundColor3 = targetKnob }):Play()
		else
			toggleBtn.BackgroundColor3 = targetBg
			knob.Position = targetPos
			knob.BackgroundColor3 = targetKnob
		end
	end

	local setValue = Instance.new("BindableEvent")
	setValue.Name = "SetValue"
	setValue.Parent = row
	setValue.Event:Connect(function(value, invokeCallback)
		isToggled = value == true
		renderToggle(invokeCallback == true)
		if invokeCallback and callback then callback(isToggled) end
	end)

	toggleBtn.MouseButton1Click:Connect(function()
		setValue:Fire(not isToggled, true)
	end)

	return row
end

function MidnightUI:CreateToggleWithKeybind(parent, labelText, posY, defaultVal, defaultKey, onToggle, onBind)
	local row = self:CreateToggle(parent, labelText, posY, defaultVal, onToggle)
	local label = row:FindFirstChild("Label")
	local toggle = row:FindFirstChild("Toggle")
	if label then label.Size = UDim2.new(1, -72, 1, 0) end
	if toggle then toggle.Position = UDim2.new(1, -36, 0.5, -9) end

	local currentKey = tostring(defaultKey or "C")
	local bindButton = Instance.new("TextButton")
	bindButton.Size = UDim2.new(0, 22, 0, 22)
	bindButton.Position = UDim2.new(1, -64, 0.5, -11)
	bindButton.BackgroundTransparency = 1
	bindButton.Text = ""
	bindButton.AutoButtonColor = false
	bindButton.Parent = row

	local keyboardIcon = Instance.new("ImageLabel")
	keyboardIcon.Size = UDim2.new(0, 17, 0, 17)
	keyboardIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
	keyboardIcon.BackgroundTransparency = 1
	keyboardIcon.Image = self.Icons.Keyboard
	keyboardIcon.ImageColor3 = Theme.TextSecondary
	keyboardIcon.ScaleType = Enum.ScaleType.Fit
	keyboardIcon.Parent = bindButton

	bindButton.MouseEnter:Connect(function()
		TweenService:Create(keyboardIcon, TweenInfo.new(0.12), { ImageColor3 = Theme.AccentBlue }):Play()
	end)
	bindButton.MouseLeave:Connect(function()
		TweenService:Create(keyboardIcon, TweenInfo.new(0.12), { ImageColor3 = Theme.TextSecondary }):Play()
	end)

	local setBind = Instance.new("BindableEvent")
	setBind.Name = "SetBind"
	setBind.Parent = row
	setBind.Event:Connect(function(keyName, invokeCallback)
		local proposed = tostring(keyName or "")
		if Enum.KeyCode[proposed] and Enum.KeyCode[proposed] ~= Enum.KeyCode.Unknown then
			currentKey = proposed
			if invokeCallback and onBind then onBind(currentKey) end
		end
	end)

	bindButton.MouseButton1Click:Connect(function()
		self:OpenKeybindPopup(currentKey, function(newKey)
			setBind:Fire(newKey, true)
		end)
	end)

	return row
end

function MidnightUI:CreateToggleWithColor(parent, labelText, posY, defaultVal, defaultColor, onToggleCallback, onColorCallback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -20, 0, 24)
	row.Position = UDim2.new(0, 10, 0, posY)
	row.BackgroundTransparency = 1
	row.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -66, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.Font = Theme.FontMedium
	label.TextSize = 13
	label.TextColor3 = Theme.TextPrimary
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row

	local colorBox = Instance.new("TextButton")
	colorBox.Size = UDim2.new(0, 18, 0, 18)
	colorBox.Position = UDim2.new(1, -60, 0.5, -9)
	colorBox.BackgroundColor3 = defaultColor or Color3.fromRGB(255, 55, 55)
	colorBox.BorderSizePixel = 0
	colorBox.Text = ""
	colorBox.AutoButtonColor = false
	colorBox.Parent = row

	local colorCorner = Instance.new("UICorner")
	colorCorner.CornerRadius = UDim.new(0, 4)
	colorCorner.Parent = colorBox

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Size = UDim2.new(0, 36, 0, 18)
	toggleBtn.Position = UDim2.new(1, -36, 0.5, -9)
	toggleBtn.BackgroundColor3 = defaultVal and Theme.AccentBlue or Theme.ToggleOff
	toggleBtn.BorderSizePixel = 0
	toggleBtn.Text = ""
	toggleBtn.AutoButtonColor = false
	toggleBtn.Parent = row

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggleBtn

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 12, 0, 12)
	knob.Position = defaultVal and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
	knob.BackgroundColor3 = Theme.ToggleKnob
	knob.BorderSizePixel = 0
	knob.Parent = toggleBtn

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local isToggled = defaultVal == true
	local function renderToggle(animated)
		local targetBg = isToggled and Theme.AccentBlue or Theme.ToggleOff
		local targetPos = isToggled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
		if animated then
			TweenService:Create(toggleBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = targetBg }):Play()
			TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = targetPos }):Play()
		else
			toggleBtn.BackgroundColor3 = targetBg
			knob.Position = targetPos
		end
	end

	local setValue = Instance.new("BindableEvent")
	setValue.Name = "SetValue"
	setValue.Parent = row
	setValue.Event:Connect(function(value, invokeCallback)
		isToggled = value == true
		renderToggle(invokeCallback == true)
		if invokeCallback and onToggleCallback then onToggleCallback(isToggled) end
	end)

	local setColor = Instance.new("BindableEvent")
	setColor.Name = "SetColor"
	setColor.Parent = row
	setColor.Event:Connect(function(value, invokeCallback)
		if typeof(value) ~= "Color3" then return end
		colorBox.BackgroundColor3 = value
		if invokeCallback and onColorCallback then onColorCallback(value) end
	end)

	toggleBtn.MouseButton1Click:Connect(function() setValue:Fire(not isToggled, true) end)
	colorBox.MouseButton1Click:Connect(function()
		self:OpenColorPicker(colorBox.BackgroundColor3, function(newColor)
			setColor:Fire(newColor, true)
		end)
	end)

	return row
end

function MidnightUI:CreateSlider(parent, labelText, posY, minVal, maxVal, defaultVal, unit, callback, step)
	step = step or 1
	unit = unit or ""
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -20, 0, 24)
	row.Position = UDim2.new(0, 10, 0, posY)
	row.BackgroundTransparency = 1
	row.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -30, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.Font = Theme.FontMedium
	label.TextSize = 13
	label.TextColor3 = Theme.TextPrimary
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row

	local currentVal = defaultVal

	local sliderBtn = Instance.new("TextButton")
	sliderBtn.Size = UDim2.new(0, 20, 0, 20)
	sliderBtn.Position = UDim2.new(1, -22, 0.5, -10)
	sliderBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
	sliderBtn.BorderSizePixel = 0
	sliderBtn.Text = ""
	sliderBtn.Parent = row

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 4)
	btnCorner.Parent = sliderBtn

	local btnIcon = Instance.new("ImageLabel")
	btnIcon.Size = UDim2.new(0, 12, 0, 12)
	btnIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
	btnIcon.BackgroundTransparency = 1
	btnIcon.Image = self.Icons.Sliders
	btnIcon.ImageColor3 = Color3.fromRGB(150, 160, 180)
	btnIcon.Parent = sliderBtn

	local function applyVal(val, invokeCallback)
		local num = tonumber(val)
		if not num then return end
		local final = math.clamp(minVal + math.round((num - minVal) / step) * step, minVal, maxVal)
		final = math.round(final * 1000) / 1000
		currentVal = final
		if invokeCallback and callback then callback(final) end
	end

	sliderBtn.MouseButton1Click:Connect(function()
		self:OpenSliderPopover(sliderBtn, minVal, maxVal, currentVal, unit, function(newVal)
			applyVal(newVal, true)
		end, step)
	end)

	local setValue = Instance.new("BindableEvent")
	setValue.Name = "SetValue"
	setValue.Parent = row
	setValue.Event:Connect(applyVal)

	return row
end

function MidnightUI:CreateToggleWithSlider(parent, labelText, posY, defaultToggle, minVal, maxVal, defaultSlider, unit, onToggleCallback, onSliderCallback, step)
	step = step or 1
	unit = unit or ""
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -20, 0, 24)
	row.Position = UDim2.new(0, 10, 0, posY)
	row.BackgroundTransparency = 1
	row.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -68, 1, 0)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.Font = Theme.FontMedium
	label.TextSize = 13
	label.TextColor3 = Theme.TextPrimary
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row

	local currentSliderVal = defaultSlider
	local isToggled = defaultToggle == true

	local sliderBtn = Instance.new("TextButton")
	sliderBtn.Size = UDim2.new(0, 20, 0, 20)
	sliderBtn.Position = UDim2.new(1, -62, 0.5, -10)
	sliderBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
	sliderBtn.BorderSizePixel = 0
	sliderBtn.Text = ""
	sliderBtn.Parent = row

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 4)
	btnCorner.Parent = sliderBtn

	local btnIcon = Instance.new("ImageLabel")
	btnIcon.Size = UDim2.new(0, 12, 0, 12)
	btnIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
	btnIcon.BackgroundTransparency = 1
	btnIcon.Image = self.Icons.Sliders
	btnIcon.ImageColor3 = Color3.fromRGB(150, 160, 180)
	btnIcon.Parent = sliderBtn

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Size = UDim2.new(0, 36, 0, 18)
	toggleBtn.Position = UDim2.new(1, -36, 0.5, -9)
	toggleBtn.BackgroundColor3 = defaultToggle and Theme.AccentBlue or Theme.ToggleOff
	toggleBtn.BorderSizePixel = 0
	toggleBtn.Text = ""
	toggleBtn.Parent = row

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggleBtn

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 12, 0, 12)
	knob.Position = defaultToggle and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
	knob.BackgroundColor3 = defaultToggle and Theme.AccentDark or Theme.ToggleKnob
	knob.BorderSizePixel = 0
	knob.Parent = toggleBtn

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local function renderToggle(animated)
		local targetBg = isToggled and Theme.AccentBlue or Theme.ToggleOff
		local targetKnob = isToggled and Theme.AccentDark or Theme.ToggleKnob
		local targetPos = isToggled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
		if animated then
			TweenService:Create(toggleBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = targetBg }):Play()
			TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = targetPos, BackgroundColor3 = targetKnob }):Play()
		else
			toggleBtn.BackgroundColor3 = targetBg
			knob.Position = targetPos
			knob.BackgroundColor3 = targetKnob
		end
	end

	local function applySliderVal(val, invokeCallback)
		local num = tonumber(val)
		if not num then return end
		local final = math.clamp(minVal + math.round((num - minVal) / step) * step, minVal, maxVal)
		final = math.round(final * 1000) / 1000
		currentSliderVal = final
		if invokeCallback and onSliderCallback then onSliderCallback(final) end
	end

	sliderBtn.MouseButton1Click:Connect(function()
		self:OpenSliderPopover(sliderBtn, minVal, maxVal, currentSliderVal, unit, function(newVal)
			applySliderVal(newVal, true)
		end, step)
	end)

	local setValue = Instance.new("BindableEvent")
	setValue.Name = "SetValue"
	setValue.Parent = row
	setValue.Event:Connect(function(value, invokeCallback)
		isToggled = value == true
		renderToggle(invokeCallback == true)
		if invokeCallback and onToggleCallback then onToggleCallback(isToggled) end
	end)

	toggleBtn.MouseButton1Click:Connect(function() setValue:Fire(not isToggled, true) end)
	return row
end

function MidnightUI:CreateToggleWithColorAndSlider(parent, labelText, posY, defaultToggle, defaultColor, minVal, maxVal, defaultSlider, unit, onToggleCallback, onColorCallback, onSliderCallback, step)
	step = step or 1
	unit = unit or ""
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -20, 0, 24)
	row.Position = UDim2.new(0, 10, 0, posY)
	row.BackgroundTransparency = 1
	row.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -94, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.Font = Theme.FontMedium
	label.TextSize = 13
	label.TextColor3 = Theme.TextPrimary
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row

	local currentSliderVal = defaultSlider
	local isToggled = defaultToggle == true

	local sliderBtn = Instance.new("TextButton")
	sliderBtn.Size = UDim2.new(0, 20, 0, 20)
	sliderBtn.Position = UDim2.new(1, -88, 0.5, -10)
	sliderBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
	sliderBtn.BorderSizePixel = 0
	sliderBtn.Text = ""
	sliderBtn.Parent = row

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 4)
	btnCorner.Parent = sliderBtn

	local btnIcon = Instance.new("ImageLabel")
	btnIcon.Size = UDim2.new(0, 12, 0, 12)
	btnIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
	btnIcon.BackgroundTransparency = 1
	btnIcon.Image = self.Icons.Sliders
	btnIcon.ImageColor3 = Color3.fromRGB(150, 160, 180)
	btnIcon.Parent = sliderBtn

	local colorBox = Instance.new("TextButton")
	colorBox.Size = UDim2.new(0, 18, 0, 18)
	colorBox.Position = UDim2.new(1, -62, 0.5, -9)
	colorBox.BackgroundColor3 = defaultColor or Color3.fromRGB(0, 245, 255)
	colorBox.BorderSizePixel = 0
	colorBox.Text = ""
	colorBox.Parent = row

	local colorCorner = Instance.new("UICorner")
	colorCorner.CornerRadius = UDim.new(0, 4)
	colorCorner.Parent = colorBox

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Size = UDim2.new(0, 36, 0, 18)
	toggleBtn.Position = UDim2.new(1, -36, 0.5, -9)
	toggleBtn.BackgroundColor3 = defaultToggle and Theme.AccentBlue or Theme.ToggleOff
	toggleBtn.BorderSizePixel = 0
	toggleBtn.Text = ""
	toggleBtn.Parent = row

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggleBtn

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 12, 0, 12)
	knob.Position = defaultToggle and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
	knob.BackgroundColor3 = defaultToggle and Theme.AccentDark or Theme.ToggleKnob
	knob.BorderSizePixel = 0
	knob.Parent = toggleBtn

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local function renderToggle(animated)
		local targetBg = isToggled and Theme.AccentBlue or Theme.ToggleOff
		local targetKnob = isToggled and Theme.AccentDark or Theme.ToggleKnob
		local targetPos = isToggled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
		if animated then
			TweenService:Create(toggleBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = targetBg }):Play()
			TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = targetPos, BackgroundColor3 = targetKnob }):Play()
		else
			toggleBtn.BackgroundColor3 = targetBg
			knob.Position = targetPos
			knob.BackgroundColor3 = targetKnob
		end
	end

	local function applySliderVal(val, invokeCallback)
		local num = tonumber(val)
		if not num then return end
		local final = math.clamp(minVal + math.round((num - minVal) / step) * step, minVal, maxVal)
		final = math.round(final * 1000) / 1000
		currentSliderVal = final
		if invokeCallback and onSliderCallback then onSliderCallback(final) end
	end

	sliderBtn.MouseButton1Click:Connect(function()
		self:OpenSliderPopover(sliderBtn, minVal, maxVal, currentSliderVal, unit, function(newVal)
			applySliderVal(newVal, true)
		end, step)
	end)

	colorBox.MouseButton1Click:Connect(function()
		self:OpenColorPicker(colorBox.BackgroundColor3, function(newColor)
			colorBox.BackgroundColor3 = newColor
			if onColorCallback then onColorCallback(newColor) end
		end)
	end)

	local setValue = Instance.new("BindableEvent")
	setValue.Name = "SetValue"
	setValue.Parent = row
	setValue.Event:Connect(function(value, invokeCallback)
		isToggled = value == true
		renderToggle(invokeCallback == true)
		if invokeCallback and onToggleCallback then onToggleCallback(isToggled) end
	end)

	toggleBtn.MouseButton1Click:Connect(function() setValue:Fire(not isToggled, true) end)
	return row
end

function MidnightUI:CreateChoiceSelector(parent, title, posY, choices, currentVal, callback)
	local row = Instance.new("TextButton")
	row.Size = UDim2.new(1, -20, 0, 28)
	row.Position = UDim2.new(0, 10, 0, posY)
	row.BackgroundColor3 = Theme.ToggleOff
	row.BorderSizePixel = 0
	row.AutoButtonColor = false
	row.Text = ""
	row.ZIndex = 10
	row.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = row

	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.CardStroke
	stroke.Thickness = 1
	stroke.Parent = row

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(0.5, -10, 1, 0)
	titleLabel.Position = UDim2.new(0, 10, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.Font = Theme.FontMedium
	titleLabel.TextSize = 12
	titleLabel.TextColor3 = Theme.TextPrimary
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 11
	titleLabel.Parent = row

	local valLabel = Instance.new("TextLabel")
	valLabel.Size = UDim2.new(0.5, -34, 1, 0)
	valLabel.Position = UDim2.new(0.5, 0, 0, 0)
	valLabel.BackgroundTransparency = 1
	valLabel.Text = tostring(currentVal or (choices and choices[1]) or "")
	valLabel.Font = Theme.FontSemiBold
	valLabel.TextSize = 12
	valLabel.TextColor3 = Theme.TextSecondary
	valLabel.TextXAlignment = Enum.TextXAlignment.Right
	valLabel.ZIndex = 11
	valLabel.Parent = row

	local arrowIcon = Instance.new("ImageLabel")
	arrowIcon.Size = UDim2.new(0, 12, 0, 12)
	arrowIcon.Position = UDim2.new(1, -20, 0.5, -6)
	arrowIcon.BackgroundTransparency = 1
	arrowIcon.Image = self.Icons.Arrow
	arrowIcon.ImageColor3 = Color3.fromRGB(150, 160, 180)
	arrowIcon.ZIndex = 11
	arrowIcon.Parent = row

	local isDropOpen = false
	local selected = 1
	local maxVisible = 5
	local itemH = 26
	local listH = 0

	local dropdownList = Instance.new("Frame")
	dropdownList.Size = UDim2.new(1, -20, 0, 0)
	dropdownList.Position = UDim2.new(0, 10, 0, posY + 31)
	dropdownList.BackgroundColor3 = Color3.fromRGB(14, 17, 23)
	dropdownList.BorderSizePixel = 0
	dropdownList.ClipsDescendants = true
	dropdownList.Visible = false
	dropdownList.ZIndex = 50
	dropdownList.Parent = parent

	local dropCorner = Instance.new("UICorner")
	dropCorner.CornerRadius = UDim.new(0, 6)
	dropCorner.Parent = dropdownList

	local choiceButtons = {}

	local function closeThisDropdown(animated)
		if not isDropOpen then return end
		isDropOpen = false
		if self.ActiveCloseDropdown == closeThisDropdown then self.ActiveCloseDropdown = nil end
		local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		if animated then
			TweenService:Create(arrowIcon, tweenInfo, { Rotation = 0, ImageColor3 = Color3.fromRGB(150, 160, 180) }):Play()
			TweenService:Create(row, tweenInfo, { BackgroundColor3 = Theme.ToggleOff }):Play()
			TweenService:Create(dropdownList, tweenInfo, { Size = UDim2.new(1, -20, 0, 0) }):Play()
			task.delay(0.18, function() if not isDropOpen then dropdownList.Visible = false end end)
		else
			arrowIcon.Rotation = 0
			dropdownList.Size = UDim2.new(1, -20, 0, 0)
			dropdownList.Visible = false
		end
	end

	local function openThisDropdown()
		if isDropOpen then return end
		if self.ActiveCloseDropdown then pcall(self.ActiveCloseDropdown) end
		isDropOpen = true
		self.ActiveCloseDropdown = closeThisDropdown
		dropdownList.Visible = true
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		TweenService:Create(arrowIcon, tweenInfo, { Rotation = 180, ImageColor3 = Theme.AccentWhite }):Play()
		TweenService:Create(row, tweenInfo, { BackgroundColor3 = Color3.fromRGB(28, 34, 48) }):Play()
		TweenService:Create(dropdownList, tweenInfo, { Size = UDim2.new(1, -20, 0, listH) }):Play()
	end

	local function apply(idx, invoke)
		if not choices or #choices == 0 then return end
		selected = math.clamp(idx, 1, #choices)
		local currentChoice = choices[selected]
		valLabel.Text = tostring(currentChoice or "")
		for i, btn in ipairs(choiceButtons) do
			local isSel = (i == selected)
			btn.TextColor3 = isSel and Theme.AccentBlue or Theme.TextPrimary
			local dot = btn:FindFirstChild("Dot")
			if dot then dot.Visible = isSel end
		end
		if invoke and callback and currentChoice ~= nil then callback(currentChoice) end
	end

	local function rebuildList(newChoices, defaultSelection)
		if type(newChoices) == "table" then
			choices = {}
			for _, v in ipairs(newChoices) do table.insert(choices, v) end
		end
		listH = math.min(#choices * itemH + 4, maxVisible * itemH + 4)
		if #choices == 0 then listH = 0 end
		for _, child in ipairs(dropdownList:GetChildren()) do
			if child:IsA("ScrollingFrame") or child:IsA("TextButton") or (child:IsA("Frame") and child.Name == "Divider") then
				child:Destroy()
			end
		end

		local container = dropdownList
		if #choices > maxVisible then
			local scroll = Instance.new("ScrollingFrame")
			scroll.Size = UDim2.new(1, 0, 1, 0)
			scroll.BackgroundTransparency = 1
			scroll.BorderSizePixel = 0
			scroll.ScrollBarThickness = 2
			scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 95, 125)
			scroll.CanvasSize = UDim2.new(0, 0, 0, #choices * itemH + 4)
			scroll.ZIndex = 51
			scroll.Parent = dropdownList
			container = scroll
		end

		table.clear(choiceButtons)
		for i, ch in ipairs(choices) do
			local optBtn = Instance.new("TextButton")
			optBtn.Size = UDim2.new(1, 0, 0, itemH)
			optBtn.Position = UDim2.new(0, 0, 0, (i - 1) * itemH + 2)
			optBtn.BackgroundTransparency = 1
			optBtn.Text = ""
			optBtn.AutoButtonColor = false
			optBtn.ZIndex = 52
			optBtn.Parent = container

			local optLabel = Instance.new("TextLabel")
			optLabel.Size = UDim2.new(1, -28, 1, 0)
			optLabel.Position = UDim2.new(0, 24, 0, 0)
			optLabel.BackgroundTransparency = 1
			optLabel.Text = tostring(ch)
			optLabel.Font = Theme.FontMedium
			optLabel.TextSize = 11
			optLabel.TextColor3 = (i == selected) and Theme.AccentBlue or Theme.TextPrimary
			optLabel.TextXAlignment = Enum.TextXAlignment.Left
			optLabel.ZIndex = 53
			optLabel.Parent = optBtn

			local dot = Instance.new("Frame")
			dot.Name = "Dot"
			dot.Size = UDim2.new(0, 6, 0, 6)
			dot.Position = UDim2.new(0, 10, 0.5, -3)
			dot.BackgroundColor3 = Theme.AccentBlue
			dot.BorderSizePixel = 0
			dot.Visible = (i == selected)
			dot.ZIndex = 53
			dot.Parent = optBtn

			local dotCorner = Instance.new("UICorner")
			dotCorner.CornerRadius = UDim.new(1, 0)
			dotCorner.Parent = dot

			optBtn.MouseButton1Click:Connect(function()
				apply(i, true)
				closeThisDropdown(true)
			end)
			choiceButtons[i] = optBtn

			if i < #choices then
				local div = Instance.new("Frame")
				div.Name = "Divider"
				div.Size = UDim2.new(1, -20, 0, 1)
				div.Position = UDim2.new(0, 10, 0, i * itemH + 2)
				div.BackgroundColor3 = Theme.CardStroke
				div.BorderSizePixel = 0
				div.ZIndex = 52
				div.Parent = container
			end
		end

		if isDropOpen then dropdownList.Size = UDim2.new(1, -20, 0, listH) end
		local targetSel = 1
		if defaultSelection ~= nil then
			for i, ch in ipairs(choices) do
				if tostring(defaultSelection):lower() == tostring(ch):lower() then targetSel = i; break end
			end
		end
		if #choices > 0 then apply(targetSel, false) else valLabel.Text = "" end
	end

	row.MouseButton1Click:Connect(function()
		if isDropOpen then closeThisDropdown(true) else openThisDropdown() end
	end)

	local setValue = Instance.new("BindableEvent")
	setValue.Name = "SetValue"
	setValue.Parent = row
	setValue.Event:Connect(function(val, invoke)
		for i, ch in ipairs(choices) do
			if tostring(val):lower() == tostring(ch):lower() then apply(i, invoke == true); return end
		end
		if type(val) == "number" then apply(val, invoke == true) end
	end)

	local setChoices = Instance.new("BindableEvent")
	setChoices.Name = "SetChoices"
	setChoices.Parent = row
	setChoices.Event:Connect(function(newChoices, defaultSelection)
		rebuildList(newChoices, defaultSelection)
	end)

	rebuildList(choices, currentVal)
	return row
end

-- ==========================================================
-- МОДАЛКИ: COLOR PICKER, SLIDER POPOVER, CONFIG MANAGER
-- ==========================================================
function MidnightUI:_InitPopups(MainFrame)
	-- Slider Popover
	local SliderPopover = Instance.new("CanvasGroup")
	SliderPopover.Size = UDim2.new(0, 168, 0, 26)
	SliderPopover.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
	SliderPopover.BorderSizePixel = 0
	SliderPopover.Visible = false
	SliderPopover.ZIndex = 85
	SliderPopover.Parent = MainFrame

	local pCorn = Instance.new("UICorner")
	pCorn.CornerRadius = UDim.new(0, 6)
	pCorn.Parent = SliderPopover

	local pTrack = Instance.new("Frame")
	pTrack.Size = UDim2.new(1, -50, 0, 4)
	pTrack.Position = UDim2.new(0, 8, 0.5, -2)
	pTrack.BackgroundColor3 = Color3.fromRGB(28, 34, 46)
	pTrack.BorderSizePixel = 0
	pTrack.Parent = SliderPopover

	local pFill = Instance.new("Frame")
	pFill.Size = UDim2.new(0.5, 0, 1, 0)
	pFill.BackgroundColor3 = Theme.AccentWhite
	pFill.BorderSizePixel = 0
	pFill.Parent = pTrack

	local pThumb = Instance.new("Frame")
	pThumb.Size = UDim2.new(0, 12, 0, 12)
	pThumb.Position = UDim2.new(0.5, -6, 0.5, -6)
	pThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	pThumb.BorderSizePixel = 0
	pThumb.Parent = pTrack
	local thCorn = Instance.new("UICorner")
	thCorn.CornerRadius = UDim.new(1, 0)
	thCorn.Parent = pThumb

	local pVal = Instance.new("TextLabel")
	pVal.Size = UDim2.new(0, 38, 1, 0)
	pVal.Position = UDim2.new(1, -40, 0, 0)
	pVal.BackgroundTransparency = 1
	pVal.Font = Theme.FontMedium
	pVal.TextSize = 11
	pVal.TextColor3 = Theme.TextPrimary
	pVal.Parent = SliderPopover

	local curSession = nil
	local function closeSliderPopover(animated)
		if not curSession then return end
		curSession = nil
		if animated then
			TweenService:Create(SliderPopover, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { GroupTransparency = 1 }):Play()
			task.delay(0.13, function() if not curSession then SliderPopover.Visible = false end end)
		else
			SliderPopover.Visible = false
			SliderPopover.GroupTransparency = 1
		end
	end
	self.CloseSliderPopover = closeSliderPopover

	self.OpenSliderPopover = function(_, btn, minVal, maxVal, curVal, unit, cb, step)
		if curSession and curSession.Button == btn then
			closeSliderPopover(true)
			return
		end
		curSession = { Button = btn, Min = minVal, Max = maxVal, Unit = unit or "", Step = step or 1, Callback = cb }
		local pct = math.clamp((curVal - minVal) / (maxVal - minVal), 0, 1)
		pFill.Size = UDim2.new(pct, 0, 1, 0)
		pThumb.Position = UDim2.new(pct, -6, 0.5, -6)
		pVal.Text = tostring(curVal) .. curSession.Unit

		local bPos = btn.AbsolutePosition - MainFrame.AbsolutePosition
		SliderPopover.Position = UDim2.new(0, math.clamp(bPos.X + 26, 6, MainFrame.AbsoluteSize.X - 174), 0, math.clamp(bPos.Y - 2, 6, MainFrame.AbsoluteSize.Y - 32))
		SliderPopover.Visible = true
		SliderPopover.GroupTransparency = 0
	end

	local sDrag = false
	SliderPopover.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sDrag = true
			local rel = math.clamp((input.Position.X - pTrack.AbsolutePosition.X) / pTrack.AbsoluteSize.X, 0, 1)
			local raw = curSession.Min + (curSession.Max - curSession.Min) * rel
			local final = math.clamp(curSession.Min + math.round((raw - curSession.Min) / curSession.Step) * curSession.Step, curSession.Min, curSession.Max)
			final = math.round(final * 1000) / 1000
			pFill.Size = UDim2.new(rel, 0, 1, 0)
			pThumb.Position = UDim2.new(rel, -6, 0.5, -6)
			pVal.Text = tostring(final) .. curSession.Unit
			if curSession.Callback then curSession.Callback(final) end
		end
	end)
	self:Connect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sDrag = false
		end
	end)

	-- HSV Color Picker
	local activeColorPicker = nil
	local function closeColorPicker(animated)
		if not activeColorPicker then return end
		local p = activeColorPicker
		activeColorPicker = nil
		if animated then
			TweenService:Create(p, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { GroupTransparency = 1 }):Play()
			task.delay(0.15, function() p:Destroy() end)
		else
			p:Destroy()
		end
	end
	self.CloseColorPicker = closeColorPicker

	self.OpenColorPicker = function(_, initCol, onCol)
		closeColorPicker(false)
		local curH, curS, curV = (initCol or Color3.new(1, 1, 1)):ToHSV()

		local picker = Instance.new("CanvasGroup")
		picker.Size = UDim2.new(0, 230, 0, 230)
		picker.Position = UDim2.new(0.5, -115, 0.5, -115)
		picker.BackgroundColor3 = Color3.fromRGB(16, 20, 27)
		picker.BorderSizePixel = 0
		picker.ZIndex = 60
		picker.Parent = MainFrame
		activeColorPicker = picker

		local pCorn = Instance.new("UICorner")
		pCorn.CornerRadius = UDim.new(0, 8)
		pCorn.Parent = picker

		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, -40, 0, 28)
		title.Position = UDim2.new(0, 12, 0, 0)
		title.BackgroundTransparency = 1
		title.Text = "Color Spectrum"
		title.Font = Theme.FontSemiBold
		title.TextSize = 12
		title.TextColor3 = Theme.TextPrimary
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = picker

		local closeBtn = Instance.new("TextButton")
		closeBtn.Size = UDim2.new(0, 22, 0, 22)
		closeBtn.Position = UDim2.new(1, -28, 0, 3)
		closeBtn.BackgroundTransparency = 1
		closeBtn.Text = "✕"
		closeBtn.TextColor3 = Theme.TextSecondary
		closeBtn.Font = Theme.FontBold
		closeBtn.TextSize = 12
		closeBtn.Parent = picker
		closeBtn.MouseButton1Click:Connect(function() closeColorPicker(true) end)

		local svCanvas = Instance.new("Frame")
		svCanvas.Size = UDim2.new(0, 204, 0, 95)
		svCanvas.Position = UDim2.new(0, 13, 0, 30)
		svCanvas.BackgroundColor3 = Color3.fromHSV(curH, 1, 1)
		svCanvas.BorderSizePixel = 0
		svCanvas.ClipsDescendants = true
		svCanvas.Parent = picker

		local wFrame = Instance.new("Frame")
		wFrame.Size = UDim2.new(1, 0, 1, 0)
		wFrame.BackgroundColor3 = Color3.new(1, 1, 1)
		wFrame.BorderSizePixel = 0
		wFrame.Parent = svCanvas
		local whiteGrad = Instance.new("UIGradient")
		whiteGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
		whiteGrad.Parent = wFrame

		local bFrame = Instance.new("Frame")
		bFrame.Size = UDim2.new(1, 0, 1, 0)
		bFrame.BackgroundColor3 = Color3.new(0, 0, 0)
		bFrame.BorderSizePixel = 0
		bFrame.Parent = svCanvas
		local blackGrad = Instance.new("UIGradient")
		blackGrad.Rotation = 90
		blackGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
		blackGrad.Parent = bFrame

		local hueTrack = Instance.new("Frame")
		hueTrack.Size = UDim2.new(0, 204, 0, 14)
		hueTrack.Position = UDim2.new(0, 13, 0, 132)
		hueTrack.BackgroundColor3 = Color3.new(1, 1, 1)
		hueTrack.BorderSizePixel = 0
		hueTrack.Parent = picker

		local hCorn = Instance.new("UICorner")
		hCorn.CornerRadius = UDim.new(0, 4)
		hCorn.Parent = hueTrack

		local hGrad = Instance.new("UIGradient")
		hGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
			ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
			ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
			ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
			ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
		})
		hGrad.Parent = hueTrack

		local prevBox = Instance.new("Frame")
		prevBox.Size = UDim2.new(0, 22, 0, 22)
		prevBox.Position = UDim2.new(0, 13, 0, 154)
		prevBox.BackgroundColor3 = Color3.fromHSV(curH, curS, curV)
		prevBox.BorderSizePixel = 0
		prevBox.Parent = picker

		local hexLbl = Instance.new("TextLabel")
		hexLbl.Size = UDim2.new(1, -50, 0, 22)
		hexLbl.Position = UDim2.new(0, 42, 0, 154)
		hexLbl.BackgroundTransparency = 1
		hexLbl.Font = Theme.FontMedium
		hexLbl.TextSize = 12
		hexLbl.TextColor3 = Theme.TextPrimary
		hexLbl.TextXAlignment = Enum.TextXAlignment.Left
		hexLbl.Parent = picker

		local function updateCol()
			local c = Color3.fromHSV(curH, curS, curV)
			prevBox.BackgroundColor3 = c
			svCanvas.BackgroundColor3 = Color3.fromHSV(curH, 1, 1)
			hexLbl.Text = string.format("#%02X%02X%02X (%d, %d, %d)", c.R*255, c.G*255, c.B*255, c.R*255, c.G*255, c.B*255)
			if onCol then onCol(c) end
		end
		updateCol()

		svCanvas.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				curS = math.clamp((input.Position.X - svCanvas.AbsolutePosition.X) / svCanvas.AbsoluteSize.X, 0, 1)
				curV = math.clamp(1 - (input.Position.Y - svCanvas.AbsolutePosition.Y) / svCanvas.AbsoluteSize.Y, 0, 1)
				updateCol()
			end
		end)

		hueTrack.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				curH = math.clamp((input.Position.X - hueTrack.AbsolutePosition.X) / hueTrack.AbsoluteSize.X, 0, 1)
				updateCol()
			end
		end)
	end

	-- Keybind Modal
	self.OpenKeybindPopup = function(_, curKey, onChg)
		local popup = Instance.new("Frame")
		popup.Size = UDim2.new(0, 224, 0, 122)
		popup.Position = UDim2.new(0.5, -112, 0.5, -61)
		popup.BackgroundColor3 = Color3.fromRGB(16, 20, 27)
		popup.BorderSizePixel = 0
		popup.ZIndex = 80
		popup.Parent = MainFrame

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = popup

		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, -40, 0, 30)
		title.Position = UDim2.new(0, 12, 0, 2)
		title.BackgroundTransparency = 1
		title.Text = "Keybind"
		title.Font = Theme.FontSemiBold
		title.TextSize = 12
		title.TextColor3 = Theme.TextPrimary
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = popup

		local closeBtn = Instance.new("TextButton")
		closeBtn.Size = UDim2.new(0, 22, 0, 22)
		closeBtn.Position = UDim2.new(1, -29, 0, 6)
		closeBtn.BackgroundTransparency = 1
		closeBtn.Text = "✕"
		closeBtn.TextColor3 = Theme.TextSecondary
		closeBtn.Parent = popup
		closeBtn.MouseButton1Click:Connect(function() popup:Destroy() end)

		local keyBtn = Instance.new("TextButton")
		keyBtn.Size = UDim2.new(0, 68, 0, 28)
		keyBtn.Position = UDim2.new(1, -80, 0, 39)
		keyBtn.BackgroundColor3 = Theme.NavActive
		keyBtn.BorderSizePixel = 0
		keyBtn.Text = string.upper(tostring(curKey))
		keyBtn.Font = Theme.FontSemiBold
		keyBtn.TextSize = 12
		keyBtn.TextColor3 = Theme.AccentBlue
		keyBtn.Parent = popup

		local kCorn = Instance.new("UICorner")
		kCorn.CornerRadius = UDim.new(0, 6)
		kCorn.Parent = keyBtn

		local capturing = false
		keyBtn.MouseButton1Click:Connect(function()
			capturing = true
			keyBtn.Text = "..."
			keyBtn.TextColor3 = Color3.fromRGB(255, 205, 65)
		end)

		local conn
		conn = UserInputService.InputBegan:Connect(function(input)
			if capturing and input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode ~= Enum.KeyCode.Escape then
					curKey = input.KeyCode.Name
					keyBtn.Text = string.upper(curKey)
					keyBtn.TextColor3 = Theme.AccentBlue
					if onChg then onChg(curKey) end
				else
					keyBtn.Text = string.upper(curKey)
					keyBtn.TextColor3 = Theme.AccentBlue
				end
				capturing = false
			end
		end)
		popup.Destroying:Connect(function() conn:Disconnect() end)
	end

	-- Config Browser Modal
	local function buildConfigModal()
		local modal = Instance.new("CanvasGroup")
		modal.Size = UDim2.new(0, 336, 0, 318)
		modal.Position = UDim2.new(0.5, -168, 0.5, -159)
		modal.BackgroundColor3 = Color3.fromRGB(14, 18, 25)
		modal.BorderSizePixel = 0
		modal.Visible = false
		modal.ZIndex = 70
		modal.Parent = MainFrame

		local mCorn = Instance.new("UICorner")
		mCorn.CornerRadius = UDim.new(0, 8)
		mCorn.Parent = modal

		local title = Instance.new("TextLabel")
		title.Size = UDim2.new(1, -54, 0, 42)
		title.Position = UDim2.new(0, 14, 0, 0)
		title.BackgroundTransparency = 1
		title.Text = "SAVED CONFIGS"
		title.Font = Theme.FontBold
		title.TextSize = 13
		title.TextColor3 = Theme.TextPrimary
		title.TextXAlignment = Enum.TextXAlignment.Left
		title.Parent = modal

		local closeBtn = Instance.new("TextButton")
		closeBtn.Size = UDim2.new(0, 24, 0, 24)
		closeBtn.Position = UDim2.new(1, -34, 0, 9)
		closeBtn.BackgroundTransparency = 1
		closeBtn.Text = "✕"
		closeBtn.TextColor3 = Theme.TextSecondary
		closeBtn.Parent = modal
		closeBtn.MouseButton1Click:Connect(function() modal.Visible = false end)

		local list = Instance.new("ScrollingFrame")
		list.Size = UDim2.new(1, -28, 0, 202)
		list.Position = UDim2.new(0, 14, 0, 52)
		list.BackgroundColor3 = Color3.fromRGB(10, 13, 18)
		list.BorderSizePixel = 0
		list.ScrollBarThickness = 4
		list.ScrollBarImageColor3 = Theme.AccentBlue
		list.Parent = modal

		local lLayout = Instance.new("UIListLayout")
		lLayout.Padding = UDim.new(0, 5)
		lLayout.Parent = list

		local selName, selBtn
		local function refresh()
			for _, ch in ipairs(list:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
			selName, selBtn = nil, nil
			local names = {}
			if fileApi.listfiles and self:EnsureConfigFolder() then
				local ok, files = pcall(fileApi.listfiles, self.ConfigFolder)
				if ok and type(files) == "table" then
					for _, f in ipairs(files) do
						local match = tostring(f):match("([^/\\]+)%.json$")
						if match then table.insert(names, match) end
					end
				end
			end
			table.sort(names)
			for _, name in ipairs(names) do
				local row = Instance.new("TextButton")
				row.Size = UDim2.new(1, 0, 0, 32)
				row.BackgroundColor3 = Color3.fromRGB(18, 23, 31)
				row.BorderSizePixel = 0
				row.Text = "   " .. name
				row.Font = Theme.FontMedium
				row.TextSize = 12
				row.TextColor3 = Theme.TextPrimary
				row.TextXAlignment = Enum.TextXAlignment.Left
				row.Parent = list

				local rCorn = Instance.new("UICorner")
				rCorn.CornerRadius = UDim.new(0, 5)
				rCorn.Parent = row

				row.MouseButton1Click:Connect(function()
					if selBtn and selBtn.Parent then
						selBtn.BackgroundColor3 = Color3.fromRGB(18, 23, 31)
						selBtn.TextColor3 = Theme.TextPrimary
					end
					selName = name
					selBtn = row
					row.BackgroundColor3 = Theme.NavActive
					row.TextColor3 = Theme.AccentBlue
				end)
			end
			list.CanvasSize = UDim2.new(0, 0, 0, #names * 37)
		end

		self.OpenConfigPicker = function()
			refresh()
			modal.Visible = true
		end
		self.RefreshConfigPicker = refresh
	end
	buildConfigModal()
end

return MidnightUI
