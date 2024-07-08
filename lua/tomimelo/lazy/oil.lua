return {
    'stevearc/oil.nvim',
    opts = {
        keymaps = {
            ["<C-p>"] = false,
            ["<C-c>"] = false,
            ["<C-h>"] = false,
            ["<C-l>"] = false,
            ["<C-r>"] = "actions.refresh",
        },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
}
