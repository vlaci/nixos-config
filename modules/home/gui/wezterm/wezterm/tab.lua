local wezterm = require("wezterm")
local colors = require("colors")

local tab = {}

local function get_process(tab)
    local palette = tab.is_active and colors.opposite or colors.palette
    local process_icons = {
        ["bat"] = {
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

    local process_name = string.gsub(tab.active_pane.foreground_process_name, "/?([^/]*/)", "")
    process_name = string.gsub(process_name, "^.(.*)-wrapped", "%1")
    process_name = string.gsub(process_name, "^([^.]*).*", "%1")

    if not process_name then
        process_name = "zsh"
    end

    return wezterm.format(
        process_icons[process_name]
        or { { Foreground = { Color = colors.palette.sky } }, { Text = string.format("[%s]", process_name) } }
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
            { Foreground = { Color = colors.palette.crust } },
            { Text = tab.tab_index > 0 and "" or ' ' },
            { Attribute = { Intensity = "Half" } },
            { Foreground = { Color = colors.palette.overlay0 } },
            { Text = string.format(" %s  ", tab.tab_index + 1) },
            "ResetAttributes",
            { Text = get_process(tab) },
            { Text = " " },
            { Text = get_current_working_folder_name(tab) },
            { Foreground = { Color = colors.palette.crust } },
            { Text = "" },
        })
    end)
end

return tab
