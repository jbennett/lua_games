function love.load()
	gridXCount = 70
	gridYCount = 50
	cellSize = 10
	
	love.graphics.setBackgroundColor(1, 1, 1)	
	love.keyboard.setKeyRepeat(true)
	
	resetGrid()
	
	-- glider
	-- grid[15][15] = true
	-- grid[15][16] = true
	-- grid[15][17] = true
	-- grid[16][15] = true
	-- grid[17][16] = true
	
	
end

function resetGrid()
	grid = {}
	
	for y = 0, gridYCount - 1 do
		grid[y] = {}
		for x = 0, gridXCount - 1 do
			grid[y][x] = false
		end
	end
end

function love.update()
	selectedX = math.floor(love.mouse.getX() / cellSize)
	selectedX = math.min(selectedX, gridXCount)
	selectedY = math.floor(love.mouse.getY() / cellSize)
	selectedY = math.min(selectedY, gridYCount)
	
	if love.mouse.isDown(1) then
		grid[selectedY][selectedX] = true
	elseif love.mouse.isDown(2) then
		grid[selectedY][selectedX] = false
	end
end

function love.keypressed(key)
	if key == 'c' then
		resetGrid()
	else
		local nextGrid = {}
		
		for y = 0, gridYCount - 1 do
			nextGrid[y] = {}
			for x = 0, gridXCount - 1 do
				local count = neighbourCount(x, y)
				nextGrid[y][x] = count == 3 or (grid[y][x] and count == 2)
			end
		end
		
		grid = nextGrid
	end
end

function neighbourCount(x, y)
	local total = 0
	
	for dy = -1, 1 do
		for dx = -1, 1 do
			local checkY = y + dy
			checkY = checkY == -1 and gridYCount - 1 or checkY
			checkY = checkY == gridYCount and 0 or checkY
			local checkX = x + dx
			checkX = checkX == -1 and gridXCount - 1 or checkX
			checkX = checkX == gridXCount and 0 or checkX
			
			if not (dy == 0 and dx == 0)
			and grid[checkY]
			and grid[checkY][checkX] then
				total = total + 1
			end				
		end
	end
	
	return total
end
	
function love.draw()
	for y = 0, gridYCount - 1 do
		for x = 0, gridXCount - 1 do
			
			if selectedX == x and selectedY == y then
				love.graphics.setColor(0, 1, 1)
			elseif grid[y][x] then
				love.graphics.setColor(1, 0, 1)
			else			
				love.graphics.setColor(.86, .86, .86)
			end
			
			love.graphics.rectangle(
				'fill',
				x * cellSize,
				y * cellSize,
				cellSize - 1,
				cellSize - 1
			)
		end
	end
end