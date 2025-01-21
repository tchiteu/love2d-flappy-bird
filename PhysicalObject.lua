-- PhysicalObject Class
PhysicalObject = {}

function PhysicalObject:new(world, x, y, width, height, type)
  local newPhysicalObject = {}
  self.__index = self
  setmetatable(newPhysicalObject, self)

  newPhysicalObject.width = width
  newPhysicalObject.height = height
  newPhysicalObject.body = love.physics.newBody(world, x + width / 2, y + height / 2, type)
  newPhysicalObject.shape = love.physics.newRectangleShape(width, height)
  newPhysicalObject.fixture = love.physics.newFixture(newPhysicalObject.body, newPhysicalObject.shape)

  return newPhysicalObject
end

function PhysicalObject:draw()
  if self.body then
    return love.graphics.polygon('line', self.body:getWorldPoints(self.shape:getPoints()))
  end
end

function PhysicalObject:destroy()
  if self.body then
    self.body:destroy()
    self.body = nil
  end
end

return PhysicalObject
