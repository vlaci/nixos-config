local wezterm = require 'wezterm'
local io = require 'io'
local os = require 'os'

local tab = require 'tab'
local gitstatus = require 'gitstatus'
local colors = require 'colors'

local act = wezterm.action
wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

tab.setup()

wezterm.on('trigger-show-scrollback', function(window, pane)
    local viewport_text = pane:get_lines_as_text(100000)

    local name = os.tmpname()
    local f = io.open(name, 'w+')
    assert(f ~= nil)
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
end)

wezterm.on('preview-selection', function(window, pane)
    local sel = window:get_selection_text_for_pane(pane)
    wezterm.log_info('selection is: ' .. sel)

    local path = sel:gsub(":%d+$", "")
    local line, found = sel:gsub("[^:]+:(%d+)$", "%1")

    local args = { 'bat' }
    if found == 1 then
        table.insert(args, '--pager')
        table.insert(args, 'less --RAW-CONTROL-CHARS +' .. line)
        table.insert(args, '-H')
        table.insert(args, line)
    end

    table.insert(args, path)

    wezterm.log_info(args, path, line, found)
    window:perform_action(act.SplitVertical { args = args }, pane)
end)


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

        if gitstatus.staged_changes ~= 0 then
            info = info .. string.format("+%s ", gitstatus.staged_changes)
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

    local RIGHT_SEP = ''
    local LEFT_SEP = ''

    -- Color palette for the backgrounds of each cell
    local palette = {
        -- colors.palette.mauve,
        colors.palette.red,
        colors.palette.maroon,
        colors.palette.peach,
        colors.palette.yellow,
    }

    -- Foreground color for the text across the fade
    local text_fg = colors.palette.base

    -- The elements to be formatted
    local elements = {}
    -- How many cells have been formatted
    local num_cells = 0

    -- Translate a cell into elements
    local function push(text, is_first, is_last)
        local cell_no = num_cells + 1
        if is_first then
            table.insert(elements, { Foreground = { Color = colors.scheme.tab_bar.background } })
            table.insert(elements, { Background = { Color = palette[cell_no] } })
            table.insert(elements, { Text = RIGHT_SEP })
        end
        table.insert(elements, { Foreground = { Color = text_fg } })
        table.insert(elements, { Background = { Color = palette[cell_no] } })
        table.insert(elements, { Text = ' ' .. text .. ' ' })
        if not is_last then
            table.insert(elements, { Foreground = { Color = palette[cell_no + 1] } })
            table.insert(elements, { Text = LEFT_SEP })
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


return {
    color_scheme = colors.selected,
    font = wezterm.font 'monospace',
    scrollback_lines = 100000,
    keys = {
        {
            key = 'h',
            mods = 'CTRL|SHIFT',
            action = act.EmitEvent 'trigger-show-scrollback',
        },
        {
            key = 'p',
            mods = 'CTRL|ALT',
            action = wezterm.action.QuickSelectArgs {
                label = 'preview',
                patterns = {
                    '(?:[.\\w\\-@~]+)?(?:/[.\\w\\-@]+)+(?::\\d+)?',
                    '[^ .:]+[.][^ .:]+:\\d+',
                },
                action = act.EmitEvent 'preview-selection',
            },
        },
    },
    tab_bar_at_bottom = true,
    use_fancy_tab_bar = false,
    show_new_tab_button_in_tab_bar = false,
    tab_max_width = 50,
    quick_select_patterns = {
        '[^ .]+[.][^ .]+'
    }
}
