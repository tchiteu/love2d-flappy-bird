require('PhysicalObject')

-- Pipe Class
Pipe = {}
setmetatable(Pipe, { __index = PhysicalObject })

local PIPE_VELOCITY = 3

function Pipe:new(world, x, y, width, height, type)
  local newPipe = PhysicalObject:new(world, x, y, width, height, 'static')

  local segmentWidth = 68
  local segmentHeight = 51

  newPipe.spriteSheet = love.graphics.newImage('assets/pipes_sheet.png')
  newPipe.quads = {
    bottom = love.graphics.newQuad(0, 0, segmentWidth, segmentHeight, newPipe.spriteSheet:getDimensions()),
    bottom_alt = love.graphics.newQuad(68, 0, segmentWidth, segmentHeight, newPipe.spriteSheet:getDimensions()),
    mid = love.graphics.newQuad(136, 0, segmentWidth, segmentHeight, newPipe.spriteSheet:getDimensions()),
    mid_alt = love.graphics.newQuad(204, 0, segmentWidth, segmentHeight, newPipe.spriteSheet:getDimensions()),
    top = love.graphics.newQuad(272, 0, segmentWidth, segmentHeight, newPipe.spriteSheet:getDimensions()),
    top_alt = love.graphics.newQuad(340, 0, segmentWidth, segmentHeight, newPipe.spriteSheet:getDimensions()),
  }

  newPipe.segments = {}
  local remainingHeight = height
  
  if math.random(1, 2) == 1 then
    table.insert(newPipe.segments, newPipe.quads.bottom)
  else
    table.insert(newPipe.segments, newPipe.quads.bottom_alt)
  end
  remainingHeight = remainingHeight - segmentHeight

  while remainingHeight > segmentHeight do
    if math.random(1, 2) == 1 then
      table.insert(newPipe.segments, newPipe.quads.mid)
    else
      table.insert(newPipe.segments, newPipe.quads.mid_alt)
    end
    remainingHeight = remainingHeight - segmentHeight
  end

  if math.random(1, 2) == 1 then
    table.insert(newPipe.segments, newPipe.quads.top)
  else
    table.insert(newPipe.segments, newPipe.quads.top_alt)
  end

  newPipe.type = type

  self.__index = self
  setmetatable(newPipe, self)

  return newPipe
end

function Pipe:update()
  if not self.body then 
    return
  end

  local newX = self.body:getX() - PIPE_VELOCITY
  self.body:setX(newX)
end

function Pipe:draw()
  if not self.body then
    return
  end

  local x = self.body:getX() - self.width / 2
  local y = self.body:getY() - self.height / 2
  local segmentHeight = 51

  if self.type == "top" then
    for i = #self.segments, 1, -1 do
      local segment = self.segments[i]
      love.graphics.draw(self.spriteSheet, segment, x, y, 0, 1, -1, 0, segmentHeight)
      y = y + segmentHeight
    end
  else
    for i, segment in ipairs(self.segments) do
      love.graphics.draw(self.spriteSheet, segment, x, y)
      y = y + segmentHeight
    end
  end
end

return Pipe
