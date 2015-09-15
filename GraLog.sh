#Ejemplo: GraLog MoverA.sh 'Moviendo archivo de origen a destino' 'INFO'

#INF = INFORMATIVO: mensajes explicativos sobre ejecución de algun comando. Ejemplo: Comando 'X' ha corrido satisfactoriamente
#WAR = WARNING: mensajes de advertencia pero que no afectan la continuidad de ejecución. Ejemplo: Archivo duplicado
#ERR = ERROR: mensajes de error. Ejemplo: Archivo Inexistente.

##$LOGDIR ya tiene que estar seteado a este punto
loggerPathDefault=$LOGDIR"/GraLog.sh.log"
user=$USERNAME

nombreScript='GraLog.sh'

defaultMaxLineas=500  ##discutir cantidad
defaultTipoMensaje='INFO'

ERROR_POR_PARAMETROS=-2

#Si GraLog es llamado sin la cantidad de comandos correctos mostrar mensaje
if [ $# -ne 3 -a $# -ne 2 ]
then
	echo "Gralog no ha sido llamado correctamente. El formato de llamada es:"
	echo "GraLog ComandoQueLlamo 'Mensaje' TipoDeMensaje(opcional)"
	echo `date +%F`"|"`date +%T`" $user $nombreScript ERR Comando Gralog mal utilizado" >> "$loggerPathDefault"
	
	#cantidad de lineas que tiene el log actual
	lineasQueTieneElArchivo=`wc -l $loggerPathDefault | cut -d ' ' -f 1`	
	#aca tengo que hacer la validacion para ver cuando truncar log
	if [ $lineasQueTieneElArchivo -ge $defaultMaxLines ]
	then
		echo "ver que se puede hacer"
	fi
	exit $ERROR_POR_PARAMETROS
fi

if "$1"
case "$1" in
	MoverA.sh)
		archivoLog=$LOGDIR"/"$1".log" ;;
	Gralog.sh)
		archivoLog=$LOGDIR"/"$1".log";;
	Detener.sh)
		archivoLog=$LOGDIR"/"$1".log" ;;
	Arrancar.sh)
		archivoLog=$LOGDIR"/"$1".log" ;;
	AFRAUMBR.sh)
		archivoLog=$LOGDIR"/"$1".log" ;;
	AFRAINST.sh)
		archivoLog=$GRUPO"/conf/"$1".log" ;;
	AFRANIC.sh)
		archivoLog=$LOGDIR"/"$1".log" ;;
	AFRARECI.sh)
		archivoLog=$LOGDIR"/"$1".log" ;;
	*)
		echo `date +%F`"|"`date +%T`" $user $nombreScript $defaultTipoMensaje Comando Gralog no reconocio el script pasado como primer parametro" >> "$loggerPathDefault"
		exit ERROR_POR_PARAMETROS ;;
esac

if [ -f $archivoLog ]
then
	#tamaño log
	tamanioArchivo=`stat -c %s $archivoLog`
	# ver que se puede hacer
else
	#creo log
	touch $archivoLog
fi   


if [ $# -eq 3 ]
then
	echo `date +%F`"|"`date +%T`" $user $1 $3 $2" >> "$archivoLog"
	exit 0
else
	#si entro aca es porque $# -eq 2
	echo `date +%F`"|"`date +%T`" $user $1 $defaultTipoMensaje $2" >> "$archivoLog"
	exit 0
fi

