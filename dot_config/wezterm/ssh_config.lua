local wezterm = require("wezterm")
local config_builder = require("wezterm").config_builder

local config = config_builder()

-- This configuration file generates wezterm ssh configs from the hosts .ssh/config file.

local ssh_domains = {}

for host, config in pairs(wezterm.enumerate_ssh_hosts({"~/.ssh/config"})) do
  table.insert(ssh_domains, {
    -- the name can be anything you want; we're just using the hostname
    name = host,
    -- remote_address must be set to `host` for the ssh config to apply to it
    remote_address = host,

    -- if you don't have wezterm's mux server installed on the remote
    -- host, you may wish to set multiplexing = "None" to use a direct
    -- ssh connection that supports multiple panes/tabs which will close
    -- when the connection is dropped.

    -- Wezterm used by default
    -- multiplexing = "WezTerm",

    -- if you know that the remote host has a posix/unix environment,
    -- setting assume_shell = "Posix" will result in new panes respecting
    -- the remote current directory when multiplexing = "None".
    assume_shell = 'Posix',
  })
end


return {
  ssh_domains = ssh_domains,
}
