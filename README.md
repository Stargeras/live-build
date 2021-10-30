### This project builds a live image (.iso) of either archlinux of debian with your choice of a supported desktop environment. There are many customizations I have made to the desktop environments to fine tune them to my liking, and I hope I can empower you to do the same.

### Acronyms used:
  - OS - operating system
  - DE - desktop environment

## How do I use it?
- You must be using a system running the same operating system as the one being built. For example to be an archlinux image, you must be on an archlinux system.
- All you need to do is run the 01_build.sh script in the respective OS directory and specify the desktop environment to install
- If building Debian, also specify the codename of the Debian version to build (Examples below)
- The supported desktop environments are also listed below
- See the 01_build.sh scripts for variables to tweak
- The "common" directory within each OS directory contain files and scripts that will be placed onto the target image regardless of the DE being installed
- Within each desktop environment directory, there is a bash script with the same name as the DE. This runs in chroot at build time and can be modified to run additional commands or add/remove packages
- Most DE folders also include a "config.sh" script, this runs each time the new system logs in and can be modified to add additional tweaks or lock down certain settings. In the future, I plan on adding more comments for further clarity on what the commands are doing though most are fairly self explanitory and achieve things like enabling extensions, modifying the theme, modifying programs on the panel, etc.

### Arch Linux
```
bash archlinux/01_build.sh pantheon
```

### Debian
```
bash debian/01_build.sh buster gnome
```

### Supported Desktop Environments
- Archlinux
  - budgie
  - cinammon
  - gnome
  - pantheon
  - plasma
  - ukui
  - xfce
- Debian
  - Buster
    - gnome
  - Bullseye
    - gnome
  - Sid
    - gnome
    - plasma