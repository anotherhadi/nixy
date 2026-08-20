-- Highlights color codes (#hex, rgb, etc.) with their actual color
return {
  "norcalli/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("colorizer").setup()
  end
}
