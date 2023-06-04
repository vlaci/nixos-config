local wezterm = require("wezterm")
-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Catppuccin Mocha'
  else
    return 'Catppuccin Latte'
  end
end
local colors = wezterm.color.get_builtin_schemes()[scheme_for_appearance(get_appearance())]

local palette = {
    rosewater = colors.indexed[17],
    flamingo = colors.compose_cursor,
    pink = colors.brights[6],
    mauve = colors.tab_bar.active_tab.bg_color,
    red = colors.ansi[2],
    maroon = "#eba0ac",
    peach = colors.indexed[16],
    yellow = colors.ansi[4],
    green = colors.ansi[3],
    teal = colors.brights[7],
    sky = "#89dceb",
    sapphire = "#74c7ec",
    blue = colors.ansi[5],
    lavender = "#b4befe",
    text = colors.foreground,
    subtext1 = "#bac2de",
    subtext0 = "#a6adc8",
    overlay2 = "#9399b2",
    overlay1 = "#7f849c",
    overlay0 = "#6c7086",
    surface2 = "#585b70",
    surface1 = "#45475a",
    surface0 = "#313244",
    base = colors.background,
    mantle = colors.tab_bar.inactive_tab.bg_color,
    crust = colors.tab_bar.background,
}
local tab = {}

local function get_process(tab)
    local process_icons = {
        [".bat-wrapped"] = {
            { Foreground = { Color = palette.flamingo } },
            { Text = '󰭟' },
        },
        ["docker"] = {
            { Foreground = { Color = palette.blue } },
            { Text = wezterm.nerdfonts.dev_docker },
        },
        ["bash"] = {
            { Foreground = { Color = palette.yellow } },
            { Text = wezterm.nerdfonts.cod_terminal_bash },
        },
        ["nu"] = {
            { Foreground = { Color = palette.green } },
            { Text = "❯_" },
        },
        ["zsh"] = {
            { Foreground = { Color = palette.teal } },
            { Text = "" },
        },
        ["btm"] = {
            { Foreground = { Color = palette.rosewater } },
            { Text = "" },
        },
        ["cargo"] = {
            { Foreground = { Color = palette.peach } },
            { Text = wezterm.nerdfonts.dev_rust },
        },
        ["git"] = {
            { Foreground = { Color = palette.peach } },
            { Text = wezterm.nerdfonts.dev_git },
        },
        ["python3"] = {
            { Foreground = { Color = palette.sapphire } },
            { Text = wezterm.nerdfonts.dev_python },
        },
        ["ssh"] = {
            { Foreground = { Color = palette.red } },
            { Text = '󰣀' },
        },
    }

    local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.[^.]+).*", "%2")

    if not process_name then
        process_name = "zsh"
    end

    return wezterm.format(
        process_icons[process_name]
        or { { Foreground = { Color = palette.sky } }, { Text = string.format("[%s]", process_name) } }
    )
end

local function get_current_working_folder_name(tab)
    local cwd_uri = (tab.active_pane.current_working_dir or ""):sub(8)

    local slash = cwd_uri:find("/")
    local cwd = cwd_uri
    if slash then
        cwd = cwd_uri:sub(slash)
    end
    if cwd == wezterm.home_dir then
        return "  ~"
    end

    return string.format("  %s", string.match(cwd, "([^/]+)/?$"))
end

function tab.setup()
    wezterm.on("format-tab-title", function(tab)
        return wezterm.format({
            { Foreground = { Color = palette.crust } },
            { Text = tab.tab_index > 0 and "" or ' ' },
            { Attribute = { Intensity = "Half" } },
            { Foreground = { Color = palette.overlay0 } },
            { Text = string.format(" %s  ", tab.tab_index + 1) },
            "ResetAttributes",
            { Text = get_process(tab) },
            { Text = " " },
            { Text = get_current_working_folder_name(tab) },
            { Foreground = { Color = palette.crust } },
            { Text = " " },
        })
    end)
end

return tab
