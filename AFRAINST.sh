#!/bin/bash
# Script para instalar el sistema AFRA-I

GRUPO=$(dirname $0) # Obtengo el directorio del script
CONFDIR=$GRUPO/conf # Directorio del archivo de configuracion
BINDIR=$GRUPO/bin
MAEDIR=$GRUPO/mae
NOVEDIR=$GRUPO/novedades
DATASIZE=100
ACEPDIR=$GRUPO/aceptadas
PROCDIR=$GRUPO/sospechosas
REPODIR=$GRUPO/reportes
LOGDIR=$GRUPO/log
LOGSIZE=400
LOGEXT=log
RECHDIR=$GRUPO/rechazadas
perl_minimo=5 # Version de Perl necesaria

export GRUPO;export CONFDIR;export BINDIR;export MAEDIR;export NOVEDIR;export DATASIZE
export ACEPDIR;export PROCDIR;export REPODIR;export LOGDIR;export LOGSIZE;export LOGEXT
export RECHDIR

# Funciones

# $1: Variable donde guardar el valor ; $2: Mensaje a mostrar ; $3: Opcion por default
function obtener_valor {
    echo
    echo -n -e "$2"
    read opcion
    if [ -z "$opcion" ] ; then
        opcion="$3" # Opcion por default
    fi
    eval "$1='$opcion'"
}

# $1: Variable donde está el path ; $2: Path
function normalizar_path {
    if ! [[ "$2" =~ ^$GRUPO.*$ ]] ; then # Si el path es relativo
        local aux="$GRUPO/$2"
        eval "$1='$aux'"
    fi
}

# /Funciones

# Verificar si AFRA-I esta instalado
if [ ! -d conf ] ; then
    echo "¡No existe directorio de configuración!"
    exit
fi
cd conf
if [ -f AFRAINST.conf ] ; then
    # Ya esta instalado
    echo "Hay que verificar que esté la instalación completa"
