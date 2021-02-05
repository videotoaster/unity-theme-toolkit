#!/bin/sh

# LICENSED UNDER MIT
# PLEASE CREDIT ME (https://github.com/videotoaster) THANKS

# Hi, welcome to the UTK!
# This script SHOULD  BE MODIFIED for your theme. (it'll be lame if left untouched)

icondir="./icons"              # where the icons are
thmedir="./theme"              # where the theme is
dashico="./my_dash_icon.png"   # where the dash icon is
dashena="on"                   # see https://github.com/videotoaster/unity-theme-toolkit/wiki/Environment-Variables
thmenam="My First Unity Theme" # fancy theme name
thmeath="Anonymous"            # your name

# This part is *better* left alone, but go crazy-nuts.

# First, we get the clean path to our user's home directory.
# We *could* just use ~, but I'm not sure about the reliability of that.

# save the current directory for later
currentdir=$(pwd)
# change to user's home using argless CD and save the pwd to a variable
usrhomedir=$(cd; pwd; cd $currentdir)

# status indicator :)
echo -n "Sanity check ("
# check if each folder exists
if [ -d "$currentdir/$icondir" ]; then
    # check 1 passed
    echo -n "."
    if [ -d "$currentdir/$thmedir" ]; then
        # check 2 passed
        echo -n "."
        if [ "$dashena" = "on" ]; then
        if [ -f "$currentdir/$dashico" ]; then
            # check 3 passed
            echo ".) [passed]"
        else
            # check 3 failed
            echo "x)\nDash icon not found!\nPlease ensure that $dashico exists."; exit
        fi
        else
            echo ") [passed]"
        fi
    else
        # check 2 failed
        echo "xx)\nTheme not found!\nPlease ensure that $thmedir exists."; exit
        exit
    fi
else
    # check 1 failed
    echo "xxx)\nIcons not found!\nPlease ensure that $icondir exists."; exit
    exit
fi

# another status indicator
echo -n "Finding folders ("

# themes folder
if [ -d "$homdir/.local/share/themes" ]; then # is it ~/.local/share/themes?
    themefolder="$homdir/.local/share/themes" # if so, set the variable
elif [ -d "/usr/share/themes" ]; then         # if not, check /usr/share/themes
    themefolder="/usr/share/themes"           # if it's here, set the variable
else                                          # if not, give up and throw an error.
    echo " (\e[31mxxx\e[0m)\n\e[31mNo folder found for themes.\e[0m"; exit
fi
echo -n "."

# icons folder
if [ -d "$homdir/.local/share/icons" ]; then # is it ~/.local/share/icons?
    iconfolder="$homdir/.local/share/icons"  # if so, set the variable
elif [ -d "/usr/share/icons" ]; then         # if not, check /usr/share/icons
    iconfolder="/usr/share/icons"            # if it's here, set the variable
else                                         # if not, give up and throw an error.
    echo "xx)\n\e[31mNo folder found for icons.\e[0m"; exit
    exit
fi
echo -n "."

# verify that dash icon exists
if [ "$dashena" = "on" ]; then
   if [ -f "/usr/share/unity/icons/launcher_bfb.png" ]; then
       echo ".) [\e[32mdone\e[0m]"
   else
       echo "x)\nNo dash icon found. Is Unity installed?"; exit
   fi
else
   echo ") [done]"
fi

# verify that unity is installed
echo -n "Unity... "
if [ -f "/usr/bin/unity" ]; then
   echo "is installed."
else
   echo "\e[31misn't installed!\e[0m"
   echo "Run [\e[33msudo apt install unity light-themes\e[0m] to get it."; exit
fi

# verify that the user is priveleged
echo -n "User is... "
if [ "$iconfolder" = "/usr/share/icons" ]; then
   if [ "$(whoami)" != "root" ]; then
      echo "$(whoami). \e[31mNot root\e[0m!"
      echo "\e[31mIn this environment, $0 must be run as root.\e[0m"
      echo "Try [sudo $0]!"; exit
   else
      echo "permitted."
   fi
elif [ "$thmefolder" = "/usr/share/themes" ]; then
   if [ "$(whoami)" != "root" ]; then
      echo "$(whoami). Not root!"
      echo "\e[31mIn this environment, $0 must be run as root.\e[0m"
      echo "Try [\e[33msudo $0\e[0m]!"; exit
   else
      echo "permitted."
   fi
elif [ "$dashena" = "on" ]; then
   if [ "$(whoami)" != "root" ]; then
      echo "$(whoami). Not root!"
      echo "\e[33mTo install dash icons, $0 must be run as root.\e[0m"
      echo "Try \e[33m[sudo $0]\e[0m for dash icon.";
      echo "Continuing without dash icon..."
   else
      echo "permitted."
   fi
fi

# everything is good at this point
echo "Tests passed. Installer is ready."
echo "======================================"
echo "\e[32m$thmenam\e[0m"
echo "A Unity theme by \e[32m$thmeath\e[0m"
echo "======================================"
echo -n "Are you sure you want to install? (Y/n/): "
read yn
case $yn in
    "N")
       echo "Cancelled. "; exit
       ;;
    "n")
       echo "Cancelled. "; exit
       ;;
    *)
       echo "======================================"
       ;;
esac
echo "Copying $thmedir..."
cp -r $thmedir $thmefolder
echo "Done. Copying $icondir..."
cp -r $icondir $iconfolder
echo "Done. Setting up custom dash logo:"
echo "Creating backup..."
echo "Writing restore script..."
echo '#!/bin/sh\nif [ "$(whoami)" != "root" ]; then\necho "ERROR: not root, can not restore"\nelse\ncp dash_backup.png /usr/share/unity/icons/launcher_bfb.png\nfi' > restore.sh
chmod +x restore.sh
echo 'To restore current dash icon, run [\e[34m./restore.sh\e[0m].' 
cp /usr/share/unity/icons/launcher_bfb.png "dash_backup.png"
if [ -f "dash_backup.png" ]; then
   echo "Copying new dash logo..."
   cp $dashico /usr/share/unity/icons/launcher_bfb.png
   echo "Done."
else
   echo "Couldn't find file dash_backup.png. \e[31mBackup failed!\e[0m"; exit
fi
echo "======================================"
echo "\e[32mInstallation success!\e[0m"
echo "If you're seeing this, the theme installed successfully."
echo "\e[32munity-theme-toolkit\e[0m created by \e[31mvideotoaster\e[0m!"
