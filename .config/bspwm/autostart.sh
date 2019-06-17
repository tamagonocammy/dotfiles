##enable pulseaudio. Not needed if you use dex.
/usr/bin/start-pulseaudio-x11 && sleep 2s && pa-applet
##Load appearance settings
xsetroot -cursor_name left_ptr &
export GTK2_RC_FILES="$HOME/.gtkrc-2.0" &
xrdb merge .Xresources &
#xfsettingsd &
##Wallpaper. Nitrogen just draws wallpaper, 
##while xfdesktop can also give applications menu and icons on desktop.
##It uses a lot more resources however. It you enable it you may want to 
##adjust ~/scripts/MouseLaunch to use xfdesktops app menu.
nitrogen --restore &
#xfdesktop -D &
##compositing. Required for shadows, transparency and stuff. 
##Reduces flicker. Disabling saves resources.
compton -b &
##hides mouse when you are not using it
#unclutter &
##enable local fonts in .fonts directory
xset +fp /usr/share/fonts/local &
xset +fp /usr/share/fonts/misc &
xset +fp ~/.fonts &
xset fp rehash &
fc-cache -fv &
##autostart desktop files, for example the postinstall script. 
##Might cause problems if you have multiple desktop enviroments installed.
##Dex is not installed by default.
#sleep 1s && dex -a &
##Policy kit.
#lxpolkit &
##Daemon mode for filemanager makes mounting volumes easier
thunar --daemon &
#spacefm -d &
#pcmanfm -d &
##powersaving options
xset s off &
xset s noblank &
xset s noexpose &
xset c on &
xset -dpms &
xbacklight -set 15 &
##Panel. The default is lemonbar script. Xfce4-panel can be more 
##easily configurable if you prefer that. Not installed by default
#xfce4-panel -d
polybar burs &
##Light system tray to use with lemonbar. Disable if you dont need it. 
##Edit ~/.stalonetrayrc if it is in wrong place.
#sleep 2s && stalonetray --dockapp-mode simple &
mpDris2 &
