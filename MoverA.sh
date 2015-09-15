#!/bin/bash

#MoverA archivoAMover destino quienLlama(opcional)
#Ejemplo: Mover /ParaProcesar/asd.csv /Procesados ProPro.sh

# NO TIENE QUE PONERSE LA BARRA AL FINAL DE DESTINO

nombreScript="MoverA.sh"

#Controlo la cantidad de parametros
if [ $# -ne 3 -a $# -ne 2 ]
then
	echo "Para utilizar MoverA.sh correctamente:"
	echo "Mover ArchivoAMover Destino ComandoQueLlama(opcional)"
	#registrando en el log
	#$GRUPO/Glog.sh "$nombreScript" 'Comando mal utilizado' 'ERR'  <--- algo asi deberia ser la llamada?
	exit 1
fi

#Paso a variables los parametros
ORIGEN_DIR=$(dirname "$1")
ORIGEN_FILE=$(basename "$1")


### Validaciones ###

#origen tiene que ser distinto de destino
if [ "$ORIGEN_DIR" = "$2" ]
then
	echo "Origen y destino iguales."
	#registro esto en el log
	if [ $# -eq 3 ]
	then
		echo "$3 - Comando MoverA.sh invocado con origen igual a destino. Llamado por $3" #esto se va a guardar en log
	else
		echo "$nombreScript - Comando MoverA.sh invocado con origen igual a destino. Llamado por $3"
	fi
	exit 0
fi


#valido si existe origen
if [ ! -d "$ORIGEN_DIR" ]
then
	echo "No existe el directorio especificado como Origen, operacion no realizada."
	#registro esto en el log
	if [ $# -eq 3 ]
	then
		echo "$3 - No existe directorio $ORIGEN_DIR, archivo $ORIGEN_FILE no movido."
	else
		echo "$nombreScript - Directorio $ORIGENDIR inexistente, archivo $ORIGENFILE no movido."
	fi
	exit 1
fi

#destino tiene que existir
if [ ! -d "$2" ]
then
	echo "No existe el directorio especificado en Destino, operacion no realizada"
	#registro esto en el log
	if [ $# -eq 3 ]
	then
		echo "$3 - No existe directorio $2, archivo $ORIGENFILE no movido."
	else
		echo "$nombreScript - No existe directorio $2, archivo $ORIGENFILE no movido."
	fi
	exit 1
fi

#el archivo tiene que existir
if [ ! -f "$1" ]
then
	echo "No existe el archivo especificado en el Origen"
	#registro esto en el log
	if [ $# -eq 3 ]
	then
		$GRUPO/Glog.sh "$3 - No existe $1."
	else
		$GRUPO/Glog.sh "$nombreScript - No existe $1."
	fi
	exit 1
fi


FILE_DESTINO="$2""/""$ORIGEN_FILE"
## tengo que ver varios casos:
## si existe un archivo en destino con el mismo nombre se tiene que conservar ambos
if [ ! -f "$FILE_DESTINO" ]
then
	#muevo el archivo
	mv "$1" "$FILE_DESTINO" 
	if [ $# -eq 3 ]
	then
		echo "$3 - $1 movido a $2"
	else
		echo "$nombreScript - $1 movido a $2"
	fi
	exit 0
else
	echo "aca es el bardo...."
fi

