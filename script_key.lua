_G.key = nil

local Identifier = "dynamic-"
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()
local FILENAME = "jthrgsdcde34qdsfeqre.txt"
local savedkey = isfile(FILENAME) and readfile(FILENAME) or ""


local function GetKeyLink(serviceId, hwid)
    return "https://pandadevelopment.net/getkey?service=" .. tostring(serviceId) .. "&hwid=" .. tostring(hwid)
end

local function ValidateKey(key, serviceId, hwid)
    local validationUrl = string.format(
        "https://pandadevelopment.net/v2_validation?key=%s&service=%s&hwid=%s",
        tostring(key), tostring(serviceId), tostring(hwid)
    )

    local requestFunction =
        (syn and syn.request) or
        (http and http.request) or
        (http_request) or
        (fluxus and fluxus.request) or
        (krnl and krnl.request) or
        (request) or
        nil

    if not requestFunction then
        return false, "Executor does not support HTTP requests"
    end

    local success, response = pcall(function()
        return requestFunction({
            Url = validationUrl,
            Method = "GET"
        })
    end)

    if not success or not response or not response.Body then
        return false, "No response"
    end

    local jsonSuccess, jsonData = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if not jsonSuccess then
        return false, "JSON decode error"
    end

    if jsonData["V2_Authentication"] == "success" then
        return true, "Authenticated"
    else
        local reason = jsonData["reason"] or "Unknown reason"
        return false, reason
    end
end

if gethui():FindFirstChild("key") then
	gethui().key:Destroy()
end

local Library, SaveTheme = {}, {}
local U, Tw = game:GetService("UserInputService"), game:GetService("TweenService")

