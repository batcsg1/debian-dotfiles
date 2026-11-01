-- ROG Mech extras: depth-coloured brackets + gunmetal indent guides
-- (highlight groups are defined in colorscheme.lua)
return {
  -- each nesting level of (), [], {} alternates red / steel / electric
  {
    "HiPhish/rainbow-delimiters.nvim",
    lazy = false, -- attaches on FileType; lazy-loading misses the first buffer
    submodules = false,
    config = function()
      require("rainbow-delimiters.setup").setup({
        highlight = {
          "RogDelim1",
          "RogDelim2",
          "RogDelim3",
          "RogDelim4",
          "RogDelim5",
          "RogDelim6",
        },
      })
    end,
  },

  -- LazyVim's built-in indent guides (snacks.nvim)
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        indent = { hl = "RogIndent" },
        scope = { hl = "RogScope" },
      },
    },
  },
}
