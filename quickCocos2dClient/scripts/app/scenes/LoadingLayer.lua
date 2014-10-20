local LoadingLayer = class("LoadingLayer", function()
    return display.newNode("LoadingLayer")
end)

function LoadingLayer:ctor()
	local back = display.newSprite("HelloWorld.png")
	back:setPosition(ccp(display.cx ,display.cy ))
	self:addChild(back)
	self:initTimerRenderer("hp.png","hp_bg.png")

end


function LoadingLayer:initTimerRenderer(resHp, resBg)
	
	self.hpStep = CCProgressTimer:create(display.newSprite(resHp))
	local hpBg  = CCProgressTimer:create(display.newSprite(resBg))
	

	--self.bloodRenderer = display.newNode()
    --self:setupActorNode(self.bloodRenderer)

	local fPercentage = 100
	hpBg:setType(kCCProgressTimerTypeBar)
	hpBg:setMidpoint(ccp(0, 0))
	hpBg:setBarChangeRate(ccp(1, 0))
	hpBg:setPercentage(fPercentage)
    hpBg:setAnchorPoint(ccp(0, 0.5))
    hpBg:setPosition(ccp(200, 200))
	--self.bloodRenderer:addChild(hpBg)

	local currHp = 0
	self.hpStep:setType(kCCProgressTimerTypeBar)
	self.hpStep:setMidpoint(ccp(0, 0))
	self.hpStep:setBarChangeRate(ccp(1, 0))
    self.hpStep:setAnchorPoint(ccp(0, 0.5))
	self.hpStep:setPercentage(100 /  100 * 100)
	self.hpStep:setPosition(ccp(200, 200))

	self:addChild(hpBg,2)
	self:addChild(self.hpStep,3)
	--self.bloodRenderer:addChild(self.hpStep)
end
return LoadingLayer