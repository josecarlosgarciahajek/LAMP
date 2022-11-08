#!/bin/bash
###### VARIABLES ########
blank="¡¡Debes de aceptar/denegar la opción!!"

###### FUNCIONES #######
whoroot(){
if [ `whoami` != 'root' ]; then
	echo "Debes de ejecutarme con sudo." && exit
fi
}
apache(){
case $ap in
	0) echo "Apache" && ap=1 ;;
	1) sudo apt-get install apache2 -y > /dev/null && ap=2 ;;
	2) sudo nano /etc/apache2/sites-available/000-default.conf ;;
esac
}
mysql(){
case $sql in
	0) echo "MySQL server" && sql=1	;;
	1) sudo apt-get install mysql-server -y > /dev/null && sql=2 ;;
	2) echo "Configuración de MySQL"
		echo "¡¡IMPORTANTE, SE REQUIERE TENER MySQL SERVER para hacer el siguente paso!!"
		while true; do
			read -p "¿Quieres introducir un usuario administrador? " user
			case $user in
				s)
					read -p "Introducir el usuario administrador: " usuario
					read -p "Introducir la contraseña para el administrador: " pass
					echo "Creando usuario..."
					sudo mysql -e "create user '${usuario}'@'%' identified by '${pass}';"
					sudo mysql -e "grant all on *.* to '${usuario}'@'%' with grant option;"
					sudo mysql -e "flush privileges;"
					echo "" && break ;;
				n) 	echo "" && break ;;
				*)	echo $blank ;;
			esac
		done
		sql=3 ;;
	3)	echo "¡ATENCIÓN! Se REQUIERE MySQL SERVER o CLIENTE para hacer los siguientes pasos,"
		echo "sinó dará errores."
		while true; do
			read -p "¿Quieres importar una base de datos? [s/n] " import
			case $import in
			s)	while true; do
					read -p "Pon el nombre y la ruta del archivo sql: " bdsql
					read -p "¿La base de datos está el servidor local? [s/n] " local
					case $local in
						s)	read -p "Introducir el usuario administrador: " usuario
							read -p "Introducir la contraseña para el administrador: " pass
							mysql -u ${usuario} --password="${pass}" < $bdsql &> /dev/null
							break ;;
						n)
							read -p "Introduzca la ip del servidor: " ipaddr
							read -p "Introducir el usuario administrador: " usuario
							read -p "Introducir la contraseña para el administrador: " pass
							mysql -u ${usuario} --password="${pass} -h $ipaddr" < $bdsql &> /dev/null
							break ;;
						*)	echo $blank ;;
					esac
					read -p "Has terminado de importar? [s/n] " selimp
					case $selimp in
					s) echo "" && break ;;
					n) echo "" ;;
					esac
				done
				echo "IMPORTADO" && echo "" && break;;
			n) echo "" && break ;;
			*) echo $blank ;;
			esac
		done
		sql=4 ;;
	4)	while true; do
			read -p "¿Quieres securizar la base de datos? Advertencia, esto bloqueará el acceso root. [s/n] " bloqroot
			case $bloqroot in
			s) sudo mysql -e "alter user 'root'@'localhost' identified with mysql_native_password by '5P3cial';" && break ;;
			n) echo "No se ha securizado" && break ;;
			*) echo $blank ;;
			esac
		done
		sql=5 ;;
	5)	echo "Para que se pueda acceder desde fuera se necesita editar un archivo de configuración."
		while true; do
			read -p "¿Quieres editarlo ahora? [s/n] " adrr
			case $adrr in
			s) sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf && break;;
			n) echo "No editado" && break ;;
			*) echo $blank ;;
			esac
		done
		sql=6 ;;
