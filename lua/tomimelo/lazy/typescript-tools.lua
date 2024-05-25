return {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
        settings = {
            expose_as_code_action = {"fix_all", "add_missing_imports", "remove_unused_imports"},
        }
    },
}
