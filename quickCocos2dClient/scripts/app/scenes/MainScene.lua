
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    ui.newTTFLabel({text = "Hello, World", size = 64, align = ui.TEXT_ALIGN_CENTER})
        :pos(display.cx, display.cy)
        :addTo(self)
          
    require "app.scenes.protobuf"
    protobuf.register_file "./scripts/app/scenes/person.pb"

   	stringbuffer = protobuf.encode("Person",
                   {
                      id = 12345,
                      name = "Alice",
                      email ="112323",
                    })

   	result = protobuf.decode("Person", stringbuffer)
   	print("result="..result.id,result.name,result.email)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
