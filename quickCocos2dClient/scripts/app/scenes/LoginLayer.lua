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

	--ttf
	-- local labelTTF = ui.newTTFLabel({  
 --        text 	= "",  
 --        size 	= 25,  
 --        color	= ccc3(255, 0, 0),  
 --        x 		= display.cx,   
 --        y 		= display.height*0.65  
  
 --    })  
 --    self:addChild(labelTTF)  

	--clicked join
	local function onClicked(tag)  
        if tag == 1 then  
        	local nextScene = require("app.scenes.ChatScene"):new()
        	local kEffect = {"splitCols","splitRows"}
        	local transtion = display.wrapSceneWithTransition(nextScene,kEffect[math.random(1,table.nums(kEffect))],.5)
   			display.replaceScene(transtion)
 

   --          if string.len(self.nameEditBox:getText()) < 5 then
			-- 	labelTTF:setString(tostring("用户名至少5位字符"))
			-- 	--labelTTF.test
			-- 	return
			-- end

			-- if self.passEditBox:getText() == "" then
			-- 	labelTTF:setString(tostring("请输入密码"))
			-- 	return
			-- end

			-- require "app.scenes.protobuf"
   --  		protobuf.register_file "./scripts/app/scenes/person.pb"

   -- 			stringbuffer = protobuf.encode("Person",
   --                 		{
   --                    		id = 12345,
   --                    		name = "Alice",
   --                    		email ="112323",
   --                 		 })

   -- 			result = protobuf.decode("Person", stringbuffer)
   -- 			print("result="..result.id,result.name,result.email)

			-- self.setMessageName("Messages." .. messageType .. "Request")
			-- self.setMessageData(messageData)

			-- local url = ""
			-- local request = network.createHTTPRequest(onRequestFinished, url, "POST")

			-- local buffer = protobuf.encode(self.messageName, self.messageData)

			-- local http = CCHTTPRequest:createWithUrl(
			-- 	callBack, self.url .. "/" .. messageType, 1)

			-- http:setPOSTData(buffer, string.len(buffer))
			-- http:start() 


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


function onRequestFinished(event)
    local ok = (event.name == "completed")
    local request = event.request
 
    if not ok then
        -- 请求失败，显示错误代码和错误消息
        print(request:getErrorCode(), request:getErrorMessage())
        return
    end
 
    local code = request:getResponseStatusCode()
    if code ~= 200 then
        -- 请求结束，但没有返回 200 响应代码
        print(code)
        return
    end
 
    -- 请求成功，显示服务端返回的内容
    local response = request:getResponseString()
    print(response)
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