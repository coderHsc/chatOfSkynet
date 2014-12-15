
require("app.scenes.messageManager")
require "app.scenes.protobuf"
require("app.scenes.ChatScene")
require("app.scenes.DataManager")
local Scheduler = require("framework.scheduler")

protobuf.register_file "res/talkbox.pb"

socketManager = {}

self = socketManager
local nextScene = nil 
function socketManager:initSocket() 
	if not self._socket then
        self._socket = cc.net.SocketTCP.new("192.168.106.134", 10101, false)
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CONNECTED, handler(self, self.onStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CLOSE, handler(self,self.onStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CLOSED, handler(self,self.onStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self,self.onStatus))
        self._socket:addEventListener(cc.net.SocketTCP.EVENT_DATA, handler(self,self.onData))
    end
    self._socket:connect()
    
end

function socketManager:sendMessage(msg)
    self._socket:send(msg:getPack())
end

function socketManager:onData(__event)
    local maxLen,version,messageId,msg = messageManager:unpackMessage(__event.data)

    print("messageId",messageId)
    if messageId == 0 then 
        
    	print("socket receive raw data:", msg)
        if nextScene~=nil then 
            nextScene:getChatLayer():createText(msg)
        end

    elseif messageId == 1000 then 
        local stringbuffer = protobuf.decode("talkbox.talk_result",msg)

        print("stringbuffer.id",stringbuffer.id)

        if stringbuffer.id==10 then
            print("创建用户成功")
            nextScene = require("app.scenes.ChatScene"):new()
            local kEffect = {"splitCols","splitRows"}
            print("self.nextScene",nextScene)
            local transtion = display.wrapSceneWithTransition(nextScene,kEffect[math.random(1,table.nums(kEffect))],.5)
            display.replaceScene(transtion)
            --self.nextScene:getChatLayer():createText("新用户进来")
            --self.nextScene:getChatLayer():getChatList()

        elseif stringbuffer.id==1 then 
            print("服务端解析请求创建用户的protocbuf失败")
        elseif stringbuffer.id==2 then
            print("创建用户失败，名字已经存在")

        elseif  stringbuffer.id==3 then
            print("服务端解析请求发送内容的protocbuf失败")
        end

    elseif messageId == 1002 then 
        local stringbuffer = protobuf.decode("talkbox.talk_users",msg)

        for k , v in pairs(stringbuffer.users) do
            print("vvvvvvvvvvv",v.userid,v.name)
        end
        
        nextScene:getChatLayer():updateChatList(stringbuffer.users)

    elseif messageId == 1010 then 

      
        local stringbuffer = protobuf.decode("talkbox.talk_message",msg)

        print("stringbufferstringbuffer",stringbuffer.msg,nextScene)

        nextScene:getChatLayer():createText(stringbuffer.msg)

    elseif messageId ==1008 then 
    	local stringbuffer = protobuf.decode("talkbox.talk_create",msg)
       

    	print("socket receive raw data:", maxLen,version,messageId,stringbuffer.userid,stringbuffer.name)
    end


end

function socketManager:onStatus(__event)
    print("socket status: %s", __event.name)
    -- local stringbuffer = protobuf.encode("talkbox.talk_create",
    --                 {
    --                   userid = 13,
    --                   name = "2",
                     
    --                 })
    -- local message = messageManager.getProcessMessage (1,1003,stringbuffer)
    -- self._socket:send(message:getPack())
end