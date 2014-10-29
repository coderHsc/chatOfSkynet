
require("app.scenes.messageManager")

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


	require "app.scenes.protobuf"
   	protobuf.register_file "res/talkbox.pb"

	if not self._socket then
        self._socket = cc.net.SocketTCP.new("192.168.106.134", 10101, false)
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CONNECTED, handler(self, self.onStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CLOSE, handler(self,self.onStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CLOSED, handler(self,self.onStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self,self.onStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_DATA, handler(self,self.onData))
    end
    self._socket:connect()

	--ttf
	local labelTTF = ui.newTTFLabel({  
        text 	= "",  
        size 	= 25,  
        color	= ccc3(255, 0, 0),  
        x 		= display.cx,   
        y 		= display.height*0.65  
  
    })  
    self:addChild(labelTTF)  

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
   			stringbuffer = protobuf.encode("talkbox.talk_create",
                    {
                      userid = 1,
                      name = self.nameEditBox:getText(),
                    })
   			local message = messageManager.getProcessMessage(1,1003,stringbuffer)

    		self._socket:send(message:getPack())

        	local nextScene = require("app.scenes.ChatScene"):new()
        	local kEffect = {"splitCols","splitRows"}
        	local transtion = display.wrapSceneWithTransition(nextScene,kEffect[math.random(1,table.nums(kEffect))],.5)
   			display.replaceScene(transtion)
 
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
function LoginLayer:onData(__event)
    local maxLen,version,messageId,msg = messageManager.unpackMessage(__event.data)
    print("socket receive raw data:", maxLen,version,messageId,msg)
end

function LoginLayer:onStatus(__event)
    printInfo("socket status: %s", __event.name)
    -- local stringbuffer = protobuf.encode("talkbox.talk_create",
    --                 {
    --                   userid = 13,
    --                   name = "2",
                     
    --                 })
    -- local message = messageManager.getProcessMessage (1,1003,stringbuffer)
    -- self._socket:send(message:getPack())
end


return LoginLayer