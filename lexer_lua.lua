local Lexer = {
   isString  = nil,
   isComment = nil,

   buffer  = "",
   sbuffer = "",

   tokens = {},
}

local Tokens = {
   ["let"]      = "keyword",
   ["if"]       = "keyword",
   ["for"]      = "keyword",
   ["while"]    = "keyword",
   ["function"] = "keyword",
   ["array"]    = "keyword",

   ["+"]  = "operator",
   ["-"]  = "operator",
   ["*"]  = "operator",
   ["/"]  = "operator",
   ["%"]  = "operator",
   ["="]  = "operator",
   [">"]  = "operator",
   ["<"]  = "operator",
   [">="] = "operator",
   ["<="] = "operator",
   ["=="] = "operator",
   ["!="] = "operator",

   [","] = "separator",
   ["("] = "separator",
   [")"] = "separator",
   ["{"] = "separator",
   ["}"] = "separator",
   ["["] = "separator",
   ["]"] = "separator",

   ["true"]  = "literal",
   ["false"] = "literal",
}

function Lexer.isKeyword(line, pos)
   if pos == #line then return true end

   return line:sub(pos+1, pos+1) == " " and Tokens[Lexer.buffer] == "keyword"
end

function Lexer.isIdentifier(line, pos)
   if pos == #line then return true end
   if Lexer.buffer == "" then return false end

   local char  = line:sub(pos+1, pos+1)
   local token = Tokens[char]
   return char == " " or token == "separator" or token == "operator"
end

function Lexer.clearBuffer()
   Lexer.buffer  = ""
   Lexer.sbuffer = ""
end

function Lexer.appendBuffer(character)
   if character ~= " " then
      Lexer.buffer = Lexer.buffer..character
   end
   Lexer.sbuffer = Lexer.sbuffer..character
end

function Lexer.isToken()
   return Tokens[Lexer.buffer] and true
end

function Lexer.isStringStart()
   return Lexer.buffer == "\""
end

function Lexer.isStringComplete()
   return Lexer.isString and Lexer.buffer:sub(#Lexer.buffer) == "\""
end

function Lexer.pushToken(type, value)
   Lexer.tokens[#Lexer.tokens + 1] = {type, value}
   Lexer.buffer  = ""
   Lexer.sbuffer = ""

   print(#Lexer.tokens, type, value)
end

function Lexer.lex(file)
   local tokens = {}

   file:open("r")

   for line in file:lines() do
      for i = 1, #line do
         local character = line:sub(i, i)

         if character == "\t" then
            break
         end

         Lexer.appendBuffer(character)

         if Lexer.isString then
            if Lexer.isStringComplete() then
               Lexer.pushToken("string", Lexer.sbuffer)
               Lexer.isString = false
            end
         else
            if Lexer.isStringStart() then
               Lexer.isString = true
            else
               if Lexer.isKeyword(line, i) then
                  Lexer.pushToken("keyword", Lexer.buffer)
               elseif Lexer.isToken() then
                  Lexer.pushToken(Tokens[Lexer.buffer], Lexer.buffer)
               elseif Lexer.isIdentifier(line, i) then
                  Lexer.pushToken("identifier", Lexer.buffer)
               end
            end
         end
         --print("'"..Lexer.buffer.."'")

      end
   end


   file:close()
end

return Lexer
