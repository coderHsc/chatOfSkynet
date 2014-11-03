
require("app.scenes.messageManager")
require("app.scenes.socketManager")
require "app.scenes.protobuf"
protobuf.register_file "res/talkbox.pb"

local LoginLayer = class("LoginLayer", function()
    return display.newNode("LoginLayer")
end)

function LoginLayer:ctor()
	local back = display.newSprite("HelloWorld.png")
	back:setPosition(ccp(display.cx ,display.cy ))
	self:addChild(back)
	self.nameEditBox = ui.newEditBox(
		{
			image    = "green_edit.png",
			listener = self.onEdit,
			size     = CCSize(200,40)
		}
	)
	self.nameEditBox:setInputFlag(1)
	self.nameEditBox:setPosition(ccp(display.cx ,display.cy ))
	self.nameEditBox:setPlaceHolder("Name:")
	self.nameEditBox:setPlaceholderFontColor(display.COLOR_WHITE)
	self.nameEditBox:setMaxLength(8)
	self.nameEditBox:setFont("Arial", 18)
	self:addChild(self.nameEditBox)

	self.passEditBox = ui.newEditBox(
		{
			image    = "green_edit.png",
			listener = self.onEdit,
			size     = CCSize(200,40)
		}
	)
	self.passEditBox:setInputFlag(1)
	self.passEditBox:setPosition(ccp(display.cx ,display.cy-50 ))
	self.passEditBox:setPlaceHolder("Channel:")
	self.passEditBox:setPlaceholderFontColor(display.COLOR_WHITE);
	self.passEditBox:setMaxLength(8)
	self.passEditBox:setFont("Arial", 18);
	self:addChild(self.passEditBox)

	local labelTTF = ui.newTTFLabel({  
        text 	= "",  
        size 	= 25,  
        color	= ccc3(255, 0, 0),  
        x 		= display.cx,   
        y 		= display.height*0.65  
  
    })  
    self:addChild(labelTTF)  

    socketManager:initSocket()
	--clicked join
	local function onClicked(tag)  
        if tag == 1 then  

        	if string.len(self.nameEditBox:getText()) < 5 then
				labelTTF:setString(tostring("用户名至少5位字符"))
				return
			end

			if self.passEditBox:getText() == "" then
				labelTTF:setString(tostring("请输入密码"))
				return
			end
			--socketManager:initSocket()
			-----------------------------------------------------------
			-----------------------------------------------------------
   			stringbuffer = protobuf.encode("talkbox.talk_create",
                    {
                      userid = 4,
                      name = tostring(self.nameEditBox:getText()),
                    })
   			--print("self.nameEditBox:getText()",self.nameEditBox:getText())
   			local message = messageManager:getProcessMessage(1,1003,stringbuffer)
   			socketManager:sendMessage(message)



   			-----------------------------------------------------------
    	
        end
   
    end  

	local item = ui.newTTFLabelMenuItem({  
  		    text 		= "Join",  
    		size 		= 25,
   			listener 	= onClicked,  
   		    x 			= display.cx,  
  			y 			= display.height*0.15,
  			tag 		= 1 
	}) 

	local menu = ui.newMenu({item})  
	self:addChild(menu)  

end

function LoginLayer:onEdit(event, editbox)
	 if event == "began" then
	-- 开始输入
	elseif event == "changed" then
	-- 输入框内容发生变化
	elseif event == "ended" then
	-- 输入结束
	elseif event == "return" then
	-- 从输入框返回
	end
end

return LoginLayer