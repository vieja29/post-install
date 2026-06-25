#!/bin/bash
# Script para actualizar Huayra o Debian

autor="Ricardo Villar"
scriptVersion="1.11.01"
distroname=$(lsb_release -is 2>/dev/null)
codename=$(lsb_release -cs 2>/dev/null)
releversion=$(lsb_release -rs 2>/dev/null)
logFile="upgrade_$(date +%Y%m%d_%H%M%S).log"

#####################################################################################################
clear
echo -e "\n\t*******************************************************************" | tee -a $logFile
echo -e "\t**** Script de actualización de $distroname $releversion ($codename). v$scriptVersion ****"| tee -a $logFile
echo -e "\t*******************************************************************"| tee -a $logFile
echo -e "\t\t\t\t\t\t\t  by: $autor \n"| tee -a $logFile
echo -e "Iniciando el script de actualización de $distroname. \n¿Desea continuar? (s/n):"
echo -ne "Tiene 5 segundos para cancelar el inicio. Presione 'n' para cancelar.\n"

# Contador de 5 segundos con opción de cancelar
for i in {5..1}; do
    echo -ne "Iniciando en $i segundos...  \033[0K\r"
    read -t 1 -n 1 nn
    if [[ "$nn" == "n" ]]; then
        echo -e "\nActualización cancelada.\n"
        exit
    fi
done

echo -e "\n... Iniciando actualización...\n" | tee -a $logFile
echo -e "Actualizando lista de paquetes (update)...\n" | tee -a $logFile
sudo apt-get update | tee -a $logFile
clear

echo -e "\n\t*******************************************************************" 
echo -e "\t**** Script de actualización de $distroname $releversion ($codename). v$scriptVersion ****"
echo -e "\t*******************************************************************"
echo -e "\t\t\t\t\t\t\t  by: $autor \n"
echo -e "\nIniciando actualización.\n" | tee -a $logFile
#echo -e "Mostrando paquetes actualizables (list --upgradable)...\n" | tee -a $logFile
#apt list --upgradable | tee -a $logFile
echo -ne "Tiene 15 segundos para cancelar la instalación de actualizaciones. Presione 'n' para cancelar.\n"

# Contador de 15 segundos con opción de cancelar
for i in {15..1}; do
    echo -ne "Cancelando en $i segundos...  \033[0K\r"
    read -t 1 -n 1 nn
    if [[ "$nn" == "n" ]]; then
        echo -e "\nInstalación de actualizaciones cancelada.\n" | tee -a $logFile
        exit
    fi
done

