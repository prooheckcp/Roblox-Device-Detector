local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DeviceDetector = require(ReplicatedStorage.DeviceDetector)

DeviceDetector:Setup()

DeviceDetector.ChangedDevice:Connect(function(deviceType)
    print(deviceType)
end)