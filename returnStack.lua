local Ram

local ReturnStack = {
   address = 0xDA5C,
   size    = 0x001F,
   pointer = 0x0000,
}

function ReturnStack.push(value)
   local Ram = Ram or require("ram")

   if ReturnStack.pointer < ReturnStack.size then
      ReturnStack.pointer = ReturnStack.pointer + 1
      Ram.set(ReturnStack.pointer, value)
   end
end

function ReturnStack.pop()
   local Ram = Ram or require("ram")

   if ReturnStack.pointer > 0x0000 then
      local value = Ram.get(ReturnStack.address - ReturnStack.pointer)
      ReturnStack.pointer = ReturnStack.pointer - 0x0001

      return value
   end

   return 0x0000
end

return ReturnStack
