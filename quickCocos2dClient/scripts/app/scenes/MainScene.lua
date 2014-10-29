cc.utils                = require("framework.cc.utils.init")
cc.net                  = require("framework.cc.net.init")

local ByteArray = require("framework.cc.utils.ByteArray")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()

    ui.newTTFLabel({text = "Hello, World", size = 64, align = ui.TEXT_ALIGN_CENTER})
        :pos(display.cx, display.cy)
        :addTo(self)
          
    require "app.scenes.protobuf"
    protobuf.register_file "res/talkbox.pb"

   	stringbuffer = protobuf.encode("talkbox.talk_create",
                    {
                      userid = 12345,
                      name = "Alice",
                     
                    })
   	local result = protobuf.decode("talkbox.talk_create", stringbuffer)
    local phone = protobuf.pack("talkbox.talk_create userid name",1,"123") 
    number,name = protobuf.unpack("talkbox.talk_create userid name", phone)

    print("number",number,name)
    -- --创建一个请求，并以 POST 方式发送数据到服务端
    -- local url = "http://www.google.com/"
    -- local request = network.createHTTPRequest(onRequestFinished, url, 1,"POST")

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
function MainScene:unpackMessage(message)
    local nextPos1,maxLen    = string.unpack(message,">h")
    local nextPos2,version   = string.unpack(message,">h",nextPos1)
    local nextPos3,messageId = string.unpack(message,">i",nextPos2)
    local nextPos4,msg       = string.unpack(message,">z",nextPos3)

    return maxLen,version,messageId,msg

end

function MainScene:onData(__event)
    local maxLen,version,messageId,msg = self:unpackMessage(__event.data)
    print("socket receive raw data:", maxLen,version,messageId,msg)
end

function MainScene:getProcessMessage(version,messageId,protobufMessage)
    local packA = string.pack(">hiz",version,messageId,stringbuffer)
    local byteArrayA = ByteArray.new()
    byteArrayA:writeBuf(packA)
    local packAlen = byteArrayA:getLen()

    local packB = string.pack(">hhiz",packAlen,version,messageId,stringbuffer)
    local byteArrayB = ByteArray.new()
    byteArrayB:writeBuf(packB)
    return byteArrayB
end
--给服务器发送消息
function MainScene:onStatus(__event)
    printInfo("socket status: %s", __event.name)

    stringbuffer = protobuf.encode("talkbox.talk_create",
                    {
                      userid = 13,
                      name = "2",
                     
                    })
    local message = self:getProcessMessage (1,1003,stringbuffer)
    self._socket:send(message:getPack())
end
function onRequestFinished(event)
    local ok = (event.name == "completed")
    local request = event.request
 
    if not ok then
        -- 请求失败，显示错误代码和错误消息
        print("no ok")
        print(request:getErrorCode(), request:getErrorMessage())
        return
    end
 
    local code = request:getResponseStatusCode()
    if code ~= 200 then
        -- 请求结束，但没有返回 200 响应代码
        print(code)
        return
    end
    
    --print("succecc")
    -- 请求成功，显示服务端返回的内容
    local response = request:getResponseString()
    print(response)
end
 

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
