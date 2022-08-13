#! /bin/bash

# Voozee theme for Gnome 42.*^
# Version: 1.0.1
# Customization by Spellmell
# spellmell.github.io
# spellmell@protonmail.com
# 7/25/2022
# https://github.com/spellmell/voozee_gnome_theme

THEME=voozee_dodgerblue
ROUTE=~/.themes
FONTROUTE=~/.local/share/fonts
FONTNAME="Ubuntu"
EXTWL="https://extensions.gnome.org/extension-data"
EXTUL=("extension-listtu.berry.v30" "user-themegnome-shell-extensions.gcampax.github.com.v49" "just-perfection-desktopjust-perfection.v21")

# font instalation
if [ ! -d /usr/share/fonts/$FONTNAME ];
then
  if [ ! -d $FONTROUTE ];
  then
    mkdir -p $FONTROUTE
  fi
  wget -O $FONTNAME.zip "https://fonts.google.com/download?family=$FONTNAME"
  unzip -d -o $FONTROUTE/$FONTNAME $FONTNAME.zip
  rm ./$FONTNAME.zip
fi

# theme instalation
if [ ! -d $ROUTE ];
then
  mkdir -p $ROUTE
fi

if [ $1 && -d ./voozee/$1 ];
then
  THEME=$1
  cp -r ./voozee/$1 $ROUTE
else
  cp -r ./voozee/* $ROUTE
fi

for EXTN in ${EXTUL[@]}; do
  wget "$EXTWL/$EXTN.shell-extension.zip"
  ZIPNAME=./$EXTN.shell-extension
  gnome-extensions install -f $ZIPNAME.zip
  unzip -d $ZIPNAME $ZIPNAME.zip
  NAME=$(jq '.uuid' ./$ZIPNAME/metadata.json | tr -d '"')
  gnome-extensions enable $NAME
  rm -Rf ./$ZIPNAME*
done

sed -i "s/_VOOZEETHEME_/$THEME/g" ./voozee.dconf
sed -i "s/_USERNAME_/$USER/" ./voozee.dconf

dconf load / < ./voozee.dconf

notify-send "Voozee theme has ben installed" "Make an alt+f2, r and enter, to restart gnome with the new configuration." -i "gnome-logo-text-dark"

exit 0
