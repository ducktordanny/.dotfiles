local wezterm = require("wezterm")

local config = wezterm.config_builder()

local dimmer = { brightness = 0.025 }
config.background = {
	{
		source = { File = wezterm.home_dir .. "/.config/.dotfiles/assets/cat-gang.jpeg" },
		repeat_x = "NoRepeat",
		repeat_y = "NoRepeat",
		hsb = dimmer,
		vertical_align = "Middle",
		horizontal_align = "Center",
	},
}
local border_color = "#3f4f3f"
config.window_frame = {
	border_left_width = "0.5cell",
	border_right_width = "0.5cell",
	border_bottom_height = "0.25cell",
	border_top_height = "0.25cell",
	border_left_color = border_color,
	border_right_color = border_color,
	border_bottom_color = border_color,
	border_top_color = border_color,
}
local cursor_color = "#5fd700"
config.colors = {
	cursor_bg = cursor_color,
	cursor_fg = "black",
	cursor_border = cursor_color,
}

config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.font_size = 20

config.keys = {
	-- NOTE: For some reason the default zoom is set  to `SUPER + =`
	{ key = "+", mods = "SUPER", action = wezterm.action.IncreaseFontSize },
}
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

return config
