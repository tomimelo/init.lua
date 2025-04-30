return {
    'Chaitanyabsprip/fastaction.nvim',
    opts = {
        dismiss_keys = { "<c-c>", "q" },
        override_function = function(_) end,
        keys = "aoeuidhtnsjkbmwvpgcr",
        popup = {
            border = "rounded",
            hide_cursor = true,
            highlight = {
                divider = "FloatBorder",
                key = "MoreMsg",
                title = "Title",
                window = "NormalFloat",
            },
            title = "Select one of:", -- or false to disable title
        },
        priority = {
            typescript = {
                { pattern = 'add import',                    key = 'a', order = 1 },
                { pattern = 'from module',                    key = 'i', order = 2 },
                { pattern = 'to existing import declaration', key = 't', order = 3 },
            }
        }
    },
}
