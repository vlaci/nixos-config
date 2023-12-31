local wezterm = require "wezterm"
local colors = require "colors"

local M = {}

local function get_process(tab)
    local palette = colors.scheme
    local process_icons = {
        ["bat"] = {
            { Foreground = { Color = palette.ansi[2] } },
            { Text = "󰭟" },
        },
        ["docker"] = {
            { Foreground = { Color = palette.ansi[5] } },
            { Text = wezterm.nerdfonts.dev_docker },
        },
        ["bash"] = {
            { Foreground = { Color = palette.ansi[4] } },
            { Text = wezterm.nerdfonts.cod_terminal_bash },
        },
        ["nu"] = {
            { Foreground = { Color = palette.ansi[3] } },
            { Text = "❯_" },
        },
        ["zsh"] = {
            { Foreground = { Color = palette.brights[5] } },
            { Text = "" },
        },
        ["btm"] = {
            { Foreground = { Color = palette.ansi[2] } },
            { Text = "" },
        },
        ["cargo"] = {
            { Foreground = { Color = palette.brights[2] } },
            { Text = wezterm.nerdfonts.dev_rust },
        },
        ["git"] = {
            { Foreground = { Color = palette.brights[2] } },
            { Text = wezterm.nerdfonts.dev_git },
        },
        ["python3"] = {
            { Foreground = { Color = palette.brights[3] } },
            { Text = wezterm.nerdfonts.dev_python },
        },
        ["ssh"] = {
            { Foreground = { Color = palette.ansi[2] } },
            { Text = "󰣀" },
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
        or { { Foreground = { Color = colors.scheme.brights[5] } }, { Text = string.format("[%s]", process_name) } }
    )
end


local function get_current_working_folder_name(tab)
    local cwd_uri = tab.active_pane.current_working_dir
    local cwd = ''
    if cwd_uri then
        cwd = cwd_uri.file_path
    end

    if cwd == wezterm.home_dir then
        return "  ~"
    end

    return string.format("  %s", string.match(cwd, "([^/]+)/?$"))
end


function M.setup()
    wezterm.on("format-tab-title", function(tab)
        return wezterm.format({
            { Foreground = { Color = colors.scheme.tab_bar.inactive_tab.bg_color } },
            { Text = tab.tab_index > 0 and "" or " " },
            { Attribute = { Intensity = "Half" } },
            { Foreground = { Color = colors.scheme.tab_bar.active_tab.fg_color } },
            { Text = string.format(" %s  ", tab.tab_index + 1) },
            "ResetAttributes",
            { Text = get_process(tab) },
            { Text = " " },
            { Text = get_current_working_folder_name(tab) },
            { Foreground = { Color = colors.scheme.tab_bar.inactive_tab.bg_color } },
            { Text = "" },
        })
    end)
end


return M
