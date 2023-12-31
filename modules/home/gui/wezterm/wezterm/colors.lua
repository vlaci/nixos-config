local wezterm = require "wezterm"


local M = {}

local colors, metadata = wezterm.color.load_scheme(wezterm.config_dir .. "/colors/stylix.toml")

M.selected = "stylix"
M.scheme = colors


return M
