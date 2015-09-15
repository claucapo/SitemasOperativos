#!/bin/bash

#Uso: Arrancar.sh 

nombreScript=`basename "$0"`

if [ "$BINDIR" = '' ]; then
	echo "Ambiente no inicializado"		
	exit 1
fi

x=`ps -e | grep '^.* AFRARECI\.sh$'`

if [ $? -eq 0 ]; then
	pid=`ps -e | grep ` #lo tengo que seguir armando
	echo "Error: AFRARECI se esta ejecutando con PID: ${pid}"
	#tengo que guardar esto en el log?
	exit 0
else
	#aca tengo que ejecutar el comando
fi
