local LoadingScene = class("LoadingScene", function()
    return display.newScene("LoadingScene")
end)

local loading_layer_ = nil 

function LoadingScene:ctor()
    self:init()
end

function LoadingScene:init()
	loading_layer_ = require("app.scenes.LoadingLayer"):new()
    self:addChild(loading_layer_)
end

return LoadingScene