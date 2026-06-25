#!/bin/bash
########################################################################################################################################3
#Rutina para actualización de Huayra 3.2 con los repositorios de la comunidad Huayra e instalación de software: gfortran, topcat-full, okular 
#libreoffice, man español, gedit, latex
autor="RICARDO VILLAR"
#MAIL:rvillarbravo@gmail.com
scriptVersion="2.0.6"
distro_detect=`lsb_release -si`
distro_arch=`uname -m`
#########################################################################################################################################
## COMO SE USA
## 1) se descarga a cualquier ubicación
## 2) se le da permisos de ejecución, desde un terminal con el siguiente comando:
## >>> wget https://raw.githubusercontent.com/vieja29/post-install/refs/heads/master/post_install.sh
## >>> chmod +x post_install.sh
## 3) ahora se debe convertir en root
## >>> sudo su
## 4) Se ejecuta
## >>> ./post_install.sh
#alias rm="rm -i"
#sudo su
#./posbox_v*.sh
######################################################################################################################################


#                   Instalación DE LOS REPOSITORIOS DE COMUNIDAD HUAYRA y de espejos de los repositorios oficiales


######################################################################################################################################
clear 

echo -e "\n\t########################################################"
echo -e "\t####### Inicio de script post-install. v.$scriptVersion #######"
echo -e "\t########################################################"
echo -e "                                                              by: $autor \n" 			
echo -e "\n Para cancelar actualización, precione 'Ctrl+c'.\n"
sleep 3
echo -e "\n ¿Cambiar los link's de los repositorios oficiales de Huayra? [s/n]. \n"
read nn
if [[ "$nn" = "s" || "$nn" = "S" ]]; then 
    echo -e "\n Cambiando repositorios ... \n Por favor espere unos segundos.\n"
    file="/etc/apt/sources.list.d/huayra.list.org" 
    codename=`lsb_release -da 2>null | grep Codename: |awk '{print $2}'`
    version=`lsb_release -da 2>null | grep Release: |awk '{print $2}'`
    if [ ! -f "$file" ]; then # ! -f indica si el fichero huayra.list.orig existe y es un fichero regular (no un directorio, u otro tipo de fichero 
                              # especial. En Huayra 2.x 
        direc="/etc/apt/sources.list.d/huayra.list"
        echo "$codename  #version"
     else
        direc="/etc/apt/sources.list"
        echo "$codename  #version" 
    fi    
    sudo cp "$direc" "$direc".orig
    sudo sed -i 's/repo.huayra.conectarigualdad.gob.ar/repo-huayra.conectarigualdad.gob.ar/g' "$direc"

    echo -e "\n Agregando Repositrios espejos @ FCALNO official \n."
    sudo echo "" >> "$direc"
    sudo echo "# Repositorios temporales/espejo de Huayra "$codename" @ FCALNO official" >> "$direc"
    sudo echo "# deb http://mirror.fcal.uner.edu.ar/huayra/ "$codename"             main contrib non-free # temporal" >> "$direc"
    sudo echo "# deb   http://mirror.fcal.uner.edu.ar/huayra/ "$codename"-updates   main contrib non-free # temporal" >> "$direc"
    sudo echo "" >> "$direc"
   #sudo echo "#deb http://huayra.tom.pressenter.com.ar/huayra/ "$codename" main contrib non-free # temporal" >> "$direc"
   #sudo echo "#deb http://huayra.tom.pressenter.com.ar/huayra/ "$codename"-updates   main contrib non-free # temporal" >> "$direc"
   #wget -chttp://huayra.tom.pressenter.com.ar/huayra/huayra.gpg.asc
   #sudo apt-key add huayra.gpg.asc
   #rm huayra.gpg.asc


    echo -e "\n ¿Desea agregar repositrios de la comunidad? [S/n]. \n"
    read comu
    if [[ "$comu" = "s" || "$comu" = "S" ]]; then
        sudo echo "" >> "$direc"
        sudo echo "## Comunidad Huayra" >> "$direc"
        sudo echo "#deb http://repositorio.comunidadhuayra.org/comhuayra huayra main contrib non-free" >> "$direc"
        sudo echo "#deb-src http://repositorio.comunidadhuayra.org/comhuayra huayra main contrib non-free" >> "$direc"
        #habilitación de la clave de verificación del repositorio de la comunidad huayra
        wget -c repositorio.comunidadhuayra.org/comhuayra/huayra.gpg.asc  # Habilita Llave de Verificación
        sudo apt-key add huayra.gpg.asc
        rm huayra.gpg.asc                                              # opcional

    fi 
    echo -e "\n ¡Repositorios termporales agregados!. \n" 
