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
                root_dir = function(fname)
                    local eslint_root = lspconfig.util.root_pattern(
                        ".eslintrc",
                        ".eslintrc.js",
                        ".eslintrc.cjs",
                        ".eslintrc.json",
                        "eslint.config.js",
                        "eslint.config.mjs"
                    )(fname)

                    if not eslint_root then
                        return nil
                    end

                    local has_package_json = lspconfig.util.path.exists(lspconfig.util.path.join(eslint_root,
                        "package.json"))
                    local has_tsconfig = lspconfig.util.path.exists(lspconfig.util.path.join(eslint_root, "tsconfig.json"))

                    if has_package_json or has_tsconfig then
                        return eslint_root
                    end

                    return nil
                end,
                filetypes = { "javascript", "typescript", "html" },
                on_attach = function(client, bufnr)
                    vim.keymap.set("n", "<leader>f", "<cmd>EslintFixAll<CR>", { buffer = bufnr })
                end,
            },
            vtsls = {},
            html = {},
            jsonls = {},
            cssls = {},
            -- tsserver = {},
            angularls = {
                root_dir = lspconfig.util.root_pattern('angular.json' --[[, 'project.json'--]])
            },
            biome = {
                filetypes = { "javascript", "typescript", "css", "scss", "json" },
                root_dir = lspconfig.util.root_pattern('biome.json'),
                on_attach = function(client, bufnr)
                    vim.keymap.set("n", "<leader>f", function()
                        vim.lsp.buf.format({
                            async = true,
                            filter = function(c)
                                return c.name == "biome"
                            end
                        })
                    end, { buffer = bufnr })
                end,
            },
            gopls = {},
        }
        local ensure_installed = vim.tbl_keys(servers or {})

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = ensure_installed,
            handlers = {
                function(server_name) -- default handler (optional)
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
