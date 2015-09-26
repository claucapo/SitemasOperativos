#Ejemplo: GraLog MoverA.sh 'Moviendo archivo de origen a destino' 'INFO'

#INFO = INFORMATIVO: mensajes explicativos sobre ejecución de algun comando. Ejemplo: Comando 'X' ha corrido satisfactoriamente
#WAR = WARNING: mensajes de advertencia pero que no afectan la continuidad de ejecución. Ejemplo: Archivo duplicado
#ERR = ERROR: mensajes de error. Ejemplo: Archivo Inexistente.



# - Se debe controlar el crecimiento del archivo de log
#	· En todo sistema, es importante evitar el crecimiento INDISCRIMINADO de los archivos de Log. 
#		Es por ello que esta función debe preveer un mecanismo para controlarlo y evitarlo
#	· En este mecanismo se debe tener en cuenta la variable de configuración LOGSIZE que representa el tamaño 
#			máximo que puede alcanzar un archivo de log en nuestrosistema.
#	· Este tamaño máximo es un valor de referencia ya que a los efectos prácticos, todo depende del momento en que se realiza el control.
#	· Lo importante es que SIEMPRE adopte un mecanismo para mantener controlado el
#		tamaño de un log. Puede adoptar cualquier mecanismo, aclare en Hipótesis y Aclaraciones Globales cual fue el que adoptó.

##$LOGDIR ya tiene que estar seteado a este punto
loggerPathDefault=$LOGDIR"/GraLog.sh.log"
user=$USER

nombreScript='GraLog.sh'

defaultTipoMensaje='INFO'
BYTES_IN_KB=1024

ERROR_POR_PARAMETROS=-2

where=$1	#desde donde se lanza script
why=$2		#mensaje que se quiere loguear

function division(){ # la necesito para calcular el tamaño en kb 
	echo $(($1 + $2/2) / $2)
}

function maxSizeHandler(){
	tamanioArchivoBytes=`stat -c %s $archivoLog` #obtengo la cantidad de bytes
	tamanioArchivoKbytes=$(division tamanioArchivoBytes BYTES_IN_KB)
	if [ $TAMANIO_kb -gt $LOGSIZE ]
	then
		temp='templog.log'
		echo " Log Excedido. " >> $temp 
		tail -n 50 $archivoLog >> $temp 		#agrego las ultimas 50 lineas del log viejo al nuevo.
		rm $archivoLog
		mv $temp $archivoLog
	fi
}

#Si GraLog es llamado sin la cantidad de comandos correctos mostrar mensaje
if [ $# -ne 3 -a $# -ne 2 ]
then
	echo "Gralog no ha sido llamado correctamente. El formato de llamada es:"
	echo "GraLog ComandoQueLlamo 'Mensaje' TipoDeMensaje(opcional)"
	echo `date +%F`"|"`date +%T`" $user $nombreScript ERR Comando Gralog mal utilizado" >> "$loggerPathDefault"
	
	archivoLog=$loggerPathDefault
	
	exit $ERROR_POR_PARAMETROS
fi



case "$1" in
	MoverA.sh)
		archivoLog=$LOGDIR"/"$where".log" ;;
	Gralog.sh)
		archivoLog=$LOGDIR"/"$where".log";;
	Detener.sh)
		archivoLog=$LOGDIR"/"$where".log" ;;
	Arrancar.sh)
		archivoLog=$LOGDIR"/"$where".log" ;;
	AFRAUMBR.sh)
		archivoLog=$LOGDIR"/"$where".log" ;;
	AFRAINST.sh)
		archivoLog=$GRUPO"/conf/"$where".log" ;;
	AFRANIC.sh)
		archivoLog=$LOGDIR"/"$where".log" ;;
	AFRARECI.sh)
		archivoLog=$LOGDIR"/"$where".log" ;;
	*)
		echo `date +%F`"|"`date +%T`" $user $nombreScript $defaultTipoMensaje Comando Gralog no reconocio el nombre del script $where" >> "$loggerPathDefault"
		exit ERROR_POR_PARAMETROS ;;
esac

if [ -f $archivoLog ]
then
	#valido tamaño log
	maxSizeHandler #llamo a funcion que checkea
else
	#creo log
	touch $archivoLog
fi   

	
if [ $# -eq 3 ]
then
	echo `date +%F`"|"`date +%T`" $user $where $3 $why" >> "$archivoLog"
	exit 0
else
	#si entro aca es porque $# -eq 2
	echo `date +%F`"|"`date +%T`" $user $where $defaultTipoMensaje $why" >> "$archivoLog"
	exit 0
fi

