require('PhysicalObject')
anim8 = require('libs/anim8')

-- Player Class
Player = {}
setmetatable(Player, { __index = PhysicalObject })

local PLAYER_WIDTH = 34
local PLAYER_HEIGHT = 24
local INITIAL_X = 40
local INITIAL_Y = SCREEN_HEIGHT - PLAYER_HEIGHT

function Player:new(world, x, y)
  local newPlayer = PhysicalObject:new(world, x, y, PLAYER_WIDTH, PLAYER_HEIGHT, 'dynamic')
  newPlayer.body:setFixedRotation(true)

  newPlayer.sprite = love.graphics.newImage('assets/bird_sheet.png')
  newPlayer.grid = anim8.newGrid(34, 24, newPlayer.sprite:getWidth(), newPlayer.sprite:getHeight())

  newPlayer.animations = {}
  newPlayer.animations.idle = anim8.newAnimation( newPlayer.grid('1-3', 1), 0.2)
  
  self.__index = self
  setmetatable(newPlayer, self)

  return newPlayer
end

function Player:keypressed(key)
  if key == 'space' then
    local jumpForce = -200
    local vx, vy = self.body:getLinearVelocity()

    self.body:setLinearVelocity(vx, jumpForce)

    if GAME_STATE == 'initial' then
      GAME_STATE = 'playing'
    end
  end
end

function Player:update(dt)
  if GAME_STATE == 'initial' then
    self.body:setGravityScale(0)
    self.body:setLinearVelocity(0, 0)
  elseif GAME_STATE == 'playing' then
    self.body:setGravityScale(1)
  end

  self.animations.idle:update(dt)
end

function Player:draw()
  local playerX, playerY = self.body:getWorldPoints(self.shape:getPoints())
  self.animations.idle:draw(self.sprite, playerX, playerY)
end

return Player
