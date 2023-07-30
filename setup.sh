#!/bin/bash

# Actualiza la lista de paquetes disponibles
sudo apt update -y

# Realiza una actualización del sistema
sudo apt upgrade -y

# Instala Git
sudo apt install git -y

# Instala Python 3
sudo apt install python3 -y

# Instala Nginx
sudo apt install nginx -y

# Instala MySQL Server
sudo apt install mysql-server -y

# Conectarse a RDS y correr el DDL
mysql -h (pegar aqui el dns de RDS) -P 3306 -u practicas -p < db_init.sql 

