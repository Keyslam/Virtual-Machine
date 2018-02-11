local Instructions = require("instructions")

local Assembler = {
   address = 0xDA7C,
   lookup  = {},
}

for i = 0, 0xFF do
   local inst = Instructions[i]
   Assembler.lookup[inst[3]] = i
end

function Assembler.translate(file)
   file:open("r")

   local c    = 0x0000
   local cl   = 0
   local prgm = {}
   local vars = {}

   for line in file:lines() do
      local words = {}

      for word in line:gmatch("%w+") do
         table.insert(words, word)
      end

      local numInst = Assembler.lookup[words[1]]
      local inst    = Instructions[numInst]

      if inst[2] ~= #words-1 then
         print("Invalid arguments. #"..cl)
         return
      end

      prgm[c] = numInst
      c = c + 1

      for i = 2, #words do
         local v = words[i]

         if not tonumber(v) then
            if not vars[v] then
               vars[v] = Assembler.address
               Assembler.address = Assembler.address - 1
            end

            v = vars[v]
         end

         prgm[c] = v
         c = c + 1
      end

      cl = cl + 1
   end

   file:close()

   return prgm
end

return Assembler
