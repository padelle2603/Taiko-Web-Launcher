## ⚖️ Disclaimer & Legal Notice

* This script is an **independent automation utility** for personal local use.
* It does **not** contain, host, or distribute any proprietary assets, audio files, or code belonging to Bandai Namco Entertainment Inc.
* **Taiko no Tatsujin** is a registered trademark of **Bandai Namco Entertainment Inc.**. The web versions launched by this script (`taiko.asia`, `taikoapp.uk`) are fan-made community projects independent of the official franchise.

---

* **Ubuntu / Debian / Pop!_OS:**
```bash
sudo apt install zenity pulseaudio-utils xdg-utils

```


* **Fedora:**
```bash
sudo dnf install zenity pulseaudio-utils xdg-utils

```



---

## 🚀 Usage

1. **Make the script executable:**
```bash
chmod +x taiko-launcher.sh

```


2. **Run the script:**
```bash
./taiko-launcher.sh

```


3. **Select your version** in the GUI prompt and click **OK**.

---

## 🔧 How It Works

```
┌─────────────────────────┐
│  Detect System Browser  │ ── (xdg-settings / binary search)
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│   Zenity GUI Selector   │ ── Select: Taiko Asia OR Taiko App UK
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│ Launch Browser Profile  │ ── Spawns isolated session at ~/.config/taiko-web
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│ Volume Control Daemon   │ ── Background loop caps PID audio sink to 40% (20s timeout)
└─────────────────────────┘

```
