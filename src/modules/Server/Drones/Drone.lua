--- The actual drone object
-- @classmod Drone
-- @author Quenty

local require = require(game:GetService("ReplicatedStorage"):WaitForChild("Nevermore"))

local DroneScanner = require("DroneScanner")
local BaseObject = require("BaseObject")
local ServerBinders = require("ServerBinders")
local DroneDriveControl = require("DroneDriveControl")
local DroneGoalManager = require("DroneGoalManager")
local DroneCollisionTracker = require("DroneCollisionTracker")

local Drone = setmetatable({}, BaseObject)
Drone.ClassName = "Drone"
Drone.__index = Drone

function Drone.new(obj)
	local self = setmetatable(BaseObject.new(obj), Drone)

	self._scanner = DroneScanner.new(self)

	self._driveControl = DroneDriveControl.new(self._obj, self._scanner)
	self._maid:GiveTask(self._driveControl)

	self._droneGoalManager = DroneGoalManager.new(self._driveControl)
	self._maid:GiveTask(self._driveControl)

	self._collisionTracker = DroneCollisionTracker.new(self._obj)
	self._collisionTracker.Exploded:Connect(function()
		ServerBinders.Drone:Unbind(self._obj)
	end)

	return self
end

function Drone:GetIgnorePart()
	return self._obj
end

function Drone:GetPosition()
	return self._obj.Position
end

return Drone