esac
}
phpint(){
case $phpc in
	0) echo "PHP" && phpc=1 ;;
	1) sudo apt-get install php -y > /dev/null && phpc=2 ;;
	2)	echo "Para que la página web sea dinamica necesita unos paquetes adicionales."
		echo "Se puede instalar de manera separada."
		echo "El módulo de apache sireve para que las páginas en php puedan ser visibles"
		echo "desde el servidor de apache"
		echo "El módulo de mysql sirve para conectar a una base de datois MySQL desde"
		echo "código PHP."
		while true; do
			read -p "¿Quieres instalar el modulo de php para apache? [s/n] " lib1
			case $lib1 in
				s) sudo apt-get install libapache2-mod-php -y > /dev/null && echo "" && break ;;
				n) echo ""&& break ;;
				*) echo $blank ;;
			esac
		done
		while true; do
			read -p "¿Quieres instalar el modulo de php para MySQL? [s/n] " lib2
			case $lib2 in
				s) sudo apt-get install php-mysql -y > /dev/null && echo "" && break ;;
				n) echo "" ;;
				*) echo $blank ;;
			esac
		done ;;
esac
}
gitimp(){
	read -p "Introduzca el usuario de github: " gituser
	read -p "Introduzca el nombre del repositorio: " gitrepo
	git clone https://github.com/$gituser/$gitrepo
	mv $gitrepo /var/www/html/
	echo "¡Se debe de modificar el archivo 000-default.conf para que el index sea accesible!"
	sudo systemctl restart apache2.service

}

########### SELECCIÓN DE LOS SERVICIOS #######################
whoroot
clear
echo "---------------------------------------------------------------------"
echo "                     Instalación de pila LAMP                        "
echo "---------------------------------------------------------------------"
echo ""
echo ""
echo "Bienvenido a este instalador."
echo "Se está aplicando las configuraciones optimas para el instalador."
echo "Espere un momento..."
sudo apt-get update > /dev/null
echo "Configuración completada, puede seguir con el instalador."
sleep 3
echo "Este script contiene la selección de los paquetes y la configuración"
echo "del mismo."
echo "Las opciones se contestarán por s o n."
while true; do
    read -p "¿Quieres instalar apache? [s/n] " ap
    case $ap in
    	s) ap=0 && echo "" && break ;;
    	n) echo "" && break ;;
    	*) echo $blank ;;
    esac
done
while true; do
    read -p "¿Quieres instalar MySQL server? [s/n] " sql
    case $sql in
    	s) sql=0 && echo "" && break ;;
    	n) echo "" && break ;;
    	*) echo $blank ;;
    esac
done
while true; do
    read -p "¿Quieres instalar PHP? [s/n] " phpc
    case $phpc in
    	s) phpc=0 && echo "" && break ;;
    	n) echo "" && break ;;
    	*) echo $blank ;;
    esac
done
######### SERVICIOS A INSTALAR ############
echo "Se instalarán los siguentes servicios:"
apache
mysql
phpint
######### INSTALANDO DE LOS SERVICIOS ##############
while true; do
    read -p "¿Seguro que quieres instalar estos servicios? [s/n] " inst
    case $inst in
    	s)  echo "Instalando..."
	    	echo "La instalación puede demorar dependiendo de la calidad de tu internet y/o equipo."
	    	apache && mysql && phpint
	    	echo "Se ha instalado los servicios."
    		echo "" && break ;;
    	n)  echo "¡Se ha cancelado la instalación!"
		    sleep 2 && clear && exit ;;
	    *)  echo $blank ;;
    esac
done
######### CONFIGURACIÓN DE LOS SERVICIOS ##############
while true; do
    read -p "¿Quieres implantar la app web ahora? [s/n] " sel
    case $sel in
	s) gitimp && echo "" && break ;;
	n) echo "" && break ;;
	*) echo $blank ;;
    esac
done
while true; do
    read -p "¿Quieres configurar apache? [s/n] " confap
    case $confap in
    	s) apache && echo "" && break ;;
    	n) echo "" && break ;;
	*) echo $blank ;;
    esac
done
while true; do
read -p "¿Quieres configurar mysql? [s/n] " confsql
case $confsql in
	s) sql=3
	   while [ $sql -ne 6 ]; do
		mysql
	   done
		echo "" && break ;;
	n) echo "" && break ;;
	*) echo $blank ;;
esac
done
while true; do
read -p "¿Quieres configurar PHP (recomendado)? [s/n] " confphp
case $confphp in
	s) phpint && echo "" && break;;
	n) echo "" && break ;;
	*) echo $blank ;;
esac
done
echo "¡Configuración completada!"
sleep 3
clear
