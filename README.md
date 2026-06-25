# Huayra/GNU-Linux post intallation script
Este scripts automatiza las instalaciones posteriores a la instalacion, la actualizacion del sistema (Debian o Huayra) y la instalacion de paquetes.
Paquetes que se instalan: gfortran, topcat-full, okular, man español, gedit, latex, xz-utils, ntfs-3g, vlc, audacity, geogebra, cpu-x, mozo, geany, qbittorrent, mate-sensors-applet, texstudio, TopCat, flatpak. Stremio y spotify mediante flatpak.

Descarga script Upgrade.sh para automatizar la actualizacio de Topcat y de TexStudio.App
IRAF y conda a revisar
# COMO SE USA
 1) se descarga a cualquier ubicación
 2) se le da permisos de ejecución, desde un terminal con el siguiente comando:
   wget https://raw.githubusercontent.com/vieja29/post-install/refs/heads/master/post_install.sh
   chmod +x post_install.sh
 3) ahora se debe convertir en root
   sudo su
 4) Se ejecuta
   ./post_install.sh
