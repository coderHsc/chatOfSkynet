
local ChatScene = class("ChatScene", function()
    return display.newScene("ChatScene")
end)

local chat_layer_ = nil 

function ChatScene:ctor()
    self:init()
end

function ChatScene:init()
	require("app.scenes.ChatLayer")
	chat_layer_ = ChatLayer:instance()
	ChatLayer:new()

    self:addChild(chat_layer_:getLayer())
end

function ChatScene:getChatLayer()
   return chat_layer_
end


return ChatScene