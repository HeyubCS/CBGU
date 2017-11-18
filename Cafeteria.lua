local composer = require( "composer" )
local physics = require("physics")
local backButtons = require("objects.menu_button")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local objects = {}; -- A list of objects.
local points = 0; -- A sum of possitive and negative objects.
local back_button;
local pointText;
-- All the foods
local apple = "arts/apple.png"
local cracker = "arts/cracker.png"
local sandwich = "arts/sandwich.png"
local candy = "arts/candy.png"
local spider = "arts/spider.png"
local spoon = "arts/spoon/png"
local fly = "arts/fly.png"
local grapes = "arts/grapes.png"

local function positiveObject(event)
	if(event.phase == "moved") then
		points = points + 1;
		display.remove(event.target);
		pointText.text = "Score: " .. points;
	end
end

local function negativeObject(event)
	if(event.phase == "moved") then
		points = points - 1;
		display.remove(event.target);
		pointText.text = "Score: " .. points;
	end
end

local function createObject()
	local n =  math.random(3,5)
	for i=1,n,1 do
		local theObject;
		local o = math.random(1, 6); -- Object
		theObject = display.newRect(math.random(200, display.contentWidth-200), display.contentHeight + 100, 100,100)
		theObject:setFillColor(math.random(), math.random(), math.random())

		physics.addBody(theObject, "dynamic", {isSensor = true})
		theObject:setLinearVelocity(math.random(-100,100), -150 * math.random(4,6));

		if(o == 1) then
			theObject:setFillColor(1,1,.5)
			theObject:addEventListener("touch", negativeObject)
		elseif(o == 2) then
			theObject:setFillColor(0,0,1)
			theObject:addEventListener("touch", positiveObject)
		elseif(o == 3) then
			theObject:setFillColor(1,0,0)
			theObject:addEventListener("touch", negativeObject)
		elseif(o == 4) then
			theObject:setFillColor(0,1,0)
			theObject:addEventListener("touch", positiveObject)
		elseif(o == 5) then
			theObject:setFillColor(1,.5,.5)
			theObject:addEventListener("touch", negativeObject)
		elseif(o == 6) then
			theObject:setFillColor(1,0,1)
			theObject:addEventListener("touch", positiveObject)
		--elseif(o == 7) then
		--elseif(o == 8) then
		--elseif(o == 9) then
		--elseif(o == 10) then
		else
		end
	end
	--return theObject;
	local function kill()
		display.remove(theObject);
	end
	timer.performWithDelay(1000 * 10 , kill);
end
local objectGenerator;
local function gameOver(event)
	-- Game over things.
	timer.cancel(objectGenerator);
	back_button.campus.isVisible = true;
	-- TODO: Add a button to return to campus.
end

local function startGame(bar)
	timer.performWithDelay(((1000 * 60) * 1) + 5000, gameOver); -- This game is timed.
	transition.to(bar, {x = 65, xScale = 0, time = (1000 * 60) * 1})
	objectGenerator = timer.performWithDelay(800 * math.random(2,4), createObject, 0)


end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    physics.start();
    --physics.setDrawMode("hybrid")
    local bg = display.newImage("arts/cafeteriaBG1.png", 360, 640)
    sceneGroup:insert(bg);
    local timeBar = display.newImage("arts/barfill.png", 355, 110)
    timeBar:scale(1.16,1.3)
    sceneGroup:insert(timeBar);
   	timeBar:toBack();
   	bg:toBack();
   	startGame(timeBar);
   	back_button = backButtons.newCampus();
	sceneGroup:insert(back_button.campus);
	back_button.campus.isVisible = false;

	pointText = display.newText("Score: 0", display.contentCenterX, 40, native.systemFont, 45)
	pointText:setFillColor(0,0,0)
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
