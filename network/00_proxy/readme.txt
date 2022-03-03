#1.- Crear el deplyment
#2.- Crear el service
#3.- Aixecar el proxy amb la IP del host, el port i acceptant les IPs i el paths que es poden atacar
#4.- Comanda:

kubectl proxy --address='192.168.2.190' --port=8080 --accept-hosts='.*' --accept-paths='^.*' &

curl http://192.168.2.190:8080/api/v1/namespaces/default/services/httpd:80/proxy/
