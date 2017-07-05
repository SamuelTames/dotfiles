xrdb ~/.Xresources

#xrandr --output DP-1 --rotate left

~/.fehbg

# Input configuration
xset r rate 250 60
setxkbmap -layout us -option ctrl:nocaps
xinput set-prop "SynPS/2 Synaptics TouchPad" "Device Enabled" 0

# Clipboard conistency
autocutsel -fork
autpcutsel -selection PRIMARY -fork

redshift -t 6500:2600 -l 47.6062:-122.33201 &

dunst &

compton -cb
sxhkd &
exec bspwm
