

local ChatLayer = class("ChatLayer", function()
    return display.newNode("ChatLayer")
end)

-- package.cpath = "luaclib/?.so"
-- package.path  = "lualib/?.lua;examples/?.lua"
-- local socket = require "clientsocket"
-- local bit32 = require "bit32"
-- local proto = require "proto"
-- local sproto = require "sproto"


-- local host = sproto.new(proto.s2c):host "package"
-- local request = host:attach(sproto.new(proto.c2s))

-- local fd = assert(socket.connect("127.0.0.1", 8888))

local chatList      = nil 
local contentHeight = display.height/13
local ClippingRect  = nil 
local maxLen        = nil
local maxChatIndex  = 1
local curX = display.cx
local curY = display.height
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


  chatList = display.newNode()
  local rect = CCRect(0,display.height*0.2,display.width,display.height)
  local ClippingRect = display.newClippingRegionNode(rect)
  self:addChild(ClippingRect,4)
  ClippingRect:addChild(chatList,1)
  maxLen = 4400

	local function onClicked(tag)  
        if tag == 1 then  
        	--print("sdsdd")
        	--print("xxx",self.chatEditBox:getText())
          local text = self.chatEditBox:getText()
          curY = curY - contentHeight
          chatList:addChild(self:createTTFLabel(text,curX,curY))
          --maxChatIndex
        	
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

  -- local curX = display.cx
  -- local curY = display.height
  -- local label={}
  -- for i=1,10 do
  --     local text =i .. "Hello, World 您好，世界111111111111111111"
  --     curY = curY - contentHeight
  --   	chatList:addChild(self:createTTFLabel(text,curX,curY))
  -- end

end

function ChatLayer:createTTFLabel(text,posx,posy)

    local label = ui.newTTFLabel({
          text  = text,
          font  = "Arial",
          size  = 15,
          color = ccc3(0, 255, 255), 
          dimensions = CCSize(display.width-20, 20)
       })

    label:setPosition(ccp(posx,posy))
    return label
end

function ChatLayer:setListPositionY(value)
	local scale = ( maxLen - chatList:getPositionY() ) * value
	chatList:setPositionY(scale)

end



return ChatLayer