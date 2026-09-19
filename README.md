# Phone Clone Audio Out (DARTS)

Automated setup and launcher script to mirror an Android device to Windows using [scrcpy](https://github.com/Genymobile/scrcpy) with low-latency display, full-screen playback, and redirected audio output (ideal for Granboard/dart setups, TV casting, and external displays).

---

## Overview

Running Android apps on a TV or secondary display often requires manual ADB setup, downloading archives, and typing command-line flags. This repository provides an all-in-one PowerShell installer and launcher that:

1. **Detects or Installs `scrcpy`**: Checks if `scrcpy.exe` exists in `C:\scrcpy`. If missing, queries GitHub's API, downloads the latest official 64-bit Windows release, and installs it.
2. **Downloads Custom Icon**: Grabs `GranPi.ico` from this repository and stages it in `C:\scrcpy`.
3. **Generates Launcher Script**: Creates `launch_darts.cmd` preconfigured with playback audio routing and fullscreen flags.
4. **Creates Desktop Shortcut**: Drops a `DARTS` shortcut directly onto your Windows Desktop with the custom `GranPi` icon.
5. **Auto-Launches**: Immediately starts mirroring your device.

---

## Scrcpy Parameters Used

The generated launcher executes:
```cmd
scrcpy.exe --audio-source=playback --stay-awake -f
