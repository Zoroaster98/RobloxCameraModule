local CrunchyCam = {}
CrunchyCam.__index = CrunchyCam

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local cam = workspace.CurrentCamera or workspace:WaitForChild("Camera")

local Player = game.Players.LocalPlayer

local char = Player.Character or Player.CharacterAdded:Wait()

local Humanoid = char:WaitForChild("Humanoid")

local R6 = char:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R6

local Head = char:WaitForChild("Head")

local Humanoid = char:WaitForChild("Humanoid")
local HumanoidRootPart = char:WaitForChild("HumanoidRootPart")

local Torso = if R6 then char:WaitForChild("Torso") else char:WaitForChild("UpperTorso")
local Neck = if R6 then Torso:WaitForChild("Neck") else Head:WaitForChild("Neck")

local Waist = if R6 then HumanoidRootPart:WaitForChild("RootJoint") else Torso:WaitForChild("Waist")

RHip = if R6 then Torso:WaitForChild("Right Hip") else char:WaitForChild("RightUpperLeg"):WaitForChild("RightHip")
LHip = if R6 then Torso:WaitForChild("Left Hip") else char:WaitForChild("LeftUpperLeg"):WaitForChild("LeftHip")

local LHipOriginC0 = LHip.C0
local RHipOriginC0 = RHip.C0

local NeckOriginC0 = Neck.C0
local WaistOriginC0 = Waist.C0

local wantedPos = Instance.new("Attachment")
wantedPos.Parent = workspace.Terrain

local pcam = script.Pcam:Clone()
pcam.Parent = workspace
pcam.AlignPosition.Attachment1 = wantedPos

Neck.MaxVelocity = 0.333
local param = RaycastParams.new()
param.FilterType = Enum.RaycastFilterType.Exclude
param.FilterDescendantsInstances = {char,pcam}


local spr = require(ReplicatedStorage.Module.spr)
-- Temp Value

local cameraRotation = Vector2.zero
local rad = math.rad

local CZoom = Instance.new("NumberValue")
CZoom.Value = 8
local Zoffset = Instance.new("CFrameValue")
Zoffset.Value = CFrame.new(3.25,0,0)

local ShiftOffset = Instance.new("CFrameValue")
ShiftOffset.Value = CFrame.new(1.75, 0.5, 1)

local rotationCFrame = Instance.new("CFrameValue")
local RootRotation =Instance.new("CFrameValue")
RootRotation.Value = CFrame.new()

local Time = 0

local mouse = Player:GetMouse()

local touchEnabled = UserInputService.TouchEnabled
local cam_tilt_x = Instance.new("NumberValue")
cam_tilt_x.Value = 0

local bobbing_x = Instance.new("NumberValue")
local bobbing_y = Instance.new("NumberValue")
bobbing_x.Value = 0
bobbing_y.Value = 0

local swaying_x = Instance.new("NumberValue")
local swaying_y = Instance.new("NumberValue")
swaying_x.Value = 0
swaying_y.Value = 0

local body_factor = Instance.new("NumberValue")
body_factor.Value = 0

local function lerp(a, b, t)
	return a + (b - a) * t
end

local angleX = 0
local swaying = CFrame.new()
local Frequency = 0
local Amplitude = 0
local GTimer = 0


local screenBobbing = CFrame.new()

local function Shake(deltaTime)
	local self = CrunchyCam.Shaking

	local initial_rotation = cam.CFrame.Rotation
	local initial_position = cam.CFrame.Position

	local shakepower = self.trauma^2

	self.trauma = math.max(self.trauma - self.trauma_reduction_rate*deltaTime/60,0)
	local rx = initial_rotation.X + self.max_rx * shakepower * math.noise(self.seed_1, Time / self.Resolution * self.Frequency)
	local ry = initial_rotation.Y + self.max_ry * shakepower * math.noise(self.seed_2, Time / self.Resolution * self.Frequency)
	local rz = initial_rotation.Z + self.max_rz * shakepower * math.noise(self.seed_3, Time / self.Resolution * self.Frequency)

	cam.CFrame *= CFrame.fromEulerAnglesXYZ(rx,ry,rz)
end

