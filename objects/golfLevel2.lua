--[[
	golfLevels.lua 
	Created by Tristan Davis 11/11/17

	This file will hold all the level data for the various golf levels to be implemented
	in the cat berry greens. Much of the code is generated by gumbo.
		Last edited 11-16-17
]]


local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local putter = display.newCircle(0,0,600); -- used for putting
putter:setFillColor(0,0,0, .05)
putter:setStrokeColor(1,0,0, .5)
putter.strokeWidth = 2
local putterLine;
local speedAmp = 4; -- Used to increase the max/min speed.
local checkTimer;
local defaultDamp;
local narrationText;
local strokeCount = 1;
local win = 0;
local sandDamp = 0;
local currentLevel;

-- Add any physics bodies here, it is necessary for removal of the scene.
local ball;
local hole;
local holeSensor;
local background;
local Sand;

-------------- Transition between courses -----------------
local transOpt = {
                    effect = "fade",
                   	time = 400,
                    params = { golfLevel  = 2 }
                    }

local function nextLevel()
	transOpt.params.golfLevel = transOpt.params.golfLevel + 1;
	--Remove scene objects
	composer.removeScene("objects.golfLevel2")

	if(transOpt.params.golfLevel > 3) then
		composer.gotoScene("objects.golfLevel1");
	elseif(transOpt.params.golfLevel == 2) then
		composer.gotoScene("objects.golfLevel2");
	elseif(transOpt.params.golfLevel == 1) then
		composer.gotoScene("objects.golfLevel1");
	elseif(transOpt.params.golfLevel == 3) then
		composer.gotoScene("objects.golfLevel3")
	else
		print("Thats odd, that level does not seem to exist.")
	end
end

------------- golf ball stuff ----------------

local function setBall(x, y, dens, fri, bnc, damp)
	ball = display.newCircle(360,640, 15) -- Default golf ball
	ball:setFillColor(.5,.5,.5) -- Default golf ball color	
	ball.x = x;
	ball.y = y;
	physics.addBody(ball, "dynamic",{ density = (dens or 1), friction = (fri or .2), bounce = (bnc or .2), radius = 15})
	ball.angularDamping = (damp or .4);
end

---- Is moving will check to see if the ball is in motion still. if it is not
-- it will allow the user to put again.
local function isMoving(event)
	local xv,yv = ball:getLinearVelocity();
		xv = math.abs(xv);
		yv = math.abs(yv);
		if(win == 0) then
			narrationText.text = "Current velocity: " .. math.round(xv + yv)
		end
	-- If the ball is close to stopping increase damping to prevent 'creeping'
	if(xv+yv < 400) then
		ball.linearDamping = 1 + sandDamp;
		ball.angularDamping = 1 + sandDamp;

	elseif(xv + yv < 200) then
		print("slow down!")
		ball.linearDamping = 2 + sandDamp;
		ball.angularDamping = 2 + sandDamp; 
	elseif(xv + yv < 50) then
		print("Stop!!")
		ball:setLinearVelocity(0,0)
		ball.angularVelocity = 0
	end

	-- if ball is no longer in motion.
	if(xv == 0 and yv == 0) then
		ball.linearDamping = defaultDamp + sandDamp;
		ball.angularDamping = defaultDamp + sandDamp;
		timer.cancel(checkTimer); -- Stop checking to see if ball is in motion.
		-- Set the putter to the new ball positon
		putter.x = ball.x;
		putter.y = ball.y;
		putter.isVisible = true; -- Return the putter.
		strokeCount = strokeCount + 1;
		if( win == 0) then
			narrationText.text = "Putt!"
		end
	end

end

