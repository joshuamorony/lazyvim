local lspconfig = require("lspconfig")

local configs = require("lspconfig.configs")

local root_patterns = { "angular.json", "nx.json" }
local node_modules_root = vim.fs.dirname(vim.fs.find(root_patterns, { upward = true })[1])
local project_root = require("lspconfig.util").root_pattern("angular.json", "nx.json")

if node_modules_root and project_root then
  local tsdkPath = node_modules_root .. "/node_modules/typescript/lib"

  if not configs.analog then
    configs.analog = {
      default_config = {
        cmd = {
          "analog-language-server",
          "--stdio",
        },
        init_options = {
          typescript = {
            tsdk = tsdkPath,
          },
        },
        name = "analog",
        filetypes = {
          "analog",
          "ag",
        },
        root_dir = project_root,
      },
    }
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        angularls = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("angular.json", "nx.json")(fname)
          end,
          filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
        },
        volar = {},
        analog = {},
        tailwindcss = {},
        svelte = {},
        glsl_analyzer = {},
        gopls = {
          keys = {
            -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
            { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
          },
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
      setup = {
        html = function(_, opts)
          opts.init_options = {
            dataPaths = {
              vim.fn.getcwd() .. "/node_modules/angular-three/metadata.json",
            },
            configurationSection = { "html", "css", "javascript" },
            embeddedLanguages = {
              css = true,
              javascript = true,
            },
            provideFormatter = true,
          }

          opts.handlers = {
            ["html/customDataContent"] = function(err, result, ctx, config)
              local function exists(name)
                if type(name) ~= "string" then
                  return false
                end
                return os.execute("test -e " .. name)
              end

              if not vim.tbl_isempty(result) and #result == 1 then
                if not exists(result[1]) then
                  return ""
                end
                local content = vim.fn.join(vim.fn.readfile(result[1]), "\n")
                return content
              end
              return ""
            end,
          }

          return false
        end,
        volar = function(_, opts)
          opts.filetypes = { "vue", "agx" }
        end,
        svelte = function(_, opts) end,
        analog = function(_, opts) end,
        tailwindcss = function(_, opts)
          opts.filetypes = { "css", "scss", "typescript", "analog", "ag" }
        end,
        marksman = function(_, opts)
          opts.filetypes = { "md", "markdown", "mdx", "agx" }
        end,
        glsl_analyzer = function(_, opts) end,
        angularls = function(_, opts)
          opts.root_dir = lspconfig.util.root_pattern("angular.json", "nx.json")
        end,
        gopls = function(_, opts)
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          require("lazyvim.util").lsp.on_attach(function(client, _)
            if client.name == "gopls" then
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end)
          -- end workaround
        end,
      },
    },
  },
}
