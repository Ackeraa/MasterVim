local log = require("master-vim.log")
local Buffer = require("master-vim.buffer")

local Window = {}

local function center(str)
  local width = vim.api.nvim_win_get_width(0)
  local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
  return string.rep(" ", shift) .. str
end

function Window:new()
    local buf = vim.api.nvim_create_buf(false, true)
    local border_buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "filetype", "master-vim")

    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")
    local win_height = math.ceil(height * 0.8 - 4)
    local win_width = math.ceil(width * 0.8)
    local row = math.ceil((height - win_height) / 2 - 1)
    local col = math.ceil((width - win_width) / 2)

    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
    }

    local border_opts = {
        style = "minimal",
        relative = "editor",
        width = win_width + 2,
        height = win_height + 2,
        row = row - 1,
        col = col - 1,
    }

    local border_lines = { "╔" .. string.rep("═", win_width) .. "╗" }
    local middle_line = "║" .. string.rep(" ", win_width) .. "║"
    for i = 1, win_height do
        table.insert(border_lines, middle_line)
    end
    table.insert(border_lines, "╚" .. string.rep("═", win_width) .. "╝")
    vim.api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

    local win = vim.api.nvim_open_win(buf, true, opts)
    local border_win = vim.api.nvim_open_win(border_buf, true, border_opts)
    vim.api.nvim_command("au BufWipeout <buffer> exe 'silent bwipeout! '"..border_buf)

    vim.api.nvim_win_set_option(win, "cursorline", true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { center("Master Vim"), "", ""})
    vim.api.nvim_buf_add_highlight(buf, -1, "MasterVimHeader", 0, 0, -1)

    local new_window = {
        buffer = Buffer:new(buf, self),
        win = win,
        border_win = border_win,
    }

    self.__index = self
    return setmetatable(new_window, self)
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
