-- local has_words_before = function()
--   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- end

-- local kind_icons = {
-- 	Text = "",
-- 	Method = "",
-- 	Function = "",
-- 	Constructor = "",
-- 	Field = "",
-- 	Variable = "",
-- 	Class = "",
-- 	Interface = "",
-- 	Module = "",
-- 	Property = "",
-- 	Unit = "",
-- 	Value = "",
-- 	Enum = "",
-- 	Keyword = "",
-- 	Snippet = "",
-- 	Color = "",
-- 	File = "",
-- 	Reference = "",
-- 	Folder = "󰉋",
-- 	EnumMember = "",
-- 	Constant = "",
-- 	Struct = "",
-- 	Event = "",
-- 	Operator = "",
-- 	TypeParameter = "",
-- 	Copilot = "",
-- }

-- return {
--     "hrsh7th/nvim-cmp",
--     dependencies = {
--         "hrsh7th/cmp-nvim-lsp",
--         "hrsh7th/cmp-buffer",
--         "hrsh7th/cmp-path",
--         "hrsh7th/cmp-cmdline",
--         "L3MON4D3/LuaSnip",
--         "saadparwaiz1/cmp_luasnip",
--     },
--     config = function()
--         local cmp = require("cmp")
--         local luasnip = require("luasnip")  -- 修正为正确的单行定义

--         -- 检查 Copilot 可用性函数
--         local has_copilot = pcall(require, "copilot.suggestion")

--         cmp.setup({
--             snippet = {
--                 expand = function(args)
--                     require("luasnip").lsp_expand(args.body)
--                 end,
--             },
--             sources = {
--                 { name = "nvim_lsp" },
--                 { name = "luasnip" },
--                 { name = "buffer" },
--                 { name = "path" },
--             },
--             experimental = {
--                 ghost_text = false,
--             },
--             window = {
--                 completion = cmp.config.window.bordered(),
--                 documentation = cmp.config.window.bordered(),
--               },
--             formatting = {
--                 format = function(entry, vim_item)
--                     -- 添加 kind 图标
--                     vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
--                     return vim_item
--                 end,
--             },
--             matching = {
--                 disallow_fuzzy_matching = true,
--                 disallow_fullfuzzy_matching = true,
--                 disallow_partial_fuzzy_matching = true,
--                 disallow_partial_matching = false,
--                 disallow_prefix_unmatching = true,
--             },
--             mapping = {
--                 ["<C-j>"] = cmp.mapping(function(fallback)
--                     if not cmp.visible() then
--                         cmp.complete()
--                     else
--                         cmp.select_next_item()
--                     end
--                 end, { "i", "s" }),
--                 ["<C-k>"] = cmp.mapping(function(fallback)
--                     if not cmp.visible() then
--                         cmp.complete()
--                     else
--                         cmp.select_prev_item()
--                     end
--                 end, { "i", "s" }),
--                 ["<C-b>"] = cmp.mapping.scroll_docs(-4),
--                 ["<C-f>"] = cmp.mapping.scroll_docs(4),
--                 ["<C-e>"] = cmp.mapping.abort(),
--                 ["<C-Space>"] = cmp.mapping.complete(),
--                 ["<Tab>"] = cmp.mapping(function(fallback)
--                     if has_copilot and require("copilot.suggestion").is_visible() then
--                         require("copilot.suggestion").accept()
--                     elseif cmp.visible() then
--                         cmp.confirm({ select = true })
--                     elseif luasnip.expand_or_jumpable() then
--                         luasnip.expand_or_jump()
--                     elseif has_words_before() then
--                         cmp.complete()
--                     else
--                         fallback()
--                     end
--                 end, { "i", "s" }),
--             },
--         })

--         cmp.setup.cmdline(':', {
--             mapping = cmp.mapping.preset.cmdline(),
--             sources = cmp.config.sources({
--                 { name = 'path' },
--                 { name = 'cmdline' }
--             })
--         })

--         cmp.setup.cmdline('/', {
--             mapping = cmp.mapping.preset.cmdline(),
--             sources = {
--                 { name = 'buffer' }
--             }
--         })

--         cmp.setup.filetype('toggleterm', {
--             sources = cmp.config.sources({
--                 { name = 'buffer' },
--                 { name = 'path' }
--             })
--         })

--         require("luasnip.loaders.from_vscode").lazy_load()
--     end,
-- }

local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

local icon_provider, hl_provider

