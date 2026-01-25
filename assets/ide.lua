--// IDEModule.lua
local IDEModule = {}
IDEModule.__index = IDEModule

local TextService = game:GetService("TextService")

function IDEModule.new(Config)
    local self = setmetatable({}, IDEModule)
    
    self.Text = Config.Text or ""
    self.Colors = Config.Colors or {
        Default = Color3.fromRGB(200, 200, 200),
        Keyword = Color3.fromRGB(248, 109, 124),
        String = Color3.fromRGB(173, 241, 149),
        Comment = Color3.fromRGB(100, 100, 100),
        Method = Color3.fromRGB(132, 214, 247)
    }
    
    self:CreateGui(Config)
    self:ApplySyntaxHighlighting()
    
    return self
end

function IDEModule:CreateGui(Config)
    local EditorFrame = Instance.new("ScrollingFrame")
    EditorFrame.Name = "CodeEditor"
    EditorFrame.Size = Config.Size or UDim2.fromScale(1, 1)
    EditorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    EditorFrame.BorderSizePixel = 0
    EditorFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    EditorFrame.AutomaticCanvasSize = Enum.AutomaticSize.XY

    local Display = Instance.new("TextLabel")
    Display.Name = "Display"
    Display.Size = UDim2.fromScale(1, 1)
    Display.BackgroundTransparency = 1
    Display.TextColor3 = self.Colors.Default
    Display.TextSize = Config.FontSize or 13
    Display.FontFace = Config.FontFace or Font.fromEnum(Enum.Font.Code)
    Display.TextXAlignment = Enum.TextXAlignment.Left
    Display.TextYAlignment = Enum.TextYAlignment.Top
    Display.RichText = true
    Display.Parent = EditorFrame

    self.Gui = EditorFrame
    self.Display = Display
end

function IDEModule:ApplySyntaxHighlighting()
    local RawText = self.Text
    
    local SafeText = RawText:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
    
    local Keywords = {"local", "function", "return", "if", "then", "else", "end", "nil", "true", "false"}
    
    for _, word in ipairs(Keywords) do
        SafeText = SafeText:gsub("%f[%a]"..word.."%f[%A]", function(match)
            return string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
                self.Colors.Keyword.R*255, self.Colors.Keyword.G*255, self.Colors.Keyword.B*255, match)
        end)
    end

    SafeText = SafeText:gsub('"(.-)"', function(match)
        return string.format('<font color="rgb(%d,%d,%d)">"%s"</font>', 
            self.Colors.String.R*255, self.Colors.String.G*255, self.Colors.String.B*255, match)
    end)

    SafeText = SafeText:gsub("%-%-(.*)\n", function(match)
        return string.format('<font color="rgb(%d,%d,%d)">--%s</font>\n', 
            self.Colors.Comment.R*255, self.Colors.Comment.G*255, self.Colors.Comment.B*255, match)
    end)

    self.Display.Text = SafeText
end

function IDEModule:SetText(NewText)
    self.Text = NewText
    self:ApplySyntaxHighlighting()
end

function IDEModule:GetText()
    return self.Text
end

return IDEModule
