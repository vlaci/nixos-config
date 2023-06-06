local wezterm = require "wezterm"

local colors = require "colors"
local gitstatus = require "gitstatus"


local M = {}


local function shorten_path(path)
    local home = wezterm.home_dir

    if path:sub(1, home:len()) == home then
        path = "~" .. path:sub(home:len() + 1)
    end

    local shortenedPath = ""
    local directories = {}

    for directory in string.gmatch(path, "[^/]+") do
        table.insert(directories, directory)
    end

    local numDirectories = #directories
    local repo_found = false
    for i = 1, numDirectories - 1 do
        local current = table.concat(directories, "/", 1, i)
        if not repo_found and #wezterm.glob(current:gsub("^~", home) .. "/.git") ~= 0 then
            repo_found = true
        end
        if repo_found then
            shortenedPath = shortenedPath .. directories[i] .. "/"
        else
            shortenedPath = shortenedPath .. string.sub(directories[i], 1, 1) .. "/"
        end
    end

    shortenedPath = shortenedPath .. directories[numDirectories]

    return shortenedPath
end


function M.setup()
    wezterm.on("update-right-status", function(window, pane)
        local cells = {}

        -- Figure out the cwd and host of the current pane.
        -- This will pick up the hostname for the remote host if your
        -- shell is using OSC 7 on the remote host.
        local cwd_uri = pane:get_current_working_dir()
        local cwd = nil
        if cwd_uri then
            cwd_uri = cwd_uri:sub(8)
            local slash = cwd_uri:find "/"
            local hostname = ""
            if slash then
                hostname = cwd_uri:sub(1, slash - 1)
                -- Remove the domain name portion of the hostname
                local dot = hostname:find "[.]"
                if dot then
                    hostname = hostname:sub(1, dot - 1)
                end
                cwd = cwd_uri:sub(slash)

                table.insert(cells, shorten_path(cwd))
                table.insert(cells, hostname)
            end
        end

        local git = gitstatus:get(cwd)
        if git.is_git then
            local info = string.format(" %s ", git.branch)

            if git.commits_behind_upstream ~= 0 then
                info = info .. string.format("⇣%s", git.commits_behind_upstream)
            end

            if git.commits_ahead_upstream ~= 0 then
                info = info .. string.format("⇡%s ", git.commits_ahead_upstream)
            end

            if git.commits_behind_pushremote ~= 0 then
                info = info .. string.format("⇠%s", git.commits_behind_pushremote)
            end

            if git.commits_ahead_pushremote ~= 0 then
                info = info .. string.format("⇢%s ", git.commits_ahead_pushremote)
            end

            if git.stashes ~= 0 then
                info = info .. string.format("*%s ", git.stashes)
            end

            if git.staged_changes ~= 0 then
                info = info .. string.format("+%s ", git.staged_changes)
            end

            if git.unstaged_changes ~= 0 then
                info = info .. string.format("!%s ", git.unstaged_changes)
            end

            if git.files_untracked ~= 0 then
                info = info .. string.format("?%s ", git.files_untracked)
            end

            table.insert(cells, info)
        end
        -- An entry for each battery (typically 0 or 1 battery)
        for _, b in ipairs(wezterm.battery_info()) do
            table.insert(cells, string.format("%.0f%%", b.state_of_charge * 100))
        end

        local RIGHT_SEP = ""
        local LEFT_SEP = ""

        local palette = {
            colors.palette.red,
            colors.palette.maroon,
            colors.palette.peach,
            colors.palette.yellow,
        }

        local text_fg = colors.palette.base

        local elements = {}
        local num_cells = 0

        local function push(text, is_first, is_last)
            local cell_no = num_cells + 1
            if is_first then
                table.insert(elements, { Foreground = { Color = colors.scheme.tab_bar.background } })
                table.insert(elements, { Background = { Color = palette[cell_no] } })
                table.insert(elements, { Text = RIGHT_SEP })
            end
            table.insert(elements, { Foreground = { Color = text_fg } })
            table.insert(elements, { Background = { Color = palette[cell_no] } })
            table.insert(elements, { Text = " " .. text .. " " })
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
end


return M
