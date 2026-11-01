-- ROG RGB — tokyonight recoloured to the kitty/starship neon spectrum
local rgb = {
  red = "#ff1744",
  orange = "#ff6d00",
  yellow = "#ffd600",
  green = "#00e676",
  cyan = "#00e5ff",
  blue = "#2979ff",
  purple = "#d500f9",
  pink = "#ff00aa",
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
        c.bg = "#000000"
        c.bg_dark = "#000000"
        c.bg_float = "#000000"
        c.bg_popup = "#0a0a12"
        c.bg_sidebar = "#0a0a12"
        c.bg_statusline = "#0a0a12"
        c.bg_highlight = "#120a1c"
        c.bg_visual = "#3a1060"
        c.bg_search = "#0d2a66"

        c.fg = "#e6e6f0"
        c.fg_dark = "#a8a8c0"
        c.fg_gutter = "#3a3450"
        c.comment = "#6a6488"
        c.border = rgb.purple

        -- full spectrum: each role gets its own hue
        c.red = rgb.red
        c.red1 = "#d50000"
        c.orange = rgb.orange
        c.yellow = rgb.yellow
        c.green = rgb.green
        c.green1 = "#69ff94"
        c.green2 = "#00b35c"
        c.teal = "#1de9b6"
        c.cyan = rgb.cyan
        c.blue = rgb.blue
        c.blue0 = "#0d2a66"
        c.blue1 = "#5c9dff"
        c.blue2 = "#00b0ff"
        c.blue5 = "#6ef3ff"
        c.blue6 = "#b3f5ff"
        c.blue7 = "#1a1440"
        c.magenta = rgb.purple
        c.magenta2 = rgb.pink
        c.purple = "#b388ff"
      end,
      on_highlights = function(hl, c)
        hl.CursorLineNr = { fg = rgb.pink, bold = true }
        hl.LineNr = { fg = "#3a3450" }
        hl.Visual = { bg = "#3a1060" }
        hl.Search = { bg = "#0d2a66", fg = "#ffffff" }
        hl.IncSearch = { bg = rgb.pink, fg = "#000000" }
        hl.CurSearch = { bg = rgb.cyan, fg = "#000000" }
        hl.MatchParen = { fg = rgb.yellow, bold = true, underline = true }
        hl.WinSeparator = { fg = rgb.purple }
        hl.FloatBorder = { fg = rgb.cyan }
        hl.FloatTitle = { fg = rgb.pink, bold = true }
        hl.PmenuSel = { bg = "#3a1060", fg = "#ffffff", bold = true }
        hl.TabLineSel = { bg = rgb.purple, fg = "#000000", bold = true }
        hl.DiagnosticError = { fg = rgb.red }
        hl.DiagnosticWarn = { fg = rgb.yellow }
        hl.DiagnosticInfo = { fg = rgb.cyan }
        hl.DiagnosticHint = { fg = rgb.green }

        -- rainbow brackets (rainbow-delimiters.nvim)
        hl.RainbowDelimiterRed = { fg = rgb.red }
        hl.RainbowDelimiterOrange = { fg = rgb.orange }
        hl.RainbowDelimiterYellow = { fg = rgb.yellow }
        hl.RainbowDelimiterGreen = { fg = rgb.green }
        hl.RainbowDelimiterCyan = { fg = rgb.cyan }
        hl.RainbowDelimiterBlue = { fg = rgb.blue }
        hl.RainbowDelimiterViolet = { fg = rgb.purple }

        -- rainbow indent guides (snacks.indent) — dimmed so code stays readable
        hl.RGBIndent1 = { fg = "#4d0715" }
        hl.RGBIndent2 = { fg = "#4d2100" }
        hl.RGBIndent3 = { fg = "#4d4000" }
        hl.RGBIndent4 = { fg = "#004524" }
        hl.RGBIndent5 = { fg = "#00454d" }
        hl.RGBIndent6 = { fg = "#0c244d" }
        hl.RGBIndent7 = { fg = "#40004b" }
        hl.RGBScope = { fg = rgb.pink }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "tokyonight-night" },
  },
}
