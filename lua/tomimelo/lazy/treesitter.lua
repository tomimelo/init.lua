return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = 'main',
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
        local ts = require("nvim-treesitter")

        ts.setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        -- Custom parser definition on main
        vim.api.nvim_create_autocmd("User", {
            pattern = "TSUpdate",
            callback = function()
                require("nvim-treesitter.parsers").templ = {
                    install_info = {
                        url = "https://github.com/vrischmann/tree-sitter-templ.git",
                        files = { "src/parser.c", "src/scanner.c" },
                        branch = "master",
                    },
                }
            end,
        })

        -- Register parser <-> filetype mapping
        vim.treesitter.language.register("templ", { "templ" })

        -- Install parsers
        ts.install({
            "javascript",
            "typescript",
            "html",
            "vimdoc",
            "vim",
            "luadoc",
            "lua",
            "c",
            "bash",
            "go",
            "templ",
        })

        -- Enable Treesitter highlighting per filetype, with your old large-file guard
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "javascript",
                "typescript",
                "html",
                "vimdoc",
                "vim",
                "lua",
                "c",
                "sh",
                "bash",
                "go",
                "templ",
                "markdown",
            },
            callback = function(args)
                local max_filesize = 100 * 1024
                local filename = vim.api.nvim_buf_get_name(args.buf)
                local ok, stats = pcall(vim.uv.fs_stat, filename)
                if ok and stats and stats.size > max_filesize then
                    return
                end

                pcall(vim.treesitter.start, args.buf)

                -- Approximation of your old additional_vim_regex_highlighting = { "markdown" }
                if vim.bo[args.buf].filetype == "markdown" then
                    vim.bo[args.buf].syntax = "markdown"
                end
            end,
        })

        -- Enable Treesitter indent per filetype
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "javascript",
                "typescript",
                "html",
                "lua",
                "c",
                "sh",
                "bash",
                "go",
                "templ",
            },
            callback = function(args)
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
