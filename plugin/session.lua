vim.api.nvim_create_user_command("SessionToggle", function()
    require("session").toggle()
end, {})

