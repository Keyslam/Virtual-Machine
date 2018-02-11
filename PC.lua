local Ram

local PC = {
   address = 0xDA7D,
}

function PC.increment(step)
   local Ram = Ram or require("ram")

   local value = Ram.get(PC.address)
   value = bit.band(0xFFFF, value + (step or 1))
   PC.set(value)
end

function PC.decrement(step)
   local Ram = Ram or require("ram")

   local value = Ram.get(PC.address)
   value = bit.band(0xFFFF, value - (step or 1))
   PC.set(value)
end

function PC.get()
   local Ram = Ram or require("ram")

   return Ram.get(PC.address)
end

function PC.set(value)
   local Ram = Ram or require("ram")

   Ram.set(PC.address, value)
end


return PC
