-- Finds where the typst-preview page can be scrolled to for a cursor position.
--
-- tinymist only resolves a source position to the page when the character at it
-- is literal markup text (`Key idea.`). Code (`#lorem(25)`, `title: "..."`,
-- `#set ...`), generated output, math and blank lines resolve to nothing.
-- `scan` walks the markup from a start line (the heading above the cursor) to the
-- cursor with a small subset of Typst's syntax and reports:
--   * `in_text`:  whether the character at the cursor resolves, and
--   * `fallback`: the last resolvable character before the cursor (the closest
--                 place on the page, e.g. the end of `Key idea.` for the cursor
--                 on the `#lorem(25)` that follows it).
-- It is a heuristic, not a parser: it tracks markup `[ ]`, code `( ) { }`,
-- strings, comments, math and raw blocks, and treats `#let/#set/#show/#import/
-- #include/#context` as code up to the end of the statement's line.
local M = {}

local STMT = { let = true, set = true, show = true, import = true, include = true, context = true }
local CTL = { ['if'] = true, ['for'] = true, ['while'] = true }

-- Markup characters that are syntax, not text. `[` and `]` are text unless they
-- open/close a content block, which is decided by the surrounding frame.
local SYNTAX = { ['*'] = true, ['_'] = true, ['~'] = true, ['\\'] = true }

local function is_space(c)
  return c == ' ' or c == '\t'
end

local function is_ident_start(c)
  return c ~= nil and c:match '^[%a_]$' ~= nil
end

local function is_ident(c)
  return c ~= nil and c:match '^[%w_%-]$' ~= nil
end

