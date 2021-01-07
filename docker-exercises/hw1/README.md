ej4. He utilizado el puerto 80 en vez de 8080, dado que este último generaba ¨unhealthy¨ en todos los intentos realizados con las imágenes de nginx y Elasticsearch.

    - Dockerfile: 
        FROM nginx:1.19.3
        EXPOSE 8080/tcp
        HEALTHCHECK --interval=45s --timeout=5s --start-period=25s --retries=2 CMD curl --fail http://localhost:8080 || exit 1

    - docker build -t imageex4 .
    - docker run -d --name=containerex4 imageex4

    - docker ps
    CONTAINER ID   IMAGE      COMMAND                  CREATED          STATUS                             PORTS              NAMES
    f47f8b139226   imageex4   "/docker-entrypoint.…"   29 seconds ago   Up 29 seconds (health: starting)   80/tcp, 8080/tcp   containerex4

    - docker ps
    CONTAINER ID   IMAGE      COMMAND                  CREATED              STATUS                          PORTS              NAMES
    1c9eafd1a8bd   imageex4   "/docker-entrypoint.…"   About a minute ago   Up About a minute (unhealthy)   80/tcp, 8080/tcp   containerex4


