-- VSCode Debug Config
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

SCREEN_WIDTH = 667
SCREEN_HEIGHT = 375
CURRENT_DISTANCE = 0
PIPE_WIDTH = 50
PIPE_SEPARATION = 100
PIPE_DISTANCE = 200

require("Ground")
require("Pipe")
require("Player")

local world
local player = {}
local ground = {}
local ball = {}
local pipes = {}

function createPipes(quantity)
  local topPipesHeights = { 120, 150, 170 }

  local topPipeHeight = topPipesHeights[math.random(1, 3)]
  local bottomPipeY = topPipeHeight + PIPE_SEPARATION
  local bottomPipeHeight = SCREEN_HEIGHT - bottomPipeY
  
  local topPipe = Pipe:new(world, SCREEN_WIDTH, 0, PIPE_WIDTH, topPipeHeight)
  local bottomPipe = Pipe:new(world, SCREEN_WIDTH, bottomPipeY, PIPE_WIDTH, bottomPipeHeight)

  table.insert(pipes, topPipe)
  table.insert(pipes, bottomPipe)
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

  createPipes(1)
end

function love.keypressed(key)
  player:keypressed(key)
end

local lastPipeDistance = 0

function love.update(dt)
  world:update(dt)
  player:update(dt)

  for i = 1, #pipes do
    pipes[i]:update()
  end

  if CURRENT_DISTANCE - lastPipeDistance >= PIPE_DISTANCE then
    createPipes(1)
    lastPipeDistance = CURRENT_DISTANCE
  end

  CURRENT_DISTANCE = CURRENT_DISTANCE + 1
end

function love.draw()
  for i = 1, #pipes do
    pipes[i]:draw()
  end

  ground:draw()
  player:draw()

  -- Debug
  love.graphics.print("distance: " .. CURRENT_DISTANCE, 10)
  love.graphics.print("pipes: " .. #pipes, 10, 30)
end
