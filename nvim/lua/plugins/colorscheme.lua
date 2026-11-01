-- ROG Mech — tokyonight recoloured to match kitty / waybar / hyprland
-- Palette sourced from the rog_mech.jpg wallpaper (see dotfiles README.md)
local rog = {
  crust = "#06090d",
  base = "#0b1015",
  mantle = "#10161d",
  surface0 = "#161d26",
  surface1 = "#222b36",
  surface2 = "#343a45",
  overlay = "#555c68",
  comment = "#6b7380",
  steel = "#8794a6",
  subtext = "#a9b6c6",
  text = "#d6dde6",
  chrome = "#eef2f6",

  red = "#ff2233",
  red_hi = "#ff5566",
  red_mid = "#c41a28",
  red_deep = "#6b0a12",
  red_sel = "#3a0d15",

  volt = "#b8d4ff",
  volt_dim = "#6f93c4",
  volt_deep = "#1f3047",

  -- muted support hues (same as kitty ANSI) so code stays readable
  amber = "#e8a24a",
  amber_hi = "#f3c27f",
  green = "#7fc29b",
  cyan = "#7fb4c9",
  rose = "#e57b98",
}

return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
        comments = { italic = true },
      },
      on_colors = function(c)
        c.bg = rog.base
        c.bg_dark = rog.crust
        c.bg_float = rog.base
        c.bg_popup = rog.mantle
        c.bg_sidebar = rog.base
        c.bg_statusline = rog.mantle
        c.bg_highlight = rog.surface0
        c.bg_visual = rog.red_sel
        c.bg_search = rog.volt_deep

        c.fg = rog.text
        c.fg_dark = rog.subtext
        c.fg_float = rog.text
        c.fg_sidebar = rog.subtext
        c.fg_gutter = rog.surface2
        c.comment = rog.comment
        c.dark3 = rog.overlay
        c.dark5 = rog.steel
        c.border = rog.surface1
        c.border_highlight = rog.red_mid
        c.terminal_black = rog.surface2

        -- syntax: red for structure, electric blue for calls, steel for glue
        c.red = rog.red
        c.red1 = rog.red_mid
        c.magenta = rog.rose -- function / return keywords
        c.magenta2 = rog.red
        c.purple = rog.red_hi -- keywords
        c.blue = rog.volt -- functions
        c.blue0 = rog.volt_deep
        c.blue1 = rog.volt_dim -- types
        c.blue2 = rog.cyan
        c.blue5 = rog.steel -- operators
        c.blue6 = rog.chrome
        c.blue7 = rog.surface1
        c.cyan = rog.cyan
        c.teal = rog.cyan
        c.green = rog.green -- strings
        c.green1 = rog.subtext -- properties
        c.green2 = "#4f7a63"
        c.orange = rog.amber -- constants / numbers
        c.yellow = rog.amber_hi -- parameters

        c.git = { add = rog.green, change = rog.volt_dim, delete = rog.red, ignore = rog.overlay }
        c.diff = {
          add = "#13261c",
          change = rog.volt_deep,
          delete = "#2a0c11",
          text = "#2a4466",
        }
        c.error = rog.red
        c.warning = rog.amber
        c.info = rog.volt
        c.hint = rog.steel
        c.todo = rog.volt
      end,
      on_highlights = function(hl)
        hl.Keyword = { fg = rog.red_hi }
        hl.CursorLine = { bg = rog.surface0 }
        hl.CursorLineNr = { fg = rog.red, bold = true }
        hl.LineNr = { fg = rog.surface2 }
        hl.Visual = { bg = rog.red_sel }
        hl.Search = { bg = rog.volt_deep, fg = rog.chrome }
        hl.IncSearch = { bg = rog.red, fg = rog.crust }
        hl.CurSearch = { bg = rog.volt, fg = rog.crust }
        hl.MatchParen = { fg = rog.red, bold = true, underline = true }
        hl.WinSeparator = { fg = rog.surface2 }
        hl.FloatBorder = { fg = rog.red_mid }
        hl.FloatTitle = { fg = rog.red, bold = true }
        hl.Pmenu = { bg = rog.mantle, fg = rog.text }
        hl.PmenuSel = { bg = rog.red_sel, fg = rog.chrome, bold = true }
        hl.PmenuSbar = { bg = rog.surface0 }
        hl.PmenuThumb = { bg = rog.red_mid }
        hl.TabLineSel = { bg = rog.red, fg = rog.crust, bold = true }
        hl.DiagnosticError = { fg = rog.red }
        hl.DiagnosticWarn = { fg = rog.amber }
        hl.DiagnosticInfo = { fg = rog.volt }
        hl.DiagnosticHint = { fg = rog.steel }

        -- brackets by depth (rainbow-delimiters.nvim, see rog-extras.lua)
        hl.RogDelim1 = { fg = rog.red }
        hl.RogDelim2 = { fg = rog.steel }
        hl.RogDelim3 = { fg = rog.volt }
        hl.RogDelim4 = { fg = rog.red_hi }
        hl.RogDelim5 = { fg = rog.subtext }
        hl.RogDelim6 = { fg = rog.volt_dim }

        -- indent guides (snacks.indent): gunmetal, red for the current scope
        hl.RogIndent = { fg = rog.surface1 }
        hl.RogScope = { fg = rog.red_mid }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight-night" },
  },
  {
    -- mode colours: normal = red, insert = electric, visual = chrome
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local function mode(accent)
        return {
          a = { bg = accent, fg = rog.crust, gui = "bold" },
          b = { bg = rog.surface1, fg = accent },
          c = { bg = rog.mantle, fg = rog.subtext },
        }
      end
      opts.options = opts.options or {}
      opts.options.theme = {
        normal = mode(rog.red),
        insert = mode(rog.volt),
        visual = mode(rog.text),
        replace = mode(rog.amber),
        command = mode(rog.red_hi),
        terminal = mode(rog.volt_dim),
        inactive = {
          a = { bg = rog.mantle, fg = rog.overlay },
          b = { bg = rog.mantle, fg = rog.overlay },
          c = { bg = rog.mantle, fg = rog.overlay },
        },
      }
    end,
  },
}
