#!/bin/bash

file="/usr/lib/chromium/master_preferences"

cat > ${file} << EOF
{
  "homepage": "https://github.com/stargeras/live-build",
  "homepage_is_newtabpage": false,
  "browser": {
    "custom_chrome_frame": true,
    "show_home_button": true,
    "window_placement": {
      "bottom": 1022,
      "left": 9,
      "maximized": false,
      "right": 1694,
      "top": 6,
      "work_area_bottom": 1080,
      "work_area_left": 0,
      "work_area_right": 1920,
      "work_area_top": 30
    }
  },
  "session": {
    "restore_on_startup": 4,
    "startup_urls": [
      "archlinux.org"
    ]
  },
  "extensions": {
    "theme": {
      "use_system": true
    }
  }
}
EOF
chmod 644 ${file}