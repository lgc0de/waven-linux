# Waven Linux
## Standalone wineprefix

Le script utilise la version Wine de Lutris qui inclue les patchs proton de Valve ainsi que d'autres fix créés par la communauté.

- configure un prefix wine dédié
- installe le launcher Ankama
- support de DXVK pour le matériel compatible (optionnel)

## Utilisation
### Wine
- ouvrir un terminal et lancer ```./waven-linux.sh configure```
- laisser le chemin proposé et cliquer sur installer
- cliquer sur lancer le launcher
- une fois sur la page de login, fermer le launcher
- relancer le launcher via le script ```./start-waven.sh```

### DXVK
Si votre matériel est compatible avec vulkan, le script permet de configurer DXVK pour Waven. 
- fermer le jeu & launcher
- lancer ```./waven-linux.sh dxvk```
- relancer le launcher & le jeu :)