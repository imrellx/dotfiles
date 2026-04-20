-- Theme indirection managed by set_theme; active colorscheme is picked by
-- _themes/<active>/nvim.lua symlinked to plugins/theme.lua.
-- Diverges from ivn-term/config/nvim/lua/plugins/colorscheme.lua, which
-- reads the active theme from a file.

return {
  { "kepano/flexoki-neovim", name = "flexoki" },
  { "ellisonleao/gruvbox.nvim" },
  { "folke/tokyonight.nvim" },
}