local function SudoRandom(min,max,seed)
	local ratio = (1+math.noise(Time * 0.1,seed * 0.1))/2
	return lerp(min,max,ratio)
end

--Perlin Bob
--local function Bob(dt)
--	local self = CrunchyCam.Bobbing
--	if not self.active or dt > 2.5 then return end
--	Time += dt/60
--	local vel = math.max((HumanoidRootPart.AssemblyLinearVelocity*Vector3.new(1,0,1)).Magnitude,0.005)

--	spr.target(cam_tilt_x,0.8,1.75,{Value = math.clamp(UserInputService:GetMouseDelta().X / dt * 0.15, -2.5, 2.5)})
--	--spr.target(bobbing_x,0.8,2.5,{Value = math.sin(Time * self.frequency * 0.1 * math.pi * vel) * self.amplitude * 0.1})
--	--spr.target(bobbing_y,0.8,2.5,{Value = math.sin(Time * self.frequency * 0.1 * 0.5  * math.pi * vel) * self.amplitude * 0.1})

--	spr.target(bobbing_x,0.8,2.5,{Value = math.noise(Time*vel*self.frequency*0.1,1*self.frequency*0.1) * self.amplitude * 0.29})
--	spr.target(bobbing_y,0.8,2.5,{Value = math.noise(Time*vel*self.frequency*0.1,3*self.frequency*0.1) * self.amplitude * 0.29})

--	if dt > 2 then
--		spr.target(swaying_x, 1 ,2 , {Value = 0})
--		spr.target(swaying_y, 1 ,2 , {Value = 0})
--	else
--		spr.target(swaying_x, self.swaying.bounciness , self.swaying.speed , {Value = math.cos(Time * 0.25 * SudoRandom(10,15,1)) * (SudoRandom(5,20,5) * 0.03 )})
--		spr.target(swaying_y, self.swaying.bounciness, self.swaying.speed , {Value = math.cos(Time * 0.25 * SudoRandom(5,10,10)) * (SudoRandom(2,10,15)  * 0.03)})
--	end
--	print(bobbing_x.Value)
--	spr.target(body_factor,0.8,1,{Value = -cam.CFrame:VectorToObjectSpace((HumanoidRootPart.Velocity or Vector3.new()) / math.max(Humanoid.WalkSpeed, 0.01)).X * 0.05 })
--	body_factor.Value = math.clamp(body_factor.Value, -0.05, 0.05)
--	cam.CFrame *= CFrame.fromEulerAnglesXYZ(0, 0, math.rad(cam_tilt_x.Value)*self.cam_tilt.multiplier) --sway
--		* CFrame.fromEulerAnglesXYZ(math.rad(bobbing_x.Value), math.rad(bobbing_y.Value), body_factor.Value*self.body_factor.multiplier) -- Cam Bobbing
--		* CFrame.fromEulerAnglesXYZ(math.rad(swaying_x.Value), math.rad(swaying_y.Value), math.rad(swaying_y.Value * 5)) -- stabilizer
--	cam.CFrame += Vector3.yAxis*bobbing_x.Value*self.yAxis_multiplier
--end


