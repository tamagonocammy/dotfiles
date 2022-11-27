
#!/bin/bash

# Send notification with album art when ncmpcpp plays a new song
# execute_on_song_change must be set in ncmpcpp config

music_dir="$HOME/Music"
previewdir="$HOME/.ncmpcpp/previews"
filename="$(mpc --format "$music_dir"/%file% current)"
previewname="$previewdir/$(mpc --format %album% current | base64).png"

[ -e "$previewname" ] || ffmpeg -y -i "$filename" -an -vf scale=128:128 "$previewname" > /dev/null 2>&1


notify-send -r 27072 "$(mpc --format '%title%' current)" "$(mpc --format '%artist% - %album%' current)" -i "$previewname"
