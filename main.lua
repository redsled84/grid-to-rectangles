local ROT = require 'rotLove/rot'
local bg = ROT.Map.Brogue(45, 45)
bg:create(function(x,y,val)end,true)
local grid = bg._map

function safeCheck(x, y)
  return x > 0 and y > 0 and x <= #grid[1] and y <= #grid 
end

local rects = {}

local function existantRect(x, y)
  for i = 1, #rects do
    local rect = rects[i]
    if rect.x == x and rect.y == y then
      return true
    end
  end
  return false
end

local function similarRect(x, w, j)
  for i = 1, #rects do
    local rect = rects[i]
    if rect.x == x and rect.w == w and j ~= i then
      return true
    end
  end
  return false
end

local doors = {}
function optimizeMap()
  for y = 1, #grid do
    local rx = 1
    for x = 1, #grid[y] do
      local rw = x - rx 
      local n = grid[y][x]
      local rowContainsZero = false
      if n == 0 then
        rowContainsZero = true
      end
      if not rowContainsZero and x == #grid[y] and not existantRect(rx, y) then
        table.insert(rects, {x=rx, y=y, w=rw, h=1})
      end
      if x < #grid[y] then
        if n == 0 and grid[y][x+1] == 1 then
          rx = x + 1
        end
        if n == 2 and grid[y-1][x] == 0 and grid[y+1][x] == 0 then
          table.insert(rects, {x=rx, y=y, w=rw, h=1})
          rx = x+1
        end
        if n == 1 and grid[y][x+1] == 0 and not existantRect(rx, y) then
          table.insert(rects, {x=rx, y=y, w=rw+1, h=1})
        end
      end
    end
  end
  table.insert(rects, {x=#grid[1], y = 1, w = 1, h = #grid})
end

function love.load()
  optimizeMap()
end

function love.draw()
  for i = 1, #rects do
    local rect = rects[i]
    love.graphics.setColor(255,255,255,100)
    love.graphics.rectangle('fill', rect.x*8, rect.y*8, rect.w*8, rect.h*8)
    love.graphics.setColor(255,255,255,100)
    love.graphics.rectangle('line', rect.x*8, rect.y*8, rect.w*8, rect.h*8)
  end
  for i = 1, #doors do
    local door = doors[i]
    love.graphics.setColor(0,255,0,100)
    love.graphics.rectangle('fill', door.x*8, door.y*8, door.w*8, door.h*8)
  end
  for y = 1, #grid do
    for x = 1, #grid[y] do
      local n = grid[y][x]
      if n == 2 then
        love.graphics.setColor(255,0,0, 40)
        love.graphics.rectangle('fill', x*8, y*8, 8, 8)
      end
    end
  end

  local realGridXOffset = 370
  for y = 1, #grid do
    for x = 1, #grid[y] do
      local n = grid[y][x]
      if n == 1 then
        love.graphics.setColor(255,255,255,180)
        love.graphics.rectangle('fill', x*8+realGridXOffset, y*8, 8, 8)
      end
      if n == 2 then
        love.graphics.setColor(255,0,0, 190)
        love.graphics.rectangle('fill', x*8+realGridXOffset, y*8, 8, 8)
      end
    end
  end
end

function love.keypressed(key)
  if key == 'r' then
    love.event.quit('restart')
  end
end
