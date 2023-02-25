local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

local astyle = {
  bg = "#081633",
  fg = "#A9A1E1",
}

local bstyle = {
  bg = "#081633",
}

local cstyle = {
  bg = "#081633",
  fg = "#A9A1E1",
  gui = 'bold',
}

local fname = require('lualine.components.filename'):extend()
local highlight = require'lualine.highlight'
function fname:init(options)
  options.path = 1
  options.symbols = { modified = '', readonly = ' [-]', unnamed = '', }
  fname.super.init(self, options)
  self.status_colors = {
    saved = highlight.create_component_highlight_group(astyle, '', self.options),
    modified = highlight.create_component_highlight_group(cstyle, '', self.options),
  }
end

function fname:update_status()
  local data = fname.super.update_status(self)
  return highlight.component_format_highlight(vim.bo.modified
    and self.status_colors.modified
    or self.status_colors.saved) .. data
end

local colors = {
  yellow = '#ECBE7B',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#98be65',
  orange = '#FF8800',
  violet = '#a9a1e1',
  magenta = '#c678dd',
  blue = '#51afef',
  red = '#ec5f67'
}

lualine.setup {
  options = {
    icons_enabled = true,
    theme = {
      normal = {
        a = astyle,
        b = bstyle,
        c = astyle,

        x = astyle,
        y = bstyle,
        z = astyle,
      },
    },
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  colors = {
    percentage  = colors.cyan,
    title  = colors.cyan,
    message  = colors.cyan,
    spinner = colors.cyan,
    lsp_client_name = colors.magenta,
    use = true,
  },
  sections = {
    lualine_a = {
      {
        'lsp_progress',
        display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' }},
        colors = {
          percentage = colors.cyan,
          title = colors.cyan,
          message = colors.cyan,
          spinner = colors.cyan,
          lsp_client_name = colors.magenta,
          use = true,
        },
        separators = {
          component = ' ',
          progress = ' | ',
          message = { pre = '(', post = ')'},
          percentage = { pre = '', post = '%% ' },
          title = { pre = '', post = ': ' },
          lsp_client_name = { pre = '[', post = ']' },
          spinner = { pre = '', post = '' },
          -- message = { commenced = 'In Progress', completed = 'Completed' },
        },
        timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
        spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
      },
      'branch',
      {
        'diagnostics',

        -- Table of diagnostic sources, available sources are:
        --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
        -- or a function that returns a table as such:
        --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
        sources = { 'nvim_diagnostic' },

        -- Displays diagnostics for the defined severity types
        sections = { 'error', 'warn', 'info', 'hint' },

        diagnostics_color = {
          -- Same values as the general color option can be used here.
          error = 'DiagnosticError', -- Changes diagnostics' error color.
          warn  = 'DiagnosticWarn',  -- Changes diagnostics' warn color.
          info  = 'DiagnosticInfo',  -- Changes diagnostics' info color.
          hint  = 'DiagnosticHint',  -- Changes diagnostics' hint color.
        },
        symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'},
        colored = true,           -- Displays diagnostics status in color if set to true.
        update_in_insert = false, -- Update diagnostics in insert mode.
        always_visible = false,   -- Show diagnostics even if there are none.
      },
    },
    lualine_b = {
      fname
    },
    lualine_c = {},
    lualine_x = {
      'encoding',
      {'filetype', colored = false},
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {},
  tabline = {
    lualine_a = {
      'lsp_progress2',
    },
    -- Did the :Taboo (tab-rename) plugin broke these tabs?
    lualine_b = {
      {'tabs', mode = 0,},
    },
    lualine_x = {
      'diagnostics',
      'branch',
    },
  },
  extensions = {},
}
