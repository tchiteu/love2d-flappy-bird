require("PhysicalObject")

-- Ground Class
Ground = {}
setmetatable(Ground, { __index = PhysicalObject })

function Ground:new(world)
  local newGround = PhysicalObject:new(world, 0, SCREEN_HEIGHT - 20, SCREEN_WIDTH, 20, "static")

  self.__index = self
  setmetatable(newGround, self)

  return newGround
end

return Ground
