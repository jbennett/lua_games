-- Setup
function love.load()
	gridXCount = 20
	gridYCount = 15
	cellSize = love.graphics.getWidth() / gridXCount
	defaultUpdatePeriod = 0.1
	grandmaSpeed = 0.3
	dadSpeed = 0.05
	defaultChallengeSpeed = defaultUpdatePeriod * 3
	challengeModeSpeed = 0.85
	speedMode = 'normal'
	updatePeriod = defaultUpdatePeriod
	
	reset()
end

function reset()
	directionQueue = { 'right' }
	snakeAlive = true
	snakeSegments = {
		{ x = 3, y = 10 },
		{ x = 2, y = 10 },
		{ x = 1, y = 10 },
	}
	timer = 0
	
	if speedMode == 'challenge' then
		updatePeriod = defaultChallengeSpeed
	end
	
	moveFood()
end

function moveFood()
	local possibleFoodPositions = {}
	
	for foodX = 1, gridXCount do
		for foodY = 1, gridYCount do
			local possible = true
			
			for segmentIndex, segment in ipairs(snakeSegments) do
				if foodX == segment.x and foodY == segment.y then
					possible = false
				end
			end
			
			if possible then
				table.insert(possibleFoodPositions, {
					x = foodX,
					y = foodY
				})
			end
		end
	end
	
	foodPosition = possibleFoodPositions[
		love.math.random(#possibleFoodPositions)
	]
end

function love.draw()
	love.graphics.setColor(138/256, 43/256, 226/256)
	love.graphics.rectangle(
		'fill',
		0,
		0,
		gridXCount * cellSize,
		gridYCount * cellSize
	)
	
	if snakeAlive then
		love.graphics.setColor(0.6, 1, .32)
	else
		love.graphics.setColor(0.5, 0.5, 0.5)
	end
	
	for segmentIndex, segment in ipairs(snakeSegments) do
		drawCell(segment.x, segment.y)
	end
	
	love.graphics.setColor(1, 0.3, 0.3)
	drawCell(foodPosition.x, foodPosition.y)
	
	love.graphics.setColor(1, 1, 1)
	if speedMode ~= 'challenge' then
		love.graphics.print("Score: " .. #snakeSegments, 10, 10, 0, 2, 2)
	else
		love.graphics.print(string.format("Score: %s Speed: %d", #snakeSegments, 1 / updatePeriod), 10, 10, 0, 2, 2)
	end
end

function drawCell(x, y)
	love.graphics.rectangle(
		'fill',
		(x - 1) * cellSize,
		(y - 1) * cellSize,
		cellSize - 1,
		cellSize - 1
	)
end

function love.update(dt)
	timer = timer + dt
	
	if snakeAlive then
		if timer >= updatePeriod then
			timer = 0
			
			if #directionQueue > 1 then
				table.remove(directionQueue, 1)
			end
			
			local nextXPosition = snakeSegments[1].x
			local nextYPosition = snakeSegments[1].y
			
			if directionQueue[1] == 'right' then
				nextXPosition = nextXPosition + 1
			elseif directionQueue[1] == 'left' then
				nextXPosition = nextXPosition - 1
			elseif directionQueue[1] == 'down' then
				nextYPosition = nextYPosition + 1
			elseif directionQueue[1] == 'up' then
				nextYPosition = nextYPosition - 1
			end
			
			if nextXPosition < 1 then
				nextXPosition = gridXCount
			end
			if nextXPosition > gridXCount then
				nextXPosition = 1
			end
			if nextYPosition < 1 then
				nextYPosition = gridYCount
			end
			if nextYPosition > gridYCount then
				nextYPosition = 1
			end
			
			local canMove = true
			
			for segmentIndex, segment in ipairs(snakeSegments) do
				if segmentIndex ~= #snakeSegments -- skip last
				and nextXPosition == segment.x
				and nextYPosition == segment.y then
					canMove = false
				end
			end
			
			if canMove then
				table.insert(snakeSegments, 1, {
					x = nextXPosition,
					y = nextYPosition
				})
				
				if snakeSegments[1].x == foodPosition.x
				and snakeSegments[1].y == foodPosition.y then
					moveFood()
					
					if speedMode == 'challenge' then
						updatePeriod = updatePeriod * challengeModeSpeed
					end
				else
					table.remove(snakeSegments)
				end
			else
				snakeAlive = false
			end
		end
	elseif timer >= 2 then
		reset()
	end
end

function love.keypressed(key)
	if key == 'right' 
	and directionQueue[#directionQueue] ~= 'right'
	and directionQueue[#directionQueue] ~= 'left' then
		table.insert(directionQueue, 'right')
	elseif key == 'left'
	and directionQueue[#directionQueue] ~= 'left'
	and directionQueue[#directionQueue] ~= 'right' then
		table.insert(directionQueue, 'left')
	elseif key == 'down'
	and directionQueue[#directionQueue] ~= 'down'
	and directionQueue[#directionQueue] ~= 'up' then
		table.insert(directionQueue, 'down')
	elseif key == 'up'
	and directionQueue[#directionQueue] ~= 'up'
	and directionQueue[#directionQueue] ~= 'down' then
		table.insert(directionQueue, 'up')
	end
		
	if key == 'g' then
		if speedMode == 'grandma' then
			updatePeriod = defaultUpdatePeriod
			speedMode = 'normal'
		else
			updatePeriod = grandmaSpeed
			speedMode = 'grandma'
		end
	end
	
	if key == 'd' then
		if speedMode == 'dad' then
			updatePeriod = defaultUpdatePeriod
			speedMode = 'normal'
		else
			updatePeriod = dadSpeed
			speedMode = 'dad'
		end
	end
	
	if key == 'c' then
		if speedMode == 'challenge' then
			updatePeriod = defaultUpdatePeriod
			speedMode = 'normal'
		else
			updatePeriod = defaultChallengeSpeed
			speedMode = 'challenge'
		end
	end
end