-- SINE BOB
local function Bob(dt)
	local self = CrunchyCam.Bobbing
	if not self.active or dt > 2.5 then return end
	Time += dt/60
	local vel = math.max((HumanoidRootPart.AssemblyLinearVelocity*Vector3.new(1,0,1)).Magnitude,0.005)

	spr.target(cam_tilt_x,0.8,1.75,{Value = math.clamp(UserInputService:GetMouseDelta().X / dt * 0.15, -2.5, 2.5)})
	--spr.target(bobbing_x,0.8,2.5,{Value = math.sin(Time * self.frequency * 0.1 * math.pi * vel) * self.amplitude * 0.1})
	--spr.target(bobbing_y,0.8,2.5,{Value = math.sin(Time * self.frequency * 0.1 * 0.5  * math.pi * vel) * self.amplitude * 0.1})


	spr.target(bobbing_x,0.8,2.5,{Value = math.sin(Time * self.frequency * 0.1 * math.pi * vel) * self.amplitude * 0.1})
	spr.target(bobbing_y,0.8,2.5,{Value = math.sin(Time * self.frequency * 0.1 * 0.5  * math.pi * vel) * self.amplitude * 0.1})

	if dt > 2 then
		spr.target(swaying_x, 1 ,2 , {Value = 0})
		spr.target(swaying_y, 1 ,2 , {Value = 0})
	else
		spr.target(swaying_x, self.swaying.bounciness , self.swaying.speed , {Value = math.cos(Time * 0.25 * SudoRandom(10,15,1)) * (SudoRandom(5,20,5) * 0.03 )})
		spr.target(swaying_y, self.swaying.bounciness, self.swaying.speed , {Value = math.cos(Time * 0.25 * SudoRandom(5,10,10)) * (SudoRandom(2,10,15)  * 0.03)})
	end
	--spr.target(body_factor,0.8,1,{Value = -cam.CFrame:VectorToObjectSpace((HumanoidRootPart.Velocity or Vector3.new()) / math.max(Humanoid.WalkSpeed, 0.01)).X * 0.05 })
	--body_factor.Value = math.clamp(body_factor.Value, -0.05, 0.05)
	cam.CFrame *= --CFrame.fromEulerAnglesXYZ(0, 0, math.rad(cam_tilt_x.Value)*self.cam_tilt.multiplier) --sway
		 CFrame.fromEulerAnglesXYZ(math.rad(bobbing_x.Value), math.rad(bobbing_y.Value), 0) -- Cam Bobbing
		--* CFrame.fromEulerAnglesXYZ(math.rad(swaying_x.Value), math.rad(swaying_y.Value), math.rad(swaying_y.Value * 5)) -- stabilizer
	cam.CFrame += Vector3.yAxis*bobbing_x.Value*self.yAxis_multiplier
end

local function FOV()
	local vel = (HumanoidRootPart.AssemblyLinearVelocity*Vector3.new(1,0,1)).Magnitude
	if vel > 1 then
		spr.target(cam, 0.4 , 0.5, { -- 1.5
			FieldOfView = 75
		})
	else
		spr.target(cam, 0.4 , 1, { -- 1.25
			FieldOfView = 70
		})
	end
end

local function update(deltaTime)
	deltaTime *= 60
	local mousePos = UserInputService:GetMouseLocation()
	local self = CrunchyCam

	cameraRotation = Vector2.new(cameraRotation.X, math.clamp(cameraRotation.Y, rad(-self.max_rotation_y), rad(self.max_rotation_y))) 
	wantedPos.WorldPosition = self.Host.Position+self.HostOffset

	local delta_x = mousePos.X/mouse.ViewSizeX
	local delta_y = mousePos.Y/mouse.ViewSizeY
	
	local panning = CFrame.fromOrientation(math.rad(5-delta_y * self.MaxPan),math.rad(5-delta_x * self.MaxPan),0)

	local wantedro = CFrame.fromEulerAnglesYXZ(cameraRotation.Y, cameraRotation.X, 0)*panning

	spr.target(rotationCFrame,self.camRotation.bounciness,self.camRotation.speed,{Value = wantedro})
	spr.target(CZoom,self.Zooming.bounciness,self.Zooming.speed,{Value = self.Zoom})
	spr.target(Zoffset,self.Offsetting.bounciness,self.Offsetting.speed,{Value = self.offset})
	
	if self.ShiftLock.active then
		spr.target(ShiftOffset, self.SOffsetting.bounciness, self.SOffsetting.speed,{Value = self.SOffsetting.offset})
	else spr.target(ShiftOffset, self.SOffsetting.bounciness, self.SOffsetting.speed,{Value = CFrame.new(0, 0, 0)})
	end
	
	cam.CFrame = rotationCFrame.Value*(Zoffset.Value + Vector3.new(0,0,CZoom.Value))*ShiftOffset.Value + pcam.Position

	Bob(deltaTime)
	FOV()
	Shake(deltaTime)
	--Collision detection

	local Result = workspace:Raycast(pcam.Position, cam.CFrame.Position - pcam.Position, param) 
	--pcam is the part that's following the player's head
	-- Or the cf that our camera offset on


	if Result ~= nil then
		---Credit Arbeiter
		local ObstructionDisplacement = (Result.Position - pcam.Position)
		local ObstructionPosition = pcam.Position + ObstructionDisplacement.Unit * (ObstructionDisplacement.Magnitude - 1)  -- THe minus one is unit
		local _,_,_,r00,r01,r02,r10,r11,r12,r20,r21,r22 = cam.CFrame:components()
		cam.CFrame = CFrame.new(ObstructionPosition.x, ObstructionPosition.y, ObstructionPosition.z , r00, r01, r02, r10, r11, r12, r20, r21, r22)
	end
	
	if not self.Host:IsDescendantOf(char) then return end 
	Humanoid.AutoRotate = not self.ShiftLock.active

	if self.ShiftLock.active then
		local _, y, _ = cam.CFrame:ToOrientation();
		spr.target(RootRotation,self.ShiftLock.bounciness,self.ShiftLock.speed,{Value = CFrame.Angles(0, y, 0)})
		HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position)*RootRotation.Value
	end
