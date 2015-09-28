#!/bin/bash

#Uso: Detener nombreFunción

if [ $# -ne 1 ]
then
	echo ""
	echo -e '\t'"Detener fue  llamado incorrectamente. La llamada debe tener formato:"
	echo -e '\t'">bash Detener nombreProcesoAMatar"
	exit 1
fi

comando="$(ps -a | grep "$1$" | awk '{print $1}')"
echo $comando

if [ "$comando" = '' ]
then
	echo "No se encontro al proceso $1 corriendo"
else
	echo "Terminando proceso $1 con PID: $comando"
	kill $(ps -a | grep "$1" | awk '{print $1}') 
fi
