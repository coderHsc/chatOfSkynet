local ChatScene = class("ChatScene", function()
    return display.newScene("ChatScene")
end)

local chat_layer_ = nil 

function ChatScene:ctor()
    
    self:init()
end

function ChatScene:init()
	
	chat_layer_ = require("app.scenes.ChatLayer"):new()
    self:addChild(chat_layer_)
end

return ChatScene