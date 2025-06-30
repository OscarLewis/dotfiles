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
config.font = wezterm.font 'FiraCode Nerd Font Mono'

-- Cursor style
config.default_cursor_style = 'SteadyBar'

-- Theme settings

-- Everblush does not support Wezterm select text.
-- This is currently installed in the /colors/ directory of wizterm config.
-- config.color_scheme = 'Everblush'
-- Catppuccin & varients support Wezterm select text. https://github.com/catppuccin/wezterm
-- I also like that it themes the tab bar very nicely, however that's not a need.
-- config.color_scheme = "Catppuccin Mocha"
-- Frappe is okay, it's lighter than Mocha, which I think I do not perfer.
-- config.color_scheme = "Catppuccin Frappe
-- Rose pine moon just turns the selected text white which isn't great, also much brighter than Mocha.
-- config.color_scheme = "rose-pine-moon"
-- Ayu Mirage looks nice.
-- It has a nice helix theme, however as you can see it doesn't highlight the config.variable
-- like Catppuccin or the default theme do.
-- config.color_scheme = 'Ayu Mirage'
-- gruvbox_dark_hard is my favorite gruvbox varient.
-- horizon-dark is nice.
-- jetbrains_dark is a classic.
-- onedarker is nice, I like the green, blue, and purple.
-- config.color_scheme = 'onedarker'

-- One half dark is nice and highlights copy mode selections!
config.color_scheme = 'OneHalfDark'

-- Ayu Mirage Gogh variant, not that different in my config.
-- config.color_scheme = 'Ayu Mirage (Gogh)'

-- Command palette should use a white font for visibility.
config.command_palette_fg_color = '#ffffff'

-- Theme overrides.
local jennyOrange = '#ff8811'
config.colors = {
  cursor_border = jennyOrange,
  cursor_bg = jennyOrange,
  tab_bar = {
    -- The active tab is the one that has focus in the window
    active_tab = {
      -- The color of the text for the tab
      fg_color = '#ffffff',
      -- The color of the background area for the tab
      bg_color = '#000000'
    },
    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = { fg_color = '#ffffff', bg_color = '#333333' },
    -- You can configure some alternate styling when the mouse pointer
    -- moves over inactive tabs
    inactive_tab_hover = {
      bg_color = '#1f1f1f',
      fg_color = '#ffffff',
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab_hover`.
    },
    -- The new tab button that let you create new tabs
    new_tab = {
      bg_color = '#333333',
      fg_color = '#ffffff',

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over the new tab button
    new_tab_hover = {
      bg_color = '#1f1f1f',
      fg_color = '#ffffff',
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab_hover`.
    },
  }
}

-- Window settings
config.window_decorations = "TITLE|RESIZE"
-- config.window_decorations = "RESIZE"

-- Tab settings
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true

-- Line height settings
config.line_height = 1

-- Leader config
config.leader = {
  key = 'e',
  mods = 'ALT',
  timeout_milliseconds = 2000
}

-- Display current domain and the date in right_status
wezterm.on('update-status', function(window, pane)
  local domain = pane:get_domain_name()
  local print_text = domain or ""
  local month_day = wezterm.strftime '%_m.%d'
  local color_scheme = window:effective_config().resolved_palette
  local workspace_title = window:active_workspace()
  -- local print_workspace = workspace or "default"

  -- Currently title is not being used
  -- local title = pane:get_title()
  local right_status_text = utf8.char(0xf52e) .. ' ' .. workspace_title ..
      ' ' .. utf8.char(0xebc8) .. ' ' .. print_text .. ' ' .. utf8.char(0xf455) .. month_day .. ' '
  window:set_right_status(wezterm.format({
    { Foreground = { Color = "#61afef" } },
    -- 0xebc8 is the tmux icon and 0xf455 is the calendar.
    -- Extra spaces are added to make the appearance more uniform.
    { Text = right_status_text },

  }))
end)



-- local function toggle_zoom_and_rename(win, pane)
--   -- Define the indicator you want to use for a zoomed pane.
--   -- Using a space at the beginning prevents it from looking cramped.
--   local zoom_indicator = ' 🔭'
--   wezterm.log_info 'zoom function activated.'
--   -- Get the Tab object for the active tab.
--   local active_tab = win:active_tab()
--   if not active_tab then
--     return
--   end

--   -- Get the current title of the active tab.
--   local current_title = active_tab:get_title()
--   if current_title == "" then
--     current_title = "None"
--   wezterm.log_info(string.format('active tab is: %s', current_title))

--   -- First, perform the action to toggle the zoom state.
--   -- We do this first to know what the *new* state is.
--   win:perform_action(wezterm.action.TogglePaneZoomState, pane)

--   for _, info in ipairs(pane:panes_with_info()) do
--       wezterm.log_info(string.format("Pane is zoomed: %s", info.is_zoomed))
--   end

--   -- After toggling, we check if the pane is now zoomed.
--   -- The is_zoomed() method returns true if the pane is zoomed.
--   for _, info in ipairs(active_tab:panes_with_info()) do
--       wezterm.log_info(string.format("Pane is zoomed: %s", info.is_zoomed))
--       if info.is_zoomed then
--       pane_title = info.pane:get_title()
--       wezterm.log_info(string.format("Pane title is '%s'.", pane_title))
--       wezterm.log_info 'pane was zoomed.'
--       -- If the pane is now zoomed, we want to add the indicator.
--       -- We'll also check to make sure we don't add it multiple times
--       -- if the title somehow already has it.
--       -- if not current_title:find(zoom_indicator, 1, true) then
--       --   active_tab:set_title(current_title .. zoom_indicator)
--       -- end
--     end
--   end
--   else
--     -- If the pane is not zoomed, we want to remove the indicator.
--     -- string.gsub finds and replaces the indicator with an empty string.
--     local new_title = current_title:gsub(zoom_indicator, '')
--     active_tab:set_title(new_title)
--   end
-- end


-- Key binds
config.keys = {
  -- Helix (neovim is spooky 😱) motions to move between panes
  -- CTRL + (h,j,k,l) to move between panes
  {
    key = 'h',
    mods = 'CTRL',
    action = act({ ActivatePaneDirection = "Left" })
  },
  {
    key = 'j',
    mods = 'CTRL',
    action = act({ ActivatePaneDirection = "Down" })
  },
  {
    key = 'k',
    mods = 'CTRL',
    action = act({ ActivatePaneDirection = "Up" })
  },
  {
    key = 'l',
    mods = 'CTRL',
    action = act({ ActivatePaneDirection = "Right" })
  },
  -- Helix motions to adjust panel size
  {
    key = 'h',
    mods = 'ALT',
    action = act.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'j',
    mods = 'ALT',
    action = act.AdjustPaneSize { "Down", 5 },
  },
  {
    key = 'k',
    mods = 'ALT',
    action = act.AdjustPaneSize { "Up", 5 },
  },
  {
    key = 'l',
    mods = 'ALT',
    action = act.AdjustPaneSize { "Right", 5 },
  },
  -- Zoom on pane
  {
    key = 'z',
    mods = 'LEADER',
    action = act.TogglePaneZoomState
  },
  -- Zoom on pane and indicate on tab bar
  -- {
  --   key = 'z',
  --   mods = 'LEADER',
  --   action = wezterm.action_callback(function(win, pane)
  --     toggle_zoom_and_rename(win, pane)
  --    end)
  -- },
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
    action = act.SendKey { key = 'l', mods = 'CTRL' },
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