---- putterEvent will handle drawing the vector decribing force and direction as well as
-- implementing that force on the ball.
local function putterEvent(event)
	if(event.phase == "moved") then
		-- Get change in x and y
		local deltaX = ball.x + event.x;
		local deltaY = ball.y + event.y;
		-- Normalize positions
		deltaX = deltaX - ball.x;
		deltaY = deltaY - ball.y;
		-- If a line already exists remove it.
		if(putterLine ~= nil) then
			display.remove(putterLine);
		end
		putterLine = display.newLine(ball.x, ball.y, deltaX, deltaY);
		putterLine.strokeWidth = 8;
		putterLine:setStrokeColor(0,0,1)
	end
	if(event.phase == "ended") then
		putter.isVisible = false; -- Temporarily remove putter.
		-- Get change in x and y
		local deltaX = event.x - ball.x;
		local deltaY = event.y - ball.y;
		-- set ball velocity
		ball:setLinearVelocity(deltaX * speedAmp, deltaY * speedAmp)
		display.remove(putterLine)
		-- while ball is in motion check to see if it is still in motion
		checkTimer = timer.performWithDelay(50, isMoving, 0) 
	end
end

---- Will handle the times the player manages to land the ball in the hole.
local function inTheHole(event)

	if(event.other == ball) then
		ball:setLinearVelocity(0,0);
		ball.angularVelocity = 0;
		transition.to(event.other, {time = 150, x = hole.x, y = hole.y})
		narrationText.text = "Hole in: ".. strokeCount;
		win = 1;
		--print("Here")
		timer.performWithDelay(2000, nextLevel)
	end
end
---------------- Sand event --------------------
local function sandPit(event)
	if(event.phase == "began") then
		--in the pit.
		sandDamp = 20;
		ball.linearDamping = sandDamp;
		ball.angularDamping = sandDamp;
	elseif(event.phase == "ended") then
		-- Out of the pit.
		ball.linearDamping = defaultDamp;
		ball.angularDamping = defaultDamp;
		sandDamp = 0;
	end

end



-- create()
function scene:create( event )
    local sceneGroup = self.view
    -- Create the golf course.
    -- Create the flicker doodle thingy
-------------------------------------------------------------------------
---------------- THE following was generated by GUMBO -------------------
-------------------------------------------------------------------------

	local physics = require( "physics" )
	physics.start()
	--physics.setDrawMode( "hybrid" )
	--physics.setDrawMode( "debug" )

	---------------------------
	-- Shapes
	---------------------------
	local topright = { 211,-281, -75,-532, -153,-633 }
	topright.density = 1; topright.friction = 0.3; topright.bounce = 0.2; 

	local shape_2 = { 205,-286, 215,-275, 204,-270, 160,-213, 136,-136 }
	shape_2.density = 1; shape_2.friction = 0.3; shape_2.bounce = 0.2; 

	local shape_3 = { 204,-288, 208,-269, 218,-275 }
	shape_3.density = 1; shape_3.friction = 0.3; shape_3.bounce = 0.2; 

	local shape_4 = { 204,-269, 167,-225, 144,-157, 132,-98, 125,-28, 137,89, 163,162, 199,214 }
	shape_4.density = 1; shape_4.friction = 0.3; shape_4.bounce = 0.2; 

	local shape_5 = { 198,213, 250,282, 293,322, 353,353, 354,224 }
	shape_5.density = 1; shape_5.friction = 0.3; shape_5.bounce = 0.2; 

	local shape_6 = { 351,356, 351,630, 358,631 }
	shape_6.density = 1; shape_6.friction = 0.3; shape_6.bounce = 0.2; 

	local shape_7 = { 350,622, -359,622, -358,629 }
	shape_7.density = 1; shape_7.friction = 0.3; shape_7.bounce = 0.2; 

	local shape_8 = { -359,622, -354,-532, -359,-540, -352,-533, -73,-531 }
	shape_8.density = 1; shape_8.friction = 0.3; shape_8.bounce = 0.2; 

	local shape_9 = { -359,-540, -350,-525, -355,621 }
	shape_9.density = 1; shape_9.friction = 0.3; shape_9.bounce = 0.2; 

	local shape_10 = { -350,-529, -353,-637, -357,-632, -347,-634 }
	shape_10.density = 1; shape_10.friction = 0.3; shape_10.bounce = 0.2; 

	local shape_11 = { -347,-630, -150,-632, -153,-640 }
	shape_11.density = 1; shape_11.friction = 0.3; shape_11.bounce = 0.2; 

	local Topsand = { -150,-21, -138,-85, -106,-136, -49,-163, 10,-180, 66,-156, 113,-112, 146,-73 }
	Topsand.density = 1; Topsand.friction = 0.3; Topsand.bounce = 0.2; 

	local roghtbottomsand = { 145,-69, 144,22, 116,109, 75,148, 39,171, -1,179, -44,180, -78,162 }
	roghtbottomsand.density = 1; roghtbottomsand.friction = 0.3; roghtbottomsand.bounce = 0.2; 

	local leftbottomsand = { -152,-19, -144,60, -121,112, -102,144, -78,160, 121,-58 }
	leftbottomsand.density = 1; leftbottomsand.friction = 0.3; leftbottomsand.bounce = 0.2; 


	local mainBG = display.newImageRect( "golf-l2.png", 720, 1280 )
	mainBG.x = 360
	mainBG.y = 640
	physics.addBody( mainBG, "static", 
		{density=topright.density, friction=topright.friction, bounce=topright.bounce, shape=topright},
		{density=shape_3.density, friction=shape_3.friction, bounce=shape_3.bounce, shape=shape_3},
		{density=shape_4.density, friction=shape_4.friction, bounce=shape_4.bounce, shape=shape_4},
		{density=shape_5.density, friction=shape_5.friction, bounce=shape_5.bounce, shape=shape_5},
		{density=shape_6.density, friction=shape_6.friction, bounce=shape_6.bounce, shape=shape_6},
		{density=shape_7.density, friction=shape_7.friction, bounce=shape_7.bounce, shape=shape_7},
		{density=shape_9.density, friction=shape_9.friction, bounce=shape_9.bounce, shape=shape_9},
		{density=shape_10.density, friction=shape_10.friction, bounce=shape_10.bounce, shape=shape_10},
		{density=shape_11.density, friction=shape_11.friction, bounce=shape_11.bounce, shape=shape_11}
	)

	local holeGumbo = display.newImageRect( "hole.png", 49, 49 )
	holeGumbo.x = 99
	holeGumbo.y = 199
	
	 Sand = display.newImageRect( "Sand.png", 307, 367 )
	Sand.x = 183
	Sand.y = 495
