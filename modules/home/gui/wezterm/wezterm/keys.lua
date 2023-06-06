local wezterm = require "wezterm"
local act = wezterm.action


local keys = {
    {
        key = "h",
        mods = "CTRL|SHIFT",
        action = act.EmitEvent "trigger-show-scrollback",
    },
    {
        key = "p",
        mods = "CTRL|ALT",
        action = wezterm.action.QuickSelectArgs {
            label = "preview",
            patterns = {
                "(?:[.\\w\\-@~]+)?(?:/[.\\w\\-@]+)+(?::\\d+)?",
                "[^ .:]+[.][^ .:]+:\\d+",
            },
            action = act.EmitEvent "preview-selection",
        },
    }
}


wezterm.on("trigger-show-scrollback", function(window, pane)
    local viewport_text = pane:get_lines_as_text(100000)

    local name = os.tmpname()
    local f = io.open(name, "w+")
    assert(f ~= nil)
    f:write(viewport_text)
    f:flush()
    f:close()

    window:perform_action(act.SpawnCommandInNewTab { args = { "less", "+G", name } }, pane)

    -- Wait "enough" time for less to read the file before we remove it.
    -- The window creation and process spawn are asynchronous wrt. running
    -- this script and are not awaitable, so we just pick a number.
    wezterm.sleep_ms(1000)
    os.remove(name)
end)


wezterm.on("preview-selection", function(window, pane)
    local sel = window:get_selection_text_for_pane(pane)

    local path = sel:gsub(":%d+$", "")
    local line, found = sel:gsub("[^:]+:(%d+)$", "%1")

    local args = { "bat" }
    if found == 1 then
        table.insert(args, "--pager")
        table.insert(args, "less --RAW-CONTROL-CHARS +" .. line)
        table.insert(args, "-H")
        table.insert(args, line)
    end

    table.insert(args, path)

    window:perform_action(act.SplitVertical { args = args }, pane)
end)


return keys
