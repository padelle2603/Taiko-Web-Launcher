#!/bin/bash

# ==========================================
# 1. DETECT SYSTEM DEFAULT BROWSER
# ==========================================
DEFAULT_DESKTOP=$(xdg-settings get default-web-browser 2>/dev/null)

if [ -n "$DEFAULT_DESKTOP" ]; then
    # Extract executable command from the default .desktop file
    BROWSER_CMD=$(grep -m 1 "^Exec=" /usr/share/applications/"$DEFAULT_DESKTOP" "$HOME/.local/share/applications/"$DEFAULT_DESKTOP 2>/dev/null | cut -d'=' -f2 | awk '{print $1}')
fi

# Fallback if xdg-settings fails or cannot locate the .desktop file
if [ -z "$BROWSER_CMD" ]; then
    if command -v zen-browser &> /dev/null; then BROWSER_CMD="zen-browser"
    elif command -v firefox &> /dev/null; then BROWSER_CMD="firefox"
    elif command -v helium &> /dev/null; then BROWSER_CMD="helium"
    else BROWSER_CMD="xdg-open"
    fi
fi

# ==========================================
# 2. TAIKO VERSION SELECTION
# ==========================================
SELECTION=$(zenity --list --radiolist \
    --title="Taiko Web Launcher" \
    --text="Select the version of Taiko you want to play:" \
    --column="" --column="Version" --column="Description" \
    TRUE "Taiko Asia" "Ready-to-play with extensive built-in song library" \
    FALSE "Taiko App UK" "Great for loading custom songs (.tja)")

case $SELECTION in
    "Taiko Asia")
        URL="https://taiko.asia/en"
        PROFILE_DIR="$HOME/.config/taiko-web"
        ;;
    "Taiko App UK")
        URL="https://taikoapp.uk/"
        PROFILE_DIR="$HOME/.config/taiko-web"
        ;;
    *)
        exit 0
        ;;
esac

mkdir -p "$PROFILE_DIR"

# ==========================================
# 3. LAUNCH DEFAULT BROWSER
# ==========================================
if [ "$BROWSER_CMD" = "xdg-open" ]; then
    $BROWSER_CMD "$URL" &
else
    $BROWSER_CMD --profile "$PROFILE_DIR" --new-window "$URL" &
fi

TARGET_PID=$!

# ==========================================
# 4. AUTOMATIC VOLUME CONTROL
# ==========================================
set_specific_tab_volume() {
    # Retry for 20 seconds until the game tab starts emitting audio
    for i in {1..20}; do
        # Search PipeWire/PulseAudio sink inputs matching our target PID (or its children)
        for SINK_ID in $(pactl list sink-inputs | awk -v pid="$TARGET_PID" '
            /Sink Input #/ { id=$3; gsub("#", "", id) }
            /application.process.id =/ { if ($3 == "\""pid"\"" || $3 == pid) print id }
        '); do
            if [ -n "$SINK_ID" ]; then
                pactl set-sink-input-volume "$SINK_ID" 40%
                exit 0
            fi
        done
        sleep 1
    done
}

set_specific_tab_volume &
