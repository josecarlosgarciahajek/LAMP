# Explicación del script.
El script es un instalador básico y guiado para la instalación de servicios para la pila LAMP
El script está dividido por servicios y funciones

## Variable
##### $blank
- Es un echo diciendo que debes de seleccionar una opción dentro del case.

## Funciones

##### whoroot
- Verifica que el script se ejecute mediante sudo.

##### apache
- Instalar apache.
- Editar el archivo de configuración.
- Si es un balanceador de carga, habilita los modulos necesarios.

##### mysql
- Instalar mysql-server.
- Crear un usuario administrador desde le propio scritp.
- Importar una base de datos. OJO IMPORTANTE, ES NECESARIO TENER MYSQL SERVER O CLIENTE para hacer el resto de acciones. En el script lo detalla.
- Securizar el acceso root.

##### phpint
- Instalar php.
- Instalar libapache2-lib-php.
- Instalar php-mysql.
##### gitimp
- Hacer un git clone especificando en nombre del usuario y la contraseña.

## Instalador
Las preguntas están dentro de un while, es decir, si respondes mal no te dejará seguir con la instalación hasta que se seleccione la opción correcta. Hay una variable que imprime el mensaje de error.

## Configuración
Al finalizar de instalar los servicios se puede configurar de manera "limitada", cada uno será responsable de lo que edite y lo que no edite.

## Descargo de responsabilidades
No me hago responsable de que mi script ha dado problemas en un servidor dado que este script.
Ha sido ejecutado sin problemas en varios servidores.


###### José Carlos García Hájek©
