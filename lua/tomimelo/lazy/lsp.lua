return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-cmdline",
        "j-hui/fidget.nvim",
    },
    config = function()
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local lspconfig = require("lspconfig")
        capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())

        local servers = {
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "it", "describe", "before_each", "after_each" },
                        }
                    }
                }

            },
            eslint = {
                on_attach = function()
                    vim.keymap.set("n", "<leader>f", "<cmd>EslintFixAll<CR>")
                end
            },
            vtsls = {},
            html = {},
            jsonls = {},
            cssls = {},
            -- tsserver = {},
            angularls = {
                root_dir = lspconfig.util.root_pattern('angular.json', 'project.json')
            },
            kotlin_language_server = {}
        }
        local ensure_installed = vim.tbl_keys(servers or {})

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = ensure_installed,
            handlers = {
                function(server_name) -- default handler (optional)
                    if server_name == "tsserver" then return end
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                    lspconfig[server_name].setup(server)
                end,
            }
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
