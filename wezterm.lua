-- 導入 WezTerm 模塊
local wezterm = require 'wezterm'

-- 初始化配置
local config = wezterm.config_builder()

-- 設置窗口透明度和模糊效果（玻璃球效果）
config.window_background_opacity = 0.4  -- 透明度，0.0（完全透明）到 1.0（不透明）
config.macos_window_background_blur = 20  -- macOS 模糊效果，值越大模糊越強

-- 設置背景：圖片 + 透明淡白色遮罩
config.background = {
  {
    source = { File = '/Users/shuhi/.config/wezterm/Desk.jpg' },  -- macOS 圖片路徑
    hsb = { brightness = 0.3 },  -- 調整亮度以提高對比度
    opacity = 0.3,  -- 圖片透明度
  },
  {
    source = { Color = 'rgba(235, 255, 255, 0.3)' },  -- 透明淡白色遮罩
    height = '100%',
    width = '100%',
  },
}

-- 設置字體和顏色
config.font = wezterm.font 'JetBrainsMono Nerd Font'  -- 使用 Nerd Font
config.font_size = 12  -- 字體大小
config.colors = {
  foreground = '#000000',  -- 黑色文字
  background = 'rgba(220, 220, 230, 0.6)',  -- 與背景一致
  cursor_bg = '#000000',  -- 光標背景色
  cursor_fg = '#FFFFFF',  -- 光標文字色
  cursor_border = '#000000',  -- 光標邊框色
  selection_fg = '#FFFFFF',  -- 選中文本的前景色
  selection_bg = 'rgba(255, 255, 255, 0.4)',  -- 選中文本的背景色
}

-- 簡化窗口邊框，增強沉浸感
config.window_decorations = 'RESIZE'  -- 僅保留調整大小功能，去掉標題欄

-- 必須返回 config 表
return config
