local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action
local mux = wezterm.mux

-- Max FPS
config.max_fps = 144


-- Unix domain
config.unix_domains = {
  {
    name = 'unix',
  },
}

-- Load the unix domain on startup
-- config.default_gui_startup_args = { 'connect', 'unix' }

-- Load SSH settings
local ssh_domains = require("ssh_config")

-- Font settings
-- TODO: Add backup/fallback fonts
config.font = wezterm.font 'FiraCode Nerd Font Mono'

-- Cursor style
config.default_cursor_style = 'SteadyBar'

-- Theme settings

-- Everblush does not support Wezterm select text.
-- This is currently installed in the /colors/ directory of wizterm config.
-- config.color_scheme = 'Everblush'

-- Catppuccin & varients support Wezterm select text. https://github.com/catppuccin/wezterm
config.color_scheme = "Catppuccin Mocha"

-- Frappe is okay, it's lighter than Mocha, which I think I do not perfer.
-- config.color_scheme = "Catppuccin Frappe

-- Rose pine moon just turns the selected text white which isn't great, also much brighter than Mocha.
-- config.color_scheme = "rose-pine-moon"

-- Ayu Mirage looks interesting, a leading canidate.
config.color_scheme = 'Ayu Mirage'

-- Ayu Mirage Gogh variant, not that different in my config.
-- config.color_scheme = 'Ayu Mirage (Gogh)'

-- Window settings
config.window_decorations = "TITLE|RESIZE"

-- Tab settings
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true
-- config.window_frame = {
  -- The font used in the tab bar.
  -- Roboto Bold is the default; this font is bundled
  -- with wezterm.
  -- Whatever font is selected here, it will have the
  -- main font setting appended to it to pick up any
  -- fallback fonts you may have used there.
--   font = wezterm.font { family = 'Roboto', weight = 'Bold' },
--   -- font = wezterm.font 'FiraCode Nerd Font',
--   -- The size of the font in the tab bar.
--   -- Default to 10.0 on Windows but 12.0 on other systems
--   font_size = 12.0,

--   -- The overall background color of the tab bar when
--   -- the window is focused
--   -- active_titlebar_bg = '#232a2d',
--   active_titlebar_bg = '#67b0e8',
--   -- The overall background color of the tab bar when
--   -- the window is not focused
--   inactive_titlebar_bg = '#141b1e',
-- }

config.colors = {
  tab_bar = {
    -- The color of the inactive tab bar edge/divider
    inactive_tab_edge = '#575757',
  },
}

-- Line height settings
config.line_height = 1

-- Leader config
config.leader = {
  key = 'e',
  mods = 'ALT',
  timeout_milliseconds = 2000
}

-- Key binds
config.keys = {
  -- Helix motions
  -- CTRL + (h,j,k,l) to move between panes
  {
    key = 'h',
    mods = 'CTRL',
    action =  act({ ActivatePaneDirection = "Left" })
  },
  {
    key = 'j',
    mods = 'CTRL',
    action =  act({ ActivatePaneDirection = "Down" })
  },
  {
    key = 'k',
    mods = 'CTRL',
    action =  act({ ActivatePaneDirection = "Up" })
  },
  {
    key = 'l',
    mods = 'CTRL',
    action =  act({ ActivatePaneDirection = "Right" })
  },
  -- Attach to muxer
  {
    key = 'a',
    mods = 'LEADER',
    action = act.AttachDomain 'unix',
    -- action = act.AttachDomain('CurrentPaneDomain')
  },
  -- Detach from muxer
  {
    key = 'd',
    mods = 'LEADER',
    action = act.DetachDomain('CurrentPaneDomain'),
  },
  -- Rename session
  {
    key = '$',
    mods = 'LEADER|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter new name for session',
      action = wezterm.action_callback(
        function(window, pane, line)
          if line then
            mux.rename_workspace(
              window:mux_window():get_workspace(),
              line
            )
          end
        end
      ),
    },
  },
  -- Rename tabs
  {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(
        function(window, pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end
      ),
    },
  },
  -- Show list of workspaces
  {
    key = 's',
    mods = 'LEADER',
    action = act.ShowLauncherArgs { flags = 'WORKSPACES' },
  },
  -- Show tab navigator
  {
    key = 'w',
    mods = 'LEADER',
    action = act.ShowTabNavigator,
  },
  -- Show pane selection
  {
    key = 'q',
    mods = 'LEADER',
    action = act.PaneSelect,
  },
  -- Vertical Split
  {
    -- %
    key = '%',
    mods = 'LEADER|SHIFT',
    action = act.SplitPane {
      direction = 'Right',
      size = { Percent = 50 },
    },
  },
  -- Horizontal split
  {
    -- -
    key = '"',
    mods = 'LEADER|SHIFT',
    action = act.SplitPane {
      direction = 'Down',
      size = { Percent = 50 },
    },
  },
  -- Closing pane
  {
    key = 'x',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- Create a new tab
  {
    key = 'c',
    mods = 'LEADER',
    action = wezterm.action.SpawnTab "CurrentPaneDomain"
  },
  {
    key = 'b',
    mods = 'LEADER',
    action = wezterm.action.ActivateTabRelative(-1)
  },
  {
    key = 'n',
    mods = 'LEADER',
    action = wezterm.action.ActivateTabRelative(1)
  },
   -- Swap panes
  {
    -- {
    key = '{',
    mods = 'LEADER|SHIFT',
    action = act.PaneSelect { mode = 'SwapWithActiveKeepFocus' }
  },
  -- Clear screen
  {
    key = 'l',
    mods = "LEADER|CTRL",
    action = act.SendKey { key='l', mods='CTRL'},
  }
}

-- TODO: This isn't working as expected.
-- Map tabs to number keys
-- for i = 1, 9 do
--     -- leader + number to activate that tab
--     table.insert(config.keys, {
--         key = tostring(i),
--         mods = "LEADER",
--         action = wezterm.action.ActivateTab(i),
--     })
-- end

config.scrollback_lines = 5000

return config
