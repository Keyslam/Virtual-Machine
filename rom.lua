local Rom = {
   size = 0xFFFF,
}

function Rom.get(address)
   return Ram[address] or 0x0000
end

return Ram
