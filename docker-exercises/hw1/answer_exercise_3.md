3. [2,5 ptos] Crea un contenedor con las siguientes especificaciones:
    a. Utilizar la imagen base NGINX haciendo uso de la versión 1.19.3
    b. Al acceder a la URL localhost:8080/index.html aparecerá el mensaje HOMEWORK 1
    c. Persistir el fichero index.html en un volumen llamado static_content

    1. Creación del volumen llamado static_content
        - docker volume create static_content

    2. Confirmar que se ha creado con éxito el volumen
        - docker volume inspect static_content

        [
            {
                "CreatedAt": "2021-01-03T18:12:46Z",
                "Driver": "local",
                "Labels": {},
                "Mountpoint": "/var/lib/docker/volumes/static_content/_data",
                "Name": "static_content",
                "Options": {},
                "Scope": "local"
            }
        ]

    3. Lanzar un contenedor usando como imagen base NGINX 1.19.3, vinculada al volumen "static_content" (-v static_content:/var/lib/html), en el puerto 8080 (-dp       8080:80)
        - docker run -dp 8080:80 --name containerex3 -it -v static_content:/var/lib/html nginx:1.19.3

    4. En este momento, al acceder a localhost:8080/index.html, aparece el mensaje "WELCOME TO NGINX", aun queda sustituir el fichero index.html original de nginx por uno propio con el título "HOMEWORK 1". 

    5. Creamos un fichero index.html como el siguiente:

    <!DOCTYPE html>
    <html>
    <head>
    <title>HOMEWORK 1</title>
    <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
    </style>
    </head>
    <body>
    <h1>HOMEWORK 1</h1>
    </body>
    </html>

    6. Acto seguido, remplazaremos el index.html del contenedor por el recién creado. Para ello, necesitaremos el identificador del contenedor:
        - docker ps
        
        CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS              PORTS                  NAMES
        10b17725fe2c   nginx:1.19.3   "/docker-entrypoint.…"   3 minutes ago   Up About a minute   0.0.0.0:8080->80/tcp   containerex3

    7. Una vez conocemos el identificador (10b17725fe2c), copiamos el fichero en su interior. 
        - docker cp index.html 10b17725fe2c:/usr/share/nginx/html/

    8. al refrescar el navegador (control+F5) aparece el título ¨HOMEWORK 1¨
