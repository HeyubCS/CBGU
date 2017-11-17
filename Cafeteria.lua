local composer = require( "composer" )
local physics = require("physics")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local objects = {}; -- A list of objects.
local points; -- A sum of possitive and negative objects.


local function positiveObject(event)
	points = points + 1;
end

local function negativeObject(event)
	points = points - 1;
end

local function createObject()
	local o = math.random(1, 6); -- Object
	local theObject;
	theObject = display.newRect(math.random(200, display.contentWidth-200), display.contentHeight + 100, 50,50)
	theObject:setFillColor(math.random(), math.random(), math.random())

	physics.addBody(theObject, "dynamic", {isSensor = true})
	theObject:setLinearVelocity(math.random(-100,100), -150 * math.random(4,6));


	if(o == 1) then
		theObject:setFillColor(1,1,0)
		theObject:addEventListener("tap", negativeObject)
	elseif(o == 2) then
		theObject:setFillColor(0,0,1)
		theObject:addEventListener("tap", positiveObject)
	elseif(o == 3) then
		theObject:setFillColor(1,0,0)
		theObject:addEventListener("tap", negativeObject)
	elseif(o == 4) then
		theObject:setFillColor(0,1,0)
		theObject:addEventListener("tap", positiveObject)
	elseif(o == 5) then
		theObject:setFillColor(1,.5,.5)
		theObject:addEventListener("tap", negativeObject)
	elseif(o == 6) then
		theObject:setFillColor(1,0,1)
		theObject:addEventListener("tap", positiveObject)
	--elseif(o == 7) then
	--elseif(o == 8) then
	--elseif(o == 9) then
	--elseif(o == 10) then
	else
	end
	--return theObject;
	local function kill()
		display.remove(theObject);
	end
	timer.performWithDelay(1000 * 10 , kill);
end

local function gameOver(event)
	-- Game over things.
end

local function startGame()
	timer.performWithDelay((1000 * 60) * 2, gameOver); -- This game is timed.
	--timer.performWithDelay((100 * math.random(1,20), )

end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    physics.start();
    timer.performWithDelay(800 * math.random(2,4), createObject, 0)
    -- Code here runs when the scene is first created but has not yet appeared on screen

end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