-------------------------------------------------------------------------
----------------  End of Gumbo - generated code       -------------------
-------------------------------------------------------------------------
	physics.addBody(Sand, "dynamic", -- I forgot to tell gumbo to do this.
					{density=Topsand.density, friction=Topsand.friction, bounce=Topsand.bounce, shape=Topsand},
					{density=Topsand.density, friction=Topsand.friction, bounce=Topsand.bounce, shape=roghtbottomsand},
					{density=Topsand.density, friction=Topsand.friction, bounce=Topsand.bounce, shape=leftbottomsand})
	Sand.isSensor = true; -- Sensor, objects shouldn't bounce off of this...

	Sand:addEventListener("collision", sandPit);


	background = mainBG; -- For sake of the generated code.
	hole = holeGumbo;
	setBall(360,1200); -- Set the position of the ball.
	physics.setGravity(0,0)

    narrationText =  display.newText( "Putt!", 340, 100, native.systemFont, 64 )
	narrationText:setFillColor( 1, 0, 0.5 )


    sceneGroup:insert(background)
    sceneGroup:insert(hole)
	background:toFront();
	-- Create sensor for detectin when user has landed a hole.
	holeSensor = display.newCircle(hole.x, hole.y, 15)
	physics.addBody(holeSensor, "kinematic", {isSensor = true, radius = 10})
	holeSensor:addEventListener("collision", inTheHole);
	
	-- Create sensor for determining the trojectory vector.
	putter.x = ball.x;
	putter.y = ball.y;
	
	defaultDamp = ball.linearDamping;
	putter:addEventListener("touch", putterEvent);
	hole:toFront();

	sceneGroup:insert(holeSensor);
	holeSensor:toBack();
	sceneGroup:insert(narrationText);
	sceneGroup:insert(ball);
	sceneGroup:insert(putter);
	sceneGroup:insert(Sand);
	Sand:toBack();
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
    sceneGroup:remove(background)
    sceneGroup:remove(ball);
    sceneGroup:remove(holeSensor)
    sceneGroup:remove(Sand)
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
