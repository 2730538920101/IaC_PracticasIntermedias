#!/bin/bash

# Actualiza la lista de paquetes disponibles
sudo apt update -y

# Realiza una actualización del sistema
sudo apt upgrade -y

# Instala Python 3
sudo apt install python3 -y
sudo apt install python3-pip -y
sudo pip install -r /backend/requirements.txt

# Instala Nginx
sudo apt install nginx -y
sudo mkdir -p /data/nginx
sudo cp -R /home/ubuntu/dist/frontend /data/nginx
sudo cp /home/ubuntu/angular.conf /etc/nginx/conf.d/
sudo nginx -t
sudo systemctl status nginx
sudo systemctl restart nginx
sudo systemctl status nginx


# Instala MySQL Server
sudo apt install mysql-server -y

# Conectarse a RDS y correr el DDL
mysql -h (pegar aqui el dns de RDS) -P 3306 -u practicas -D PracticasI_db -p < db_init.sql 

