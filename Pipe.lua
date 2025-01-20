require("PhysicalObject")

-- Pipe Class
Pipe = {}
setmetatable(Pipe, { __index = PhysicalObject })

local PIPE_VELOCITY = 1

function Pipe:new(world, x, y, width, height)
  local newPipe = PhysicalObject:new(world, x, y, width, height, "static")

  self.__index = self
  setmetatable(newPipe, self)

  return newPipe
end

function Pipe:update()
  local newX = self.body:getX() - PIPE_VELOCITY

  self.body:setX(newX)
end

return Pipe
