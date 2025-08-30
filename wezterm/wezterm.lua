-- 載入 WezTerm API
local wezterm = require 'wezterm'


-- 工具函數：取得目前 pane 的工作目錄
local function currentDir(pane)
    local cwd_uri = pane:get_current_working_dir():sub(8) -- 去掉 file://
    local slash = cwd_uri:find("/")
    local cwd = ""
    local hostname = ""
    if slash then
        hostname = cwd_uri:sub(1, slash - 1)
        local dot = hostname:find("[.]")
        if dot then
            hostname = hostname:sub(1, dot - 1)
        end
        cwd = cwd_uri:sub(slash)
    else
        cwd = wezterm.home_dir -- 如果沒有找到，預設回家目錄
    end

    return cwd
end

-- 事件：增加背景不透明度
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

-- 事件：降低背景不透明度
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



-- 事件：GUI 啟動時自動最大化
-- wezterm.on('gui-startup', function(cmd)
--     local _, _, window = wezterm.mux.spawn_window(cmd or {})
--     window:gui_window():maximize()
-- end)




-- 事件：更新右側狀態列
wezterm.on('update-right-status', function(window, pane)
    local function space(str)
        return string.format('   %s   ', str)
    end

    -- Home 路徑顯示
    local home = space(string.format("%s  %s", wezterm.nerdfonts.md_home, wezterm.home_dir))

    -- 目前目錄
    -- local result, dir = pcall(currentDir, pane)
    -- if result == false then
    --     dir = ""
    -- end
    -- local current_dir = string.gsub(
    --     space(string.format("%s  %s", wezterm.nerdfonts.md_folder_open, dir)),
    --     wezterm.home_dir, '~'
    -- )

    
    -- 日期時間
    local date = space(string.format("%s  %s", wezterm.nerdfonts.md_calendar_clock,
        wezterm.strftime('%Y-%m-%d %H:%M:%S')))

    -- 電池資訊
    -- local bat = ''
    -- for _, b in ipairs(wezterm.battery_info()) do
    --     local per = math.floor(b.state_of_charge * 100)
    --     local icon = string.format('%s  ', wezterm.nerdfonts.md_battery)
    --     bat = space(string.format('%s%s%d%%', bat, icon, per))
    -- end

    -- 主題名稱
    local overrides = window:get_config_overrides() or {}
    local config = window:effective_config()
    local theme = ''
    if not overrides.color_scheme then
        theme = space(string.format('%s  %s', wezterm.nerdfonts.md_format_color_fill, config.color_scheme))
    else
        theme = space(string.format('%s  %s', wezterm.nerdfonts.md_format_color_fill, overrides.color_scheme))
    end

    -- 更新右上角狀態列
    window:set_right_status(wezterm.format {
        { Attribute = { Intensity = "Bold" } },
        { Background = { Color = "None" } },
        { Text = table.concat({ home, theme, date }, ' | ') },
    })
end)

-- 自訂tab顯示名稱(簡短顯示)
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    -- 只顯示 tab index
    local title = tostring(tab.tab_index + 1)
    -- -- 可用 max_width 截斷
    if #title > max_width then
        title = string.sub(title, 1, max_width)
    end

    -- 設定顏色（深綠背景，白色文字）
    return {
        { Background = { Color = "#728A7A" } },-- 淺綠
        { Foreground = { Color = "#D4C3AA" } }, -- 淺咖啡
        { Text = " " .. title .. " " },
    }
end)
  
