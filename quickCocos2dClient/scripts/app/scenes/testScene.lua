local LoginScene = class("LoginScene", function()
    return display.newScene("LoginScene")
end)

local login_layer_ = nil 

function LoginScene:ctor()
    self:init()
end

function LoginScene:init()
	login_layer_ = require("app.scenes.LoginLayer"):new()
    self:addChild(login_layer_)
end

return LoginScene

