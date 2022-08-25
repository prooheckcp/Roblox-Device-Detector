local Connection = {}
Connection.__index = Connection

function Connection.new()
    return setmetatable({}, Connection)
end

function Connection:Destroy() : ()
    
end

export type Connection = typeof(Connection)

return Connection