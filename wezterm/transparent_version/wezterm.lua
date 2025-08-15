local wezterm = require 'wezterm'

local themes = {}
for k, _ in pairs(wezterm.get_builtin_color_schemes()) do
    table.insert(themes, k)
end

local fav_themes = {
    "SweetTerminal (Gogh)",
    "PaulMillr",
    "Aco (Gogh)",
    "Monokai Remastered",
    "LiquidCarbonTransparentInverse",
    "Mikazuki (terminal.sexy)",
    "Erebus (terminal.sexy)",
    "SynthWave (Gogh)",
    "FairyFloss (Gogh)",
}

local function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

local function currentDir(pane)
    local cwd_uri = pane:get_current_working_dir():sub(8)
    local slash = cwd_uri:find("/");
    local cwd = "";
    local hostname = "";
    if slash then
        hostname = cwd_uri:sub(1, slash - 1);
        local dot = hostname:find("[.]");
        if dot then
            hostname = hostname:sub(1, dot - 1);
        end
        cwd = cwd_uri:sub(slash);
    else
        cwd = wezterm.home_dir
    end

    return cwd
end

wezterm.on('increment-opacity', function(window, _)
    local overrides = window:get_config_overrides() or {}
    local config = window:effective_config()

    if not overrides.window_background_opacity then
        overrides.window_background_opacity = config.window_background_opacity + 0.1
    else
        overrides.window_background_opacity = overrides.window_background_opacity + 0.1
    end

    if overrides.window_background_opacity < 1.1 then
        window:set_config_overrides(overrides)
    end
end)

wezterm.on('decrement-opacity', function(window, _)
    local overrides = window:get_config_overrides() or {}
    local config = window:effective_config()

    if not overrides.window_background_opacity then
        overrides.window_background_opacity = config.window_background_opacity - 0.1
    else
        overrides.window_background_opacity = overrides.window_background_opacity - 0.1
    end

    if overrides.window_background_opacity > -0.1 then
        window:set_config_overrides(overrides)
    end
end)

