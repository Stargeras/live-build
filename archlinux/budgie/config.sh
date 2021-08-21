gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.desktop.interface clock-format '12h'
gsettings set org.gnome.gedit.preferences.editor scheme 'oblivion'
#gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/gnome/Road.jpg'
gsettings set org.gnome.desktop.interface gtk-theme 'Plata-Noir'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
gsettings set org.gnome.desktop.interface cursor-theme 'breeze_cursors'
#gsettings set org.gnome.desktop.interface monospace-font-name 'Monospace 11'
gsettings set org.gnome.nautilus.window-state initial-size '(1050, 560)'
#Terminal size
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ default-size-rows 27
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ default-size-columns 122
#PANEL=\$(dconf list /com/solus-project/budgie-panel/panels/ |cut -c 2-37)
#LAUNCHERS=\$(dconf list /com/solus-project/budgie-panel/instance/icon-tasklist/ |cut -c 2-37)
#dconf write /com/solus-project/budgie-panel/panels/{\$PANEL}/location "'bottom'"
#dconf write /com/solus-project/budgie-panel/panels/{\$PANEL}/size "45"
#dconf write /com/solus-project/budgie-panel/instance/icon-tasklist/{\$LAUNCHERS}/pinned-launchers "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']"
dconf load /com/solus-project/budgie-panel/ < ~/Documents/panel.dconf
nohup budgie-panel --replace&
rm -f ~/nohup.out