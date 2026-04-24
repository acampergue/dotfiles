-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

config.scrollback_lines = 100000

-- For example, changing the initial geometry for new windows:
-- config.initial_cols = 120
-- config.initial_rows = 28

-- or, changing the font size and color scheme.
-- config.font_size = 10
-- config.color_scheme = 'AdventureTime'

-- config.font = wezterm.font("JetBrainsMono NFM")
config.font = wezterm.font_with_fallback({
  "JetBrainsMono NFM",
  "Symbols Nerd Font Mono",
  "Noto Color Emoji",
})
config.font_size = 13.0

-- Seti is nice and has a green touch I like
config.color_scheme = 'Seti'

-- config.color_scheme = 'Summer Pop (Gogh)'
-- config.color_scheme = 'Shapeshifter (dark) (terminal.sexy)'
-- config.color_scheme = 'Sweet Terminal (Gogh)'
-- config.color_scheme = 'Symfonic'
-- config.color_scheme = 'Abernathy'
-- config.color_scheme = 'Symphonic (Gogh)'
-- config.color_scheme = 'Synth Midnight Terminal Dark (base16)'
-- config.color_scheme = 'synthwave'
-- config.color_scheme = '3024 (base16)'

-- Finally, return the configuration to wezterm:
return config
