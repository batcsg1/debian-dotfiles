-- RGB extras: rainbow brackets + rainbow indent guides
return {
  -- each nesting level of (), [], {} gets the next spectrum colour
  {
    "HiPhish/rainbow-delimiters.nvim",
    lazy = false, -- attaches on FileType; lazy-loading misses the first buffer
    submodules = false,
    config = function()
      require("rainbow-delimiters.setup").setup({
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterOrange",
          "RainbowDelimiterYellow",
          "RainbowDelimiterGreen",
          "RainbowDelimiterCyan",
          "RainbowDelimiterBlue",
          "RainbowDelimiterViolet",
        },
      })
    end,
  },

  -- LazyVim's built-in indent guides (snacks.nvim), cycled through the spectrum
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        indent = {
          hl = {
            "RGBIndent1", "RGBIndent2", "RGBIndent3", "RGBIndent4",
            "RGBIndent5", "RGBIndent6", "RGBIndent7",
          },
        },
        scope = { hl = "RGBScope" },
      },
    },
  },
}
