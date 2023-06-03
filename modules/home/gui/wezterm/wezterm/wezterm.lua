local wezterm = require 'wezterm'
local io = require 'io'
local os = require 'os'

local tab = require 'tab'

local color_scheme = 'Catppuccin Mocha'
local scheme = wezterm.get_builtin_color_schemes()[color_scheme]
local act = wezterm.action
wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

scheme.tab_bar.active_tab.bg_color = '#9399b2'

tab.setup()

wezterm.on('trigger-show-scrollback', function(window, pane)
    local viewport_text = pane:get_lines_as_text(100000)

    local name = os.tmpname()
    local f = io.open(name, 'w+')
    f:write(viewport_text)
    f:flush()
    f:close()

    window:perform_action(act.SpawnCommandInNewTab { args = { 'less', '+G', name } }, pane)

    -- Wait "enough" time for less to read the file before we remove it.
    -- The window creation and process spawn are asynchronous wrt. running
    -- this script and are not awaitable, so we just pick a number.
    --
    -- Note: We don't strictly need to remove this file, but it is nice
    -- to avoid cluttering up the temporary directory.
    wezterm.sleep_ms(1000)
    os.remove(name)
end
)

return {
    colors = scheme,
    font = wezterm.font 'monospace',
    scrollback_lines = 100000,
    keys = {
        {
            key = 'h',
            mods = 'CTRL|SHIFT',
            action = act.EmitEvent 'trigger-show-scrollback',
        },
    },
    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
    show_new_tab_button_in_tab_bar = false,
    tab_max_width = 50,
    hide_tab_bar_if_only_one_tab = true,
}
