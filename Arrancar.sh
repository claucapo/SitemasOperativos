#!/bin/bash

#Uso: Arrancar

nombreScript=`basename "$0"`

if [ "$BINDIR" = '' ]; then 
	echo "Ambiente no inicializado"		
	exit 1
fi

afrareciPid=`ps -e | grep '^.* AFRARECI$' | sed 's/ \?\([0-9]*\).*/\1/' | awk '{print $1}' | head -n 1`

if [ afrareciPid != ""]; then
	echo "Error: AFRARECI se esta ejecutando con PID: ${afrareciPid}"
	$GRUPO/GraLog.sh "$nombreScript" "El demonio ya se encuentra corriendo con PID: ${afrareciPid}"
	exit 0
else
	#aca tengo que ejecutar el comando
	$BINDIR/AFRARECI.sh &
	afrareciPid=`ps -e | grep '^.* AFRARECI$' | sed 's/ \?\([0-9]*\).*/\1/' | awk '{print $1}' | head -n 1`
	if [ afrareciPid != "" ]; then
		echo "AFRARECI inicializado con PID: ${afrareciPid}"				
		$GRUPO/Gralog.sh "$nombreScript" "Iniciando el demonio AFRARECI con el Process ID: ${afrareciPid}"
		exit 0
	else 
		$GRUPO/Gralog.sh "$nombreScript" "Error al iniciar el proceso AFRARECI"
	fi

fi
