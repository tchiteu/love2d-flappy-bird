-- VSCode Debug Config
if os.getenv('LOCAL_LUA_DEBUGGER_VSCODE') == '1' then
  require('lldebugger').start()
end

SCREEN_WIDTH = 680
SCREEN_HEIGHT = 357
GAME_STATE = 'initial' -- playing, dead
GAME_POINTS = 0
CURRENT_DISTANCE = 0
PIPE_WIDTH = 68
PIPE_SEPARATION = 102
PIPE_DISTANCE = 100

require('Ground')
require('Pipe')
require('Player')

local world
local player = {}
local ground = {}
local ball = {}
local pipes = {}

function createPipes()
  local topPipesHeights = { 102, 153, 204 }

  local topPipeHeight = topPipesHeights[math.random(1, 2)]
  local bottomPipeY = topPipeHeight + PIPE_SEPARATION
  local bottomPipeHeight = SCREEN_HEIGHT - bottomPipeY
  
  local topPipe = Pipe:new(world, SCREEN_WIDTH, 0, PIPE_WIDTH, topPipeHeight, 'top')
  local bottomPipe = Pipe:new(world, SCREEN_WIDTH, bottomPipeY, PIPE_WIDTH, bottomPipeHeight, 'bottom')

  table.insert(pipes, topPipe)
  table.insert(pipes, bottomPipe)
end

function death()
  GAME_STATE = 'dead'
end

function love.load()
  -- Config
  local font = love.graphics.newFont(24)
  love.graphics.setFont(font)
  love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, { resizable = false, vsync = true })

  -- World
  world = love.physics.newWorld(0, 9.81 * 64, true)
  player = Player:new(world, 20, SCREEN_HEIGHT / 2)
  ground = Ground:new(world)

  world:setCallbacks(death)

  createPipes()
end

function love.keypressed(key)
  player:keypressed(key)
end

local lastPipeDistance = 0

function love.update(dt)
  if GAME_STATE == 'dead' then
    return
  end

  world:update(dt)
  player:update(dt)

  for i = #pipes, 1, -1 do
    local pipe = pipes[i]
    pipe:update()

    local pipeX = pipe.body:getX()

    if pipeX - pipe.width < 0 then
      GAME_POINTS = GAME_POINTS + 1
    end

    if pipeX + pipe.width < 0 then
      table.remove(pipes, i)
      pipe:destroy()
    end
  end

  if CURRENT_DISTANCE - lastPipeDistance >= PIPE_DISTANCE then
    createPipes()
    lastPipeDistance = CURRENT_DISTANCE
  end

  CURRENT_DISTANCE = CURRENT_DISTANCE + 1
end

function love.draw()
  for i = #pipes, 1, -1 do
    pipes[i]:draw()
  end

  ground:draw()
  player:draw()

  -- Debug
  love.graphics.print('Points: ' .. GAME_POINTS)
end