end

local function charRotation()
	local self = CrunchyCam
	if not self.Host:IsDescendantOf(char) then return end 
	local Point = Vector3.zero
	local ray = workspace.CurrentCamera:ViewportPointToRay(mouse.X,mouse.Y)
	local P = ray.Direction*100
	local result = workspace:Raycast(ray.Origin,P,param)
	if result then Point = result.Position
	else Point = ray.Origin + P end
	local Dis = Head.Position - Point

	local at = math.atan((Head.CFrame.Y - Point.Y) / Dis.magnitude) * -.5
	local rot = (Dis.Unit):Cross(Torso.CFrame.lookVector).Y
	
	if self.HeadRotation.active then
		spr.target(Neck,self.HeadRotation.bounciness,self.HeadRotation.speed,{C0 = CFrame.Angles(at, rot, 0) * NeckOriginC0})
		else Neck.C0 = NeckOriginC0
	end
	if self.BodyRotation.active then
		spr.target(Waist,self.BodyRotation.bounciness,self.BodyRotation.speed,{C0 = CFrame.Angles(at, rot*.5, 0)*WaistOriginC0})
		else Waist.C0 = WaistOriginC0
	end

	local legsCounterCFrame = (Waist.C0 * WaistOriginC0:Inverse()):Inverse()

	RHip.C0 =  legsCounterCFrame*RHipOriginC0
	LHip.C0 = legsCounterCFrame*LHipOriginC0
end

local function onInputChange(input, typ) 
	--if typ then return end
	local self = CrunchyCam
	if input.UserInputType == Enum.UserInputType.MouseWheel then 
		self.Zoom = math.clamp(self.Zoom - input.Position.Z * self.zoomSens, self.minZoom, self.maxZoom)
		self.offset = self.maxOffset:Lerp(self.minOffset, (self.maxZoom-self.Zoom)/self.Alerp)
	elseif input.UserInputState == Enum.UserInputState.Begin and (input.KeyCode == Enum.KeyCode.I or input.KeyCode == Enum.KeyCode.O) then 
		if input.KeyCode == Enum.KeyCode.I then self.Zoom = math.min(self.Zoom + self.zoomSens,self.maxZoom) self.offset = self.maxOffset:Lerp(self.minOffset, (self.maxZoom-self.Zoom)/self.Alerp)
		else self.Zoom = math.max(self.Zoom - self.zoomSens, self.minZoom) self.offset = self.maxOffset:Lerp(self.minOffset, (self.maxZoom-self.Zoom)/self.Alerp) end
	end

	if self.ShiftLock.active then
		if input.UserInputState == Enum.UserInputState.Change then
			local delta = input.Delta
			local X = math.sqrt(math.abs(delta.X)) * .02
			local Y = math.sqrt(math.abs(delta.Y)) * .02

			cameraRotation -= Vector2.new(
				if delta.X > 0 then X else -X,
				if delta.Y > 0 then Y else -Y
			)
			cameraRotation = Vector2.new(cameraRotation.X,math.clamp(cameraRotation.Y, math.rad(-self.max_rotation_y), math.rad(self.max_rotation_y))) --Clamp the y axis so it doesn't goes underground
		end
		return
	end

	local rightHold = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
	if rightHold and input.UserInputState == Enum.UserInputState.Change then
		local delta = input.Delta 
		local X = math.sqrt(math.abs(delta.X)) * .02
		local Y = math.sqrt(math.abs(delta.Y)) * .02

		cameraRotation -= Vector2.new(
			if delta.X > 0 then X else -X,
			if delta.Y > 0 then Y else -Y
		)
		cameraRotation = Vector2.new(cameraRotation.X,math.clamp(cameraRotation.Y, math.rad(-self.max_rotation_y), math.rad(self.max_rotation_y)))
	end
	UserInputService.MouseBehavior = rightHold and Enum.MouseBehavior.LockCurrentPosition or Enum.MouseBehavior.Default	
