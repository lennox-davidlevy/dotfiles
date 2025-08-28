# i3wm Configuration Guidelines for Agents

## Configuration Management
- **Reload config**: `i3-msg reload` or `$mod+Shift+c`
- **Restart i3**: `i3-msg restart` or `$mod+Shift+r`  
- **Validate config**: `i3 -C -c ~/.config/i3/config`

## Style Guidelines
- Use 4-space indentation consistently
- Comment blocks start with `#` followed by space
- Variable names use snake_case with `$` prefix (e.g., `$mod`, `$ws1`)
- Workspace names format: `"number:Name"` (e.g., `"1:Terminal"`)
- Key bindings group related functionality together
- Use meaningful workspace assignments and window rules

## Key Configuration Patterns  
- Modifier key: `$mod` (Mod4/Super key)
- Navigation: hjkl vim-style bindings preferred
- Workspace switching: Alt+number (Mod1+1-0)
- Window movement: $mod+Shift+direction
- External scripts stored in `~/.config/rofi/` and `~/.local/bin/`

## Monitor Setup
- Primary monitor: HDMI-0, Secondary: HDMI-1  
- Workspaces 1-5 on primary, 6-10 on secondary
- Wallpaper management via `feh --bg-fill`

When modifying config, always test with `i3 -C` before applying changes.