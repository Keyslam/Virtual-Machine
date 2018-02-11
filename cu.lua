local PC, Ram, Instructions

local CU = {
   running = true,
}

function CU.fetch()
   PC  = PC or require("pc")
   Ram = Ram or require("ram")

   return Ram.get(PC.get())
end

function CU.decode(numInstr)
   local Instructions = Instructions or require("instructions")

   local instr = Instructions[numInstr]
   return instr[1], instr[2], instr[3]
end

function CU.execute(inst, argCount)
   local PC = PC or require("pc")
   local Ram = Ram or require("Ram")

   local args = {}
   for i = 1, argCount do
      args[i] = Ram.get(PC.get() + i)
   end

   PC.increment(argCount + 1)
   inst(unpack(args))
end

function CU.step()
   if CU.running then
      local numInst = CU.fetch()
      local inst, argCount, name = CU.decode(numInst)
      --print(name)
      CU.execute(inst, argCount)
   end
end

return CU
