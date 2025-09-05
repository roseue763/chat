--// Roblox Private Chat (Safe Version)
--// Delta exploit, Luau

local HttpService = game:GetService("HttpService")
local webhook = https://discord.com/api/webhooks/1413464159861080064/ku9BGJdeIBpOtoQEfrrk_naYkJ6oCoe4aGAlENr3oc6OUWjRuRQFNf9jQq9Q3sJZxIt7"  -- رابط Webhook خاص بك

--// GUI Setup
local player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Position = UDim2.new(0, 10, 0.4, 0)
Frame.Size = UDim2.new(0.3, 0, 0.4, 0)

local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 5)
ScrollingFrame.Size = UDim2.new(1, -10, 0.75, -10)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local TextBox = Instance.new("TextBox", Frame)
TextBox.Position = UDim2.new(0, 5, 0.82, 0)
TextBox.Size = UDim2.new(1, -10, 0.15, -10)
TextBox.PlaceholderText = "Type your message..."
TextBox.Text = ""

--// Function: Add message to GUI
local function addMessage(msg)
    local label = Instance.new("TextLabel", ScrollingFrame)
    label.Size = UDim2.new(1, -10, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = msg
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end

--// Function: Send message to Discord
local function sendMessage(msg)
    local data = {["content"] = player.Name .. ": " .. msg}
    local json = HttpService:JSONEncode(data)
    syn.request({
        Url = webhook,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = json
    })
end

--// Send message on Enter
TextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and TextBox.Text ~= "" then
        sendMessage(TextBox.Text)
        TextBox.Text = ""
    end
end)

--// Fetch messages from Webhook every 5 seconds
spawn(function()
    while true do
        local success, response = pcall(function()
            return syn.request({Url = webhook .. "?limit=10", Method = "GET"})
        end)

        if success and response.Success then
            local messages = HttpService:JSONDecode(response.Body)
            ScrollingFrame:ClearAllChildren()
            UIListLayout.Parent = ScrollingFrame
            for i = #messages, 1, -1 do
                addMessage(messages[i].content)
            end
        end

        wait(5)  -- update every 5 seconds (safe)
    end
end)