if [[ "$nn" != "s" ]]; then 
    sudo apt-get upgrade -y | tee -a $logFile
    echo -e "\nEjecutando dist-upgrade...\n" | tee -a $logFile
    sudo apt-get dist-upgrade -y | tee -a $logFile

    echo -e "\nEliminando paquetes instalados automáticamente que no son necesarios...\n" | tee -a $logFile
    sudo apt-get autoremove -y | tee -a $logFile

    echo -e "\nBorrando el caché de APT...\n" | tee -a $logFile
    sudo apt-get autoclean -y | tee -a $logFile

    # Verificar la existencia de Conda
    if command -v conda &> /dev/null; then
      #  echo -e "\nConda está instalado en el sistema." | tee -a $logFile
        echo -e "\nActualización de Conda..." | tee -a $logFile
        conda update conda -y | tee -a $logFile
        echo -e "\nEliminando paquetes descargados (Miniconda)...\n" | tee -a $logFile
        conda clean -t -y | tee -a $logFile
    else
        echo -e "\nConda no está instalado en el sistema.\n" | tee -a $logFile
    fi

    # Verificar la existencia de Dropbox
    if test -e dropbox.py; then
        #echo -e "\nDropbox está instalado en el sistema." | tee -a $logFile
        echo -e "\nActualización de Dropbox..." | tee -a $logFile
        python3 dropbox.py update | tee -a $logFile
    else
        echo -e "\nDropbox.py no está en el directorio del usuario.\n" | tee -a $logFile
    fi


    # Verificar la existencia de topcat-full.jar
    if [[ -f "topcat-full.jar" ]]; then
        echo -e "\n Actualización de TOPCAT. \n" | tee -a $logFile
        current_version=$( java -jar topcat-full.jar -version | grep -oP "TOPCAT Version \K[0-9]+\.[0-9]+\-[0-9]+")
        #Busco el numero de la ultima version publicada
        CONTENT=$(curl -s https://www.star.bris.ac.uk/~mbt/topcat/)
        # Extraer la versión más reciente de TOPCAT
        latest_version=$(echo "$CONTENT" | grep -oP "<p>The most recent public release of TOPCAT is <strong>version \K[0-9]+\.[0-9]+\-[0-9]+" | head -1)
        echo -e "Última versión disponible de TOPCAT.\n" 
  
        if [[ "$current_version" != "$latest_version" ]]; then
            echo -e "\nUna nueva versión de TOPCAT está disponible.\n Iniciando la actualización..." | tee -a $logFile
            echo -e " \n La version mas actual es $latest_version.\n La version en sus sistema es $current_version" | tee -a $logFile
            rm topcat-full.jar 
            wget -c http://www.star.bris.ac.uk/~mbt/topcat/topcat-full.jar
        else
            echo -e "\nLa versión de TOPCAT está actualizada." | tee -a $logFile
            echo -e "La version mas actual es $latest_version.\n La version en sus sistema es $current_version" | tee -a $logFile
        fi 
    else
        echo -e "\nTOPCAT no está instalado en el sistema.\n"
    fi 

# Verificar la existencia de TexStudio.AppImage 
    if [[ -f "TexStudio.AppImage" ]]; then
        echo -e "\n Actualización de TexStudio. \n" | tee -a $logFile
        current_version=$(./TexStudio.AppImage --version | grep -oP 'TeXstudio \K[0-9]+\.[0-9]+\.[0-9]+')
        CONTENT=$(curl -s https://www.texstudio.org/#news)
        # Extraer el número de la versión más reciente de TeXstudio
        latest_version=$(echo "$CONTENT" | grep -oP ' new release <strong>TeXstudio \K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
        # Comprobar si se ha encontrado una versión
        if [[ "$current_version" != "$latest_version" ]]; then
            echo -e "\nUna nueva versión de TeXstudio está disponible.\n Iniciando la actualización..." | tee -a $logFile
            echo -e " \n La version más actual es $latest_version. La version en sus sistema es $current_version" | tee -a $logFile
            wget -c  https://github.com/texstudio-org/texstudio/releases/download/$latest_version/texstudio-$latest_version-x86_64.AppImage
            rm TexStudio.AppImage | tee -a $logFile
            mv texstudio-$latest_version-x86_64.AppImage TexStudio.AppImage | tee -a $logFile
            rm texstudio-$latest_version-x86_64.AppImage | tee -a $logFile
            chmod +x TexStudio.AppImage
        else
            echo -e "\nLa versión de TeXsudio está actualizada." | tee -a $logFile
            echo -e "La version mas actual es $latest_version.\n La version en sus sistema es $current_version" | tee -a $logFile
        fi
    else
         echo -e "\n TexStudio no está instalado en el sistema.\n" 
    fi 

    #actualizacion Aladin  
      #file="/Aladin/aladin"   #"/etc/apt/sources.list.d/huayra.list.orig"
    #if [  -f "$file" ]; then 
        #rm -f Aladin
        #sleep 5
        #echo "descarga de Aladin e instalación"
        #wget -c http://aladin.u-strasbg.fr/java/download/Aladin.tar
        #tar -xvf Aladin.tar
        #rm Aladin.tar
    #fi

else
    echo -e "\nActualización cancelada.\n" | tee -a $logFile
    exit
fi

clear
echo -e "\n\t*******************************************************************" 
echo -e "\t**** Script de actualización de $distroname $releversion ($codename). v$scriptVersion ****"
echo -e "\t*******************************************************************"
echo -e "\t\t\t\t\t\t\t  by: $autor \n"

echo -e "\nPurgando archivos de configuración de aplicaciones desinstaladas...\n" | tee -a $logFile
sudo dpkg -l | grep ^rc | awk '{print $2}' | xargs sudo apt-get purge -y | tee -a $logFile

echo -e "\nLimpieza completada.\n" | tee -a $logFile

# Eliminar archivos de log viejos
echo -e "\nEliminando archivos de log viejos...\n" | tee -a $logFile
find . -name "upgrade_*.log" -type f -mtime +5 -exec rm -f {} \; | tee -a $logFile
echo -e "\nArchivos de log viejos eliminados.\n" | tee -a $logFile

echo -e "\n\t******* ACTUALIZACIÓN $distroname $codename FINALIZADA. *******" | tee -a $logFile
