local Preset = {}

-- For more detailed documentation visit:

-- Interpolation/movement is mainly done with Spring
-- Spring have two property
-- 1 bounciness is the bounce of the spring 1 is no bounce less than 1 is under bounce and more than 1 is upper bounce
-- 2 frequency dictate how fast the interpolation, spring is
-- For more information check out https://devforum.roblox.com/t/spring-driven-motion-spr/714728

Preset.Default = {
		Host = nil,
		HostOffset = Vector3.new(0,2,0), --Head Position
		camRotation = {bounciness = 0.5, speed = 2},
		-- Zoom Setting
		zoomSens = 1.5,
		maxZoom = 14,
		minZoom = 0,
		Zoom = 8,
		Zooming = {bounciness = 0.8, speed = 3}, -- The property of Zoom interpolation 
		Offsetting = {bounciness = 0.8, speed = 1.5},
		SOffsetting = {bounciness = 0.8, speed = 2, offset = CFrame.new(1.75, 0.5, 1)},
		maxOffset = CFrame.new(0,0,0), -- The offset when Zoom is maximum
		minOffset = CFrame.new(0,0,0), -- The offset when Zoom is minimum
		max_rotation_y = 60, -- Max rotation up and down, roblox's default = 90 
		-- We need these offset to keep the character on third of the screen
		-- Camera Shake setting
		Shaking = {
			trauma_reduction_rate = 0.225,
			max_rx = 10, -- you can think of this as amplitude imply how hard it shake
			max_ry = 10,
			max_rz = 5,
			Resolution = 100, -- How smooth between shake value
			Frequency = 1400,    -- How steep between shake value aka how much it shake
		},
		pcam = {MaxForce = 10000, Responsiveness = 35},
		Bobbing = {
			active = true,
			
			-- Important parameters
			frequency = 3, --Frequency dictate how much sine wave there are/ how much the cam bob
			amplitude = 3,-- Amplitude dictate how big the sine wave are/ how strong the cam bob
			
			yAxis_multiplier = 0.005,
			
			--Not as important if edit then it's advice to just edit the multiplier
			
			bobbing = {speed = 2.5, bounciness = 0.8},
			swaying = {multiplier = 3.5, speed = 1.5, bounciness = 0.8},
			cam_tilt = {multiplier = 4.5, speed = 1.75, bounciness = 0.8},
			--body_factor = {multiplier = 1, speed = 1, bounciness = 0.8},
		},
		MaxPan = 20, -- How much the camera Pan when you move the mouse
		-- Character setting
		HeadRotation = {active = true ,bounciness = 0.6, speed = 2},
		BodyRotation = {active = true ,bounciness = 0.65, speed = 1.6},
		ShiftLock = {active = false,crossHair = "rbxassetid://14608831830" ,bounciness = 0.7, speed = 2.25}
}

Preset.RuleOfThird = {
		Host = nil,
		HostOffset = Vector3.new(0,2.5,0), --Head Position
		camRotation = {bounciness = 0.5, speed = 2},
		-- Zoom Setting
		zoomSens = 1.5,
		maxZoom = 14,
		minZoom = 8,
		Zoom = 8,
		Zooming = {bounciness = 0.8, speed = 3}, -- The property of Zoom interpolation 
		Offsetting = {bounciness = 0.8, speed = 1.5},
		SOffsetting = {bounciness = 0.8, speed = 2, offset = CFrame.new(0.5, 0.25, 0.5)}, --shift offset
		maxOffset = CFrame.new(5.5,1.5,0), -- The offset when Zoom is maximum
		minOffset = CFrame.new(3.25,0,0), -- The offset when Zoom is minimum
		max_rotation_y = 60, -- Max rotation up and down, roblox's default = 90 
		-- We need these offset to keep the character on third of the screen
		-- Camera Shake setting
		Shaking = {
			trauma_reduction_rate = 0.225,
			max_rx = 10, -- you can think of this as amplitude imply how hard it shake
			max_ry = 10,-- max_rotation_y
			max_rz = 5,
			Resolution = 100, -- How smooth between shake value
			Frequency = 1400,    -- How steep between shake value aka how much it shake
		},
		pcam = {MaxForce = 10000, Responsiveness = 35},
		Bobbing = {
			active = true,
			
			-- Important parameters
			frequency = 3.6, --Frequency dictate how much sine wave there are/ how much the cam bob
			amplitude = 9,-- Amplitude dictate how big the sine wave are/ how strong the cam bob
			
			yAxis_multiplier = 0.005, -- set this to 0 if it's too nauseating 
			
			--Not as important if edit then it's advice to just edit the multiplier
			
			bobbing = {speed = 2.5, bounciness = 0.8},
			swaying = {multiplier = 3.5, speed = 1.5, bounciness = 0.8},
			cam_tilt = {multiplier = 4.5, speed = 1.75, bounciness = 0.8},
			body_factor = {multiplier = 1, speed = 1, bounciness = 0.8},
		},
		MaxPan = 20, -- How much the camera Pan when you move the mouse
		-- Character setting
		HeadRotation = {active = true ,bounciness = 0.6, speed = 2},
		BodyRotation = {active = true ,bounciness = 0.65, speed = 1.6},
		ShiftLock = {active = false,crossHair = "rbxassetid://14608831830" ,bounciness = 0.7, speed = 2.25}
}

return Preset
