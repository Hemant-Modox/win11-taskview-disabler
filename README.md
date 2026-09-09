# Win11 Task View Toggle

A single batch script to fully **enable or disable Windows 11 Task View** ("Desktop View"), including several less-obvious triggers that Windows' own Settings app doesn't fully cover — touchpad gestures, Xbox Game Bar controller shortcuts, and USB power-management quirks that can cause Task View to pop up unexpectedly.

Built to work around a Windows 11 bug where Task View re-enables itself or gets triggered by unrelated hardware events even after being turned off in Settings.

## Features

The tool presents a simple menu with two options: **Disable** and **Enable/Restore**. Each one is fully reversible.

What gets toggled:

- Task View button on the taskbar (direct setting + Group Policy, per-user and machine-wide)
- Virtual desktop switch animation
- "Meet Now" taskbar flyout
- Widgets policy
- 3-finger and 4-finger touchpad swipe gestures
- 3-finger and 4-finger touchpad tap gestures
- Master touch-gesture switch (also affects touchscreen edge-swipe gestures)
- "Open Xbox Game Bar using this button on a controller" (fixes Task View / Game Bar being triggered by a controller's Guide/Home/Power button)
- Xbox Game Bar / GameDVR (per-user and Group Policy)
- USB Selective Suspend (reduces phantom input from USB devices powering on/off)
- Fast Startup (prevents stale USB driver state from misfiring on boot)

## Requirements

- Windows 11
- Administrator privileges (the script checks for this and will refuse to run without it)

## Usage

1. Download `TaskView-Toggle-Tool.bat`.
2. Right-click the file and choose **Run as administrator**.
3. Choose an option from the menu:
   - `1` — Disable Task View and related triggers
   - `2` — Enable / restore everything to Windows defaults
   - `3` — Exit
4. **Sign out and back in, or reboot**, for all changes to take full effect.
   - Touchpad gesture changes are cached at login and may not apply live.
   - The Fast Startup change specifically requires a **full restart** (sign-out alone is not enough).

## What this does NOT cover

- **Win+Tab keyboard shortcut** — there is no safe way to disable this via a plain registry key without remapping the Tab or Windows key, which would break other shortcuts. If you need this too, consider remapping it with [Microsoft PowerToys Keyboard Manager](https://learn.microsoft.com/windows/powertoys/keyboard-manager) instead.
- **Third-party/manufacturer-specific gesture software** (e.g. Synaptics or Elan touchpad drivers, custom controller software) may have their own settings that override Windows defaults. If gestures still trigger Task View after running this tool, check the manufacturer's control panel as well.
- **Genuine phantom keystrokes from faulty USB hardware/drivers** — the USB Selective Suspend and Fast Startup tweaks address common root causes, but if a specific USB receiver is misbehaving at the driver level, updating its driver/firmware is the real fix.

## ⚠️ Disclaimer

This script modifies the Windows Registry and system power settings, including some machine-wide (`HKEY_LOCAL_MACHINE`) and Group Policy keys. While every change made is reversible using the "Enable/Restore" option in the same script:

- **Create a System Restore point before running it**, just in case:
  ```
  Start → type "Create a restore point" → System Protection tab → Create
  ```
- Use at your own risk. Test in a non-critical environment first if you're unsure.
- This is not an official Microsoft tool and is not affiliated with or endorsed by Microsoft.

## License

Released under the [MIT License](LICENSE).

## Contributing

Found another trigger for Task View that isn't covered here? Pull requests and issues are welcome.
