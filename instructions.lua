local CU, Ram, PC, FB, Rom

local Instructions = {
   [0x00] = {function()
   end, 0, "NOOP"},

   [0x01] = {function(address, value)
      local Ram = Ram or require("ram")

      Ram.set(address, value)
   end, 2, "LOAD"},

   [0x02] = {function(address)
      local Ram = Ram or require("ram")

      print("LOG MESSAGE: " ..Ram.get(address))
   end, 1, "LOG"},

   [0x03] = {function(value)
      local PC = PC or require("pc")
      PC.set(value)
   end, 1, "GOTO"},

   [0x04] = {function(a, b, c)
      local Ram = Ram or require("ram")

      local sum = Ram.get(a) + Ram.get(b)

      local overflow = sum ~= math.min(0xFFFF, sum)

      Ram.set(c, math.min(0xFFFF, math.max(0, sum)))
   end, 3, "ADD"},

   [0x05] = {function(from, to)
      local Ram = Ram or require("ram")

      Ram.set(to, Ram.get(from))
   end, 2, "MOVE"},

   [0x06] = {function(x, y, pixel)
      local Ram = Ram or require("ram")
      local FB  = FB or require("fb")

      FB.plot(Ram.get(x), Ram.get(y), Ram.get(pixel))
   end, 3, "PLOT"},

   [0x07] = {function(a, b, c)
      local Ram = Ram or require("ram")

      local sum = Ram.get(a) - Ram.get(b)

      Ram.set(c, math.min(0xFFFF, math.max(0, sum)))
   end, 3, "SUB"},

   [0x08] = {function(a, b, c)
      local Ram = Ram or require("ram")

      local sum = Ram.get(a) * Ram.get(b)

      Ram.set(c, math.min(0xFFFF, math.max(0, sum)))
   end, 3, "MULT"},

   [0x09] = {function(rom_address, ram_address)
      local Ram = Ram or require("ram")
      local Rom = Rom or require("ram")

      Ram.set(ram_address, Rom.get(rom_address))
   end, 2, "LOADROM"},

   [0xFF] = {function()
      local CU = CU or require("CU")

      CU.running = false
   end, 0, "HALT"},
}

return setmetatable(Instructions, {
   __index = function() return Instructions[0x00] end,
})
