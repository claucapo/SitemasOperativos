#!/bin/bash

#Uso: Arrancar.sh 

nombreScript=`basename "$0"`

if [ "$BINDIR" = '' ]; then 
	echo "Ambiente no inicializado"		
	exit 1
fi

afrareciCommandChecker=`ps -e | grep '^.* AFRARECI\.sh$'`

if [ $? -eq 0 ]; then
	pid=`ps -e | grep '^.* AFRARECI\.sh$'` #lo tengo que seguir armando
	echo "Error: AFRARECI se esta ejecutando con PID: ${pid}"
	$GRUPO/GraLog.sh "$nombreScript" "El demonio ya se encuentra corriendo con PID: ${pid}"
	exit 0
else
	#aca tengo que ejecutar el comando
	#$BINDIR/AFRARECI.sh & <-- algo asi deberia ser
	$afrareciCommandChecker
	if [ $? -eq 0 ]; then
		pid=`ps -e | grep '^.* AFRARECI\.sh$'` #todavia no funca
		echo "AFRARECI.sh inicializado con PID: ${pid}"				
		$GRUPO/Gralog.sh "$nombreScript" "Iniciando el demonio AFRARECI con el Process ID: ${pid}"
		exit 0
	fi

fi
