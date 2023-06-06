local wezterm = require "wezterm"

local colors = require "colors"
local keys = require "keys"
local statusbar = require "statusbar"
local tab = require "tab"


local config = wezterm.config_builder()

statusbar.setup()
tab.setup()

wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

config:set_strict_mode(true)

config.keys = keys

config.color_scheme = colors.selected
config.font = wezterm.font "monospace"

config.scrollback_lines = 100000

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 50

config.quick_select_patterns = {
    "[^ .]+[.][^ .]+"
}
config.quick_select_alphabet = "arstqwfpzxcdneioluyhgmvjbh"


return config
