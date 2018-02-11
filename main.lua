local PC           = require("PC")
local Ram          = require("ram")
local FB           = require("FB")
local Instructions = require("instructions")
local CU           = require("CU")

local Assembler = require("assembler_lua")


CU.running = false

function love.update(dt)
   CU.step()
   FB.render()
   love.timer.sleep(0.025)
end


function love.draw()
   FB.draw()
end

function love.keypressed(key)
   if key == "s" then
      CU.running = true
   end
end

function love.filedropped(file)
   local asm = Assembler.translate(file)
   if asm then
      for address = 0, 0xFFFF do
         if asm[address] then
            Ram.set(address, asm[address])
            print(address, asm[address])
         end
      end
   end
end

--[[
underflow = n ~= math.max(0, n)
overflow = n ~= math.min(0xFFFF, n)
value = math.min(0xFFFF, math.max(0, n))
]]