else
    # Hay que instalar
    
    version_perl=`(perl -v) | sed -n "s-^This is perl \([0-9]*\).*-\1-p"`
    if [ ! $version_perl -ge $perl_minimo ] ; then
        echo -e "Para ejecutar el sistema AFRA-I es necesario contar con Perl 5 o superior.\n\nEfectúe su instalación e inténtelo nuevamente.\n\nProceso de instalación cancelado." 
        exit
    fi
    
    while [ "$opcion1" != Si ] ; do
        obtener_valor opcion1 "***********************************************************\n*           Proceso de Instalación de \"AFRA-I\"            *\n* Tema I Copyright © Grupo 01 - Segundo Cuatrimestre 2015 *\n***********************************************************\nA T E N C I O N: Al instalar UD. expresa aceptar los térmi-\nnos y condiciones del \"ACUERDO DE LICENCIA DE SOFTWARE\"\nincluido en este paquete.\n¿Acepta? (Si–No): " Si
        if [ "$opcion1" == No ] ; then
            exit
        fi
    done
    
    opcion_maestra=No
    while [ "$opcion_maestra" == No ] ; do
        obtener_valor BINDIR "Defina el directorio de instalación de los ejecutables ($BINDIR): " "$BINDIR"
        normalizar_path BINDIR "$BINDIR"
        
        obtener_valor MAEDIR "Defina el directorio para maestros y tablas ($MAEDIR): " "$MAEDIR"
        normalizar_path MAEDIR "$MAEDIR"
        
        obtener_valor NOVEDIR "Defina el directorio de recepción de archivos de llamadas ($NOVEDIR): " "$NOVEDIR"
        normalizar_path NOVEDIR "$NOVEDIR"
        
        while ! [[ "$opcion2" =~ ^[0-9]*$ ]] ; do # Repetir mientras no se ingrese un numero
            obtener_valor opcion2 "Defina el espacio mínimo libre para la recepción de archivos de llamadas en MBytes ($DATASIZE): " $DATASIZE
        done
        DATASIZE=$opcion2
        
        # Verificar espacio en disco
        disponible=`df -BM | tail -n 1 | tr -s ' ' | cut -d' ' -f 4`
        disponible="${disponible%?}" # Saco la M del final
        if [[ $disponible < $DATASIZE ]] ; then
            echo -e "Insuficiente espacio en disco.\n\nEspacio disponible: " $disponible "MB.\n\nEspacio requerido: " $DATASIZE "MB.\n\nInténtelo nuevamente."
            exit
        fi
        
        obtener_valor ACEPDIR "Defina el directorio de grabación de los archivos de llamadas aceptadas ($ACEPDIR): " "$ACEPDIR"
        normalizar_path ACEPDIR "$ACEPDIR"
        
        obtener_valor PROCDIR "Defina el directorio de grabación de los registros de llamadas sospechosas ($PROCDIR): " "$PROCDIR"
        normalizar_path PROCDIR "$PROCDIR"
        
        obtener_valor REPODIR "Defina el directorio de grabación de los reportes ($REPODIR): " "$REPODIR"
        normalizar_path REPODIR "$REPODIR"
        
        obtener_valor LOGDIR "Defina el directorio para los archivos de log ($LOGDIR): " "$LOGDIR"
        normalizar_path LOGDIR "$LOGDIR"
        
        while ! [[ "$extension" =~ ^[a-zA-Z0-9]{1,5}$ ]] ; do # Repetir mientras no sea una extension valida
            obtener_valor extension "Defina el nombre para la extensión de los archivos de log ($LOGEXT): " $LOGEXT
        done
        LOGEXT=$extension
        
        while ! [[ "$logsize" =~ ^[0-9]*$ ]] ; do # Repetir mientras no se ingrese un numero
            obtener_valor logsize "Defina el tamaño máximo para cada archivo de log en kBytes ($LOGSIZE): " $LOGSIZE
        done
        LOGSIZE=$logsize
        
        obtener_valor RECHDIR "Defina el directorio de grabación de archivos rechazados ($RECHDIR): " "$RECHDIR"
        normalizar_path RECHDIR "$RECHDIR"
        
        # Informe de valores ingresados
        opcion_maestra=A
        while [ "$opcion_maestra" != Si ] ; do
            obtener_valor opcion_maestra "Directorio de ejecutables: $BINDIR\n\nDirectorio de Maestros y Tablas: $MAEDIR\n\nDirectorio de recepción de archivos de llamadas: $NOVEDIR\n\nEspacio mínimo libre para arribos: $DATASIZE MB\n\nDirectorio de archivos de llamadas aceptados: $ACEPDIR\n\nDirectorio de archivos de llamadas sospechosas: $PROCDIR\n\nDirectorio de archivos de reportes de llamadas: $REPODIR\n\nDirectorio de archivos de log: $LOGDIR\n\nExtensión para los archivos de log: $LOGEXT\n\nTamaño máximo para los archivos de log: $LOGSIZE kB\n\nDirectorio de archivos rechazados: $RECHDIR\n\nEstado de la instalación: LISTA\n\n¿Desea continuar con la instalación? (Si-No): " Si
            if [ "$opcion_maestra" == No ] ; then
                # Volver a preguntar directorios
                clear
                break
            fi
        done
    
    done
    
    # Grabar logs retrasados
    
    # Confirmar instalacion
    while [ "$opcion3" != Si ] ; do
        obtener_valor opcion3 "Iniciando instalación. ¿Está Ud. seguro? (Si-No): " Si
        if [ "$opcion3" == No ] ; then
            exit
        fi
    done
    
    # Creacion de estructuras de directorio
    echo "Creando estructuras de directorio. . . ."
    mkdir -p $BINDIR;mkdir -p $MAEDIR;mkdir -p $NOVEDIR;mkdir -p $ACEPDIR;mkdir -p $PROCDIR/proc
    mkdir -p $REPODIR;mkdir -p $LOGDIR;mkdir -p $RECHDIR/llamadas
    
    # Mover archivos
    echo "Instalando programas y funciones. . . ."
    $GRUPO/MoverA.sh $GRUPO/GraLog.sh $BINDIR AFRAINST.sh
    #$GRUPO/MoverA.sh $GRUPO/MoverA.sh $BINDIR AFRAINST.sh
    #$BINDIR/MoverA.sh $GRUPO/AFRAINST.sh $BINDIR AFRAINST.sh
    #$BINDIR/MoverA.sh $GRUPO/AFRAINIC.sh $BINDIR AFRAINST.sh
    #$BINDIR/MoverA.sh $GRUPO/AFRARECI.sh $BINDIR AFRAINST.sh
    #$BINDIR/MoverA.sh $GRUPO/AFRAUMBR.sh $BINDIR AFRAINST.sh
    #$BINDIR/MoverA.sh $GRUPO/AFRALIST.p $BINDIR AFRAINST.sh
    #$BINDIR/MoverA.sh $GRUPO/Detener.sh $BINDIR AFRAINST.sh
    #$BINDIR/MoverA.sh $GRUPO/Arrancar.sh $BINDIR AFRAINST.sh
    
    
fi
