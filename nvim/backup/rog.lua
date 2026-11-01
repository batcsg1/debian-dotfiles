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
        c.bg = "#000000"
        c.bg_dark = "#000000"
        c.bg_float = "#000000"
        c.bg_popup = "#0a0a0a"
        c.bg_sidebar = "#0a0a0a"
        c.bg_statusline = "#0a0a0a"
        c.bg_highlight = "#14080a"
        c.bg_visual = "#5a000c"
        c.bg_search = "#8b0016"

        c.fg = "#e8e0e0"
        c.fg_dark = "#b9a8ab"
        c.fg_gutter = "#4a2a2e"
        c.comment = "#7a5a5f"
        c.border = "#8b0016"

        -- everything folded into the red/amber ramp
        c.red = "#ff0033"
        c.red1 = "#c8102e"
        c.orange = "#ff7a3d"
        c.yellow = "#ff9d3d"
        c.green = "#d94f5c"
        c.green1 = "#ff8d9e"
        c.green2 = "#8b2f3a"
        c.teal = "#ff8d9e"
        c.cyan = "#ff8d9e"
        c.blue = "#ff4d66"
        c.blue0 = "#7a1020"
        c.blue1 = "#ff6b80"
        c.blue2 = "#ff4d66"
        c.blue5 = "#ffb3bd"
        c.blue6 = "#ffd6db"
        c.blue7 = "#3d0008"
        c.magenta = "#ff2d55"
        c.magenta2 = "#ff0033"
        c.purple = "#ff2d55"
      end,
      on_highlights = function(hl)
        hl.CursorLineNr = { fg = "#ff0033", bold = true }
        hl.LineNr = { fg = "#4a2a2e" }
        hl.Visual = { bg = "#5a000c" }
        hl.Search = { bg = "#8b0016", fg = "#ffffff" }
        hl.IncSearch = { bg = "#ff0033", fg = "#000000" }
        hl.MatchParen = { fg = "#ff7a3d", bold = true }
        hl.WinSeparator = { fg = "#8b0016" }
        hl.FloatBorder = { fg = "#ff0033" }
        hl.PmenuSel = { bg = "#8b0016", fg = "#ffffff" }
        hl.TabLineSel = { bg = "#c8102e", fg = "#0a0a0a", bold = true }
        hl.DiagnosticError = { fg = "#ff0033" }
        hl.DiagnosticWarn = { fg = "#ff7a3d" }
        hl.DiagnosticInfo = { fg = "#ff8d9e" }
        hl.DiagnosticHint = { fg = "#d94f5c" }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight-night" },
  },
}
