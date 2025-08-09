local wezterm = require('wezterm')
local mux = wezterm.mux

return {
  -- ================
  -- 外觀設定
  -- ================

  -- 主題顏色 "Catppuccin Macchiato"
  color_scheme = 'Dracula',
  default_cursor_style = 'BlinkingUnderline',
  
  -- 設置字體顏色為黑色
  foreground_text_hsb = { hue = 0, saturation = 0, brightness = 0 },
  
  -- 模糊效果
  -- blur_behind_tab_bar = true,
  -- blur_behind_split_panes = true,
  -- blur_behind_windows = true,

  -- 隱藏視窗標題列
  -- window_decorations = "NONE",


  -- ================
  -- 分頁與視窗管理
  -- ================

  -- 背景圖片
   background = {
     {
       source = {
		-- 圖片路徑(建議使用絕對路徑)
        File = 'C:/Users/shuhi/.config/wezterm/cat.jpg',
       },
		-- 圖片縮放模式
        -- resize = "NoScale",

		-- 圖片背景透明度
       opacity = 0.1,
     },
	 {
		source = { Color = 'rgba(128, 128, 128,0.5)' },  -- 灰色色，帶 50% 透明度
		height = '100%',
		width = '100%',
	},
	
  },
  
  -- 窗口設置
  window_background_opacity = 0.9, -- 透明度
  win32_system_backdrop = 'Acrylic', -- 啟用 Windows Acrylic 模糊效果
  
  
  
  -- 分頁欄放置在底部
  tab_bar_at_bottom = true,
  colors = {
    selection_bg = '#FFFFFF',  -- 選取區塊背景色，淺灰色
	selection_fg = '#000000',  -- 選取區塊文字顏色（黑色）
    tab_bar = {
      active_tab = {
        bg_color = '#CCCCCC', -- 活躍分頁背景
        fg_color = '#FFFFFF', -- 活躍分頁文字為白色
      },
      inactive_tab = {
        bg_color = '#CCCCCC', -- 非活躍分頁背景
        fg_color = '#999999', -- 非活躍分頁文字為灰色
      },
    },
  },
  
  -- 增強型分頁(支援圖標)
  use_fancy_tab_bar = true,

  -- 隱藏分頁欄位, 除非有多個分頁
  enable_tab_bar = true,


  
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
  


  
  -- ================
  -- 視窗分割  
  -- ================
  keys = {
    -- 視窗分割
    { key = '\\', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },

    -- 退出當前視窗分割
    -- 按下 LEADER 後再按 q
    { key = 'q', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },

    -- 在分割視窗中移動焦點
    -- Vim 風格
    { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Left') },
    { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Right') },
    { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Up') },
    { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection('Down') },
 
    -- 分頁切換
    { key = 'Tab', mods = 'CTRL', action = wezterm.action.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
    
    -- 關閉分頁
    { key = 'w', mods = 'LEADER', action = wezterm.action.CloseCurrentTab { confirm = true } },
    
    -- 建立新分頁
    { key = 't', mods = 'LEADER', action = wezterm.action.SpawnTab('CurrentPaneDomain') },

    -- 開啟 launch_menu
    -- LEADER + s
    { key = 's', mods = 'LEADER', action = wezterm.action.ShowLauncher },

    -- 重新載入設定檔，方便調整
    { key = 'r', mods = 'LEADER', action = wezterm.action.ReloadConfiguration },

    -- 常用快捷鍵設定
    -- 複製
    { key = 'c', mods = 'LEADER', action = wezterm.action.CopyTo 'Clipboard' },
    -- 貼上
    { key = 'v', mods = 'LEADER', action = wezterm.action.PasteFrom 'Clipboard' },
  },

  -- 設定 LEADER 鍵為 CTRL+a，方便與 GNU Screen 或 tmux 相容
  leader = { key = 'a', mods = 'CTRL'},

  -- 啟動時自動最大化視窗
  -- enable_kitty_graphics = true,
  
  -- 啟用滑鼠滾動
  -- enable_scroll_bar = true,

  
  -- =======================================================================================
  -- 其他進階設定
  -- =======================================================================================
  
  -- 啟動時執行的指令
  -- 可以設定啟動時自動切換到特定的 shell
  -- default_prog = { 'C:\\Users\\felixhuang\\scoop\\apps\\msys2\\current\\usr\\bin\\fish.exe'},
  
  -- 跨平台鍵盤設置
  use_ime = true, -- 啟用輸入法支援(適合中文輸入)
  hide_tab_bar_if_only_one_tab = true, -- 單一分頁時隱藏分頁欄位
  
  
    -- 視窗邊界調整
  -- window_padding = {
  --   left = 0,
  --   right = 0,
  --   top = 0,
  --   bottom = 0,
  -- },
}
