local bind = require("bind")
local log = require("log")

local function create_empty(count)
    local lines = {}
    for idx = 1, count, 1 do
        lines[idx] = ""
    end

    return lines
end

local Buffer = {}

function Buffer:new(bufh, window)
    local on_change_list = {}
    local new_buf = {
        bufh = bufh,
        window = window,
        instructions = {},
        on_change_list = on_change_list,
        last_rendered = {},
        last_rendered_instruction = {},
    }

    self.__index = self
    local buff = setmetatable(new_buf, self)
    buff:attach()

    return buff
end

function Buffer:_sheduled_on_line()
    if self == nil or self.on_change_list == nil then
        log.info("Memory Leak...", self.bufh, self.window)
        return
    end

    for _, fn in ipairs(self.on_change_list) do
        local ok, err = pcall(
            fn, buf, changedtick, firstline, lastline, linedata, more)
        
        if not ok then
            log.info("Buffer:_scheduled_on_line: is not ok", err)
            ok, err = pcall(function()
                if end_it_all then
                    end_it_all()
                else
                    self:close()
                end
            end)
            if not ok then
                log.info("AGAIN?????????", err)
            end
        end
    end
end

function Buffer:on_line(buf, changedtick, firstline, lastline, linedata, more)
    vim.schedule(function()
        self:_sheduled_on_line(buf, changedtick, firstline, lastline, linedata, more)
    end)
end

function Buffer:attach()
    vim.api.nvim_buf_attach(self.bufh, true, {
        on_lines = bind(self, "online")
    })
end

function Buffer:render(lines)
    local idx = 1
    local instruction_len = #self.instructions
    --local last_rendered_len = #self.last_rendered
    --local last_rendered_instruction_len = #self.last_rendered_instruction

    self:clear()
    self.last_rendered = lines

    if self.debug_line_str ~= nil then
        vim.api.nvim_buf_set_lines(self.bufh, 0, 1, false, {self.debug_line_str})
    end

    if instruction_len > 0 then
        vim.api.nvim_buf_set_lines(
            self.bufh, idx, idx + instruction_len, false, self.instructions)
        idx = idx + instruction_len
    end

    log.info("Buffer:Rendering")
    vim.api.nvim_buf_set_lines(self.bufh, idx, idx + #lines, false, lines)

end

function Buffer:debug_line(line)
    if line ~= nil then
        self.debug_line_str = line
    end
end

function Buffer:set_instructions(lines)
    self.last_rendered_instruction = self.instructions
    self.instructions = lines
end

function Buffer:clear_game_lines()
    local start_offset = table.getn(self.instructions) + 1
    local len = table.getn(self.last_rendered)

    local lines = vim.api.nvim_buf_get_lines(
        self.bufh, start_offset, start_offset + len, false)

    log.info("Buffer:get_game_lines", start_offset, len, vim.inspect(lines))

    return lines
end

function Buffer:clear()
    local len = #self.last_rendered_instruction + 1 + (#self.last_rendered or 0)

    vim.api.nvim_buf_set_lines(
        self.bufh, 0, len, false, create_empty(len))
end

function Buffer:on_change(cb)
    table.insert(self.on_change_list, cb)
end

function Buffer:remove_listener(cb)

    local idx = 1
    local found = false
    while idx <= #self.on_change_list and found == false do
        found = self.on_change_list[idx] == cb
        if found == false then
            idx = idx + 1
        end
    end

    if found then
        log.info("Buffer:remove_listener removing listener")
        table.remove(self.on_change_list, idx)
    end
end

return Buffer