-- 快捷鍵綁定
local keys = {
    { key = 'd', mods = 'LEADER', action = wezterm.action.ShowDebugOverlay }, -- Leader+d 顯示 debug
	
	 -- 視窗分割
    { key = '\\', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } }, -- Leader+v 水平分割
    { key = '-', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },   -- Leader+s 垂直分割
    { key = 'q', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },     -- LEADER + q 退出當前視窗分割
	
	
	-- 分頁
    { key = 'n', mods = 'LEADER', action = wezterm.action.SpawnCommandInNewTab { domain = 'CurrentPaneDomain' } }, -- Leader+n 新分頁
    { key = 'w', mods = 'LEADER', action = wezterm.action.CloseCurrentTab { confirm = true } }, -- 關閉分頁
	
	
    { key = 'f', mods = 'LEADER', action = wezterm.action.ToggleFullScreen }, -- Leader+f 全螢幕
    { key = '[', mods = 'LEADER', action = wezterm.action.ActivateCopyMode }, -- Leader+[ 進入複製模式
    { key = 'j', mods = 'LEADER|CTRL', action = wezterm.action.ActivateLastTab }, -- Ctrl+Leader+j 切換到最後一個分頁
	
	
	-- 在分割視窗中移動焦點
    { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' }, -- Leader+h 聚焦左邊窗格
    { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' }, -- Leader+j 聚焦下方窗格
    { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },   -- Leader+k 聚焦上方窗格
    { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },-- Leader+l 聚焦右邊窗格

    -- 分頁切換
    { key = 'Tab', mods = 'CTRL', action = wezterm.action.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },

	
	-- 開啟 launch_menu
    -- LEADER + s
    { key = 's', mods = 'LEADER', action = wezterm.action.ShowLauncher },
	
	
	-- 透明度
    { key = ']', mods = 'CTRL', action = wezterm.action.EmitEvent 'increment-opacity' },  -- Ctrl+] 提高不透明度
    { key = '[', mods = 'CTRL', action = wezterm.action.EmitEvent 'decrement-opacity' },  -- Ctrl+[ 降低不透明度
	
	-- 常用快捷鍵設定
    -- 複製
    -- { key = 'c', mods = 'LEADER', action = wezterm.action.CopyTo 'Clipboard' },
    -- 貼上
    -- { key = 'v', mods = 'LEADER', action = wezterm.action.PasteFrom 'Clipboard' },
	-- 重新載入設定檔，方便調整
	{ key = 'r', mods = 'LEADER', action = wezterm.action.ReloadConfiguration },
	
}

-- Leader+數字 1~8 切換分頁
for i = 1, 8 do
    table.insert(keys, {
        key = tostring(i),
        mods = 'LEADER',
        action = wezterm.action.ActivateTab(i - 1),
    })
end

-- 主設定
local config = {
    pane_focus_follows_mouse = true,         -- 滑鼠移動自動聚焦 pane
    use_fancy_tab_bar = true,                -- 使用 fancy tab bar
    tab_bar_at_bottom = true,                -- 把 tab bar 移到最下面
    show_new_tab_button_in_tab_bar = false,  -- 隱藏新增分頁按鈕
    font_size = 13.0,                        -- 字體大小
    window_decorations = "RESIZE",           -- 只有可縮放邊框，無標題列
    window_background_opacity = 0.6,         -- 背景透明度 60%
    use_ime = true,                          -- 啟用輸入法支援(適合中文輸入)
    ime_preedit_rendering = "System",        -- 使用系統的 IME 候選字顯示
	
	-- Leader 鍵
    leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }, -- 設定 Leader 鍵 Ctrl+a
    keys = keys,                     -- 套用快捷鍵配置
	
	
    -- hide_tab_bar_if_only_one_tab = true, -- 單一分頁時隱藏分頁欄位
    adjust_window_size_when_changing_font_size = false, -- 改字體大小不調整視窗大小
    enable_wayland = true,           -- 啟用 Wayland (Linux)
    color_scheme = "Dracula", -- 預設主題
    hide_mouse_cursor_when_typing = false, -- 打字時不隱藏滑鼠
    window_padding = { left = 1, right = 1, top = 0, bottom = 0 }, -- 視窗內邊距
    colors = {
        tab_bar = {
            background = 'rgba(0, 0, 0, 1)' -- tab bar 背景色
        },
    },
    inactive_pane_hsb = { hue = 1.0, saturation = 1.0, brightness = 1.0 }, -- 非作用中窗格亮度
    warn_about_missing_glyphs = false, -- 不顯示字體缺字警告
    -- mouse_bindings = {
    --    {
    --        event = { Up = { streak = 1, button = 'Left' } },
    --        mods = 'NONE',
    --        action = wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection', -- 左鍵選取 → 複製
    --    },
    --    {
    --        event = { Up = { streak = 1, button = 'Left' } },
    --        mods = 'CTRL',
    --        action = wezterm.action.OpenLinkAtMouseCursor, -- Ctrl+左鍵點擊 → 開啟連結
    --    },
    --},
	
	-- ================
	-- SSH 連線設定
	-- ================

	-- 透過 LEADER + s 開啟 launch_menu
	launch_menu = {
		{
			label = 'SSH shuhi56',
			args = { 'ssh', 'shuhi@shuhi56'},
		},
	},
	
    default_cwd = "D:\\Shuhi\\weztmp", -- 預設啟動目錄 = 使用者家目錄
}

-- 回傳 config
return config
