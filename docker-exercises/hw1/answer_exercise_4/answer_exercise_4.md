4. [2,5 ptos] Crea una imagen docker a partir de un Dockerfile. Esta aplicación expondrá un servicio en el puerto 8080 y se deberá hacer uso de la instrucción HEALTHCHECK para comprobar si la aplicación está ofreciendo el servicio o por si el contrario existe un problema.
El healthcheck deberá parametrizarse con la siguiente configuración:

- La prueba se realizará cada 45 segundos 
    --interval=45s
- Por cada prueba realizada, se esperará que la aplicación responda en menos de 5 segundos. Si tras 5 segundos no se obtiene respuesta, se considera que la prueba habrá fallado 
    --timeout=5s
- Ajustar el tiempo de espera de la primera prueba (Ejemplo: Si la aplicación del contenedor tarda en iniciarse 10s, configurar el parámetro a 15s)
    --start-period=25s
- El número de reintentos será 2. Si fallan dos pruebas consecutivas, el contenedor deberá cambiar al estado “unhealthy”)
    --retries=2

    1. En primer lugar, crear el siguiente Dockerfile:

        FROM nginx:1.19.3
        EXPOSE 80
        HEALTHCHECK --interval=45s --timeout=5s --retries=2 --start-period=25s \
        CMD curl localhost:80 || exit 
    
    - CMD curl localhost:80 || exit , es la prueba a realizar; intentará acceder a localhost:80, y en caso de error ejecutará exit

    2. Creamos una imagen a partir del Dockerfile creado:
        - docker build -t nginx-health .

    3. Una vez creada la imagen, lanzamos el contenedor con ella:
        - docker run -d --name=nginxex4 nginx-health

    4. Con docker ps, podemos observar en la columna status el estado de los recursos del contenedor (health: starting - healthy - unhealthy)

        - docker ps
        CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS                            PORTS     NAMES
        a93470154dad   nginx-health   "/docker-entrypoint.…"   4 seconds ago   Up 3 seconds (health: starting)   80/tcp    nginxex4

        - docker ps
        CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS                    PORTS     NAMES
        a93470154dad   nginx-health   "/docker-entrypoint.…"   59 seconds ago   Up 58 seconds (healthy)   80/tcp    nginxex4
