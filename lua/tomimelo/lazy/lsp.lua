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
        local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        local function exists(path)
            return path and vim.uv.fs_stat(path) ~= nil
        end

        -- eslint root: look up for eslint config + (package.json OR tsconfig.json)
        local function eslint_root(arg)
            local bufnr = type(arg) == "number" and arg or 0
            -- This uses Neovim's new root finder. It walks up from the buffer's path.
            return vim.fs.root(bufnr,
                { "eslint.config.js", "eslint.config.mjs", ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" })
        end

        -- ── Server configs ───────────────────────────────────────────────
        -- lua_ls
        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim", "it", "describe", "before_each", "after_each" } },
                },
            },
        })

        -- eslint
        local base_eslint_on_attach = vim.lsp.config.eslint and vim.lsp.config.eslint.on_attach
        vim.lsp.config("eslint", {
            capabilities = capabilities,
            filetypes = { "javascript", "typescript", "html" },
            -- root_dir = eslint_root,
            on_attach = function(client, bufnr)
                if base_eslint_on_attach then base_eslint_on_attach(client, bufnr) end
                vim.keymap.set("n", "<leader>f", "<cmd>LspEslintFixAll<CR>", {
                    buffer = bufnr, noremap = true, silent = true, desc = "ESLint Fix All (LSP)",
                })
            end,
        })

        -- vtsls
        local base_vtsls_on_attach = vim.lsp.config.vtsls and vim.lsp.config.vtsls.on_attach
        vim.lsp.config("vtsls", {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                if base_vtsls_on_attach then base_vtsls_on_attach(client, bufnr) end
                -- client.server_capabilities.documentFormattingProvider = false
            end,
        })

        -- biome
        local function biome_root(arg)
            local bufnr = type(arg) == "number" and arg or 0
            return vim.fs.root(bufnr, { "biome.json" })
        end
        local base_biome_on_attach = vim.lsp.config.biome and vim.lsp.config.biome.on_attach
        vim.lsp.config("biome", {
            capabilities = capabilities,
            filetypes = { "javascript", "typescript", "css", "scss", "json" },
            root_dir = biome_root,
            on_attach = function(client, bufnr)
                if base_biome_on_attach then base_biome_on_attach(client, bufnr) end
                vim.keymap.set("n", "<leader>f", function()
                    vim.lsp.buf.format({
                        async = true,
                        filter = function(c)
                            return c.name == "biome"
                        end
                    })
                end, { buffer = bufnr })
            end,
        })

        -- angularls (root via angular.json or project.json)
        local function angular_root(arg)
            local bufnr = type(arg) == "number" and arg or 0
            return vim.fs.root(bufnr, { "angular.json", "project.json" })
        end
        vim.lsp.config("angularls", {
            capabilities = capabilities,
            -- root_dir = angular_root,
        })

        -- html / jsonls / cssls / gopls
        for _, name in ipairs({ "html", "jsonls", "cssls", "gopls" }) do
            local base = vim.lsp.config[name] or {}
            vim.lsp.config(name, vim.tbl_deep_extend("force", base, { capabilities = capabilities }))
        end

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls", "eslint", "vtsls", "html", "jsonls", "cssls", "angularls", "biome", "gopls",
            },
        })

        for _, name in ipairs({
            "lua_ls", "eslint", "vtsls", "html", "jsonls", "cssls", "angularls", "biome", "gopls",
        }) do
            vim.lsp.enable(name)
        end

        vim.diagnostic.config({
            -- update_in_insert = true,
            virtual_text = { spacing = 2, source = "if_many" }, -- <— inline messages ON
            virtual_lines = false,
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
