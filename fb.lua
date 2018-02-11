local Ram

local FB = {
   address = 0xDA7E,
   size    = 0x2580,

   buffer = love.image.newImageData(240, 160),

   colors = {
      [0x0] = {  0,   0,   0}, -- Black
      [0x1] = { 29,  43,  83}, -- Dark Blue
      [0x2] = {126,  37,  83}, -- Dark Purple
      [0x3] = {  0, 135,  81}, -- Dark Green
      [0x4] = {171,  82,  54}, -- Brown
      [0x5] = { 95,  87,  79}, -- Dark Gray
      [0x6] = {194, 195, 199}, -- Light Gray
      [0x7] = {255, 241, 232}, -- White
      [0x8] = {255,   0,  77}, -- Red
      [0x9] = {255, 163,   0}, -- Orange
      [0xA] = {255, 236,  39}, -- Yellow
      [0xB] = {  0, 228,  54}, -- Green
      [0xC] = { 41, 173, 255}, -- Blue
      [0xD] = {131, 118, 156}, -- Indigo
      [0xE] = {255, 119, 168}, -- Pink
      [0xF] = {255, 204, 170}, -- Peach
   },
}

function FB.plot(x, y, pixel)
   local Ram = Ram or require("ram")

   local address = FB.address + math.floor(x / 4) + y * 60
   local index   = x % 4

   local c = {}
   local value = Ram.get(address)

   c[0] = bit.band(0xF000, value) / 0x1000
   c[1] = bit.band(0x0F00, value) / 0x100
   c[2] = bit.band(0x00F0, value) / 0x10
   c[3] = bit.band(0x000F, value)

   c[index] = pixel

   Ram.set(address, (c[0] * 0x1000) + (c[1] * 0x100) + (c[2] * 0x10) + c[3])
end

function FB.render()
   local Ram = Ram or require("ram")

   local x, y = 0, 0
   local c    = {}

   for address = FB.address, FB.address + FB.size - 1 do
      local value = Ram.get(address)

      c[1] = bit.band(0xF000, value) / 0x1000
      c[2] = bit.band(0x0F00, value) / 0x100
      c[3] = bit.band(0x00F0, value) / 0x10
      c[4] = bit.band(0x000F, value)

      for i = 1, 4 do
         local color = FB.colors[c[i]]
         FB.buffer:setPixel(x, y, color)

         x = x + 1
      end

      if x > 239 then
         x = 0
         y = y + 1
      end
   end
end

function FB.draw()
   local img = love.graphics.newImage(FB.buffer)
   img:setFilter("nearest", "nearest")
   love.graphics.draw(img, 0, 0, 0, love.graphics.getWidth() / 240, love.graphics.getHeight() / 160)
end

return FB
