
cc.utils                = require("framework.cc.utils.init")
cc.net                  = require("framework.cc.net.init")

local ByteArray = require("framework.cc.utils.ByteArray")

messageManager = {}

function messageManager:getProcessMessage(version,messageId,protobufMessage)
    local packA = string.pack(">hiz",version,messageId,stringbuffer)
    local byteArrayA = ByteArray.new()
    byteArrayA:writeBuf(packA)
    local packAlen = byteArrayA:getLen()

    local packB = string.pack(">hhiz",packAlen,version,messageId,stringbuffer)
    local byteArrayB = ByteArray.new()
    byteArrayB:writeBuf(packB)
    return byteArrayB
end
-- #define OP_ZSTRING  'z'     /* zero-terminated string */
-- #define OP_BSTRING  'p'     /* string preceded by length byte */
-- #define OP_WSTRING  'P'     /* string preceded by length word */
-- #define OP_SSTRING  'a'     /* string preceded by length size_t */
-- #define OP_STRING   'A'     /* string */
function messageManager:unpackMessage(message)
    local nextPos1,maxLen    = string.unpack(message,">h")
    local nextPos2,version   = string.unpack(message,">h",nextPos1)
    local nextPos3,messageId = string.unpack(message,">i",nextPos2)
    local nextPos4,msg       = string.unpack(message,">z",nextPos3,maxLen)

    return maxLen,version,messageId,msg

end

