require("app.scenes.LoadingLayer")
local LoadingScene = class("LoadingScene", function()
    return display.newScene("LoadingScene")
end)

local loading_layer_ = nil 

function LoadingScene:ctor()
    self:init()
end

function LoadingScene:init()
	local loadingLayer=LoadingLayer:instance()
	local loadingLayer=LoadingLayer:instance()
	loadingLayer:new()
    self:addChild(loadingLayer:getLayer())
end

return LoadingScene