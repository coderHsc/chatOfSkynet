
require("app.scenes.messageManager")
require("app.scenes.socketManager")
-- local ChatLayer = class("ChatLayer", function()
--     return display.newNode("ChatLayer")
-- end)
ChatLayer={}


local chatList      = nil 
local contentHeight = display.height/13
local ClippingRect  = nil 
local maxLen        = nil
local maxChatIndex  = 1
local curX = display.cx
local curY = display.height

function ChatLayer:instance()
  local o = _G.ChatLayer  
    if o then return o end  
    o = {}  
    _G.ChatLayer = o  
    setmetatable(o, self)  
    self.__index = self  
    return o  

end
function ChatLayer:new()

  self.chatLayer = display.newNode("ChatLayer")
  self.id = nil 
  self.name =nil
  self.chatList = nil 
	local back = display.newSprite("HelloWorld.png")
	back:setPosition(ccp(display.cx ,display.cy ))
	self.chatLayer:addChild(back)
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
	self.chatLayer:addChild(self.chatEditBox)


  chatList = display.newNode()
  local rect = CCRect(0,display.height*0.2,display.width,display.height)
  local ClippingRect = display.newClippingRegionNode(rect)
  self.chatLayer:addChild(ClippingRect,4)
  ClippingRect:addChild(chatList,1)
  maxLen = 4400

	local function onClicked(tag)  
        if tag == 1 then  
          local text = self.chatEditBox:getText()
          curY = curY - contentHeight
          chatList:addChild(self:createTTFLabel(text,curX,curY))

          self:sendMsg(text)
          
          ---------------------------------------------------------------------
          -- stringbuffer = protobuf.encode("talkbox.talk_message",
          --           {
          --             fromuserid = 7,
          --             touserid =7,
          --             msg = text,
          --           })
          -- --print("self.nameEditBox:getText()",self.nameEditBox:getText())
          -- local message = messageManager:getProcessMessage(1,1005,stringbuffer)
          -- socketManager:sendMessage(message)
          -----------------------------------------------------------------------
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
	self.chatLayer:addChild(menu)  

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
        :addTo(self.chatLayer)

  --chat list 

  -- local curX = display.cx
  -- local curY = display.height
  -- local label={}
  -- for i=1,10 do
  --     local text =i .. "Hello, World 您好，世界111111111111111111"
  --     curY = curY - contentHeight
  --   	chatList:addChild(self:createTTFLabel(text,curX,curY))
  -- end

  -----------------------------------------------------------
       -- stringbuffer = protobuf.encode("talkbox.talk_create",
       --             {
       --               userid = 1,
       --               name = tostring("zhangsan"),
      --              })
       -- local message = messageManager:getProcessMessage(1,1003,stringbuffer)
       -- socketManager:sendMessage(message)
        -----------------------------------------------------------

end

function ChatLayer:getLayer()
  return self.chatLayer 
end

function ChatLayer:getChatList()

   stringbuffer = protobuf.encode("talkbox.talk_users.talk_user",
    {
        userid = self.id,
        name   = self.name,
    })
   local message = messageManager:getProcessMessage(1,1001,stringbuffer)
   socketManager:sendMessage(message)


end

function ChatLayer:sendMsg(text)
    
    -- self:getChatList()
    -- if self.chatList ~= nil then 
    --   for k,v in pairs(self.chatList) do 
    --     print("ChatLayer:sendMsg",v.userid,v.name)

        print("xxxxxxxxxxxxx",text,DataManager.getId())
          local str = protobuf.encode("talkbox.talk_message",
           {
              touserid = -1,
              msg = "hello world",
              fromuserid = DataManager.getId(),
            
            })
          local message = messageManager:getProcessMessage(1,1005,str)
      
          socketManager:sendMessage(message)
      

          print("send over",message)
    --   end
    -- end

end

function ChatLayer:updateChatList(chatList)
    self.chatList = chatList

end

function ChatLayer:createText(text)

  print("create text",text)
   self.name = DataManager.getName()
   if self.name ~= nil then 
      curY = curY - contentHeight
      local str = self.name .. ":" .. text 
      chatList:addChild(self:createTTFLabel(str,curX,curY))

    end
end

function ChatLayer:setId(id)

  print("selfId",id)
  self.id = id

end

function ChatLayer:setName( name )
   self.name = name 
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



--return ChatLayer