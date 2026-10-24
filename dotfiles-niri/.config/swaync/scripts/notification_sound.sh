#!/usr/bin/env bash
# ============================================================
# SwayNC Notification Sound Player
# Plays clean notification sound on receiving alerts
# ============================================================

# Do not play if Do Not Disturb (DND) is active
if [[ "$(swaync-client -D 2>/dev/null)" == "true" ]]; then
    exit 0
fi

# Prevent loops if SwayNC itself sends internal alerts
if [[ "${SWAYNC_APP_NAME:-}" == "swaync" ]]; then
    exit 0
fi

# Determine sound name (handle (null) or empty exported by SwayNC)
sound_name="${SWAYNC_SOUND_NAME:-}"
if [[ -z "$sound_name" || "$sound_name" == "(null)" ]]; then
    sound_name="message"
fi

# Determine sound file fallback
sound_file="${SWAYNC_SOUND_FILE:-}"
if [[ -z "$sound_file" || "$sound_file" == "(null)" || ! -f "$sound_file" ]]; then
    sound_file="/usr/share/sounds/freedesktop/stereo/message.oga"
fi

# Play sound
if command -v canberra-gtk-play &>/dev/null; then
    canberra-gtk-play -i "$sound_name" 2>/dev/null || \
    pw-play "$sound_file" 2>/dev/null || true
elif command -v pw-play &>/dev/null; then
    pw-play "$sound_file" 2>/dev/null || true
fi

exit 0
