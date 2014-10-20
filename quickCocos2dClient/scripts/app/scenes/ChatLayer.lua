local ChatLayer = class("ChatLayer", function()
    return display.newNode("ChatLayer")
end)


local chatList      = nil 
local contentHeight = display.height/13
local ClippingRect  =nil 
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



	local function onClicked(tag)  
        if tag == 1 then  
        	print("sdsdd")
        	print("xxx",self.chatEditBox:getText())
        	
   		end

   	end
	--ttf
	local item = ui.newTTFLabelMenuItem({  
  		  text 		= "input",  
    		size 		= 18,
   			listener 	= onClicked,  
   		    x 			= display.width*0.92,  
  			y 			= display.height*0.1,
  			tag 		= 1 
	}) 

	local menu = ui.newMenu({item})  
	self:addChild(menu)  

  --
	--SliderBar
	local kImages = {
    	bar = "SliderBar.png",
    	button = "SliderBar.png",
	}
	local kSlider = cc.ui.UISlider.new(display.TOP_TO_BOTTOM, kImages, {scale9 = true})
        :onSliderValueChanged(function(event) 
            self:setListPositionY(event.value / 100)
        end)
        :setSliderSize(20, display.height-30)
        :setSliderValue(0)
        :align(display.CENTER_TOP, display.width - 20 , display.cy + display.height/2)
        :addTo(self)

  --chat list 



  chatList = display.newNode()
  local curX = display.cx
  local curY = display.height
  local label={}
  for i=1,20 do
    	 label = ui.newTTFLabel({
    		  text = i .. "Hello, World 您好，世界111111111111111111",
    		  font = "Arial",
		      size = 15,
		      color = ccc3(0, 255, 255), 
    		  dimensions = CCSize(display.width-20, 20)
		   })
    	 curY = curY-contentHeight
    	 label:setPosition(ccp(curX,curY))
    	 chatList:addChild(label)
  end

  local rect = CCRect(0,display.height*0.2,display.width,display.height)
  local ClippingRect = display.newClippingRegionNode(rect)
  self:addChild(ClippingRect,4)
  
  ClippingRect:addChild(chatList,1)
end


function ChatLayer:setListPositionY(value)
	local scale = ( kLength - self:getHeight()) * value
	--print("value : ",value,"scale : ",scale)
	chatList:setPositionY(scale)
	--self.myScale = scale
end



return ChatLayer