-- 

function love.load()
	width = 400
	height = 240	
	
	timer = 0
	timeUsed = 0
	lastPom = nil
	status = 'ready'
	
	-- duration in seconds
	workLength = 25 * 60
	breakLength = 5 * 60
	longBreakLength = 20 * 60
	workCount = 4
	
	currentPOM = 0
	remaining = workLength
	
	currentScreen = 'poms'
	selectedSetting = 'workLength'
	
	love.graphics.setBackgroundColor(1, 0, 0)
end

function love.update(dt)
	if status == 'paused' then return end
	
	timer = timer + dt
	if timer < 1 then return end
	
	timeUsed = timeUsed + timer
	timer = 0
	
	remaining = currentPOMLength() - timeUsed
	if remaining < 1 then
		currentPOM = currentPOM + 1
		currentPOM = currentPOM > workCount * 2 and 0 or currentPOM
		timeUsed = 0
		remaining = currentPOMLength()
	end
end

function currentPOMLength()
	if currentPOM == workCount * 2 then return longBreakLength
	elseif currentPOM % 2 == 0 then return workLength
	else return breakLength
	end
end

function love.keypressed(key)
	if currentScreen == 'settings' then
		if key == 'up' then
			if selectedSetting == 'workLength' then selectedSetting = 'return'
			elseif selectedSetting == 'breakLength' then selectedSetting = 'workLength'
			elseif selectedSetting == 'longBreakLength' then selectedSetting = 'breakLength'
			elseif selectedSetting == 'workCount' then selectedSetting = 'longBreakLength'
			elseif  selectedSetting == 'reset' then selectedSetting = 'workCount'
			elseif  selectedSetting == 'return' then selectedSetting = 'reset'
			end
		elseif key == 'down' then
			if selectedSetting == 'workLength' then selectedSetting = 'breakLength'
			elseif selectedSetting == 'breakLength' then selectedSetting = 'longBreakLength'
			elseif selectedSetting == 'longBreakLength' then selectedSetting = 'workCount'
			elseif selectedSetting == 'workCount' then selectedSetting = 'reset'
			elseif  selectedSetting == 'reset' then selectedSetting = 'return'
			elseif  selectedSetting == 'return' then selectedSetting = 'workLength'
			end
		elseif key == 'left' then
			if selectedSetting ~= 'reset' then selectedSetting = 'reset'
			else selectedSetting = 'return'
			end
		elseif key == 'right' then
			if selectedSetting ~= 'return' then selectedSetting = 'return'
			else selectedSetting = 'reset'
			end
		elseif key == 'a' then
			if selectedSetting == 'reset' then
				-- TODO: Reset settings
				currentScreen = 'poms'
			elseif selectedSetting == 'return' then currentScreen = 'poms'				
			end
		elseif key == 'b' then selectedSetting = 'return'
		end
	elseif currentScreen == 'poms' then
		if status == 'ready' then
			if key == 'a' then
				status = 'running'
			end
		else
			if key == 'a' then
				if status == 'running' then status = 'paused'
				elseif status == 'paused' then status = 'running'
				end
			elseif key == 'b' then
				currentScreen = 'settings'
			end
		end
	end
end

function love.draw()
	if currentScreen == 'settings' then
		drawSettings()
	elseif currentScreen == 'poms' then
		drawPomScreen()
	end	
end

function drawSettings()
	love.graphics.print('Work Length', 85, 75)
	love.graphics.print('Break Length', 84, 100)
	love.graphics.print('Long Break Length', 50, 125)
	love.graphics.print('POM Count', 97, 150)
	
	local selectedYOffset = 0
	local selectedXOffset = 180
	if selectedSetting == 'workLength' then selectedYOffset = 70
	elseif selectedSetting == 'breakLength' then selectedYOffset = 95
	elseif selectedSetting == 'longBreakLength' then selectedYOffset = 120
	elseif selectedSetting == 'workCount' then selectedYOffset = 145
	elseif selectedSetting == 'reset' then
		selectedXOffset = 73
		selectedYOffset = 195
	elseif selectedSetting == 'return' then
		selectedXOffset = 135
		selectedYOffset = 195
	end
	
	
	love.graphics.setColor(1, 1, 1)
	love.graphics.rectangle(
		'fill',
		selectedXOffset,
		selectedYOffset,
		50,
		25
	)
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(workLength, 195, 75)
	love.graphics.print(breakLength, 195, 100)
	love.graphics.print(longBreakLength, 195, 125)
	love.graphics.print(workCount, 195, 150)
	
	love.graphics.print('Reset', 80, 200)
	love.graphics.print('Return', 140, 200)
