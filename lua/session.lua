---@class Config
local config = {}

---@class MyModule
local M = {}

local session_tab ---@type integer|nil

---@type Config
M.config = config

---@param args Config?
M.setup = function(args)
    M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.toggle = function()
    if session_tab and vim.api.nvim_tabpage_is_valid(session_tab) then
        local tabnr = vim.api.nvim_tabpage_get_number(session_tab)
        vim.cmd("tabclose " .. tabnr)
        session_tab = nil
        return
    end

    vim.cmd("tabnew")
    session_tab = vim.api.nvim_get_current_tabpage()

    local session_win = vim.api.nvim_get_current_win()
    local session_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(session_win, session_buf)

    vim.cmd("split")
    local command_win = vim.api.nvim_get_current_win()
    local command_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(command_win, command_buf)

    vim.cmd("wincmd k")
    session_win = vim.api.nvim_get_current_win()
    local total_height = vim.api.nvim_win_get_height(session_win) + vim.api.nvim_win_get_height(command_win)
    local height_a = math.floor(total_height * 0.7 + 0.5)
    vim.api.nvim_win_set_height(session_win, height_a)

    vim.cmd("vsplit")
    local term_win = vim.api.nvim_get_current_win()
    local term_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(term_win, term_buf)

    local total_width = vim.api.nvim_win_get_width(session_win) + vim.api.nvim_win_get_width(term_win)
    local width_a = math.floor(total_width * 0.15 + 0.5)
    vim.api.nvim_win_set_width(session_win, width_a)
end

return M
