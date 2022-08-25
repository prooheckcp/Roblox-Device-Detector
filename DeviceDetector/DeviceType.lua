local DeviceType = {
    Controller = "Controller",
    Mobile = "Mobile",
    Computer = "Computer",
}

table.freeze(DeviceType)

export type DeviceType = typeof(DeviceType)

return DeviceType