end

function drawPomScreen()
	local minutesLeft = remaining / 60
	local secondsLeft = remaining % 60
	
	love.graphics.setColor(1, 1, 1)
	if status == 'ready' then
		love.graphics.print("Ready, press A", 200, 100, 0, 2, 2)
		return
	end
	
	love.graphics.print(string.format('%i:%02i', minutesLeft, secondsLeft), 250, 125, 0, 2, 2)	
	
	local workWidth = 40
	local breakWidth = 20
	local longBreakWidth = 30
	local margin = 10
	local pomOffset = 50
	local borderGap = 1
	local borderWidth = 1
	
	for i = 0, workCount - 1 do
		love.graphics.setColor(0, 1, 0)
		love.graphics.rectangle(
			'fill',
			pomOffset + (workWidth + breakWidth + margin * 2) * i,
			175,
			workWidth,
			20
		)
		
		if i * 2 == currentPOM then
			love.graphics.rectangle(
				'line',
				pomOffset + (workWidth + breakWidth + margin * 2) * i - borderGap - borderWidth,
				175 - borderGap - borderWidth,
				workWidth + (borderGap + borderWidth) * 2,
				20 + (borderGap + borderWidth) * 2
			)	
		end
		
		love.graphics.setColor(0, 0, 1)
		love.graphics.rectangle(
			'fill',
			pomOffset + (workWidth + breakWidth + margin * 2) * i + margin + workWidth,
			175,
			breakWidth,
			20
		)
		
		if i * 2 + 1 == currentPOM then
			love.graphics.rectangle(
				'line',
				pomOffset + (workWidth + breakWidth + margin * 2) * i + margin + workWidth - borderGap - borderWidth,
				175 - borderGap - borderWidth,
				breakWidth + (borderGap + borderWidth) * 2,
				20 + (borderGap + borderWidth) * 2
			)
		end
	end
	
	love.graphics.setColor(0, 1, 1)
	love.graphics.rectangle(
		'fill',
		pomOffset + (workWidth + breakWidth + margin * 2) * workCount,
		175,
		longBreakWidth,
		20
	)
	
	if currentPOM == workCount * 2 then
		love.graphics.rectangle(
			'line',
			pomOffset + (workWidth + breakWidth + margin * 2) * workCount  - borderGap - borderWidth,
			175 - borderGap - borderWidth,
			longBreakWidth + (borderGap + borderWidth) * 2,
			20 + (borderGap + borderWidth) * 2
		)
	end
	
	love.graphics.setColor(1, 1, 1)
	love.graphics.circle(
		'fill',
		pomOffset, 
		300,
		20,
		20
	)
	if status == 'running' then
		love.graphics.rectangle(
			'fill',
			pomOffset - 10,
			250,
			8,
			20
		)
		love.graphics.rectangle(
			'fill',
			pomOffset,
			250,
			8,
			20
		)
	elseif status == 'paused' then
		love.graphics.polygon(
			'fill',
			pomOffset - 8,
			250,
			pomOffset + 6,
			260,
			pomOffset - 8,
			270
		)
	end
	
	love.graphics.circle(
		'fill',
		pomOffset + 70,
		300,
		20,
		20
	)
	love.graphics.rectangle(
		'fill',
		pomOffset + 56,
		250,
		28,
		5
	)
	love.graphics.rectangle(
		'fill',
		pomOffset + 56,
		258,
		28,
		5
	)
	love.graphics.rectangle(
		'fill',
		pomOffset + 56,
		266,
		28,
		5
	)
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.print('A', pomOffset - 9, 284, 0, 2, 2)
	love.graphics.print('B', pomOffset + 62, 284, 0, 2, 2)
end