fi
 sleep 1 


########################################################################################################################################
echo -e "\n Iniciando actualización de $distro_detect. \n"
#  sincronizar 
#--------------
sudo apt update
#######################################################################################################################################


# Instala los Keyring para evitar error por claves de apt update
echo
if [ $(sudo dpkg-query -W -f='${Status}' debian-keyring 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
  sudo apt install -y debian-keyring
else
    echo -e "\n Debian-keyring instalado."
fi
if [ $(sudo dpkg-query -W -f='${Status}' debian-archive-keyring 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
  sudo apt install -y debian-archive-keyring
else
    echo -e "\n Debian-archive-keyring instalado. \n"
fi
sleep 2

####################################################################################################################
#actualización de la distro
#--------------------------
sudo apt upgrade -y ; sudo apt dist-upgrade -y 
sudo apt autoremove ; sudo apt autoclean -y
##########################################################################################################################################
#                               INSTALACION DE DRIVER Y PAQUETES

echo -e "\n Actualización de Firefox. \n"
sleep 2
sudo update-firefox

sleep 2
# instalacion de okular, gfortran, latex, man español,

echo -e "\n instalacion de okular, gfortran, latex, man español \n"

sudo apt install -y okular okular-extra-backends gfortran xz-utils ntfs-3g vlc audacity geogebra cpu-x mozo #xfat-fuse exfat-utils #locate #neofetch screenfetch huayra-grub-themes-limbo pulseaudio-module-bluetooth
echo -e "\n"
sudo apt install -y geany qbittorrent mate-sensors-applet libcanberra-gtk-module libcanberra-gtk3-module texstudio libqwt-qt5-6 #brightside skippy-xd
echo -e "\n"
sudo apt install -y texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-pictures \
    texlive-science \
    texlive-bibtex-extra \
    texlive-lang-spanish \
    texlive-lang-english \
    texlive-xetex \
    texlive-luatex \
    #texlive-fonts-extra \
    biber \
    latexmk 

sleep 2

echo -e "\n ¿Desea instalar Dropbox, stremio, telegram etc... [s/n].? \n "
read nn 
 if [[ "$nn" = "S" || "$nn" = "s" ]]; then

    echo -e "\n Instalando flatpak para luego instalar Stremio \n"
    sudo apt install flatpak
    echo -e "\n Añadir el repositorio de Flathub \n"
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub com.stremio.Stremio
    
    
#    echo -e " \n Descargando dropbox "
#	cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.$distro_arch" | tar xzf 
    wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2026.05.06_amd64.deb  
    sudo dpkg -i dropbox_2026.05.06_amd64.deb
 	#echo "\n \t Si estás ejecutando Dropbox en tu servidor por primera vez, se te solicitará que copies y pegues un vínculo en un explorador en funcionamiento para crear una nueva cuenta o para agregar tu servidor a una cuenta existente. Una vez que lo hagas, se creará tu carpeta de Dropbox en el directorio principal. Descarga esta secuencia de comandos de Python para controlar Dropbox desde la línea de comandos. Para acceder con más facilidad, inserta un vínculo simbólico a la secuencia de comandos en cualquier lugar de tu RUTA. \n"
	#sleep 10
 	#wget  https://linux.dropbox.com/packages/dropbox.py
	#~/.dropbox-dist/dropboxd
	#python3 dropbox.py update

#telegram
	wget -c https://telegram.org/dl/desktop/linux
	tar -Jxvf tsetup.6.9.3.tar.xz
	cd Telegram ; ./Updater 

#Brave navegador
	sudo sudo apt install curl
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
    sudo apt update
    sudo apt install brave-browser
 fi


#echo" modificacion del screemfetch para que reconozca Huayra/GNU-LINUX"
#sleep 5 
#wget -c https://cloud.openmailbox.org/index.php/s/he8e00YZvD3Hg5G
#chmod +x screenfetch ; sudo mv screenfetch /usr/bin 
#sleep 4
#echo "Instalacón completada"


echo -e "\n ¿Quiere Congifurar el idioma para las man pages? [S/n] \n"
read utf
if [[ "$utf" = "s" || "$utf" = "S" ]]; then 
    sudo apt install -y manpages-es
    echo -e "\n UTF-n Congifurar el idioma para las man pages. \n ( Buscar es_AR.UTF-8 UTF-8)"   
    sleep 5
    sudo dpkg-reconfigure locales
    sleep 1

echo -e "\n Descagando TOPCAT e instalando. \n"
#descaga de topcat
wget -c http://www.star.bris.ac.uk/~mbt/topcat/topcat-full.jar
chmod +x topcat-full.jar

echo -e "\n Instalacón completada. \n"

sleep 2
echo -e "\n ¿Quiere instalar Aladin? [S/n] \n"
read al
if [[ "$al" = "s" || "$al" = "S" ]]; then
    wget -c http://aladin.u-strasbg.fr/java/download/Aladin.tar
    tar -xvf Aladin.tar
    rm Aladin.tar
    sleep 2 
    echo -e "\n Instalacón completada. \n"
fi

echo -e "\n ¿Desea instalar IRAF? [S/n] \n"
read iraf
if [[ "$iraf" = "s" || "$iraf" = "S" ]]; then
    echo -e "\n Menu de versiones de IRAF disponibles: \n"
    echo "      1. IRAF NOAO v2.16 (update 2012)."
    echo "      2. IRAF Communitie v2.16.1+2018 (update 2018)."
    echo "Elija una opción (1 o 2):"
    read num
    case $num in
    
    	1)
        	wget -c https://www.dropbox.com/s/n1beoskz71o0zx6/install_iraf_NOAO.sh?dl=0
			mv install_iraf_NOAO.sh?dl=0 install_iraf_NOAO.sh
        	chmod +x install_iraf_NOAO.sh 
        	sudo ./install_iraf_NOAO.sh 
        	rm install_iraf_NOAO.sh	;;
    	2)
        	wget -c https://www.dropbox.com/s/8e063j9ku0j4elw/install-iraf-community.sh?dl=0
			mv install-iraf-community.sh?dl=0 install-iraf-community.sh
			chmod +x install-iraf-community.sh
        	sudo ./install-iraf-community.sh 
        	rm install-iraf-community.sh ;;
    esac
fi

#echo " ¿Desea instalar Anaconda ( Python para astronomia)?[S/n]"
#read py
#if [[ "$py" = "S" || "$py" = "s"]]; then
#    wget -c
#	 mv
#    sudo ./
#    rm
#fi

echo -e "\n Descargando scripts de actualizacion de la distribución.\n (Para ejecutar tipee ./upgrade.sh)\n"
wget -c https://raw.githubusercontent.com/vieja29/post-install/refs/heads/master/Upgrade.sh
chmod +x Upgrade.sh
sleep 1
#echo -e "\n Descargando scripts de instalacion a travez de BACKPORTS de tú distribución base. (Para ejecutar tipee install_backports.sh) \n."
#wget -c https://www.dropbox.com/s/16q2k856wurjh3u/install_backports.sh?dl=0
#mv install_backports.sh?dl=0 install_backports.sh
#chmod +x install_backports.sh 


echo -e "\n Purgando archivos de configuración de aplicaciones desinstaladas...\n"
echo "--------------------------------------------------------------------------------------------------"
# para borrar ficheros de configuracion de aplicaciones desistaladas 
#        grep ^rc busca en la primera columna la cadena "rc"
#        cut -d " "  es para saltar el primer cadena de caractres, -f 3 es para saltar las 3 primeras columnas
#        xargs pone la cadena de caracteres adelante de los comandos a utilizar,
sudo dpkg -l | grep ^rc | awk '{print $2}' | xargs sudo apt-get purge -y

exit
