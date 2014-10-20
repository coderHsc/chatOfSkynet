local ChatLayer = class("ChatLayer", function()
    return display.newNode("ChatLayer")
end)

function ChatLayer:ctor()
	local back = display.newSprite("HelloWorld.png")
	back:setPosition(ccp(display.cx ,display.cy ))
	self:addChild(back)
	self.chatEditBox = ui.newEditBox(
		{
			image    = "green_edit.png",
			listener = self.onEdit,
			size     = CCSize(400,20)
		}
	)
	self.chatEditBox:setInputFlag(1)
	self.chatEditBox:setPosition(ccp(display.cx*0.9 ,display.height*0.1))
	self.chatEditBox:setPlaceHolder("")
	self.chatEditBox:setPlaceholderFontColor(display.COLOR_WHITE)
	self.chatEditBox:setMaxLength(8)
	self.chatEditBox:setFont("Arial", 18)
	self:addChild(self.chatEditBox)



	--ttf
	local item = ui.newTTFLabelMenuItem({  
  		    text 		= "input",  
    		size 		= 18,
   			listener 	= onClicked,  
   		    x 			= display.width*0.9,  
  			y 			= display.height*0.1,
  			tag 		= 1 
	}) 

	local menu = ui.newMenu({item})  
	self:addChild(menu)  






end



return ChatLayer