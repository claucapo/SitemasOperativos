#!/bin/bash

#Uso: Detener.sh nombreFunción

if [ $# -ne 1 ]
then
	echo ""
	echo -e '\t'"Detener.sh fue  llamado incorrectamente. La llamada debe tener formato:"
	echo -e '\t'">bash Detener.sh nombreProcesoAMatar"
	exit 1
fi

comando="$(ps -a | grep "$1$")" #me falta terminar
echo $comando

if [ "$comando" = '' ]
then
	echo "No se encontro al proceso $1 corriendo"
else
	echo "Terminando proceso $1 con PID: $comando"
	kill $(ps -a | grep "$1") #me falta terminar
fi