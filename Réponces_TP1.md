**6. c.**

La méthode utilisé dans le 5. permet de modifier le contenue d'un docker sans reconstruire l'image.
La méthode 6 avec le Dockerfile permet de créer une image avec le fichier index.html dedans, on peut redéployer cette image, elle aura toujours le meme index.html, il faut reconstruire l'image pour faire une modification.


docker run -d --name phpmyadmin-container -e PMA_HOST=192.168.10.13 -p 8081:80 phpmyadmin

docker run -d --name mysql-container -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=mydb -p 3306:3306 mysql:5.7

**8.**

Docker compose permet de configurer un container avec un fichier .yml cela permet de garder la configuration, contrairement aux commande docker run qui reste dans le terminal.
Il est facile de partager un fichier docker-compose.yml a une autre personne et le containeur lancé par un meme docker-compose aura toujours la meme configuration.

Le moyen de configurer le conteneur mysql au lancement est d'utiliser les la section **"environnement"** en donnant une valeur a une variable utilisable par le conteneur. Ces valeurs sont souvent indiqués sur le repo de l'image. 

'''
environment:
    MYSQL_ROOT_PASSWORD: root
    MYSQL_DATABASE: mydb
    MYSQL_USER: user
    MYSQL_PASSWORD: password
'''


**9. a.**
Voir network-multitool/docker-compose.yml

**9. b.**

*docker inspect web*

'''
            "Networks": {
                "network-multitool_frontend": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": [
                        "web",
                        "web"
                    ],
                    "MacAddress": "02:42:ac:13:00:02",
                    "DriverOpts": null,
                    "NetworkID": "db872ac8cac9e17053d6072d713214a794d201d339ced3164f4ea1ea3f39027f",
                    "EndpointID": "dcebeac9ad6ee91eb74d9f8caaef0b9329bea4554420ccd080a7de2e44eae289",
                    "Gateway": "172.19.0.1",
                    "IPAddress": "172.19.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": [
                        "web",
                        "e90b5d55796b"
                    ]
                }
            }
'''
Dans la parti networks le conteneur web contient uniquement "network-multitool_frontend" qui est le network rattahé au frontend

*docker inspect db*

'''
            "Networks": {
                "network-multitool_backend": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": [
                        "db",
                        "db"
                    ],
                    "MacAddress": "02:42:ac:14:00:03",
                    "DriverOpts": null,
                    "NetworkID": "d9175b3ca95fcc9fb50cf9b28433f439dbefce9befd4ff645f151f1206facfeb",
                    "EndpointID": "62185ddc3e199e910d02c18716edefa2f427635d6cba6c523f8ef5a70a6ff74c",
                    "Gateway": "172.20.0.1",
                    "IPAddress": "172.20.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": [
                        "db",
                        "f0be9c26175f"
                    ]
                }
            }
'''
Dans la parti networks le conteneur web contient uniquement "network-multitool_backend" qui est le network rattahé au backend

*docker inspect db*

'''
            "Networks": {
                "network-multitool_backend": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": [
                        "app",
                        "app"
                    ],
                    "MacAddress": "02:42:ac:14:00:02",
                    "DriverOpts": null,
                    "NetworkID": "d9175b3ca95fcc9fb50cf9b28433f439dbefce9befd4ff645f151f1206facfeb",
                    "EndpointID": "b11bd73221595eda65e43b08f89205be40e9c5d96d7e991f985e4f0bd6df6342",
                    "Gateway": "172.20.0.1",
                    "IPAddress": "172.20.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": [
                        "app",
                        "b466466886bd"
                    ]
                },
                "network-multitool_frontend": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": [
                        "app",
                        "app"
                    ],
                    "MacAddress": "02:42:ac:13:00:03",
                    "DriverOpts": null,
                    "NetworkID": "db872ac8cac9e17053d6072d713214a794d201d339ced3164f4ea1ea3f39027f",
                    "EndpointID": "22ea064f326aa4ad828c0082fc1f74fcc7cb1adb8598a144e4a57f0bfd85409a",
                    "Gateway": "172.19.0.1",
                    "IPAddress": "172.19.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": [
                        "app",
                        "b466466886bd"
                    ]
                }
            }
'''
Dans la parti networks le conteneur app contient les 2 networks: "network-multitool_backend" "network-multitool_frontend"

J'utilise la commande docker exec -it web ping db pour tester un ping depuis le conteneur web vers le conteneur db

Voici ci-dessous le résultat des ping

On a bien 

'''
remi@vm-terraform-1013:~/git/conteneurisation$ docker exec -it web ping db
ping: db: Try again
remi@vm-terraform-1013:~/git/conteneurisation$ docker exec -it web ping app
PING app (172.19.0.3) 56(84) bytes of data.
64 bytes from app.network-multitool_frontend (172.19.0.3): icmp_seq=1 ttl=64 time=0.099 ms
64 bytes from app.network-multitool_frontend (172.19.0.3): icmp_seq=2 ttl=64 time=0.034 ms
64 bytes from app.network-multitool_frontend (172.19.0.3): icmp_seq=3 ttl=64 time=0.040 ms
^C
--- app ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2036ms
rtt min/avg/max/mdev = 0.034/0.057/0.099/0.029 ms
remi@vm-terraform-1013:~/git/conteneurisation$ docker exec -it app ping db
PING db (172.20.0.3) 56(84) bytes of data.
64 bytes from db.network-multitool_backend (172.20.0.3): icmp_seq=1 ttl=64 time=0.113 ms
64 bytes from db.network-multitool_backend (172.20.0.3): icmp_seq=2 ttl=64 time=0.041 ms
^C
--- db ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1015ms
rtt min/avg/max/mdev = 0.041/0.077/0.113/0.036 ms
remi@vm-terraform-1013:~/git/conteneurisation$ docker exec -it db ping web
ping: web: Try again
'''

On a bien web et db qui ne peuvent pas se ping, mais les deux peuvent ping app

**9. c.**

Prenons l'exemple d'une application web:

Frontend: Nginx

Backend: Express

Base de données: Mysql
