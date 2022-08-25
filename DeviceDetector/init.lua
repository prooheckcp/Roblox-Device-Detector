local UserInputService = game:GetService("UserInputService")

local DeviceType = require(script.DeviceType)
local Connection = require(script.Connection)

local USER_INPUT_TYPE : Dictionary<Enum.UserInputType| DeviceType.DeviceType> = {
    [Enum.UserInputType.Gamepad1] = DeviceType.Controller,
    [Enum.UserInputType.Touch] = DeviceType.Mobile,
    [Enum.UserInputType.Keyboard] = DeviceType.Computer,
    [Enum.UserInputType.MouseButton1] = DeviceType.Computer,
    [Enum.UserInputType.MouseButton2] = DeviceType.Computer,
}

local DeviceDetector = {}
DeviceDetector._currentDevice = nil :: DeviceType.DeviceType
DeviceDetector._deviceChangedCallbacks = {}
DeviceDetector.ChangedDevice = {}

function DeviceDetector:Setup() : DeviceType.DeviceType
    if UserInputService.TouchEnabled then
        self._currentDevice = DeviceType.Mobile
    elseif UserInputService.GamepadEnabled then
        self._currentDevice = DeviceType.Controller
    else
        self._currentDevice = DeviceType.Computer
    end

    UserInputService.GamepadConnected:Connect(function()
        self:SetCurrentDevic(DeviceType.Controller)
    end)

    UserInputService.GamepadDisconnected:Connect(function()
        self:SetCurrentDevice(DeviceType.Computer)
    end)

    UserInputService.InputChanged:Connect(function(inputObject : InputObject)
        if 
        inputObject.KeyCode ~= Enum.KeyCode.Thumbstick1
        and inputObject.KeyCode ~= Enum.KeyCode.Thumbstick2 then
            return
        end

        if inputObject.Position.Magnitude < 0.2 then
            return
        end

        self:_DeviceInput(inputObject)
    end)

    UserInputService.InputBegan:Connect(function(...)
        self:_DeviceInput(...)
    end)

    return self._currentDevice
end

function DeviceDetector:SetCurrentDevice(deviceType : DeviceType.DeviceType) : nil
    if deviceType == self._currentDevice then
        return
    end

    self._currentDevice = deviceType

    for _, connection in pairs(self._deviceChangedCallbacks) do
        connection(self:GetCurrentDevice())
    end
end

function DeviceDetector.ChangedDevice:Connect(callback : (deviceType : DeviceType.DeviceType)->nil) : Connection.Connection
    local newConnection : Connection.Connection = Connection.new()
    DeviceDetector._deviceChangedCallbacks[newConnection] = callback

    function newConnection:Disconnect()
        self:Destroy()
    end

    function newConnection:Destroy()
        DeviceDetector._deviceChangedCallbacks[newConnection] = nil
    end

    return newConnection
end

function DeviceDetector:GetCurrentDevice() : DeviceType.DeviceType
    return self._currentDevice
end

function DeviceDetector:_DeviceInput(inputObject : InputObject) : nil
    if not USER_INPUT_TYPE[inputObject.UserInputType] then
        return
    end

    self:SetCurrentDevice(USER_INPUT_TYPE[inputObject.UserInputType])
end

return DeviceDetector