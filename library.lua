-------------------------------------
-- Services
-------------------------------------

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-------------------------------------
-- Variables & Functions
-------------------------------------

local gethui = gethui or function() return CoreGui end

local Fonts = {
	Small = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Light),
	Big = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Heavy),
	Large = Enum.Font.GothamBlack
}

local function _(ClassName, Properties)
	local Inst = Instance.new(ClassName)
	for Property, Value in Properties do
		local Success, Error = pcall(function()
			Inst[Property] = Value
		end)
		if not Success then
			warn(Error)
		end
	end
	return Inst
end

local function Str(Inst)
	local Stroke = _("UIStroke", {
		Parent = Inst,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		LineJoinMode = Enum.LineJoinMode.Miter
	})

	local Tree = {}

	function Tree:Trans(x)
		Stroke.Transparency = x
		return Tree
	end

	function Tree:Size(x)
		Stroke.Thickness = x
		return Tree
	end

	function Tree:Col(x)
		Stroke.Color = x
		return Tree
	end

	function Tree:Mode(Name)
		Stroke.LineJoinMode = Enum.LineJoinMode[Name]
		return Tree
	end

	return Tree
end

local function Pad(Inst)
	local Padding = _("UIPadding", {
		Parent = Inst
	})

	local Tree = {}

	function Tree:L(Scale, Offset)
		Padding.PaddingLeft = UDim.new(Scale, Offset)
		return Tree
	end

	function Tree:R(Scale, Offset)
		Padding.PaddingRight = UDim.new(Scale, Offset)
		return Tree
	end

	function Tree:T(Scale, Offset)
		Padding.PaddingTop = UDim.new(Scale, Offset)
		return Tree
	end

	function Tree:B(Scale, Offset)
		Padding.PaddingBottom = UDim.new(Scale, Offset)
		return Tree
	end

	function Tree:A(Scale, Offset)
		Padding.PaddingLeft = UDim.new(Scale, Offset)
		Padding.PaddingRight = UDim.new(Scale, Offset)
		Padding.PaddingTop = UDim.new(Scale, Offset)
		Padding.PaddingBottom = UDim.new(Scale, Offset)
		return Tree
	end

	return Tree
end

local function Round(Inst, Scale, Offset)
	local Corner = _("UICorner", {
		Parent = Inst,
		CornerRadius = UDim.new(Scale or 0, Offset or 0)
	})
	return Corner
end

local function Ratio(Inst, X)
	local Constraint = _("UIAspectRatioConstraint", {
		Parent = Inst,
		AspectRatio = X or 1
	})
	return Constraint
end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local function CustomDrag(Inst)
	local Dragging = false
	local DragInput
	local DragStart
	local StartPos

	Inst.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = Input.Position
			StartPos = Inst.Position

			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	Inst.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			DragInput = Input
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Input == DragInput and Dragging then
			local Delta = Input.Position - DragStart
			local Parent = Inst.Parent.AbsoluteSize

			local Goal = UDim2.new(
				StartPos.X.Scale + (Delta.X / Parent.X),
				0,
				StartPos.Y.Scale + (Delta.Y / Parent.Y),
				0
			)

			TweenService:Create(Inst, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = Goal}):Play()
		end
	end)
end

-------------------------------------
-- File System
-------------------------------------

if not isfolder("Dupre") then
	makefolder("Dupre")
end

for _, Name in {"aura", "Check"} do
	Name = Name .. ".png"
	if not isfile(Name) then
		local Link = `https://raw.githubusercontent.com/d-upre/Dupre-Library/refs/heads/main/assets/{Name}`
		local Content = game:HttpGet(Link)
		writefile(Name, Content)
	end
end

-------------------------------------
-- Library
-------------------------------------

local Library = {}

