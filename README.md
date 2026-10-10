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
6. **Smart Execution**: Validates existing installations before running—if everything is already set up, it launches immediately without re-downloading or overwriting files.

---

## Scrcpy Parameters Used

The generated launcher executes:
```cmd
scrcpy.exe --audio-source=playback --stay-awake -f

```

* `--audio-source=playback`: Captures standard device media audio and streams it to the host Windows system.
* `--stay-awake`: Prevents the phone display from sleeping while plugged in.
* `-f`: Launches directly into fullscreen mode (`Alt + F` toggles windowed/fullscreen).

---

## Audio & Microphone Behavior (Important for Online Play)

Because `--audio-source=playback` specifically targets Android media streams, your audio divides naturally between your TV/laptop and your phone:

* **Game Audio (Hits, Caller, Sound Effects)**: Routed through your PC/laptop. If your laptop is connected to an external screen or TV via HDMI, all in-game dart sounds and sound effects play directly through the **TV / receiver speakers**.
* **Opponent Player Voice Audio**: In-app voice chat / call audio remains routed through the **phone's speaker**.
* **Microphone Input**: Your **phone's microphone remains the active microphone** for talking to opponents. You do not need to configure an external PC mic.

*(Note: If no HDMI cord is connected, game audio simply plays through your laptop's built-in speakers.)*

---

### Prerequisites Setup Guide

#### 1. Verify Windows 10 / 11 (64-bit)
1. Press `Win + I` on your keyboard to open Windows Settings.
2. Navigate to **System** > **About**.
3. Look under the **Device specifications** section. 
4. Confirm that **System type** says "64-bit operating system".

#### 2. Enable Developer Options (Android)
1. Open the **Settings** app on your Android phone.
2. Scroll down and tap **About phone** (on some devices, you may then need to tap **Software information**).
3. Find the **Build number** entry.
4. Tap **Build number** 7 times in rapid succession. 
5. Enter your PIN or pattern if prompted. You will see a toast message saying, "You are now a developer!"

#### 3. Enable USB Debugging (Android)
1. Go back to the main **Settings** menu.
2. Navigate to **System** > **Developer options**. *(Note: On some phones like Samsung, Developer options is at the very bottom of the main settings list).*
3. Scroll down to the **Debugging** section.
4. Toggle on **USB debugging**.
5. Tap **OK** on the warning prompt to confirm.

#### 4. Connect and Authorize
1. Connect your Android phone to your PC using a high-quality data USB cable.
2. Unlock your phone screen.
3. A prompt will appear on your phone asking to **Allow USB debugging?** (If it doesn't appear immediately, try opening a command prompt on your PC and running `adb devices`).
4. Check the box for **Always allow from this computer**.
5. Tap **Allow**.



---

## Quick Start / Installation

### Option 1: Run via One-Liner (PowerShell)

Open PowerShell and run:

```powershell
irm [https://raw.githubusercontent.com/kegerraider/phone-clone-audio-out/main/setup_darts.ps1](https://raw.githubusercontent.com/kegerraider/phone-clone-audio-out/main/setup_darts.ps1) | iex

```

### Option 2: Manual Run

1. Clone or download this repository:
```bash
git clone [https://github.com/kegerraider/phone-clone-audio-out.git](https://github.com/kegerraider/phone-clone-audio-out.git)

```


2. Open PowerShell in the project directory and run:
```powershell
.\setup_darts.ps1

```


3. Once complete, double-click the **DARTS** icon on your Desktop anytime your phone is connected to start playing.

---

## Repository Structure

```text
phone-clone-audio-out/
├── GranPi.ico        # Custom shortcut icon
├── setup_darts.ps1   # Idempotent installer & shortcut generator
└── README.md         # Documentation

```

---

## Useful Scrcpy Shortcuts

| Shortcut | Action |
| --- | --- |
| `Alt + F` | Toggle Fullscreen |
| `Alt + O` | Turn phone screen off (keeps game running on TV) |
| `Alt + Shift + O` | Turn phone screen back on |
| `Alt + P` | Power button emulation |
| `Alt + Up / Down` | Adjust volume |

```

```
