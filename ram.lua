local Ram = {
   size = 0xFFFF,
}

function Ram.get(address)
   return Ram[address] or 0x0000
end

function Ram.set(address, value)
   if address >= 0 and address <= Ram.size then
      value = math.min(0xFFFF, math.max(0, value))
      Ram[address] = value
   end
end

return Ram
