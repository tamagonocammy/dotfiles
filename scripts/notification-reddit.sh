#!/bin/sh

URL=""
USERAGENT="polybar-scripts/notification-reddit:v1.0 u/reddituser"

notifications=$(curl -sf --user-agent "juancamilo2000" "https://www.reddit.com/message/unread/.json?feed=2eeca32920188f77c8b5eece218c9553a5f6d221&user=juancamilo_2000" | jq '.["data"]["children"] | length')

if [ -n "$notifications" ] && [ "$notifications" -gt 0 ]; then
    echo "#1 $notifications"
else
    echo "#2"
fi