end

function CrunchyCam:Init(Option, Preset) 
	assert(typeof(Option) == "table", "parameter is not a table")
	
	if self.connections then
		for _,v in pairs(self.connections) do
			v:Disconnect()
		end
		RunService:UnbindFromRenderStep("Camera")
		RunService:UnbindFromRenderStep("charRotation")
	end

	
	if typeof(Preset) == "table" then 
		Option.__index = function(tabl, key)
			if Option[key] ~= nil then return Option[key] end
			if Preset[key] ~= nil then return Preset[key] end
			warn("The Property indexed is not valid")
		end
	else Option.__index = Option end
	
	local self = setmetatable(self,Option)

	workspace.Retargeting = Enum.AnimatorRetargetingMode.Disabled
	cam.CameraType = Enum.CameraType.Scriptable
	cam.CameraSubject = nil

	-- Precalculation / Temp value
	self.Shaking.seed_1 = 1 / self.Shaking.Resolution * self.Shaking.Frequency -- Seed for Shaking
	self.Shaking.seed_2 = 2 / self.Shaking.Resolution * self.Shaking.Frequency
	self.Shaking.seed_3 = 3 / self.Shaking.Resolution * self.Shaking.Frequency
	

	self.Alerp = self.maxZoom - self.minZoom --Division for lerping the offset
	self.Shaking.trauma = 0
	self.offset = self.minOffset
	
	self.pcam = pcam
	self.Host = if typeof(self.Host) ~= "Instance" then Torso else self.Host

	self.connections = {

		UserInputService.InputBegan:Connect(onInputChange),
		UserInputService.InputChanged:Connect(onInputChange),
		UserInputService.InputEnded:Connect(onInputChange),
		UserInputService.InputBegan:Connect(function(input, gpe)
			if not (input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift) then return end
			self.ShiftLock.active = not self.ShiftLock.active

			if self.ShiftLock.active then 
				UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
				UserInputService.MouseIcon = self.ShiftLock.crossHair
			else
				UserInputService.MouseBehavior = Enum.MouseBehavior.Default
				UserInputService.MouseIcon = ""
			end
		end),

	}
	
	RunService:BindToRenderStep("Camera",Enum.RenderPriority.Camera.Value, update)
	if self.HeadRotation.active or self.BodyRotation.active then
		RunService:BindToRenderStep("charRotation", Enum.RenderPriority.Character.Value, charRotation)
	end
	return self
end


function CrunchyCam:Traumatize(trauma)
	assert(typeof(trauma) == "number", "Trauma is just a number!")
	self.Shaking.trauma = math.min(self.Shaking.trauma + trauma,1) 
	--[[ Adding trauma, trauma is the level of camera
	shake. With 1 being 100% camera shake and 0 be 0% camerashake]]
end

function CrunchyCam:ToggleDebug()
	pcam.Transparency = if pcam.Transparency == 0.65 then 0 else 0.65
	pcam.AlignPosition.Visible = not pcam.AlignPosition.Visible
end

function CrunchyCam:ToggleBobbing(state :boolean)
	assert(typeof(state) == "boolean" or state == nil, "state must be a boolean value or nil")
	local self = CrunchyCam.Bobbing
	if state == nil then self.active = not self.active
	else self.active = state end
end

