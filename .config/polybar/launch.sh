#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done


# Launch arch_updates script
arch_updates & echo $! > ~/.config/polybar/scripts/arch/arch_updates.pid

# Launch
polybar burs &
echo "Bar launched..."



