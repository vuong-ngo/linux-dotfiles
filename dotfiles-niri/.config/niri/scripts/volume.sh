#!/usr/bin/env bash

# ============================================================
# Script: System Volume & Microphone Control
# Description: Adjusts audio sink/source volume via wpctl with OSD notifications
# ============================================================

show_help() {
  cat <<EOF
Usage: $(basename "$0") <up|down|mute|mic> [OPTION]

Description:
  Controls WirePlumber audio sink/source volume and mute states.

Commands:
  up            Increase volume by 5%
  down          Decrease volume by 5%
  mute          Toggle speaker mute
  mic           Toggle microphone mute

Options:
  -h, --help    Show this help message and exit

Examples:
  $(basename "$0") up        # Volume +5%
  $(basename "$0") down      # Volume -5%
  $(basename "$0") mute      # Mute speaker
  $(basename "$0") mic       # Mute microphone
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || -z "${1:-}" ]]; then
  show_help
  exit 0
fi

case "$1" in
up)
  wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
  ;;
down)
  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
  ;;
mute)
  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  ;;
mic)
  wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
  ;;
*)
  echo "Invalid command: $1"
  show_help
  exit 1
  ;;
esac

VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print int($2 * 100)}')
IS_MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep -o "MUTED")
IS_MIC_MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -o "MUTED")

if [[ "$1" == "mic" ]]; then
  if [ -z "$IS_MIC_MUTED" ]; then
    notify-send -a "Audio" -t 1200 \
      -h string:x-canonical-private-synchronous:audio-mic \
      -i microphone-sensitivity-high "Microphone" "Unmuted"
  else
    notify-send -a "Audio" -t 1200 \
      -h string:x-canonical-private-synchronous:audio-mic \
      -i microphone-sensitivity-muted "Microphone" "Muted"
  fi
else
  if [ -n "$IS_MUTED" ]; then
    notify-send -a "Audio" -t 1200 \
      -h string:x-canonical-private-synchronous:audio-volume \
      -h int:value:0 \
      -i audio-volume-muted "Volume" "Muted"
  else
    ICON="audio-volume-high"
    if [ "$VOLUME" -le 30 ]; then
      ICON="audio-volume-low"
    elif [ "$VOLUME" -le 70 ]; then
      ICON="audio-volume-medium"
    fi
    notify-send -a "Audio" -t 1200 \
      -h string:x-canonical-private-synchronous:audio-volume \
      -h int:value:"$VOLUME" \
      -i "$ICON" "Volume" "${VOLUME}%"
  fi
fi