local function get_kind_icon(CTX)
  if not icon_provider then
    local _, mini_icons = pcall(require, "mini.icons")
    if _G.MiniIcons then
      icon_provider = function(ctx)
        local is_specific_color = ctx.kind_hl and ctx.kind_hl:match "^HexColor" ~= nil
        if ctx.item.source_name == "LSP" then
          local icon, hl = mini_icons.get("lsp", ctx.kind or "")
          if icon then
            ctx.kind_icon = icon
            if not is_specific_color then ctx.kind_hl = hl end
          end
        elseif ctx.item.source_name == "Path" then
          ctx.kind_icon, ctx.kind_hl = mini_icons.get(ctx.kind == "Folder" and "directory" or "file", ctx.label)
        elseif ctx.item.source_name == "Snippets" then
          ctx.kind_icon, ctx.kind_hl = mini_icons.get("lsp", "snippet")
        end
      end
    end
    if not icon_provider then
      local lspkind_avail, lspkind = pcall(require, "lspkind")
      if lspkind_avail then
        icon_provider = function(ctx)
          if ctx.item.source_name == "LSP" then
            local icon = lspkind.symbolic(ctx.kind, { mode = "symbol" })
            if icon then ctx.kind_icon = icon end
          elseif ctx.item.source_name == "Snippets" then
            local icon = lspkind.symbolic("snippet", { mode = "symbol" })
            if icon then ctx.kind_icon = icon end
          end
        end
      end
    end
    if not icon_provider then icon_provider = function() end end
  end
  
  if not hl_provider then
    local highlight_colors_avail, highlight_colors = pcall(require, "nvim-highlight-colors")
    if highlight_colors_avail then
      local kinds
      hl_provider = function(ctx)
        if not kinds then kinds = require("blink.cmp.types").CompletionItemKind end
        if ctx.item.kind == kinds.Color then
          local doc = vim.tbl_get(ctx, "item", "documentation")
          if doc then
            local color_item = highlight_colors.format(doc, { kind = kinds[kinds.Color] })
            if color_item and color_item.abbr_hl_group then
              if color_item.abbr then ctx.kind_icon = color_item.abbr end
              ctx.kind_hl = color_item.abbr_hl_group
            end
          end
        end
      end
    end
    if not hl_provider then hl_provider = function() end end
  end
  
  icon_provider(CTX)
  hl_provider(CTX)
  return { text = CTX.kind_icon .. CTX.icon_gap, highlight = CTX.kind_hl }
end

return {
  "Saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "nvim-lua/plenary.nvim", -- 如果需要的话添加依赖
    -- "hrsh7th/cmp-nvim-lsp",
    -- "hrsh7th/nvim-cmp",
  },
  keys = {
    { "<Leader>uc", function() 
      vim.b.blink_cmp_enabled = not vim.b.blink_cmp_enabled 
      vim.notify("Buffer completion " .. (vim.b.blink_cmp_enabled and "enabled" or "disabled"))
    end, desc = "Toggle autocompletion (buffer)" },
    { "<Leader>uC", function() 
      vim.g.blink_cmp_enabled = not vim.g.blink_cmp_enabled 
      vim.notify("Global completion " .. (vim.g.blink_cmp_enabled and "enabled" or "disabled"))
    end, desc = "Toggle autocompletion (global)" },
  },
  opts = {
    enabled = function()
      -- 检查是否为提示缓冲区
      local is_prompt = vim.bo.buftype == "prompt"
      -- 支持 cmp-dap
      local dap_prompt = vim.tbl_contains({ "dap-repl", "dapui_watches", "dapui_hover" }, vim.bo.filetype)
      if is_prompt and not dap_prompt then return false end
      -- 使用全局和缓冲区级别的启用标志
      return vim.F.if_nil(vim.b.blink_cmp_enabled, vim.g.blink_cmp_enabled ~= false)
    end,
    fuzzy = {
       implementation = 'lua',
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    keymap = {
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-n>"] = { "select_next", "show" },
      ["<C-p>"] = { "select_prev", "show" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-f>"] = { "scroll_documentation_up", "fallback" },
      ["<C-b>"] = { "scroll_documentation_down", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = {
        "snippet_forward",
        function()
            if vim.g.ai_accept then
                return vim.g.ai_accept()
            end
        end,
        "select_next",
        function(cmp)
          if has_words_before() or vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
        end,
        "fallback",
      },
      ["<S-Tab>"] = {
        "snippet_backward",
        "select_prev",
        function(cmp)
          if vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
        end,
        "fallback",
      },
    },
    completion = {
      list = { selection = { preselect = false, auto_insert = true } },
      menu = {
        auto_show = function(ctx) return ctx.mode ~= "cmdline" end,
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        draw = {
          treesitter = { "lsp" },
          components = {
            kind_icon = {
              text = function(ctx) return get_kind_icon(ctx).text end,
              highlight = function(ctx) return get_kind_icon(ctx).highlight end,
            },
          },
        },
      },
      accept = {
        auto_brackets = { enabled = true },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        window = {
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
      },
    },
    signature = {
      window = {
        border = "rounded",
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
      },
    },
  },
  config = function(_, opts)
    local cmp = require("blink.cmp")
    cmp.setup(opts)

    -- 如果使用 LSP，添加 capabilities
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
          client.capabilities = vim.tbl_deep_extend(
            "force",
            client.capabilities,
            require("blink.cmp").get_lsp_capabilities(client.capabilities)
          )
        end
      end,
    })
  end,
}