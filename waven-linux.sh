#!/bin/sh
dir="$PWD"
lutriswinepath="/home/$USER/.local/share/lutris/runners/wine"

# change version number to downgrade to another old build
winever="6.21-4"

# use for wine
wine="$dir/lutris-$winever-x86_64/bin/wine"
prefix="$dir/wine-waven"
overrides="libglesv2,powershell.exe=d"
launcher="$dir/wine-waven/drive_c/Program Files/Ankama/Ankama Launcher/Ankama Launcher.exe"
exec="$dir/ankama-launcher.exe"

# use for dxvk
dxvkver=$(curl --silent "https://api.github.com/repos/doitsujin/dxvk/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | cut -d'v' -f2)

# create new script
script=$(cat <<EOF
#!/bin/sh
WINEPREFIX=$prefix WINEDLLOVERRIDES=$overrides "$wine" "$launcher" > /dev/null 2>&1 &
EOF
)

# user action to perform
action="$1"

case "$action" in
configure)
  ;;
dxvk)
  ;;
*)
  echo "Action inconnue: $action"
  echo "Usage: $0 [configure|dxvk]"
  exit 1
esac

configure() {
  if [ -d $lutriswinepath ]; then
    if [ -d "$lutriswinepath/lutris-$winever-x86_64" ]; then
      if [ ! -d "$dir/lutris-$winever-x86_64" ]; then
          ln -s $lutriswinepath/lutris-$winever-x86_64 $dir
          wineinstall=true
      fi
    echo "Wine correctement installé"
    else
      echo "Télécharger wine depuis Lutris, version : lutris-$winever"
      echo "Puis relancer le script"
    fi
  else
    # download lutris wine build
    if [ ! -d "$winever-x86_64" ]; then
        wget https://github.com/lutris/wine/releases/download/lutris-$winever/wine-lutris-$winever-x86_64.tar.xz
        tar -xf wine-lutris-$winever-x86_64.tar.xz
        rm wine-lutris-$winever-x86_64.tar.xz
        wineinstall=true
    fi
  fi

  if [ "$wineinstall" = true ]; then
    # configure wine prefix, install launcher
    if [ ! -d "wine-waven" ]; then
      wget "https://launcher.cdn.ankama.com/installers/production/Ankama Launcher-Setup.exe" -O "ankama-launcher.exe"

      WINEPREFIX=$prefix WINEDLLOVERRIDES=$overrides "$wine" "$exec"
      rm ankama-launcher.exe
    fi

    echo "$script" | tee start-waven.sh

    # add execute to script
    chmod +x $dir/start-waven.sh
  fi
}

# configure dxvk
dxvk() {
    wget https://github.com/doitsujin/dxvk/releases/download/v$dxvkver/dxvk-$dxvkver.tar.gz
    tar -xf dxvk-$dxvkver.tar.gz
    WINEPREFIX=$prefix $dir/dxvk-$dxvkver/setup_dxvk.sh install
    rm dxvk-$dxvkver.tar.gz
}

$action