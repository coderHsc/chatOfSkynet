
require("app.scenes.messageManager")
require "app.scenes.protobuf"
protobuf.register_file "res/talkbox.pb"

socketManager = {}

self = socketManager

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

    if messageId == 1008 then 
    	stringbuffer = protobuf.decode("talkbox.talk_create",msg)
    	print("socket receive raw data:", maxLen,version,messageId,stringbuffer.userid,stringbuffer.name)
    end
end

function socketManager:onStatus(__event)
    printInfo("socket status: %s", __event.name)
    -- local stringbuffer = protobuf.encode("talkbox.talk_create",
    --                 {
    --                   userid = 13,
    --                   name = "2",
                     
    --                 })
    -- local message = messageManager.getProcessMessage (1,1003,stringbuffer)
    -- self._socket:send(message:getPack())
end