function CrunchyCam:ToggleShiftLock(state :boolean)
	assert(typeof(state) == "boolean" or state == nil, "state must be a boolean value or nil")
	local self = CrunchyCam.ShiftLock
	if state == nil then self.active = not self.active
	else self.active = state end
end

function CrunchyCam:ToggleBodyRotation(state :boolean)
	assert(typeof(state) == "boolean" or state == nil, "state must be a boolean value or nil")
	local self = CrunchyCam.BodyRotation
	if state == nil then self.active = not self.active
	else self.active = state end
end

function CrunchyCam:ToggleHeadRotation(state :boolean)
	assert(typeof(state) == "boolean" or state == nil, "state must be a boolean value or nil")
	local self = CrunchyCam.HeadRotation
	if state == nil then self.active = not self.active
	else self.active = state end
end


function CrunchyCam:SetHost(host : Instance, offset : Vector3)
	if not offset then offset = Vector3.zero end
	assert(host == nil or (typeof(host) == "Instance" and host.Position and host:IsDescendantOf(game.Workspace)), "host is not an Instance noir nil or host don't have a position")
	assert(typeof(offset) == "Vector3","offset must be a Vector3 value")
	
	if host == nil then
		repeat task.wait() until Torso and Torso:IsDescendantOf(game.Workspace) and char.Humanoid.Health ~= 0
		self.Host = Torso
		print(self.Host)
		param.IgnoreWater = true
		param.FilterType = Enum.RaycastFilterType.Exclude
		param.FilterDescendantsInstances = {self.Host,char}	
		return
	end
	-- if host is nil then host is automatically assign to player's character
	
	self.Host = host
	param.IgnoreWater = true
	param.FilterType = Enum.RaycastFilterType.Exclude
	param.FilterDescendantsInstances = {self.Host,pcam}	
end

Player.CharacterAdded:Connect(function(Char)
	local self = CrunchyCam
	local BodyHost = (self.Host == nil or self.Host:IsDescendantOf(char) or self.Host:IsDescendantOf(Char))
	char = Char
	local R6 = char:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R6
	Head = char:FindFirstChild("Head")

	Humanoid = char:FindFirstChild("Humanoid")
	HumanoidRootPart = char:FindFirstChild("HumanoidRootPart")

	Torso = if R6 then char:FindFirstChild("Torso") else char:FindFirstChild("UpperTorso") 
	Neck = if R6 then Torso:FindFirstChild("Neck") else Head:FindFirstChild("Neck")

	Waist = if R6 then HumanoidRootPart:FindFirstChild("RootJoint") else Torso:WaitForChild("Waist")

	if R6 then
		RHip = Torso:FindFirstChild("Right Hip")
		LHip = Torso:FindFirstChild("Left Hip")
	end
	
	if not BodyHost then return end
	
	self.Host = Torso

	Neck.MaxVelocity = 0.333

	param.IgnoreWater = true
	param.FilterType = Enum.RaycastFilterType.Exclude
	param.FilterDescendantsInstances = {char,pcam}
end)

--[[ Crunchy Cam an over-engineered camera that you never know you needed
- Developed by MrVietChopsticks
- Pablo Picasso once said "Good artist copy, Great artist steal"
- Credit: + CameraService by Lugical for base template https://devforum.roblox.com/t/cameraservice-a-new-camera-for-a-new-roblox/1988655
		  + Excellent spring modudle Fractality: https://devforum.roblox.com/t/spring-driven-motion-spr/714728
		  + dthecooles: cool animation for the demo https://devforum.roblox.com/t/r6-ikpf-inverse-kinematics-procedural-footplanting/1472311
		  + movement iterpolation: https://devforum.roblox.com/t/simulating-smoother-character-movement/776344/3
		  + Camera Panning: https://devforum.roblox.com/t/making-camera-move-slightly-with-your-mouse/125392/2
		  + Camera Bobbing: https://devforum.roblox.com/t/configurable-head-bobbing-script/1505850/12
		  + BodyRotation r6 and r15: https://devforum.roblox.com/t/bending-player-torso-on-an-r6-rig/1945245/3
		  + Perlin noise shake from gdc talk: https://www.youtube.com/watch?v=tu-Qe66AvtY
]]		

return CrunchyCam