function Library.Load(o)
	local function init(getFrame)
		local MTREL = "Glass"
		local binds = {}
		local root = Instance.new('Folder', workspace.CurrentCamera)
		root.Name = 'BlurSnox'

		local gTokenMH = 99999999
		local gToken = math.random(1, gTokenMH)

		local DepthOfField = Instance.new('DepthOfFieldEffect', game:GetService('Lighting'))
		DepthOfField.FarIntensity = 0
		DepthOfField.FocusDistance = 51.6
		DepthOfField.InFocusRadius = 50
		DepthOfField.NearIntensity = 1
		DepthOfField.Name = "DPT_"..gToken

		local frame = Instance.new('Frame')
		frame.Parent = getFrame
		frame.Size = UDim2.new(0.95, 0, 0.95, 0)
		frame.Position = UDim2.new(0.5, 0, 0.5, 0)
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.BackgroundTransparency = 1

		local GenUid; do 
			local id = 0
			function GenUid()
				id = id + 1
				return 'neon::'..tostring(id)
			end
		end

		do
			local function IsNotNaN(x)
				return x == x
			end
			local continue = IsNotNaN(workspace.CurrentCamera:ScreenPointToRay(0,0).Origin.x)
			while not continue do
				game:GetService('RunService').RenderStepped:wait()
				continue = IsNotNaN(workspace.CurrentCamera:ScreenPointToRay(0,0).Origin.x)
			end
		end

		local DrawQuad; do
			local acos, max, pi, sqrt = math.acos, math.max, math.pi, math.sqrt
			local sz = 0.2

			local function DrawTriangle(v1, v2, v3, p0, p1) -- I think Stravant wrote this function
				local s1 = (v1 - v2).magnitude
				local s2 = (v2 - v3).magnitude
				local s3 = (v3 - v1).magnitude
				local smax = max(s1, s2, s3)
				local A, B, C
				if s1 == smax then
					A, B, C = v1, v2, v3
				elseif s2 == smax then
					A, B, C = v2, v3, v1
				elseif s3 == smax then
					A, B, C = v3, v1, v2
				end

				local para = ( (B-A).x*(C-A).x + (B-A).y*(C-A).y + (B-A).z*(C-A).z ) / (A-B).magnitude
				local perp = sqrt((C-A).magnitude^2 - para*para)
				local dif_para = (A - B).magnitude - para

				local st = CFrame.new(B, A)
				local za = CFrame.Angles(pi/2,0,0)

				local cf0 = st

				local Top_Look = (cf0 * za).lookVector
				local Mid_Point = A + CFrame.new(A, B).lookVector * para
				local Needed_Look = CFrame.new(Mid_Point, C).lookVector
				local dot = Top_Look.x*Needed_Look.x + Top_Look.y*Needed_Look.y + Top_Look.z*Needed_Look.z

				local ac = CFrame.Angles(0, 0, acos(dot))

				cf0 = cf0 * ac
				if ((cf0 * za).lookVector - Needed_Look).magnitude > 0.01 then
					cf0 = cf0 * CFrame.Angles(0, 0, -2*acos(dot))
				end
				cf0 = cf0 * CFrame.new(0, perp/2, -(dif_para + para/2))

				local cf1 = st * ac * CFrame.Angles(0, pi, 0)
				if ((cf1 * za).lookVector - Needed_Look).magnitude > 0.01 then
					cf1 = cf1 * CFrame.Angles(0, 0, 2*acos(dot))
				end
				cf1 = cf1 * CFrame.new(0, perp/2, dif_para/2)

				if not p0 then
					p0 = Instance.new('Part')
					p0.FormFactor = 'Custom'
					p0.TopSurface = 0
					p0.BottomSurface = 0
					p0.Anchored = true
					p0.CanCollide = false
					p0.CastShadow = false
					p0.Material = MTREL
					p0.Size = Vector3.new(sz, sz, sz)
					local mesh = Instance.new('SpecialMesh', p0)
					mesh.MeshType = 2
					mesh.Name = 'WedgeMesh'
				end
				p0.WedgeMesh.Scale = Vector3.new(0, perp/sz, para/sz)
				p0.CFrame = cf0

				if not p1 then
					p1 = p0:clone()
				end
				p1.WedgeMesh.Scale = Vector3.new(0, perp/sz, dif_para/sz)
				p1.CFrame = cf1

				return p0, p1
			end

			function DrawQuad(v1, v2, v3, v4, parts)
				parts[1], parts[2] = DrawTriangle(v1, v2, v3, parts[1], parts[2])
				parts[3], parts[4] = DrawTriangle(v3, v2, v4, parts[3], parts[4])
			end
		end

		if binds[frame] then
			return binds[frame].parts
		end

		local uid = GenUid()
		local parts = {}
		local f = Instance.new('Folder', root)
		f.Name = frame.Name

		local parents = {}
		do
			local function add(child)
				if child:IsA'GuiObject' then
					parents[#parents + 1] = child
					add(child.Parent)
				end
			end
			add(frame)
		end

		local function UpdateOrientation(fetchProps)
			local properties = {
				Transparency = 0.98;
				BrickColor = BrickColor.new('Institutional white');
			}
			local zIndex = 1 - 0.05*frame.ZIndex

			local tl, br = frame.AbsolutePosition, frame.AbsolutePosition + frame.AbsoluteSize
			local tr, bl = Vector2.new(br.x, tl.y), Vector2.new(tl.x, br.y)
			do
				local rot = 0;
				for _, v in ipairs(parents) do
					rot = rot + v.Rotation
				end
				if rot ~= 0 and rot%180 ~= 0 then
					local mid = tl:lerp(br, 0.5)
					local s, c = math.sin(math.rad(rot)), math.cos(math.rad(rot))
					local vec = tl
					tl = Vector2.new(c*(tl.x - mid.x) - s*(tl.y - mid.y), s*(tl.x - mid.x) + c*(tl.y - mid.y)) + mid
					tr = Vector2.new(c*(tr.x - mid.x) - s*(tr.y - mid.y), s*(tr.x - mid.x) + c*(tr.y - mid.y)) + mid
					bl = Vector2.new(c*(bl.x - mid.x) - s*(bl.y - mid.y), s*(bl.x - mid.x) + c*(bl.y - mid.y)) + mid
					br = Vector2.new(c*(br.x - mid.x) - s*(br.y - mid.y), s*(br.x - mid.x) + c*(br.y - mid.y)) + mid
				end
			end
			DrawQuad(
				workspace.CurrentCamera:ScreenPointToRay(tl.x, tl.y, zIndex).Origin, 
				workspace.CurrentCamera:ScreenPointToRay(tr.x, tr.y, zIndex).Origin, 
				workspace.CurrentCamera:ScreenPointToRay(bl.x, bl.y, zIndex).Origin, 
				workspace.CurrentCamera:ScreenPointToRay(br.x, br.y, zIndex).Origin, 
				parts
			)
			if fetchProps then
				for _, pt in pairs(parts) do
					pt.Parent = f
				end
				for propName, propValue in pairs(properties) do
					for _, pt in pairs(parts) do
						pt[propName] = propValue
					end
				end
			end
		end

		UpdateOrientation(true)
		game:GetService('RunService'):BindToRenderStep(uid, 2000, UpdateOrientation)
		return {
			DepthOfField,
			frame
		}
	end
	local function gl(i)
		local IconList = loadstring(game:HttpGet('https://raw.githubusercontent.com/Dummyrme/Library/refs/heads/main/Icon.lua'))()
		local iconData = IconList.Icons[i]
		if iconData then
			local spriteSheet = IconList.Spritesheets[tostring(iconData.Image)]
			if spriteSheet then
				return {
					Image = spriteSheet,
					ImageRectSize = iconData.ImageRectSize,
					ImageRectPosition = iconData.ImageRectPosition,
				}
			end
		end
		if type(i) == 'string' and not i:find('rbxassetid://') then
			return {
				Image = "rbxassetid://".. i,
				ImageRectSize = Vector2.new(0, 0),
				ImageRectPosition = Vector2.new(0, 0),
			}
		elseif type(i) == 'number' then
			return {
				Image = "rbxassetid://".. i,
				ImageRectSize = Vector2.new(0, 0),
				ImageRectPosition = Vector2.new(0, 0),
			}
		else
			return i
		end
	end
	local function tw(info)
		return Tw:Create(info.v,TweenInfo.new(info.t, info.s, Enum.EasingDirection[info.d]),info.g)
	end
	local function lak(t, o)
		local a, b, c, d
		local function u(i)
			local dt = i.Position - c
			tw({v = o, t = 0.05, s = Enum.EasingStyle.Linear, d = "InOut", g = {Position = UDim2.new(d.X.Scale, d.X.Offset + dt.X, d.Y.Scale, d.Y.Offset + dt.Y)}}):Play()
		end
		t.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then a = true c = i.Position d = o.Position; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then a = false end end) end end)
		t.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then b = i end end)
		U.InputChanged:Connect(function(i) if i == b and a then u(i) end end)
	end
	local function click(p)
		local Click = Instance.new("TextButton")

		Click.Name = "Click"
		Click.Parent = p
		Click.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Click.BackgroundTransparency = 1.000
		Click.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Click.BorderSizePixel = 0
		Click.Size = UDim2.new(1, 0, 1, 0)
		Click.Font = Enum.Font.SourceSans
		Click.Text = ""
		Click.TextColor3 = Color3.fromRGB(0, 0, 0)
		Click.TextSize = 14.000

		return Click
	end

	local HubName = o.Name or 'Frosina Community'
	local Color = o.Color or Color3.fromRGB(69, 143, 255)
	local Icon = o.Icon or 14930953469
	local Key = o.Key or {}

	local ScreenGui = Instance.new("ScreenGui")
	local Background_1 = Instance.new("Frame")
	local UICorner_1 = Instance.new("UICorner")
	local UIGradient_1 = Instance.new("UIGradient")
	local UIPadding_1 = Instance.new("UIPadding")
	local Left_1 = Instance.new("CanvasGroup")
	local UIListLayout_1 = Instance.new("UIListLayout")
	local TItleIcon_1 = Instance.new("Frame")
	local UIListLayout_2 = Instance.new("UIListLayout")
	local ImageLabel_1 = Instance.new("ImageLabel")
	local TextLabel_1 = Instance.new("TextLabel")
	local adsframe_1 = Instance.new("Frame")
	local ads_1 = Instance.new("TextLabel")
	local KeyFrame_1 = Instance.new("Frame")
	local UIListLayout_3 = Instance.new("UIListLayout")
	local TextLabel_2 = Instance.new("TextLabel")
	local Frame_1 = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local ImageLabel_2 = Instance.new("ImageLabel")
	local Keybox_1 = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local UIStroke_1 = Instance.new("UIStroke")
	local UIPadding_2 = Instance.new("UIPadding")
	local TextBox_1 = Instance.new("TextBox")
	local RedeemFrame_1 = Instance.new("Frame")
	local UIListLayout_4 = Instance.new("UIListLayout")
	local Button_1 = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local Shadow_1 = Instance.new("ImageLabel")
	local Text_1 = Instance.new("Frame")
	local UIListLayout_5 = Instance.new("UIListLayout")
	local TextLabel_3 = Instance.new("TextLabel")
	local ImageLabel_3 = Instance.new("ImageLabel")
	local Click_1 = Instance.new("TextButton")
	local TextLabel_4 = Instance.new("TextLabel")
	local Line_1 = Instance.new("Frame")
	local TabList_1 = Instance.new("Frame")
	local UIListLayout_7 = Instance.new("UIListLayout")

	ScreenGui.Parent = gethui()
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Name = "key"
    
	Background_1.Name = "Background"
	Background_1.Parent = ScreenGui
	Background_1.AutomaticSize = Enum.AutomaticSize.Y
	Background_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Background_1.BackgroundColor3 = Color3.fromRGB(40,40,44)
	Background_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Background_1.BorderSizePixel = 0
	Background_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Background_1.Size = UDim2.new(0, 350,0, 0)
	Background_1.ClipsDescendants = true
	Background_1.BackgroundTransparency = 1
	
	lak(Background_1, Background_1)

	local blurframe = init(Background_1)

	UICorner_1.Parent = Background_1
	UICorner_1.CornerRadius = UDim.new(0,13)

	UIGradient_1.Parent = Background_1
	UIGradient_1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 12, 20)), ColorSequenceKeypoint.new(0.5, Color), ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 20))}
	UIGradient_1.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(0.5,0.04375), NumberSequenceKeypoint.new(1,0)}

	UIPadding_1.Parent = Left_1
	UIPadding_1.PaddingBottom = UDim.new(0,15)
	UIPadding_1.PaddingLeft = UDim.new(0,15)
	UIPadding_1.PaddingRight = UDim.new(0,15)
	UIPadding_1.PaddingTop = UDim.new(0,15)

	Left_1.Name = "Left"
	Left_1.Parent = Background_1
	Left_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Left_1.BackgroundTransparency = 1
	Left_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Left_1.BorderSizePixel = 0
	Left_1.Size = UDim2.new(1, 0,1, 0)
	Left_1.GroupTransparency = 1
	Left_1.ClipsDescendants = false

	UIListLayout_1.Parent = Left_1
	UIListLayout_1.Padding = UDim.new(0,10)
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder

	TItleIcon_1.Name = "TItleIcon"
	TItleIcon_1.Parent = Left_1
	TItleIcon_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	TItleIcon_1.BackgroundTransparency = 1
	TItleIcon_1.BorderColor3 = Color3.fromRGB(0,0,0)
	TItleIcon_1.BorderSizePixel = 0
	TItleIcon_1.Size = UDim2.new(0, 100,0, 20)

	UIListLayout_2.Parent = TItleIcon_1
	UIListLayout_2.Padding = UDim.new(0,8)
	UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

	ImageLabel_1.Parent = TItleIcon_1
	ImageLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	ImageLabel_1.BackgroundTransparency = 1
	ImageLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
	ImageLabel_1.BorderSizePixel = 0
	ImageLabel_1.Size = UDim2.new(0, 17,0, 17)
	ImageLabel_1.Image = gl(Icon).Image
	ImageLabel_1.ImageRectSize = gl(Icon).ImageRectSize
	ImageLabel_1.ImageRectOffset = gl(Icon).ImageRectPosition
	ImageLabel_1.ImageColor3 = Color

	TextLabel_1.Parent = TItleIcon_1
	TextLabel_1.AutomaticSize = Enum.AutomaticSize.X
	TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	TextLabel_1.BackgroundTransparency = 1
	TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
	TextLabel_1.BorderSizePixel = 0
	TextLabel_1.Size = UDim2.new(0, 0,0, 20)
	TextLabel_1.Font = Enum.Font.Gotham
	TextLabel_1.Text = "KEY SYSTEM"
	TextLabel_1.TextColor3 = Color
	TextLabel_1.TextSize = 11
	TextLabel_1.TextXAlignment = Enum.TextXAlignment.Left

	adsframe_1.Name = "adsframe"
	adsframe_1.Parent = Left_1
	adsframe_1.AutomaticSize = Enum.AutomaticSize.Y
	adsframe_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	adsframe_1.BackgroundTransparency = 1
	adsframe_1.BorderColor3 = Color3.fromRGB(0,0,0)
	adsframe_1.BorderSizePixel = 0
	adsframe_1.LayoutOrder = 1
	adsframe_1.Size = UDim2.new(1, 0,0, 0)

	ads_1.Name = "ads"
	ads_1.Parent = adsframe_1
	ads_1.AutomaticSize = Enum.AutomaticSize.Y
	ads_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	ads_1.BackgroundTransparency = 1
	ads_1.BorderColor3 = Color3.fromRGB(0,0,0)
	ads_1.BorderSizePixel = 0
	ads_1.Size = UDim2.new(1, 0,1, 0)
	ads_1.Font = Enum.Font.GothamBold
	ads_1.RichText = true
	ads_1.Text = "WELCOME TO THE,\n<font color='"..string.format("rgb(%d, %d, %d)", Color.r * 255, Color.g * 255, Color.b * 255).."'>"..HubName.."</font>"
	ads_1.TextColor3 = Color3.fromRGB(255,255,255)
	ads_1.TextSize = 22
	ads_1.TextWrapped = true
	ads_1.TextXAlignment = Enum.TextXAlignment.Left

	KeyFrame_1.Name = "KeyFrame"
	KeyFrame_1.Parent = Left_1
	KeyFrame_1.AutomaticSize = Enum.AutomaticSize.Y
	KeyFrame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	KeyFrame_1.BackgroundTransparency = 1
	KeyFrame_1.BorderColor3 = Color3.fromRGB(0,0,0)
	KeyFrame_1.BorderSizePixel = 0
	KeyFrame_1.LayoutOrder = 2
	KeyFrame_1.Size = UDim2.new(1, 0,0, 0)

	UIListLayout_3.Parent = KeyFrame_1
	UIListLayout_3.Padding = UDim.new(0,5)
	UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

	TextLabel_2.Parent = KeyFrame_1
	TextLabel_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
	TextLabel_2.BackgroundTransparency = 1
	TextLabel_2.BorderColor3 = Color3.fromRGB(0,0,0)
	TextLabel_2.BorderSizePixel = 0
	TextLabel_2.Size = UDim2.new(1, 0,0, 20)
	TextLabel_2.Font = Enum.Font.Gotham
	TextLabel_2.Text = "License Key"
	TextLabel_2.TextColor3 = Color3.fromRGB(255,255,255)
	TextLabel_2.TextSize = 12
	TextLabel_2.TextTransparency = 0.20000000298023224
	TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
	
	Frame_1.Parent = TextLabel_2
	Frame_1.AnchorPoint = Vector2.new(1, 0.5)
	Frame_1.BackgroundColor3 = Color
	Frame_1.BackgroundTransparency = 0.56
	Frame_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Frame_1.BorderSizePixel = 0
	Frame_1.Position = UDim2.new(1, 0,0.5, 0)
	Frame_1.Size = UDim2.new(0, 18,0, 18)

	UICorner_2.Parent = Frame_1
	UICorner_2.CornerRadius = UDim.new(1,0)

	ImageLabel_2.Parent = Frame_1
	ImageLabel_2.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
	ImageLabel_2.BackgroundTransparency = 1
	ImageLabel_2.BorderColor3 = Color3.fromRGB(0,0,0)
	ImageLabel_2.BorderSizePixel = 0
	ImageLabel_2.Position = UDim2.new(0.5, 0,0.5, 0)
	ImageLabel_2.Size = UDim2.new(0, 12,0, 12)
	ImageLabel_2.Image = "rbxassetid://13868333926"

	local HideShowKey = click(Frame_1)

	Keybox_1.Name = "Keybox"
	Keybox_1.Parent = KeyFrame_1
	Keybox_1.BackgroundColor3 = Color
	Keybox_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Keybox_1.BorderSizePixel = 0
	Keybox_1.LayoutOrder = 1
	Keybox_1.Size = UDim2.new(1, 0,0, 35)
	Keybox_1.Transparency = 0.76

	UICorner_3.Parent = Keybox_1
	UICorner_3.CornerRadius = UDim.new(0,4)

	UIStroke_1.Parent = Keybox_1
	UIStroke_1.Color = Color
	UIStroke_1.Thickness = 1.2
	UIStroke_1.Transparency = 0.64

	UIPadding_2.Parent = Keybox_1
	UIPadding_2.PaddingLeft = UDim.new(0,10)
	UIPadding_2.PaddingRight = UDim.new(0,10)

	TextBox_1.Parent = Keybox_1
	TextBox_1.Active = true
	TextBox_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	TextBox_1.BackgroundTransparency = 1
	TextBox_1.BorderColor3 = Color3.fromRGB(0,0,0)
	TextBox_1.BorderSizePixel = 0
	TextBox_1.CursorPosition = -1
	TextBox_1.Size = UDim2.new(1, 0,1, 0)
	TextBox_1.Font = Enum.Font.Gotham
	TextBox_1.PlaceholderColor3 = Color3.fromRGB(134,134,134)
	TextBox_1.PlaceholderText = "XXXX-XXXX-XXXX-XXXX"
	TextBox_1.Text = ""
	TextBox_1.TextColor3 = Color3.fromRGB(255,255,255)
	TextBox_1.TextSize = 12
	TextBox_1.TextXAlignment = Enum.TextXAlignment.Left
	TextBox_1.ClearTextOnFocus = false

	RedeemFrame_1.Name = "RedeemFrame"
	RedeemFrame_1.Parent = Left_1
	RedeemFrame_1.AutomaticSize = Enum.AutomaticSize.Y
	RedeemFrame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	RedeemFrame_1.BackgroundTransparency = 1
	RedeemFrame_1.BorderColor3 = Color3.fromRGB(0,0,0)
	RedeemFrame_1.BorderSizePixel = 0
	RedeemFrame_1.LayoutOrder = 3
	RedeemFrame_1.Size = UDim2.new(1, 0,0, 0)

	UIListLayout_4.Parent = RedeemFrame_1
	UIListLayout_4.Padding = UDim.new(0,10)
	UIListLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder

	Button_1.Name = "Button"
	Button_1.Parent = RedeemFrame_1
	Button_1.BackgroundColor3 = Color
	Button_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Button_1.BorderSizePixel = 0
	Button_1.Size = UDim2.new(1, 0,0, 35)

	UICorner_4.Parent = Button_1
	UICorner_4.CornerRadius = UDim.new(0,6)

	Shadow_1.Name = "Shadow"
	Shadow_1.Parent = Button_1
	Shadow_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Shadow_1.BackgroundColor3 = Color3.fromRGB(163,162,165)
	Shadow_1.BackgroundTransparency = 1
	Shadow_1.Position = UDim2.new(0.499683142, 0,0.499584019, 0)
	Shadow_1.Size = UDim2.new(1.04999995, 0,1.5, 0)
	Shadow_1.Image = "rbxassetid://1316045217"
	Shadow_1.ImageColor3 = Color
	Shadow_1.ImageTransparency = 0.800000011920929
	Shadow_1.ScaleType = Enum.ScaleType.Slice
	Shadow_1.SliceCenter = Rect.new(10, 10, 118, 118)

	Text_1.Name = "Text"
	Text_1.Parent = Button_1
	Text_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Text_1.BackgroundTransparency = 1
	Text_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Text_1.BorderSizePixel = 0
	Text_1.Size = UDim2.new(1, 0,1, 0)

	UIListLayout_5.Parent = Text_1
	UIListLayout_5.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_5.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_5.VerticalAlignment = Enum.VerticalAlignment.Center

	TextLabel_3.Parent = Text_1
	TextLabel_3.AutomaticSize = Enum.AutomaticSize.X
	TextLabel_3.BackgroundColor3 = Color3.fromRGB(255,255,255)
	TextLabel_3.BackgroundTransparency = 1
	TextLabel_3.BorderColor3 = Color3.fromRGB(0,0,0)
	TextLabel_3.BorderSizePixel = 0
	TextLabel_3.Size = UDim2.new(0, 0,1, 0)
	TextLabel_3.Font = Enum.Font.GothamBold
	TextLabel_3.Text = "Redeem"
	TextLabel_3.TextColor3 = Color3.fromRGB(255,255,255)
	TextLabel_3.TextSize = 12

	ImageLabel_3.Parent = Text_1
	ImageLabel_3.BackgroundColor3 = Color3.fromRGB(255,255,255)
	ImageLabel_3.BackgroundTransparency = 1
	ImageLabel_3.BorderColor3 = Color3.fromRGB(0,0,0)
	ImageLabel_3.BorderSizePixel = 0
	ImageLabel_3.LayoutOrder = 2
	ImageLabel_3.Size = UDim2.new(0, 20,0, 20)
	ImageLabel_3.Image = "rbxassetid://14938884688"

	Click_1.Name = "Click"
	Click_1.Parent = Button_1
	Click_1.Active = true
	Click_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Click_1.BackgroundTransparency = 1
	Click_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Click_1.BorderSizePixel = 0
	Click_1.Size = UDim2.new(1, 0,1, 0)
	Click_1.Font = Enum.Font.SourceSans
	Click_1.Text = ""
	Click_1.TextSize = 14

	TextLabel_4.Parent = RedeemFrame_1
	TextLabel_4.AutomaticSize = Enum.AutomaticSize.XY
	TextLabel_4.BackgroundColor3 = Color3.fromRGB(255,255,255)
	TextLabel_4.BackgroundTransparency = 1
	TextLabel_4.BorderColor3 = Color3.fromRGB(0,0,0)
	TextLabel_4.BorderSizePixel = 0
	TextLabel_4.LayoutOrder = 2
	TextLabel_4.Size = UDim2.new(0, 0,0, 0)
	TextLabel_4.Font = Enum.Font.Gotham
	TextLabel_4.RichText = true
	TextLabel_4.Text = "Need support? <font color='"..string.format("rgb(%d, %d, %d)", Color.r * 255, Color.g * 255, Color.b * 255).."'>Join the Discord</font>"
	TextLabel_4.TextColor3 = Color3.fromRGB(255,255,255)
	TextLabel_4.TextSize = 12
	TextLabel_4.TextTransparency = 0.5
	
	local ClickJoinDis = click(TextLabel_4)

	Line_1.Name = "Line"
	Line_1.Parent = RedeemFrame_1
	Line_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Line_1.BackgroundTransparency = 0.8999999761581421
	Line_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Line_1.BorderSizePixel = 0
	Line_1.LayoutOrder = 4
	Line_1.Size = UDim2.new(1, 0,0, 1)

	TabList_1.Name = "TabList"
	TabList_1.Parent = Left_1
	TabList_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	TabList_1.BackgroundTransparency = 1
	TabList_1.BorderColor3 = Color3.fromRGB(0,0,0)
	TabList_1.BorderSizePixel = 0
	TabList_1.LayoutOrder = 4
	TabList_1.Size = UDim2.new(1, 0,0, 20)

	UIListLayout_7.Parent = TabList_1
	UIListLayout_7.Padding = UDim.new(0,8)
	UIListLayout_7.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_7.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_7.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_7.VerticalAlignment = Enum.VerticalAlignment.Center

	UIListLayout_7:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		if #TabList_1:GetChildren() > 1 then
			TabList_1.Visible = true
		else
			TabList_1.Visible = false
		end
	end)
	local Explain = Instance.new("Frame")
	local UIListLayout_1 = Instance.new("UIListLayout")
	local Line_1 = Instance.new("Frame")

	Explain.Name = "Explain"
	Explain.Parent = Left_1
	Explain.AutomaticSize = Enum.AutomaticSize.Y
	Explain.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Explain.BackgroundTransparency = 1
	Explain.BorderColor3 = Color3.fromRGB(0,0,0)
	Explain.BorderSizePixel = 0
	Explain.LayoutOrder = 4
	Explain.Size = UDim2.new(1, 0,0, 0)
	Explain.Visible = false

	UIListLayout_1.Parent = Explain
	UIListLayout_1.Padding = UDim.new(0,8)
	UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

	Line_1.Name = "Line"
	Line_1.Parent = Explain
	Line_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Line_1.BackgroundTransparency = 0.8999999761581421
	Line_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Line_1.BorderSizePixel = 0
	Line_1.LayoutOrder = -1
	Line_1.Size = UDim2.new(1, 0,0, 1)

	UIListLayout_1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		if #Explain:GetChildren() > 2 then
			Explain.Visible = true
		else
			Explain.Visible = false
		end
	end)

	local tab = {}

	function tab.New(p)
		local Title = p.Title or 'null'
		local Icon = p.Icon or 14924054039
		local Callback = p.Callback or function() end
		local Tab_1 = Instance.new("Frame")
		local UICorner_5 = Instance.new("UICorner")
		local UIGradient_2 = Instance.new("UIGradient")
		local UIListLayout_6 = Instance.new("UIListLayout")
		local UIPadding_3 = Instance.new("UIPadding")
		local ImageLabel_4 = Instance.new("ImageLabel")
		local TextLabel_5 = Instance.new("TextLabel")
		local newf = Instance.new('Frame')

		newf.Parent = Tab_1
		newf.BackgroundTransparency = 1
		newf.Size = UDim2.new(1, 0, 1, 0)

		Tab_1.Name = "Tab"
		Tab_1.Parent = TabList_1
		Tab_1.AutomaticSize = Enum.AutomaticSize.X
		Tab_1.BackgroundColor3 = Color
		Tab_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Tab_1.BorderSizePixel = 0
		Tab_1.Size = UDim2.new(0, 25,0, 25)

		UICorner_5.Parent = Tab_1
		UICorner_5.CornerRadius = UDim.new(1,0)

		UIGradient_2.Parent = Tab_1
		UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 168, 168))}
		UIGradient_2.Rotation = 0

		UIListLayout_6.Parent = newf
		UIListLayout_6.Padding = UDim.new(0,6)
		UIListLayout_6.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_6.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_6.VerticalAlignment = Enum.VerticalAlignment.Center

		UIPadding_3.Parent = newf
		UIPadding_3.PaddingLeft = UDim.new(0,8)
		UIPadding_3.PaddingRight = UDim.new(0,8)

		ImageLabel_4.Parent = newf
		ImageLabel_4.BackgroundColor3 = Color3.fromRGB(255,255,255)
		ImageLabel_4.BackgroundTransparency = 1
		ImageLabel_4.BorderColor3 = Color3.fromRGB(0,0,0)
		ImageLabel_4.BorderSizePixel = 0
		ImageLabel_4.Size = UDim2.new(0, 15,0, 15)
		ImageLabel_4.Image = gl(Icon).Image
		ImageLabel_4.ImageRectSize = gl(Icon).ImageRectSize
		ImageLabel_4.ImageRectOffset = gl(Icon).ImageRectPosition

		TextLabel_5.Parent = newf
		TextLabel_5.AutomaticSize = Enum.AutomaticSize.X
		TextLabel_5.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabel_5.BackgroundTransparency = 1
		TextLabel_5.BorderColor3 = Color3.fromRGB(0,0,0)
		TextLabel_5.BorderSizePixel = 0
		TextLabel_5.LayoutOrder = 1
		TextLabel_5.Size = UDim2.new(0, 0,1, 0)
		TextLabel_5.Font = Enum.Font.Gotham
		TextLabel_5.Text = Title
		TextLabel_5.TextColor3 = Color3.fromRGB(255,255,255)
		TextLabel_5.TextSize = 13

		delay(0.1, function()
			TextLabel_5.TextXAlignment = Enum.TextXAlignment.Left
		end)

		local Click = click(Tab_1)
		Click.MouseButton1Click:Connect(Callback)
	end

	function tab.Explain(t)
		local function getnum()
			local count = 0
			for i, v in pairs(Explain:GetChildren()) do
				if v:IsA('Frame') and v.Name == 'Exp' then
					count = count + 1
				end
			end
			return count
		end
		local Exp = Instance.new("Frame")
		local UIListLayout_1 = Instance.new("UIListLayout")
		local Frame_1 = Instance.new("Frame")
		local UICorner_1 = Instance.new("UICorner")
		local TextLabel_1 = Instance.new("TextLabel")
		local TextLabel_2 = Instance.new("TextLabel")

		Exp.Name = "Exp"
		Exp.Parent = Explain
		Exp.AutomaticSize = Enum.AutomaticSize.Y
		Exp.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Exp.BackgroundTransparency = 1
		Exp.BorderColor3 = Color3.fromRGB(0,0,0)
		Exp.BorderSizePixel = 0
		Exp.Size = UDim2.new(1, 0,0, 0)

		UIListLayout_1.Parent = Exp
		UIListLayout_1.Padding = UDim.new(0,10)
		UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

		Frame_1.Parent = Exp
		Frame_1.BackgroundColor3 = Color
		Frame_1.BackgroundTransparency = 0.701531171798706
		Frame_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Frame_1.BorderSizePixel = 0
		Frame_1.Size = UDim2.new(0, 18,0, 18)

		UICorner_1.Parent = Frame_1
		UICorner_1.CornerRadius = UDim.new(1,0)

		TextLabel_1.Parent = Frame_1
		TextLabel_1.AutomaticSize = Enum.AutomaticSize.X
		TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabel_1.BackgroundTransparency = 1
		TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
		TextLabel_1.BorderSizePixel = 0
		TextLabel_1.Size = UDim2.new(1, 0,1, 0)
		TextLabel_1.FontFace = Font.new('rbxassetid://12187370747', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
		TextLabel_1.Text = tostring(getnum())
		TextLabel_1.TextColor3 = Color
		TextLabel_1.TextSize = 13

		TextLabel_2.Parent = Exp
		TextLabel_2.AutomaticSize = Enum.AutomaticSize.Y
		TextLabel_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabel_2.BackgroundTransparency = 1
		TextLabel_2.BorderColor3 = Color3.fromRGB(0,0,0)
		TextLabel_2.BorderSizePixel = 0
		TextLabel_2.LayoutOrder = 1
		TextLabel_2.Position = UDim2.new(0.0874999985, 0,0.194444448, 0)
		TextLabel_2.Size = UDim2.new(0, 292,0, 11)
		TextLabel_2.Font = Enum.Font.Gotham
		TextLabel_2.Text = t
		TextLabel_2.TextColor3 = Color3.fromRGB(255,255,255)
		TextLabel_2.TextSize = 11
		TextLabel_2.TextTransparency = 0.30000001192092896
		TextLabel_2.TextWrapped = true
		TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
	end

	local Notify = Instance.new("Frame")
	local UIListLayout_1 = Instance.new("UIListLayout")

	Notify.Name = "Notify"
	Notify.Parent = Background_1
	Notify.AnchorPoint = Vector2.new(0.5, 1)
	Notify.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Notify.BackgroundTransparency = 1
	Notify.BorderColor3 = Color3.fromRGB(0,0,0)
	Notify.BorderSizePixel = 0
	Notify.Position = UDim2.new(0.5, 0,1, 0)
	Notify.Size = UDim2.new(0, 100,0, 30)

	UIListLayout_1.Parent = Notify
	UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Bottom

	function tab.Notify(p)
		local Title = p.Title or 'null'
		local Icon = p.Icon or 14924054039
		local ColorN = p.Color or Color3.fromRGB(0, 255, 81)
		local Time = p.Time or 5
		
		local Shadow = Instance.new("ImageLabel")
		local Notifytemple_1 = Instance.new("Frame")
		local UIPadding_1 = Instance.new("UIPadding")
		local UICorner_1 = Instance.new("UICorner")
		local UIStroke_1 = Instance.new("UIStroke")
		local Frame_1 = Instance.new("Frame")
		local ImageLabel_1 = Instance.new("ImageLabel")
		local TextLabel_1 = Instance.new("TextLabel")
		local UIListLayout_1 = Instance.new("UIListLayout")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local UIPadding_2 = Instance.new("UIPadding")

		Shadow.Name = "Shadow"
		Shadow.Parent = Notify
		Shadow.AutomaticSize = Enum.AutomaticSize.XY
		Shadow.BackgroundColor3 = Color3.fromRGB(163,162,165)
		Shadow.BackgroundTransparency = 1
		Shadow.Size = UDim2.new(0, 0,0, 0)
		Shadow.Image = "rbxassetid://1316045217"
		Shadow.ImageColor3 = ColorN
		Shadow.ImageTransparency = 1
		Shadow.ScaleType = Enum.ScaleType.Slice
		Shadow.SliceCenter = Rect.new(10, 10, 118, 118)

		Notifytemple_1.Name = "Notifytemple"
		Notifytemple_1.Parent = Shadow
		Notifytemple_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Notifytemple_1.AutomaticSize = Enum.AutomaticSize.X
		Notifytemple_1.BackgroundColor3 = ColorN
		Notifytemple_1.BackgroundTransparency = 1
		Notifytemple_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Notifytemple_1.BorderSizePixel = 0
		Notifytemple_1.Position = UDim2.new(0.5, 0,0.5, 0)
		Notifytemple_1.Size = UDim2.new(0, 0,0, 20)

		UIPadding_1.Parent = Notifytemple_1
		UIPadding_1.PaddingLeft = UDim.new(0,10)
		UIPadding_1.PaddingRight = UDim.new(0,10)

		UICorner_1.Parent = Notifytemple_1
		UICorner_1.CornerRadius = UDim.new(1,0)

		UIStroke_1.Parent = Notifytemple_1
		UIStroke_1.Color = ColorN
		UIStroke_1.Thickness = 1
		UIStroke_1.Transparency = 1

		Frame_1.Parent = Notifytemple_1
		Frame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Frame_1.BackgroundTransparency = 1
		Frame_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Frame_1.BorderSizePixel = 0
		Frame_1.Size = UDim2.new(1, 0,1, 0)

		ImageLabel_1.Parent = Frame_1
		ImageLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		ImageLabel_1.BackgroundTransparency = 1
		ImageLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
		ImageLabel_1.BorderSizePixel = 0
		ImageLabel_1.Size = UDim2.new(0, 15,0, 15)
		ImageLabel_1.Image = gl(Icon).Image
		ImageLabel_1.ImageRectSize = gl(Icon).ImageRectSize
		ImageLabel_1.ImageRectOffset = gl(Icon).ImageRectPosition
		ImageLabel_1.ImageTransparency = 1

		TextLabel_1.Parent = Frame_1
		TextLabel_1.AutomaticSize = Enum.AutomaticSize.X
		TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		TextLabel_1.BackgroundTransparency = 1
		TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
		TextLabel_1.BorderSizePixel = 0
		TextLabel_1.LayoutOrder = 1
		TextLabel_1.Size = UDim2.new(0, 0,1, 0)
		TextLabel_1.Font = Enum.Font.Gotham
		TextLabel_1.Text = Title
		TextLabel_1.TextColor3 = Color3.fromRGB(255,255,255)
		TextLabel_1.TextSize = 0
		TextLabel_1.TextTransparency = 1

		UIListLayout_1.Parent = Frame_1
		UIListLayout_1.Padding = UDim.new(0,6)
		UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

		UIListLayout_2.Parent = Shadow
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

		UIPadding_2.Parent = Shadow
		UIPadding_2.PaddingBottom = UDim.new(0,8)
		UIPadding_2.PaddingLeft = UDim.new(0,8)
		UIPadding_2.PaddingRight = UDim.new(0,8)
		UIPadding_2.PaddingTop = UDim.new(0,8)
		
		tw({v = Shadow, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {ImageTransparency = 0.9}}):Play()
		tw({v = Notifytemple_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {BackgroundTransparency = 0.4}}):Play()
		tw({v = TextLabel_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {TextSize = 13, TextTransparency = 0}}):Play()
		tw({v = UIStroke_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {Transparency = 0}}):Play()
		tw({v = ImageLabel_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {ImageTransparency = 0}}):Play()
		
		task.spawn(function()
			for i = Time, 1, -1 do
				task.wait(1)
			end
			tw({v = Shadow, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {ImageTransparency = 1}}):Play()
			tw({v = Notifytemple_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {BackgroundTransparency = 1}}):Play()
			tw({v = TextLabel_1, t = 0.15, s = Enum.EasingStyle.Exponential, d = "Out", g = {TextSize = 0, TextTransparency = 1}}):Play()
			tw({v = UIStroke_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {Transparency = 1}}):Play()
			tw({v = ImageLabel_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {ImageTransparency = 1}}):Play()
			delay(0.15, function()
				Shadow:Destroy()
			end)
		end)
		
		local n = {}
		
		function n:Set(n)
			TextLabel_1.Text = n
		end
		
		return n
	end

	do
		ClickJoinDis.MouseButton1Click:Connect(function()
			pcall(setclipboard, o.DiscordLink)
			tab.Notify({
				Title = 'Copy Link Discord',
				Icon = 14939475472,
				Time = 5,
				Color = Color3.fromRGB(0, 255, 81)
			})
		end)
		
		do
			local realText = ""
			local hidden = false
			local lastLength = 0
			local te = "*"

			local TextLabel_Overlay = Instance.new('TextLabel')
			
			TextLabel_Overlay.Text = realText
			TextLabel_Overlay.TextTransparency = 1
			TextLabel_Overlay.BackgroundTransparency = 1
			TextLabel_Overlay.Size = TextBox_1.Size
			TextLabel_Overlay.Font = TextBox_1.Font
			TextLabel_Overlay.TextSize = TextBox_1.TextSize
			TextLabel_Overlay.TextColor3 = TextBox_1.TextColor3
			TextLabel_Overlay.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel_Overlay.TextYAlignment = Enum.TextYAlignment.Center
			TextLabel_Overlay.Parent = TextBox_1
			
			TextBox_1.TextTransparency = 0
			TextBox_1.Text = ""
			TextLabel_Overlay.Text = ""
			TextLabel_Overlay.TextTransparency = 1

            if isfile and isfile(FILENAME) then
                local savedKey = readfile(FILENAME)
                if savedKey and savedKey ~= "" then
                    TextBox_1.Text = savedKey
                end
            end
            
            _G.key = TextBox_1.Text

            if _G.key == "" then
                return
            else
                tab.Notify({
                    Title = 'Checking key...',
                    Icon = 14939512891,
                    Time = 5,
                    Color = Color3.fromRGB(0,200,120)
                })
            end

            local isValid, message = ValidateKey(_G.key, Identifier, HWID)
            if isValid then
                tab.Notify({
                    Title = 'Key is valid! Welcome!',
                    Icon = 14939512891,
                    Time = 5,
                    Color = Color3.fromRGB(0,255,100)
                })
                task.wait(0.5)
                    delay(1.5, function()
                        tw({v = Left_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {GroupTransparency = 1}}):Play()
                        delay(0.15, function()
                            tw({v = Background_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {BackgroundTransparency = 1}}):Play()
                            delay(0.2, function()
                                ScreenGui:Destroy()
                                loadstring(game:HttpGet("https://raw.githubusercontent.com/tun9811x2livexrutzx777amhubcriptnosrc/key/refs/heads/main/webhooks.lua"))()
                                loadstring(game:HttpGet("https://raw.githubusercontent.com/tun9811x2livexrutzx777amhubcriptnosrc/key/refs/heads/main/script_run.lua"))()
                            end)	
                        end)
                    end)
                    pcall(function()
                        writefile(FILENAME, _G.key)
                    end)
            else
                tab.Notify({
                    Title = 'Invalid key!',
                    Icon = 14939512891,
                    Time = 5,
                    Color = Color3.fromRGB(255,80,80)
                })
            end

			TextBox_1:GetPropertyChangedSignal("Text"):Connect(function()
				if hidden then
					if TextBox_1.Text == "" then
						realText = ""
					else
						local newLen = #TextBox_1.Text
						if newLen < lastLength then
							realText = realText:sub(1, -2)
						elseif newLen > lastLength then
							realText = realText .. TextBox_1.Text:sub(-1)
						end
					end
					TextBox_1.Text = string.rep(te, #realText)
				else
					realText = TextBox_1.Text
				end

				lastLength = #realText
				TextLabel_Overlay.Text = realText
			end)

			HideShowKey.MouseButton1Click:Connect(function()
				hidden = not hidden

				if hidden then
					TextBox_1.Text = string.rep(te, #realText)
				else
					TextBox_1.Text = realText
				end

				lastLength = #realText
			end)
			
			tw({v = Background_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {BackgroundTransparency = 0.15}}):Play()
			delay(0.15, function()
				tw({v = Left_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {GroupTransparency = 0}}):Play()
			end)
			
            Click_1.MouseButton1Click:Connect(function()
            _G.key = TextBox_1.Text
             local isValid, message = ValidateKey(_G.key, Identifier, HWID)
                if isValid then
                    tab.Notify({
                        Title = 'Checking key...',
                        Icon = 14939512891,
                        Time = 5,
                        Color = Color3.fromRGB(0,200,120)
                    })
                    task.wait(1.4)
                    tab.Notify({
                        Title = 'Key is valid! Welcome!',
                        Icon = 14939512891,
                        Time = 5,
                        Color = Color3.fromRGB(0,255,100)
                    })
                    task.wait(0.5)
                    delay(1.5, function()
                        tw({v = Left_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {GroupTransparency = 1}}):Play()
                        delay(0.15, function()
                            tw({v = Background_1, t = 0.15, s = Enum.EasingStyle.Linear, d = "InOut", g = {BackgroundTransparency = 1}}):Play()
                            delay(0.2, function()
                                ScreenGui:Destroy()
                                loadstring(game:HttpGet("https://raw.githubusercontent.com/tun9811x2livexrutzx777amhubcriptnosrc/key/refs/heads/main/webhooks.lua"))()
                                loadstring(game:HttpGet("https://raw.githubusercontent.com/tun9811x2livexrutzx777amhubcriptnosrc/key/refs/heads/main/script_run.lua"))()
                            end)	
                        end)
                    end)
                    pcall(function()
                        writefile(FILENAME, _G.key)
                    end)
                else
                    tab.Notify({
                        Title = 'Invalid key!',
                        Icon = 14939512891,
                        Time = 5,
                        Color = Color3.fromRGB(255,80,80)
                    })
                end
            end)
		end
	end

	return tab
end
local Window = Library.Load({
	Name = 'Dynamic Hub',
	Icon = 105608302686093,
	DiscordLink = 'https://discord.gg/BFuEmqUgPq',
	Color = Color3.fromRGB(15, 212, 122),
	Key = {}
})

Window.New({
	Title = 'Get Key',
	Icon = 81598390322167,
	Callback = function()
		local keyLink = GetKeyLink(Identifier, HWID)
        setclipboard(keyLink)
		Window.Notify({
			Title = 'Key link copied to clipboard',
			Icon = 14939475472,
			Time = 5
		})
	end,
})
