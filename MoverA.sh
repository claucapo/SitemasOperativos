#!/bin/bash

#MoverA.sh archivoAMover destino quienLlama(opcional)
#Ejemplo: MoverA.sh /ParaProcesar/asd.csv /Procesados AFRARECI

# NO SE DEBE AGREGAR BARRA AL FINAL DE DESTINO

## Requerimiento:
# - Mover el archivo solicitado al directorio indicado sin alterar su contenido
# - Si en el destino ya existe otro archivo con el mismo nombre (nombre de archivo duplicado), no debe fracasar la operación, la función debe poder conservar ambos.
#	· Crear un subdirectorio /duplicados para depositar el archivo duplicado y moverlo allí
# - Si no obstante ello, también en /duplicados ya existe otro archivo con el mismo nombre, 
# 	· Emplear una secuencia para complementar el nombre del archivo por ejemplo: <nombre del archivo original>.nnn dónde nnn es un número de secuencia
# - Si esta función es invocada por un comando que graba en un archivo de log, registrar el resultado de su uso en el log del comando

nombreScript="MoverA.sh"

#Controlo la cantidad de parametros
if [ $# -ne 3 -a $# -ne 2 ]
then
	echo "Para utilizar MoverA.sh correctamente:"
	echo "Mover ArchivoAMover Destino ComandoQueLlama(opcional)"
	#registrando en el log
	"$BINDIR"/GraLog.sh "$nombreScript" 'Comando mal utilizado' 'INFO'
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
		"$BINDIR"/GraLog.sh "$3" "Comando MoverA.sh invocado con origen igual a destino. Llamado por $3" "ERR"
	else
		"$BINDIR"/GraLog.sh "$nombreScript" "Comando MoverA.sh invocado con origen igual a destino. Llamado por $3" "ERR"
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
		"$BINDIR"/GraLog.sh "$3" "No existe directorio $ORIGEN_DIR, archivo $ORIGEN_FILE no movido." "ERR"
	else
		"$BINDIR"/GraLog.sh "$nombreScript" "Directorio $ORIGEN_DIR inexistente, archivo $ORIGEN_FILE no movido." "ERR"
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
		"$BINDIR"/GraLog.sh "$3" "No existe directorio $2, archivo $ORIGEN_FILE no movido." "ERR"
	else
		"$BINDIR"/GraLog.sh "$nombreScript" "No existe directorio $2, archivo $ORIGEN_FILE no movido." "ERR"
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
		"$BINDIR"/GraLog.sh "$3" "No existe $1." "ERR"
	else
		"$BINDIR"/GraLog.sh "$nombreScript" "No existe $1." "ERR"
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
		"$BINDIR"/GraLog.sh "$3" "$1 movido a $2" "INFO"
	else
		"$BINDIR"/GraLog.sh "$nombreScript" "$1 movido a $2" "INFO"
	fi
	exit 0
else
	#Hipotesis General: Se va usar solo un numero de secuencia para toda la instalacion
	#Hay que buscar en el archivo de configuracion el numero de secuencia (considero que va a tener nombre SECUENCIA)
	sec_value=`grep SECUENCIA "$CONFDIR"/AFRAINST.conf | cut -d '=' -f 2`
	#Actualizar el valor de secuencia dentro del archivo de configuracion
	new_value=$((sec_value + 1))
	#Hipotesis General: Se va  usar un unico directorio de /duplicados para todo el sistema
	sed -i s/SECUENCIA=$sec_value/SECUENCIA=$new_value/ "$CONFDIR"/AFRAINST.conf
	#Mover el archivo al directorio /duplicados y le agrego al nombre del archivo la secuencia
	if ! [ -d "$2/duplicados" ] ; then
	    mkdir "$2/duplicados"
	fi
	mv "$2/$ORIGEN_FILE" "$2/duplicados/$ORIGEN_FILE.$sec_value"
fi