function Library:Init(RootName)
	-- Setup
	local Screen = _("ScreenGui", {
		Parent = gethui(),
		ResetOnSpawn = false,
		DisplayOrder = 2_147_483_647,
		Enabled = false
	})

	local Main = _("Frame", {
		Parent = Screen,
		BackgroundTransparency = 0.2,
		BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.new(0.5, 0, 0.3, 0),
		BorderSizePixel = 0
	})
	Round(Main, 0.02)
	Ratio(Main, 1.6)
	Str(Main):Size(1):Trans(0.8):Col(Color3.new(1, 1, 1)):Mode("Round")
	CustomDrag(Main)

	local TopBar = _("Frame", {
		Parent = Main,
		Size = UDim2.new(1, 0, 0.2, 0),
		BackgroundTransparency = 1
	})

	local TopBarList = _("UIListLayout", {
		Parent = TopBar,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		FillDirection = Enum.FillDirection.Horizontal
	})

	local TabList = _("ScrollingFrame", {
		Parent = Main,
		Size = UDim2.new(0.2, 0, 1 - TopBar.Size.Y.Scale, 0),
		Position = UDim2.new(0, 0, TopBar.Size.Y.Scale, 0),
		BackgroundTransparency = 1,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0)
	})

	local Layout = _("UIListLayout", {
		Parent = TabList
	})

	local Divider = _("Frame", {
		Parent = Main,
		Position = UDim2.new(0.2, 0, TopBar.Size.Y.Scale, 0),
		Size = UDim2.new(0, 1, 0.95 - TopBar.Size.Y.Scale, 0),
		BackgroundTransparency = 0.8,
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0
	})

	local IconHolder = _("Frame", {
		Parent = TopBar,
		Size = UDim2.new(0.2, 0, 1, 0),
		BackgroundTransparency = 1
	})
	Ratio(IconHolder, 1)

	local Icon = _("ImageLabel", {
		Parent = IconHolder,
		Size = UDim2.new(0.7, 0, 0.7, 0),
		Image = getcustomasset("aura.png"),
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	})
	Round(Icon, 0.1)

	local Title = _("TextLabel", {
		Parent = TopBar,
		Size = UDim2.new(0.8, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = RootName,
		TextScaled = true,
		TextColor3 = Color3.new(1, 1, 1),
		Font = Fonts.Large,
		TextStrokeTransparency = 0.5,
		TextXAlignment = Enum.TextXAlignment.Left
	})
	Pad(Title):T(0.3):B(0.3)

	local RootTree = {
		Screen = Screen
	}

	-- Tab
	local Tabs = {}
	function RootTree:Tab(TabName)
		-- Tab Design
		local Tab = _("TextButton", {
			Parent = TabList,
			BackgroundTransparency = 1,
			TextScaled = true,
			TextColor3 = Color3.new(1, 1, 1),
			FontFace = Fonts.Big,
			TextStrokeTransparency = 0.5,
			Size = UDim2.new(1, 0, 0.125, 0),
			Text = TabName,
			TextTransparency = #Tabs == 0 and 0 or 0.4
		})
		Pad(Tab):A(0.2):L(0.02):R(0.02)

		local TabFrame = _("ScrollingFrame", {
			Parent = Main,
			Position = UDim2.new(0.225, 0, TopBar.Size.Y.Scale, 0),
			Size = UDim2.new(0.75, 0, 0.95 - TopBar.Size.Y.Scale, 0),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Visible = #Tabs == 0,
			ScrollBarThickness = 0
		})
		Pad(TabFrame):A(0, 2)

		local Layout = _("UIListLayout", {
			Parent = TabFrame,
			Padding = UDim.new(0.03, 0)
		})

		local TabClass = {Tab, TabFrame, false}

		if #Tabs == 0 then
			TabClass[3] = true
		end

		Tab.MouseEnter:Connect(function()
			Tab.TextTransparency = 0
		end)

		Tab.MouseLeave:Connect(function()
			Tab.TextTransparency = TabClass[3] and 0 or 0.4
		end)

		Tab.MouseButton1Down:Connect(function()
			for _, T in Tabs do
				local Button, Frame = T[1], T[2]
				Frame.Visible = Frame == TabFrame
				Button.TextTransparency = 0.4
				T[3] = false
			end

			TabClass[3] = true
			Tab.TextTransparency = 0
		end)

		table.insert(Tabs, TabClass)

		local TabTree = {}

		-- Section
		function TabTree:Section(SectionName)
			local SectionItems = {}

			local SectionHolder = _("Frame", {
				Parent = TabFrame,
				Size = UDim2.new(1, 0, 0.1, 0),
				BackgroundTransparency = 0.9,
				BackgroundColor3 = Color3.new(0, 0, 0)
			})
			Round(SectionHolder, 0, 10)
			Str(SectionHolder):Size(1):Trans(0.9):Col(Color3.new(1, 1, 1)):Mode("Round")

			local SectionLayout = _("UIListLayout", {
				Parent = SectionHolder,
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			})

			local SectionTitle = _("TextLabel", {
				Parent = SectionHolder,
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundTransparency = 1,
				Text = SectionName,
				TextScaled = true,
				TextColor3 = Color3.new(1, 1, 1),
				Font = Fonts.Large,
				TextTransparency = 0.4,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			Pad(SectionTitle):T(0.2):B(0.2)
			table.insert(SectionItems, SectionTitle)
			
			local SectionTree = {}

			Pad(SectionHolder):L(0, 8):R(0, 8)

			local function UpdateSize()
				SectionHolder.Size = UDim2.new(1, 0, #SectionItems / 5, 0)
				
				for _, Item in SectionItems do
					Item.Size = UDim2.new(1, 0, 1 / #SectionItems, #SectionItems == 1 and 0 or -8)
				end
			end

			UpdateSize()

			-- Toggle
			function SectionTree:Toggle(ToggleName, Callback)
				local ToggleHolder = _("Frame", {
					Parent = SectionHolder,
					BackgroundTransparency = 0.95,
					BackgroundColor3 = Color3.new(1, 1, 1)
				})
				Round(ToggleHolder, 0.15)
				Str(ToggleHolder):Size(1):Trans(0.9):Col(Color3.new(1, 1, 1)):Mode("Round")
				table.insert(SectionItems, ToggleHolder)
				UpdateSize()

				local ToggleTitle = _("TextLabel", {
					Parent = ToggleHolder,
					Size = UDim2.new(0.8, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = ToggleName,
					TextScaled = true,
					TextColor3 = Color3.new(1, 1, 1),
					FontFace = Fonts.Big,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTransparency = 0.4
				})
				Pad(ToggleTitle):T(0.25):B(0.25):L(0, 5)

				local ToggleFrameHolder = _("Frame", {
					Parent = ToggleHolder,
					Size = UDim2.new(0.4, 0, 1, 0),
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0)
				})
				Ratio(ToggleFrameHolder, 1)

				local ToggleFrame = _("Frame", {
					Parent = ToggleFrameHolder,
					Size = UDim2.new(0.65, 0, 0.65, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.new(0, 0, 0),
					BackgroundTransparency = 0.95
				})
				local Stroke = Str(ToggleFrame):Size(1):Trans(0.9):Col(Color3.new(1, 1, 1)):Mode("Round")
				Round(ToggleFrame, 0.08)

				local ToggleButton = _("ImageButton", {
					Parent = ToggleFrame,
					Size = UDim2.new(0.8, 0, 0.8, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					BackgroundTransparency = 1,
					ImageTransparency = 0.4
				})

				ToggleButton.MouseEnter:Connect(function()
					ToggleFrame.BackgroundTransparency = 0.9
					Stroke:Trans(0.85)
				end)

				ToggleButton.MouseLeave:Connect(function()
					ToggleFrame.BackgroundTransparency = 0.95
					Stroke:Trans(0.9)
				end)

				local Toggle = false
				ToggleButton.MouseButton1Down:Connect(function()
					Toggle = not Toggle
					ToggleButton.Image = Toggle and getcustomasset("Check.png") or ""
					Callback(Toggle)
				end)
			end

			-- TextBox
			function SectionTree:TextBox(TextBoxName, Placeholder, Callback)
				local TextBoxHolder = _("Frame", {
					Parent = SectionHolder,
					BackgroundTransparency = 0.95,
					BackgroundColor3 = Color3.new(1, 1, 1)
				})
				Round(TextBoxHolder, 0.15)
				Str(TextBoxHolder):Size(1):Trans(0.9):Col(Color3.new(1, 1, 1)):Mode("Round")
				table.insert(SectionItems, TextBoxHolder)
				UpdateSize()

				local TextBoxTitle = _("TextLabel", {
					Parent = TextBoxHolder,
					Size = UDim2.new(0.5, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = TextBoxName,
					TextScaled = true,
					TextColor3 = Color3.new(1, 1, 1),
					FontFace = Fonts.Big,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTransparency = 0.4
				})
				Pad(TextBoxTitle):T(0.25):B(0.25):L(0, 5)

				local TextBox = _("TextBox", {
					Parent = TextBoxHolder,
					Size = UDim2.new(0.48, 0, 0.75, 0),
					Position = UDim2.new(0.51, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundTransparency = 0.9,
					BackgroundColor3 = Color3.new(0, 0, 0),
					TextScaled = true,
					Text = "",
					TextColor3 = Color3.new(1, 1, 1),
					FontFace = Fonts.Big,
					TextTransparency = 0.4,
					PlaceholderText = Placeholder
				})
				Pad(TextBox):A(0.1):L(0.03):R(0.03)
				Round(TextBox, 0.1)
				local Stroke = Str(TextBox):Size(1):Trans(0.95):Col(Color3.new(1, 1, 1)):Mode("Round")

				TextBox.FocusLost:Connect(function(EnterPressed)
					if not EnterPressed then return end

					Callback(TextBox.Text)
				end)

				TextBox.MouseEnter:Connect(function()
					Stroke:Trans(0.85)
				end)

				TextBox.MouseLeave:Connect(function()
					Stroke:Trans(0.95)
				end)
			end

			-- Button
			function SectionTree:Button(ButtonName, Callback)
				local ButtonHolder = _("Frame", {
					Parent = SectionHolder,
					BackgroundTransparency = 0.95,
					BackgroundColor3 = Color3.new(1, 1, 1)
				})
				Round(ButtonHolder, 0.15)
				local Stroke = Str(ButtonHolder):Size(1):Trans(0.9):Col(Color3.new(1, 1, 1)):Mode("Round")
				table.insert(SectionItems, ButtonHolder)
				UpdateSize()

				local Button = _("TextButton", {
					Parent = ButtonHolder,
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Text = TextBoxName,
					TextScaled = true,
					TextColor3 = Color3.new(1, 1, 1),
					FontFace = Fonts.Big,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTransparency = 0.4
				})
				Pad(Button):T(0.25):B(0.25):L(0, 5)

				local Hovering = false

				Button.MouseEnter:Connect(function()
					Hovering = true
					Stroke:Trans(0.85)
				end)

				Button.MouseLeave:Connect(function()
					Hovering = false
					Stroke:Trans(0.95)
				end)

				Button.MouseButton1Down:Connect(function()
					Callback()
					Stroke:Trans(0.7)
				end)

				Button.MouseButton1Up:Connect(function()
					Callback()
					Stroke:Trans(Hovering and 0.85 or 0.95)
				end)
			end

			return SectionTree
		end

		return TabTree
	end

	-- Intro
	local Archive = {}

	for _, Inst in Screen:GetDescendants() do
		local Props = {}

		for _, P in {"TextTransparency", "BackgroundTransparency", "ImageTransparency", "Transparency"} do
			pcall(function()
				local Value = Inst[P]
				if Value and Value ~= 1 then
					Props[P] = Value
					Inst[P] = 1
				end
			end)
		end

		Archive[Inst] = Props
	end

	Screen.Enabled = true

	local Info = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	for Inst, Props in Archive do
		for Name, Value in Props do
			TweenService:Create(Inst, Info, { [Name] = Value }):Play()
		end
	end

	return RootTree
end

return Library
