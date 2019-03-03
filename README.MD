
<h1 align="center">Delicious greeter theme<br>for the SDDM display manager</h1>
<p align="center">Put your collection of DEs and WMs on display.</p>
<p align="center"><img src="https://github.com/stuomas/stuff/blob/master/screencap.gif"></p>

## Features
Delicious wants to showcase the available sessions instead of available users as in most cases there is only one user, although the user can of course still be changed in the menu in the footer panel. Delicious is somewhat customizable to your preferences, for example the background can be either a still image or a video and the color of the icons or the whole icon theme can be changed in the configuration file. See [Configuration](#configuration) for more details.

## Installation
1. `git clone https://github.com/stuomas/delicious-sddm-theme.git`

2. `cd delicious-sddm-theme`

3. `./install.sh`

The install script moves the delicious-sddm-theme folder to `/usr/share/sddm/themes/delicious` and modifies `/etc/sddm.conf` to set this theme as the Current theme. If `/etc/sddm.conf` file does not exists, the user will be prompted to automatically create one based on currently active settings. The user will be prompted to disable SDDM's virtual keyboard if it is enabled, because it is not well supported by the theme, and it is for some reason enabled in SDDM by default. After this, the script will suggest to test the theme. You can also manually move the files to the correct location. If you use KDE Plasma, you can set the new theme in System Settings → Startup and Shutdown → Login Screen (SDDM).

## Testing

After installation, you can and should test the theme with

`sddm-greeter --test-mode --theme /usr/share/sddm/themes/delicious`

It is important to make sure it works on your system, so you are able to login. The installation script will prompt the user to test right after installation. Missing or mismatchig dependencies might cause it to malfunction, and render you unable to login. If that happens, switch to another TTY and modify `/etc/sddm.conf` from there.

## Configuration

Configuration file `theme.conf` contains some settings for easy modification. A sample configuration is commeted below. Do not include the comments in the actual configuration file!
```
[General]
background=space.mp4 //background image or video located in the background folder
fontfamily=Noto Sans Display Light //font
fontcolor=#DD000000 //font color in #AARRBBGG or #RRGGBB format
fontscale=1.1 //multiplier for font size
sessions="awesome,bspwm,dwm,fluxbox,gnome,i3,plasma,windows" //available sessions with icons
icontheme=delicate //icon theme, add your own by making folder inside icons/
iconformat=svg //format of your icons
iconoverlay=#DD000000 //overlay color for icons
iconglow=enable //glow around selected session and text
glowcolor=#FFFF0000 //color of glow
```
#### Adding an icon for missing session
Sessions are looked up from their .desktop files in `/usr/share/xsessions` and `/usr/share/wayland-sessions`, and the session name should be listed in the `sessions=` entry of `theme.conf` and match the icon filename. For example, if you have a session with `Name=xfce` in `/usr/share/xsessions/xfce.desktop`, you need to add `xfce` to the `sessions=`list, and an icon called `xfce.svg` in `/icons/delicate/`. The displayed session name comes from the `Name=` entry in the .desktop file.

#### Hide a session from the list
If you want that a specific session won't appear in the list, for example some debug sessions, you can add in the corresponding .desktop file the entry `NoDisplay=true` instead of deleting the whole file.

#### Making your own icon theme
If you want to make a icon theme called `thebesticontheme`, make a folder `/icons/thebesticontheme` and add an icon for all your sessions. Then change the `icontheme=` entry in `theme.conf`. If you use other file format than svg for the icons, change also the `iconformat=` entry. If you plan to use the color overlay option for your icon set, it is suggested to use matching color scheme for all icons.

## Acknowledgements
The theme uses some of the action icons from the [breeze-icons](https://github.com/KDE/breeze-icons), and some logic and inspiration from the [sddm-deepin](https://github.com/Match-Yang/sddm-deepin) theme.
Video used in the screen capture is from [pixabay/tommyvideo](https://pixabay.com/videos/space-galaxy-abstract-lights-5200/)
