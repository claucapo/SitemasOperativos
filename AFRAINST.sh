#!/bin/bash

echo "El propósito de este comando es efectuar la instalación del sistema AFRA-I."

echo "Defina el directorio de ejecutables ($grupo/bin):"


GRUPO=$PWD/GRUPO1
CONFDIR=$GRUPO/conf
LOGSIZE=400
export GRUPO
export CONFDIR
export LOGSIZE




function getPerlVersion(){
  if perl -v < /dev/null &>/dev/null;
  then
    local perl_info=`perl -v | grep '.' | head -n 1`
    local version=`echo $perl_info | sed 's/.*v\([0-9]\{1,2\}\.[0-9]\{1,2\}\.[0-9]\{1,2\}\).*/\1/'`
    echo $version
    return 0
  else
    return 1
  fi
}

function division(){
  echo $((($1 + $2/2) / $2))
}

function freeSpace(){
  local free_space_bytes=`df $1 | tail -n 1 | tr -s ' ' | cut -d' ' -f 4`
  echo $(division $free_space_bytes 1024)
}

if [ -z $(getPerlVersion) ]
then
  logError "No tiene instalado perl"
  exit 1
fi

PERL_VERSION=$(getPerlVersion)
echo "Version de perl instalada: $PERL_VERSION"
version=`echo $PERL_VERSION | sed 's/\([0-9]\{1,2\}\)\..*/\1/'`
if [[ version -lt 5 ]]
then
	echo "Hay que loguear?"
fi
