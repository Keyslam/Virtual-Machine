local PC           = require("PC")
local Ram          = require("ram")
local FB           = require("FB")
local Instructions = require("instructions")
local CU           = require("CU")

local Assembler = require("assembler_lua")
local Lexer     = require("lexer_lua2")

CU.running = false

function love.update(dt)
   for i = 1, 1000 do
      CU.step()
   end
   FB.render()
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
   --[[
   local asm = Assembler.translate(file)
   if asm then
      for address = 0, 0xFFFF do
         if asm[address] then
            Ram.set(address, asm[address])
         end
      end
   end
   ]]

   Lexer.lex(file)
end

--[[
underflow = n ~= math.max(0, n)
overflow = n ~= math.min(0xFFFF, n)
value = math.min(0xFFFF, math.max(0, n))
]]