---@param lines string[] buffer lines starting at 0-based line `first0`; the last one is the cursor line
---@param first0 integer
---@param cur0 integer 0-based cursor line
---@param p integer 1-based index of the character under the cursor (the position sent to tinymist)
---@return { in_text: boolean, fallback: { line: integer, character: integer }? }
function M.scan(lines, first0, cur0, p)
  local stack = { { kind = 'markup' } }
  local fallback
  local in_text = false

  local function top()
    return stack[#stack]
  end
  local function push(kind, close, call)
    stack[#stack + 1] = { kind = kind, close = close, call = call }
  end
  local function pop()
    local f = stack[#stack]
    if #stack > 1 then
      stack[#stack] = nil
    end
    -- `#f(...)[...]`: a content block or another call may follow directly.
    local below = stack[#stack]
    if f.call and below.kind == 'markup' then
      below.call = true
    end
  end

  for li, line in ipairs(lines) do
    local l0 = first0 + li - 1
    local cs = vim.fn.split(line, '\\zs')
    local n = #cs
    local i = 1
    local lit = {} -- lit[i]: cs[i] is literal text (not a space)

    if top().kind == 'markup' then
      local marker = line:match '^%s*=+%s+' or line:match '^%s*[-+]%s+' or line:match '^%s*/%s+' or line:match '^%s*%d+%.%s+'
      if marker then
        i = vim.fn.strchars(marker) + 1
      end
    end

    while i <= n do
      local c, nx = cs[i], cs[i + 1]
      local f = top()
      local k = f.kind
      local step = 1

      if k == 'bcomment' then
        if c == '*' and nx == '/' then
          pop()
          step = 2
        end
      elseif k == 'str' then
        if c == '\\' then
          step = 2
        elseif c == '"' then
          pop()
        end
      elseif k == 'math' then
        if c == '\\' then
          step = 2
        elseif c == '$' then
          pop()
        end
      elseif k == 'raw' then
        local run = 0
        while cs[i + run] == '`' do
          run = run + 1
        end
        if run >= f.fence then
          pop()
          step = run
        elseif l0 > f.line0 and not is_space(c) then
          lit[i] = true -- code lines inside a raw block are real text on the page
        end
      elseif c == '/' and nx == '/' then
        break -- line comment
      elseif c == '/' and nx == '*' then
        push 'bcomment'
        step = 2
      elseif c == '$' then
        push 'math'
      elseif c == '`' then
        local run = 0
        while cs[i + run] == '`' do
          run = run + 1
        end
        push 'raw'
        top().fence = run
        top().line0 = l0
        step = run
      elseif k == 'markup' then
        local was_call = f.call
        f.call = false
        if was_call and c == '(' then
          push('code', ')', true)
        elseif was_call and c == '[' then
          push('markup', ']')
        elseif c == '#' then
          if nx == '(' then
            push('code', ')', false)
            step = 2
          elseif nx == '{' then
            push('code', '}', false)
            step = 2
          elseif nx == '[' then
            push('markup', ']')
            step = 2
          elseif is_ident_start(nx) then
            local j = i + 1
            while is_ident(cs[j]) do
              j = j + 1
            end
            local ident = table.concat(cs, '', i + 1, j - 1)
            while cs[j] == '.' and is_ident_start(cs[j + 1]) do -- field access / method chain
              j = j + 1
              while is_ident(cs[j]) do
                j = j + 1
              end
            end
            step = j - i
            if STMT[ident] then
              push 'stmt'
            elseif CTL[ident] then
              push 'ctl'
            else
              top().call = true
            end
          end
        elseif c == '@' or c == '<' then
          -- reference / label: skip the name
          local j = i + 1
          while is_ident(cs[j]) or cs[j] == ':' or cs[j] == '.' do
            j = j + 1
          end
          while j > i + 1 and (cs[j - 1] == '.' or cs[j - 1] == ':') do
            j = j - 1 -- trailing punctuation is text, not part of the name
          end
          step = j - i
        elseif c == ']' and f.close == ']' then
          pop()
        elseif c == '\\' then
          step = 2
          lit[i + 1] = nx ~= nil and not is_space(nx)
        elseif SYNTAX[c] or is_space(c) then
          -- not text
        else
          lit[i] = true
        end
      else -- code frames: code, stmt, ctl
        if c == '"' then
          push 'str'
        elseif c == '(' then
          push('code', ')', false)
        elseif c == '{' or c == '[' then
          if k == 'ctl' then
            pop()
          end
          if c == '{' then
            push('code', '}', false)
          else
            push('markup', ']')
          end
        elseif (c == ')' and f.close == ')') or (c == '}' and f.close == '}') then
          pop()
        end
      end
      i = i + step
    end

    -- `/ Term: description`: the colon is list syntax.
    if line:match '^%s*/%s+' then
      for idx = 1, n do
        if cs[idx] == ':' then
          lit[idx] = nil
          break
        end
      end
    end

    -- A statement or control header ends with its line unless a bracket is open.
    while top().kind == 'stmt' or top().kind == 'ctl' do
      pop()
    end

    -- Resolvable: literal characters, and spaces between two literal characters.
    local function resolves(idx)
      if lit[idx] then
        return true
      end
      return idx >= 1 and idx <= n and is_space(cs[idx]) and lit[idx - 1] == true and lit[idx + 1] == true
    end

    if l0 < cur0 then
      for idx = n, 1, -1 do
        if lit[idx] then
          fallback = { line = l0, character = idx }
          break
        end
      end
    else
      in_text = resolves(p)
      for idx = math.min(p - 1, n), 1, -1 do
        if lit[idx] then
          fallback = { line = l0, character = idx }
          break
        end
      end
      break
    end
  end

  return { in_text = in_text, fallback = fallback }
end

---@param bufnr integer
---@param heading0 integer? 0-based line of the nearest heading at/above the cursor
---@param cur0 integer 0-based cursor line
---@param p integer 1-based index of the character under the cursor
function M.analyze(bufnr, heading0, cur0, p)
  local first0 = math.max(heading0 or 0, cur0 - 200, 0)
  local lines = vim.api.nvim_buf_get_lines(bufnr, first0, cur0 + 1, false)
  return M.scan(lines, first0, cur0, p)
end

return M
