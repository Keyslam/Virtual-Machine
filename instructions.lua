local CU, Ram, PC, FB, Rom

local Instructions = {
   [0x00] = {function()
   end, 0, "NOOP"},

   [0x01] = {function(a, b, c)
      local Ram = Ram or require("ram")

      local sum = Ram.get(a) + Ram.get(b)
      Ram.set(c, math.min(0xFFFF, math.max(0, sum)))
   end, 3, "ADD"},

   [0x02] = {function(a, b, c)
      local Ram = Ram or require("ram")

      local sum = Ram.get(a) - Ram.get(b)
      Ram.set(c, math.min(0xFFFF, math.max(0, sum)))
   end, 3, "SUB"},

   [0x03] = {function(a, b, c)
      local Ram = Ram or require("ram")

      local sum = Ram.get(a) * Ram.get(b)
      Ram.set(c, math.min(0xFFFF, math.max(0, sum)))
   end, 3, "MULT"},

   [0x04] = {function(a, b, c)
      local Ram = Ram or require("ram")

      Ram.set(c, math.floor(Ram.get(a) / Ram.get(b)))
   end, 3, "DIV"},

   [0x05] = {function(a, b, c)
      local Ram = Ram or require("ram")

      Ram.set(c, math.floor(Ram.get(a) % Ram.get(b)))
   end, 3, "MOD"},

   [0x06] = {function(addr)
      local PC = PC or require("pc")

      PC.set(addr)
   end, 1, "BRANCH"},

   [0x07] = {function(a, addr)
      local PC  = PC or require("pc")
      local Ram = Ram or require("ram")

      if Ram.get(a) == 0 then
         PC.set(addr)
      end
   end, 2, "BZERO"},

   [0x08] = {function(a, addr)
      local PC  = PC or require("pc")
      local Ram = Ram or require("ram")

      if Ram.get(a) ~= 0 then
         PC.set(addr)
      end
   end, 2, "BNZERO"},

   [0x09] = {function(a, b, addr)
      local PC  = PC or require("pc")
      local Ram = Ram or require("ram")

      if Ram.get(a) == Ram.get(b) then
         PC.set(addr)
      end
   end, 3, "BE"},

   [0x0A] = {function(a, b, addr)
      local PC  = PC or require("pc")
      local Ram = Ram or require("ram")

      if Ram.get(a) ~= Ram.get(b) then
         PC.set(addr)
      end
   end, 3, "BNE"},

   [0x0B] = {function(a, b, addr)
      local PC  = PC or require("pc")
      local Ram = Ram or require("ram")

      if Ram.get(a) > Ram.get(b) then
         PC.set(addr)
      end
   end, 3, "BG"},

   [0x0C] = {function(a, b, addr)
      local PC  = PC or require("pc")
      local Ram = Ram or require("ram")

      if Ram.get(a) < Ram.get(b) then
         PC.set(addr)
      end
   end, 3, "BL"},

   [0x0D] = {function(a, b, addr)
      local PC  = PC or require("pc")
      local Ram = Ram or require("ram")

      if Ram.get(a) >= Ram.get(b) then
         PC.set(addr)
      end
   end, 3, "BEG"},

   [0x0E] = {function(a, b, addr)
      local PC  = PC or require("pc")
      local Ram = Ram or require("ram")

      if Ram.get(a) <= Ram.get(b) then
         PC.set(addr)
      end
   end, 3, "BEL"},

   [0x0F] = {function(a)
      local Ram   = Ram or require("ram")
      local Stack = Stack or require("stack")

      Stack.push(Ram.get(a))
   end, 1, "PUSH"},

   [0x10] = {function(a)
      local Ram   = Ram or require("ram")
      local Stack = Stack or require("stack")

      Ram.set(a, Stack.pop())
   end, 1, "POP"},

   [0x11] = {function()
      local PC      = PC or require("pc")
      local ReStack = ReStack or require("restack")

      ReStack.push(PC.get() + 0x0001)
   end, 0, "PUSHRE"},

   [0x12] = {function()
      local PC      = PC or require("pc")
      local ReStack = ReStack or require("restack")

      PC.set(ReStack.pop())
   end, 0, "POPRE"},

   [0x13] = {function(a, b)
      local Ram = Ram or require("ram")

      Ram.set(b, Ram.get(a))
   end, 2, "MOVE"},

   [0x14] = {function(a, imm)
      local Ram = Ram or require("ram")

      Ram.set(a, imm)
   end, 2, "LOADIMM"},

   [0x15] = {function(a, b, c)
      local FB  = FB  or require("fb")
      local Ram = Ram or require("ram")

      FB.plot(Ram.get(a), Ram.get(b), Ram.get(c))
   end, 3, "PLOT"},

   [0xFD] = {function(msg)
      print(tostring(msg))
   end, 1, "DEBUG"},

   [0xFE] = {function(a)
      local Ram = Ram or require("ram")

      print(Ram.get(a))
   end, 1, "LOG"},

   [0xFF] = {function()
      local CU = CU or require("CU")

      CU.running = false
   end, 0, "HALT"},
}

return setmetatable(Instructions, {
   __index = function() return Instructions[0x00] end,
})
