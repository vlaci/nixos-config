local wezterm = require("wezterm")

local palette = {
    rosewater = "#f5e0dc",
    flamingo = "#f2cdcd",
    pink = "#f5c2e7",
    mauve = "#cba6f7",
    red = "#f38ba8",
    maroon = "#eba0ac",
    peach = "#fab387",
    yellow = "#f9e2af",
    green = "#a6e3a1",
    teal = "#94e2d5",
    sky = "#89dceb",
    sapphire = "#74c7ec",
    blue = "#89b4fa",
    lavender = "#b4befe",
    text = "#cdd6f4",
    subtext1 = "#bac2de",
    subtext0 = "#a6adc8",
    overlay2 = "#9399b2",
    overlay1 = "#7f849c",
    overlay0 = "#6c7086",
    surface2 = "#585b70",
    surface1 = "#45475a",
    surface0 = "#313244",
    base = "#1e1e2e",
    mantle = "#181825",
    crust = "#11111b",
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
    local cwd_uri = tab.active_pane.current_working_dir

    cwd_uri = cwd_uri:sub(8)

    local slash = cwd_uri:find("/")
    local cwd = cwd_uri:sub(slash)

    local HOME_DIR = os.getenv("HOME")
    if cwd == HOME_DIR then
        return "  ~"
    end

    return string.format("  %s", string.match(cwd, "[^/]+$"))
end

function tab.setup()
    wezterm.on("format-tab-title", function(tab)
        return wezterm.format({
            { Attribute = { Intensity = "Half" } },
            { Foreground = { Color = palette.surface2 } },
            { Text = string.format(" %s  ", tab.tab_index + 1) },
            "ResetAttributes",
            { Text = get_process(tab) },
            { Text = " " },
            { Text = get_current_working_folder_name(tab) },
            { Foreground = { Color = palette.base } },
            { Text = "  ▕" },
        })
    end)
end

return tab
