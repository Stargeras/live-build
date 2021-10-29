#!/bin/bash

# Favorites and panel
favorites="chromium.desktop firefox.desktop code-oss.desktop org.gnome.gedit.desktop nemo.desktop org.gnome.Terminal.desktop cinnamon-settings.desktop"
panel="chromium.desktop nemo.desktop org.gnome.Terminal.desktop"
panelfile="${HOME}/.cinnamon/configs/grouped-window-list@cinnamon.org/2.json"
# DCONF
dconfstring=""; for item in ${favorites}; do dconfstring+="'${item}', "; done
gsettings set org.cinnamon favorite-apps "[${dconfstring::-2}]"
# Panel
array=""; for item in ${panel}; do array+="\"${item}\", "; done; array="${array::-2}"
check=$(cat ${panelfile} | jq '."pinned-apps".value' -c)
while [[ "${check}" != "$(echo [${array}] | tr -d '[:space:]')" ]]; do
  return=$(jq ".\"pinned-apps\".value = [${array}]" ${panelfile})
  echo ${return} | jq > ${panelfile}
  check=$(cat ${panelfile} | jq '."pinned-apps".value' -c)
done

#jq '."pinned-apps".value[."pinned-apps".value| length] += "firefox.desktop"' ${panelfile}

gsettings set org.cinnamon.desktop.background picture-uri 'file:///usr/share/backgrounds/archlinux/mountain.jpg'
gsettings set org.nemo.window-state geometry '1175x684+376+115'
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.cinnamon.desktop.interface clock-use-24h false
gsettings set org.cinnamon.desktop.interface clock-show-date true
#/usr/share/cinnamon/applets/grouped-window-list@cinnamon.org

# Terminal
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ default-size-rows 35
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ default-size-columns 140
# Brighten washed out colors
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/bold-is-bright 'true'
# Make background a bit darker
#dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/use-theme-colors 'false'
#dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/background-color "'rgb(18,18,18)'"
# Solarized palette
#dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/palette "['rgb(7,54,66)', 'rgb(220,50,47)', 'rgb(133,153,0)', 'rgb(181,137,0)', 'rgb(38,139,210)', 'rgb(211,54,130)', 'rgb(42,161,152)', 'rgb(238,232,213)', 'rgb(0,43,54)', 'rgb(203,75,22)', 'rgb(88,110,117)', 'rgb(101,123,131)', 'rgb(131,148,150)', 'rgb(108,113,196)', 'rgb(147,161,161)', 'rgb(253,246,227)']"

# Theming
gsettings set org.cinnamon.desktop.wm.preferences theme 'Orchis-light'
gsettings set org.cinnamon.desktop.interface icon-theme 'Tela-circle'
gsettings set org.cinnamon.desktop.interface gtk-theme 'Orchis-light'
gsettings set org.cinnamon.theme name 'Orchis-light'
gsettings set org.cinnamon.desktop.interface cursor-theme 'Breeze_Hacked'
gsettings set org.gnome.gedit.preferences.editor scheme 'oblivion'
gsettings set org.gnome.Terminal.Legacy.Settings theme-variant dark

#Dark
#gsettings set org.cinnamon.desktop.wm.preferences theme 'Orchis-dark'
#gsettings set org.cinnamon.desktop.interface icon-theme 'Tela-circle-dark'
#gsettings set org.cinnamon.desktop.interface gtk-theme 'Orchis-dark'
#gsettings set org.cinnamon.theme name 'Orchis-dark'

# Fonts
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font 'Roboto 10'
gsettings set org.nemo.desktop font 'Roboto 10'
gsettings set org.cinnamon.desktop.interface font-name 'Roboto 10'
gsettings set org.gnome.desktop.interface document-font-name 'Roboto 11'
dconf write /org/gnome/desktop/interface/monospace-font-name "'Liberation Mono 11'"

# Default fonts
#gsettings set org.cinnamon.desktop.wm.preferences titlebar-font 'Sans Bold 10'
#gsettings set org.nemo.desktop font 'Noto Sans 10'
#gsettings set org.cinnamon.desktop.interface font-name 'Sans 9'
#gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 11'
