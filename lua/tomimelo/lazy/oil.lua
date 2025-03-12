return {
    'stevearc/oil.nvim',
    opts = {
        keymaps = {
            ["<C-p>"] = false,
            ["<C-c>"] = false,
            ["<C-h>"] = false,
            ["<C-t>"] = false,
            ["<C-n>"] = false,
            ["<C-s>"] = false,
            ["<C-r>"] = "actions.refresh",
        },
        view_options = {
            show_hidden = true,
        },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
}
