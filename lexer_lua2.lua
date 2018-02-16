local Lexer = {
   tokens = {
      ["string"] = "\'\"",
      ["comment"] = "#",
      ["separator"] = "(){}[],",
      ["operator"] = "+-*/%",
      ["expression"] = "<>!=",

      ["keywords"] = {
         "let",
         "if",
         "while",
         "function",
         "array",
      },
   },
}

function Lexer.getChar(line, pos)
   return line:sub(pos, pos)
end

function Lexer.nextChar(line, pos)
   return line:sub(pos + 1, pos + 1)
end

function Lexer.getString(line, pos, denum)
   for pos2 = pos + 1, #line do
      local char = Lexer.getChar(line, pos2)
      if char == denum then
         return line:sub(pos + 1, pos2 - 1), pos2 + 1
      end
   end
end

function Lexer.getComment(line, pos)
   return line:sub(pos, #line), #line
end

function Lexer.lex(file)
   for line in file:lines() do
      local buffer    = ""
      local isString  = false
      local isComment = false

      local pos = 1
      while pos <= #line do
         local char = Lexer.getChar(line, pos)

         if char == " " then
            pos = pos + 1
         elseif Lexer.tokens.string:find(char, 1, true) then
            local value
            value, pos = Lexer.getString(line, pos, char)
            print("String: ", value)
         elseif Lexer.tokens.comment:find(char, 1, true) then
            local value
            value, pos = Lexer.getComment(line, pos)
            print("Comment: ", value)
         elseif Lexer.tokens.separator:find(char, 1, true) then
            print("Separator: ", char)
            pos = pos + 1
         elseif Lexer.tokens.operator:find(char, 1, true) then
            print("Operator: ", char)
            pos = pos + 1
         elseif Lexer.tokens.expression:find(char, 1, true) then
            print("Expression: ", char)
            pos = pos + 1
         else
            pos = pos + 1
         end

      end
   end
end

return Lexer
