local wezterm = require 'wezterm'
local Gitstatus = {}

local cache = wezterm.GLOBAL.gitstatus_cache or {}
wezterm.GLOBAL.gitstatus_cache = cache

wezterm.on('user-var-changed', function()
    cache = {}
    wezterm.GLOBAL.gitstatus_cache = cache
end)

function Gitstatus:new()
    local status = {
        started = false,
        proc = nil,
        proc_out = nil,
    }
    setmetatable(status, self)
    self.__index = self
    return status
end

function Gitstatus:ensure_started()
    if self.started then
        return
    end

    local outfile = os.tmpname()
    os.remove(outfile)
    local success, stdout, stderr = wezterm.run_child_process { 'mkfifo', outfile }
    if not success then
        wezterm.log_error("Could not create child", stdout, stderr)
        return
    end

    self.proc = io.popen("gitstatusd -s -1 -u -1 -d -1 -c -1 -m -1 > " .. outfile, "w")
    self.proc_out = io.open(outfile, 'rb')
    os.remove(outfile)
    self.started = true
end

local RS = string.char(0x1e)
local US = string.char(0x1f)

local function request_info(write_fd, dir)
    write_fd:write(US .. dir .. RS)
    write_fd:flush()
end

local function read_unit(read_fd)
    local buff = ""
    while true do
        local b = read_fd:read(1)
        if b == nil then
            return buff, false
        end
        if b == RS then
            return buff, false
        end

        if b == US then
            return buff, true
        end
        buff = buff .. b
    end
end

local function read_record(read_fd)
    local rec = {}
    local field = nil
    local has_more = true

    while has_more do
        field, has_more = read_unit(read_fd)
        table.insert(rec, field)
    end
    return rec
end


local function id(s) return s end
local function toboolean(s)
    if s == '0' then
        return false
    elseif s == '1' then
        return true
    end
end

local status_mapping = {
    { 'id',                        id },
    { 'is_git',                    toboolean },
    { 'dir',                       id },
    { 'hash',                      id },
    { 'branch',                    id },
    { 'upstream',                  id },
    { 'remote',                    id },
    { 'remote_url',                id },
    { 'state',                     id },
    { 'files_in_index',            tonumber },
    { 'staged_changes',            tonumber },
    { 'unstaged_changes',          tonumber },
    { 'conflicted_changes',        tonumber },
    { 'files_untracked',           tonumber },
    { 'commits_ahead_upstream',    tonumber },
    { 'commits_behind_upstream',   tonumber },
    { 'stashes',                   tonumber },
    { 'last_tag',                  id },
    { 'unstaged_deleted_files',    tonumber },
    { 'staged_new_files',          tonumber },
    { 'staged_deleted_files',      tonumber },
    { 'push_remote',               id },
    { 'push_remote_url',           id },
    { 'commits_ahead_pushremote',  tonumber },
    { 'commits_behind_pushremote', tonumber },
    { 'files_skip_worktree',       tonumber },
    { 'files_assume_unchanged',    tonumber },
    { 'message_encoding',          id },
    { 'message',                   id },
}


function Gitstatus:get_status(dir)
    local status = {}
    if not dir then
        return status
    end

    local cached = cache[dir]
    if cached then
        return cached
    end

    self:ensure_started()
    request_info(self.proc, dir)
    for i, field in ipairs(read_record(self.proc_out)) do
        status[status_mapping[i][1]] = status_mapping[i][2](field)
    end

    cache[dir] = status
    wezterm.time.call_after(10, function()
        cache[dir] = nil
    end)

    return status
end

local instance
function Gitstatus.instance()
    if not instance then
        instance = Gitstatus:new()
    end
    return instance
end

return Gitstatus
