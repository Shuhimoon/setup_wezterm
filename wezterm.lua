-- 導入 WezTerm 模塊
local wezterm = require 'wezterm'

-- 初始化配置
local config = wezterm.config_builder()

-- 設置 Acrylic 模糊效果（玻璃球效果）
config.window_background_opacity = 0.4  -- 設置透明度，0.0（完全透明）到 1.0（完全不透明）
config.win32_system_backdrop = 'Acrylic'  -- 啟用 Windows Acrylic 模糊效果

-- 可選：設置背景圖片
config.background = {
  {
    source = { File = 'C:/Users/shuhi/.config/wezterm/Desk.jpg' },  -- 替換為你的圖片路徑
    hsb = { brightness = 0.3 },  -- 調整亮度以提高對比度
    opacity = 0.3,  -- 圖片透明度
  },
  {
    source = { Color = 'rgba(235, 255, 255, 0.3)' },  -- 添加半透明黑色遮罩，增強模糊效果
    height = '100%',
    width = '100%',
  },
}

-- 可選：設置字體和主題
config.font_size = 12  -- 字體大小，根據需要調整
config.colors = {
  foreground = '#000000',  -- 黑色文字，與淡白背景搭配
  background = 'rgba(220, 220, 230, 0.6)',  -- 與背景一致
  cursor_bg = '#000000',  -- 光標背景色
  cursor_fg = '#FFFFFF',  -- 光標文字色
  cursor_border = '#000000',  -- 光標邊框色
  selection_fg = '#FFFFFF',  -- 選中文本的前景色
  selection_bg = 'rgba(255, 255, 255, 0.4)',  -- 選中文本的背景色
}


-- 可選：移除窗口裝飾以獲得沉浸式體驗
config.window_decorations = 'RESIZE'  -- 僅保留調整窗口大小功能，去掉標題欄

-- 返回配置表
return config