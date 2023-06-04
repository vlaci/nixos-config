local wezterm = require 'wezterm'
local io = require 'io'
local os = require 'os'

local tab = require 'tab'
local gitstatus = require 'gitstatus'

local act = wezterm.action
wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

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

local function shorten_path(path)
    local home = wezterm.home_dir

    if path:sub(1, home:len()) == home then
        path = '~' .. path:sub(home:len() + 1)
    end

    local shortenedPath = ""
    local directories = {}

    for directory in string.gmatch(path, "[^/]+") do
        table.insert(directories, directory)
    end

    local numDirectories = #directories
    local repo_found = false
    for i = 1, numDirectories - 1 do
        local current = table.concat(directories, '/', 1, i)
        if not repo_found and #wezterm.glob(current:gsub("^~", home) .. '/.git') ~= 0 then
            repo_found = true
        end
        if repo_found then
            shortenedPath = shortenedPath .. directories[i] .. '/'
        else
            shortenedPath = shortenedPath .. string.sub(directories[i], 1, 1) .. '/'
        end
    end

    shortenedPath = shortenedPath .. directories[numDirectories]

    return shortenedPath
end

wezterm.on('update-right-status', function(window, pane)
    -- Each element holds the text for a cell in a "powerline" style << fade
    local cells = {}

    -- Figure out the cwd and host of the current pane.
    -- This will pick up the hostname for the remote host if your
    -- shell is using OSC 7 on the remote host.
    local cwd_uri = pane:get_current_working_dir()
    local cwd = nil
    if cwd_uri then
        cwd_uri = cwd_uri:sub(8)
        local slash = cwd_uri:find '/'
        local hostname = ''
        if slash then
            hostname = cwd_uri:sub(1, slash - 1)
            -- Remove the domain name portion of the hostname
            local dot = hostname:find '[.]'
            if dot then
                hostname = hostname:sub(1, dot - 1)
            end
            -- and extract the cwd from the uri
            cwd = cwd_uri:sub(slash)

            table.insert(cells, shorten_path(cwd))
            table.insert(cells, hostname)
        end
    end

    local gitstatus = gitstatus.instance():get_status(cwd)
    if gitstatus.is_git then
        local info = string.format(" %s ", gitstatus.branch)

        if gitstatus.commits_behind_upstream ~= 0 then
            info = info .. string.format("⇣%s", gitstatus.commits_behind_upstream)
        end

        if gitstatus.commits_ahead_upstream ~= 0 then
            info = info .. string.format("⇡%s ", gitstatus.commits_ahead_upstream)
        end

        if gitstatus.commits_behind_pushremote ~= 0 then
            info = info .. string.format("⇠%s", gitstatus.commits_behind_pushremote)
        end

        if gitstatus.commits_ahead_pushremote ~= 0 then
            info = info .. string.format("⇢%s ", gitstatus.commits_ahead_pushremote)
        end

        if gitstatus.stashes ~= 0 then
            info = info .. string.format("*%s ", gitstatus.stashes)
        end

        if gitstatus.unstaged_changes ~= 0 then
            info = info .. string.format("!%s ", gitstatus.unstaged_changes)
        end

        if gitstatus.files_untracked ~= 0 then
            info = info .. string.format("?%s ", gitstatus.files_untracked)
        end

        table.insert(cells, info)
    end
    -- An entry for each battery (typically 0 or 1 battery)
    for _, b in ipairs(wezterm.battery_info()) do
        table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
    end

    -- The powerline < symbol
    local LEFT_ARROW = ''     -- utf8.char(0xe0b3)
    -- The filled in variant of the < symbol
    local SOLID_LEFT_ARROW = '' -- utf8.char(0xe0b2)

    -- Color palette for the backgrounds of each cell
    local colors = {
        --'#cba6f7',
        '#f38ba8',
        '#eba0ac',
        '#fab387',
        '#f9e2af',
    }

    -- Foreground color for the text across the fade
    local col = wezterm.color.get_builtin_schemes()[scheme_for_appearance(get_appearance())]
    local text_fg = col.tab_bar.background

    -- The elements to be formatted
    local elements = {}
    -- How many cells have been formatted
    local num_cells = 0

    -- Translate a cell into elements
    function push(text, is_first, is_last)
        local cell_no = num_cells + 1
        table.insert(elements, { Foreground = { Color = text_fg } })
        table.insert(elements, { Background = { Color = colors[cell_no] } })
        if is_first then
            table.insert(elements, { Text = LEFT_ARROW })
        end
        table.insert(elements, { Text = ' ' .. text .. ' ' })
        if not is_last then
            table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
            table.insert(elements, { Text = SOLID_LEFT_ARROW })
        end
        num_cells = num_cells + 1
    end

    local total_cells = #cells
    while #cells > 0 do
        local cell = table.remove(cells, 1)
        push(cell, #cells == total_cells - 1, #cells == 0)
    end

    window:set_right_status(wezterm.format(elements))
end)
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


return {
    color_scheme = scheme_for_appearance(get_appearance()),
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
}
