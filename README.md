# IaC_PracticasIntermedias

* PASO 1:

    - En la carpeta donde se clonó el repositorio, ejecutar el comando: ssh-keygen -f practicas_key

dicho comando crea las claves privada y publica para poder realizar la conexion a nuestra EC2 por medio de ssh.

* PASO 2: 

    - En la misma carpeta se crea el archivo llamado terraform.auto.tfvars
        Dicho archivo debe contener las variables de entorno para la configuracion de la infrastructura de aws que terraform creará. 
        Solo se debe copiar el contenido del archivo tfvars-sample.txt ya que este contiene las variables, solo debe sustituir los valores de
        AWS_ACCESS_KEY y AWS_SECRET_ACCESS con los valores de sus credenciales de AWS.

* PASO 3:

    - Correr el comando terraform init para inicializar el repositorio de trabajo de terraform

* PASO 4:

    - Correr el comando terraform plan para validar que todo este configurado correctamente y verificar la infrastructura que se creará.

* PASO 5:

    - Correr el comando terraform apply para inicializar el proceso de contrucción de la infrastructura.

# DESPLIEGUE DE LA APLICACION

La ec2 de ubuntu por defecto viene sin nada instalado, se deben instalar las herramientas necesarias según la aplicación y sus necesidades.

Para el backend se utilizará python con el framework flask para la comunicacion con el cliente por medio de http.
El servidor debe ser expuesto en el puerto 5000 ya que ese es el puerto que le asignamos en el security group.
Se debe correr el servidor con los respectivos comandos de python.

Para el frontend se utilizará los frameworks Node Js y Angular en su última versión. 

El frontend debe ser cargado en un servidor nginx o apache ya compilado para poner en producción la aplicación.

* Paso 1 (CONEXIÓN A LA EC2):

    - Crear las llaves publica y privada con el comando: ssh-keygen -f practicas_key

    - Conectarse a la EC2 con el comando: ssh -i (RUTA A LA CLAVE PRIVADA) ubuntu@(IP PUBLICA DE LA EC2)

* Paso 2 (INSTALAR HERRAMIENTAS):

    COMANDOS DE INSTALACIONES NECESARIAS EN UBUNTU:

        - sudo apt update -y
        - sudo apt upgrade -y
        - sudo apt install git -y
        - sudo apt install python3 -y
        - sudo apt install nginx -y
        - sudo apt install mysql-server -y

    -   Se integró un script llamado setup.sh el cual al ejecutarlo instalara todas las herramientas necesarias para correr la aplicación, también inicializará la base de datos en RDS, unicamente estar atentos a los prompts del script para no detener la ejecución del mismo.

    -   Para poder ejecutar el script es necesario modificar algunos parametros como el DNS de RDS en el último comando y darle permisos al archivo
    -   chmod 777 setup.sh en la ruta del archivo luego de copiarlo en nuestra EC2.
    -   ./setup.sh

* Paso 3 (COPIAR LOS ARCHIVOS DEL PROYECTO):

        - git clone (enlace del repositorio del proyecto)

* Paso 4 (CONECTARSE A LA INSTANCIA DE RDS Y CREAR LA BASE DE DATOS):

        - mysql -h (enlace proporcionado por RDS) -P 3306 -u practicas -p < (ruta al archivo db_init.sql)

* Paso 5 (LAVANTAR EL SERVIDOR DE BACKEND):
        - crear el archivo .env con los parametros de conexion a nuestra base de datos de producción RDS en la carpeta del backend
        - python3 server.py

* Paso 6 (LEVANTAR EL SERVIDOR DE NGINX CON EL FRONTEND):

        - en la carpeta del frontend ya se debe encontrar el build en la carpeta dist de nuestro proyecto angular, para lo cual es necesario modificar el archivo package.json para que nos permita generar la carpeta dist en una ruta espicífica y asi poder subir esa carpeta al repositorio, en el entorno de desarrollo para compilar la versión de producción utilizar el comando: ng build

        - ya con la carpeta dist generada, nos conectamos a nuestra EC2 y navegamos a la siguiente ruta del sistema de archivos y con nano modificamos el archivo de configuración de nginx: sudo nano /etc/nginx/sites-available/(mi_proyecto) 

        - El archivo de configuración de nginx escuchará en el puerto 4200 y debe verse como el siguiente ejemplo:

            server {
                listen 4200;
                server_name (direccion ip publica ec2);

                root (/ruta/a/la/carpeta/dist);

                index index.html;

                location / {
                    try_files $uri $uri/ /index.html;
                }
            }

        - habilitar el sitio nginx con el comando: sudo ln -s /etc/nginx/sites-available/(mi_proyecto) /etc/nginx/sites-enabled/

        - Reiniciar el servicio de nginx con el comando: sudo systemctl restart nginx