wezterm.on('gui-startup', function(cmd)
    local _, _, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

wezterm.on('update-right-status', function(window, pane)
    local function space(str)
        return string.format('   %s   ', str)
    end

    local home = space(string.format("%s  %s", wezterm.nerdfonts.md_home, wezterm.home_dir))
    local result, dir = pcall(currentDir, pane)
    if result == false then
        dir = ""
    else
    end
    local current_dir = string.gsub(space(string.format("%s  %s", wezterm.nerdfonts.md_folder_open, dir)),
        wezterm.home_dir, '~')
    local date = space(string.format("%s  %s", wezterm.nerdfonts.md_calendar_clock,
        wezterm.strftime('%Y-%m-%d %H:%M:%S')))
    local bat = ''
    for _, b in ipairs(wezterm.battery_info()) do
        local per = math.floor(b.state_of_charge * 100)
        local icon = string.format('%s  ', wezterm.nerdfonts.md_battery)
        bat = space(string.format('%s%s%d%%', bat, icon, per))
    end

    local overrides = window:get_config_overrides() or {}
    local config = window:effective_config()
    local theme = ''
    if not overrides.color_scheme then
        theme = space(string.format('%s  %s', wezterm.nerdfonts.md_format_color_fill, config.color_scheme))
    else
        theme = space(string.format('%s  %s', wezterm.nerdfonts.md_format_color_fill, overrides.color_scheme))
    end

    window:set_right_status(wezterm.format {
        { Attribute = { Intensity = "Bold" } },
        { Background = { Color = "None" } },
        { Text = table.concat({ home, current_dir, theme, date, bat }, ' | ') },
    })
end)

wezterm.on('increment-theme', function(window, _)
    local overrides = window:get_config_overrides() or {}
    local config = window:effective_config()

    local index = 1
    if not overrides.color_scheme then
        index = indexOf(themes, config.color_scheme) or #themes
    else
        index = indexOf(themes, overrides.color_scheme) or #themes
    end

    overrides.color_scheme = themes[index + 1] or themes[#themes]
    window:set_config_overrides(overrides)
end)

wezterm.on('decrement-theme', function(window, _)
    local overrides = window:get_config_overrides() or {}
    local config = window:effective_config()

    local index = 1
    if not overrides.color_scheme then
        index = indexOf(themes, config.color_scheme) or 1
    else
        index = indexOf(themes, overrides.color_scheme) or 1
    end

    overrides.color_scheme = themes[index - 1] or themes[1]
    window:set_config_overrides(overrides)
end)

wezterm.on('random-theme', function(window, _)
    local overrides = window:get_config_overrides() or {}
    local config = window:effective_config()

    repeat
        overrides.color_scheme = themes[math.random(1, #themes)]
    until overrides.color_scheme ~= config.color_scheme

    window:set_config_overrides(overrides)
end)

wezterm.on('random-fav-theme', function(window, _)
    local overrides = window:get_config_overrides() or {}
    local config = window:effective_config()

    repeat
        overrides.color_scheme = fav_themes[math.random(1, #fav_themes)]
    until overrides.color_scheme ~= config.color_scheme

    window:set_config_overrides(overrides)
end)

wezterm.on('toggle-decoration', function(window, _)
    local overrides = window:get_config_overrides() or {}

    if not overrides.window_decorations then
        overrides.window_decorations = "TITLE | RESIZE"
    else
        if overrides.window_decorations == "TITLE | RESIZE" then
            overrides.window_decorations = "RESIZE"
        else
            overrides.window_decorations = "TITLE | RESIZE"
        end
    end

    window:set_config_overrides(overrides)
    window:restore()
    window:maximize()
end)

local keys = {
    { key = 'd', mods = 'LEADER', action = wezterm.action.ShowDebugOverlay },
    {
        key = 'v',
        mods = 'LEADER',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = 's',
        mods = 'LEADER',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'c',
        mods = 'LEADER',
        action = wezterm.action.SpawnCommandInNewTab {
            domain = 'CurrentPaneDomain',
        },
    },
    {
        key = 'f',
        mods = 'LEADER',
        action = wezterm.action.ToggleFullScreen,
    },
    { key = '[', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },
    {
        key = 'j',
        mods = 'LEADER|CTRL',
        action = wezterm.action.ActivateLastTab,
    },
    {
        key = 'h',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Left',
    },
    {
        key = 'j',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Down',
    },
    {
        key = 'k',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Up',
    },
    {
        key = 'l',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection 'Right',
    },
    {
        key = ']',
        mods = 'CTRL',
        action = wezterm.action.EmitEvent 'increment-opacity',
    },
    {
        key = '[',
        mods = 'CTRL',
        action = wezterm.action.EmitEvent 'decrement-opacity',
    },
    {
        key = '}',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.EmitEvent 'increment-theme',
    },
    {
        key = '{',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.EmitEvent 'decrement-theme',
    },
    {
        key = 't',
        mods = 'CTRL',
        action = wezterm.action.EmitEvent 'random-fav-theme',
    },
    {
        key = 't',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.EmitEvent 'random-theme',
    },
    {
        key = 'a',
        mods = 'LEADER',
        action = wezterm.action.EmitEvent 'toggle-decoration',
    },
}

for i = 1, 8 do
    table.insert(keys, {
        key = tostring(i),
        mods = 'LEADER',
        action = wezterm.action.ActivateTab(i - 1),
    })
end

local config = {
    --font = wezterm.font '0xProto',
    pane_focus_follows_mouse = true,
    use_fancy_tab_bar = true,
    font_size = 13.0,
    window_decorations = "RESIZE",
    window_background_opacity = 0.6,
    use_ime = true,
    ime_preedit_rendering = "System",
    leader = { key = 'j', mods = 'CTRL', timeout_milliseconds = 1000 },
    keys = keys,
    hide_tab_bar_if_only_one_tab = false,
    adjust_window_size_when_changing_font_size = false,
    enable_wayland = true,
    color_scheme = "Mikazuki (terminal.sexy)",
    hide_mouse_cursor_when_typing = false,
    window_padding = {
        left = 1,
        right = 1,
        top = 0,
        bottom = 0,
    },
    colors = {
        tab_bar = {
            background = 'rgba(0, 0, 0, 1)'
        },
    },
    inactive_pane_hsb = {
        hue = 1.0,
        saturation = 1.0,
        brightness = 1.0,
    },
    warn_about_missing_glyphs = false,
    mouse_bindings = {
        {
            event = { Up = { streak = 1, button = 'Left' } },
            mods = 'NONE',
            action = wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection',
        },
        {
            event = { Up = { streak = 1, button = 'Left' } },
            mods = 'CTRL',
            action = wezterm.action.OpenLinkAtMouseCursor,
        },
    },
    xim_im_name = 'fcitx',
    default_cwd = wezterm.home_dir,
}

return config
