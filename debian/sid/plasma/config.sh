#kwriteconfig5 --file plasmarc --group Theme --key name breeze-dark
#kwriteconfig5 --file kdeglobals --group General --key ColorScheme "Breeze Dark"
#kwriteconfig5 --file kdeglobals --group General --key Name breeze-dark
#kwriteconfig5 --file kdeglobals --group KDE --key LookAndFeelPackage org.kde.breezedark.desktop
#kwriteconfig5 --file kdeglobals --group icons --key Theme breeze-dark
#kwriteconfig5 --file gtk-3.0/settings.ini --group Settings --key gtk-theme-name "Breeze Dark"
#kwriteconfig5 --file gtk-3.0/settings.ini --group Settings --key gtk-icon-theme-name breeze-dark
#kwriteconfig5 --file gtk-3.0/settings.ini --group Settings --key gtk-application-prefer-dark-theme true
lookandfeeltool -a org.kde.breezedark.desktop
