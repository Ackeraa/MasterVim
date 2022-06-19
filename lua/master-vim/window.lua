local log = require("master-vim.log")
local Buffer = require("master-vim.buffer")

local Window = {}

local function generate_config(row_padding, col_padding)
    row_padding = row_padding or 6
    col_padding = col_padding or 6

    local vim_stats = vim.api.nvim_list_uis()[1]
    return {
        row = math.floor(row_padding / 2),
        col = math.floor(col_padding / 2),
        width = vim_stats.width - row_padding,
        height = vim_stats.height - col_padding,
        relative = "editor",
    }
end

function Window:new(row_padding, col_padding)
    local new_window = {
        config = generate_config(row_padding, col_padding),
        row_padding = row_padding,
        col_padding = col_padding,
        bufh = 0,
        buffer = nil,
        win_id = 0,
    }

    self.__index = self
    return setmetatable(new_window, self)
end

function Window:show()
    if self.bufh == 0 then
        self.bufh = vim.api.nvim_create_buf(false, true)
        self.buffer = Buffer:new(self.bufh, self)
    end

    if self.win_id == 0 then
        self.win_id = vim.api.nvim_open_win(self.bufh, true, self.config)
    else
        vim.api.nvim_win_set_config(self.win_id, self.config)
    end
end

function Window:resize()
    if not vim.api.nvim_win_is_valid(self.win_id) then
        return false
    end

    local ok, msg = pcall(function()
        print("onResize before", vim.inspect(self.config))
        self.config = generate_config(self.row_padding, self.col_padding)
        print("onResize", vim.inspect(self.config))
        self:show()
    end)

    if not ok then
        log.info("Window:resize", msg)
    end

    return ok
end

function Window:close()
    if self.win_id ~= 0 then
        vim.api.nvim_win_close(self.win_id, true)
    end

    self.win_id = 0

    log.info("window#close", debug.traceback())
    if self.buffer then
        self.buffer:close()
    end

    self.bufh = 0
    self.buffer = nil
end

return Window
