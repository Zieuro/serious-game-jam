EZ-Theme is a tool meant to quickly and simply modify themes. 

How to use:
1. Enable the plugin in the Project Settings > Plugins window
2. The EZ-Theme window will be docked on the right panel (where the inspector and signal windows normally are)
3. Select a theme to modify or click "New" to create a copy of the default themes
4. Select a font file
5. Enter a font size
6. Pick a color to apply to the primary control nodes (buttons, toggles, bars, entry boxes, ect.)
7. Pick a color to apply to the secondary control nodes (panels, background colors)
8. Click save to save the changes

Modifying:
- Altering the color applications:
    - At the top of "EZ - Theme_Dock.gd" there are constants for different style box types. Modifying STYLE_COLOR_PRIMARY_BASE, STYLE_COLOR_SECONDARY_BASE, or STYLE_COLOR_TERTIARY_BASE will change what colors are applied. Look at the function "_on_PrimaryColor_changed" to understand how some colors are applied even though they aren't specifically listed.
    By default the constants are:
        const STYLE_COLOR_PRIMARY_TRUMP_BASE : String = "normal"
        const STYLE_COLOR_PRIMARY_TAB_BASE : String = "tab_selected"
        const STYLE_COLOR_SECONDARY_TAB_BASE : String = "tab"
        const STYLE_PROPERTY_PANEL : String = "panel"
        const STYLE_COLOR_PRIMARY_BASE = ["normal", "fill", "slider", "grabber", "tab_selected", "separator", "selected"]
        const STYLE_COLOR_SECONDARY_BASE = ["scroll", "panel", "grabber_area", "split_bar_background", "background"]
        const STYLE_COLOR_TERTIARY_BASE = []

- There is a tertiary color picker that is disabled in "EZ - Theme.tscn". You can enable that and add to the const to modify further.

Contact:
- If you find any bugs, feel free to send me a message via: https://inanimateink.com/

Support:
- Check out my steam game "We Are Square": https://store.steampowered.com/app/3316390/We_Are_Square/
- Ko-fi: https://ko-fi.com/inanimateink