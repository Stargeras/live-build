#lookandfeeltool -a org.kde.breezedark.desktop
#sed -i "s#ordering=#ordering=preferred://browser,applications:systemsettings.desktop,applications:org.kde.dolphin.desktop,applications:org.kde.kate.desktop,applications:org.kde.discover.desktop,applications:org.kde.konsole.desktop#g" ~/.config/kactivitymanagerd-statsrc

#default browser
#sed -i "s#BrowserApplication#BrowserApplication=firefox.desktop#g" ~/.config/kdeglobals
kwriteconfig5 --file kdeglobals --group General --key BrowserApplication chromium.desktop

# Favorites mods
favorites="chromium.desktop org.kde.dolphin.desktop org.kde.konsole.desktop org.kde.kate.desktop systemsettings.desktop"
sqlite3 ~/.local/share/kactivitymanagerd/resources/database 'SELECT * FROM ResourceLink;'
sqlite3 ~/.local/share/kactivitymanagerd/resources/database 'DELETE FROM ResourceLink;'
for favorite in ${favorites}; do
  sqlite3 ~/.local/share/kactivitymanagerd/resources/database 'INSERT INTO ResourceLink  VALUES (":global","org.kde.plasma.favorites.applications","applications:'${favorite}'");'
done

kquitapp5 plasmashell
kstart5 plasmashell

# imwheel config
cat > ${HOME}/.imwheelrc << EOF
".*"
None,      Up,   Button4, 3
None,      Down, Button5, 3
Control_L, Up,   Control_L|Button4
Control_L, Down, Control_L|Button5
Shift_L,   Up,   Shift_L|Button4
Shift_L,   Down, Shift_L|Button5
EOF
imwheel -kill

#OLD
#kwriteconfig5 --file plasmarc --group Theme --key name breeze-dark
#kwriteconfig5 --file kdeglobals --group General --key ColorScheme "Breeze Dark"
#kwriteconfig5 --file kdeglobals --group General --key Name breeze-dark
#kwriteconfig5 --file kdeglobals --group KDE --key LookAndFeelPackage org.kde.breezedark.desktop
#kwriteconfig5 --file kdeglobals --group icons --key Theme breeze-dark
#kwriteconfig5 --file gtk-3.0/settings.ini --group Settings --key gtk-theme-name "Breeze Dark"
#kwriteconfig5 --file gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name breeze-dark
#kwriteconfig5 --file gtk-3.0/settings.ini --group Settings --key gtk-application-prefer-dark-theme true
