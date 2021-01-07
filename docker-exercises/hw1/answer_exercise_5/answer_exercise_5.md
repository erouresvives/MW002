5. [3 ptos] (Caso de uso) La compañía para la que trabajáis estudia la posibilidad de incorporar a nivel interno una herramienta para la monitorización de logs. Para ello, os han encomendado la tarea de realizar una “Proof of Concept” (PoC). Tras evaluar diferentes productos, habéis considerado que una buena opción es la utilización del producto Elastic stack, cumple con los requisitos y necesidades de la empresa. Tras comentarlo con el CTO a última hora de la tarde, os ha solicitado que preparéis una presentación para mañana a primera hora. Dado el escaso margen para montar la demostración, la opción más ágil y rápida es utilizar una solución basada en contenedores donde levantaréis el motor de indexación (ElasticSearch) y la herramienta de visualización (Kibana). Rellena el siguiente fichero docker-compose para que podáis hacer la demostración al CTO.

    1. Crear un fichero docker-compose.yml con los siguientes contenidos:

        version: '3.6'
        services:

        elasticsearch:
        # Utilizar la imagen de elasticsearch v7.9.3
        image: docker.elastic.co/elasticsearch/elasticsearch:7.9.3

        # Asignar un nombre al contenedor
        container_name: elastic_HM1ex5

        # Define las siguientes variables de entorno:
        # discovery.type=single-node
        environment:
        - discovery.type=single-node

        # Emplazar el contenedor a la red de elastic
        networks: 
        - elastic

        # Mapea el Puerto externo 9200 al puerto interno del contenedor 9200
        # Idem para el puerto 9300
        ports:
        - 9200:9200
        - 9300:9300

        kibana:
        # Utilizar la imagen kibana v7.9.3
        image: docker.elastic.co/kibana/kibana:7.9.3

        # Asignar un nombre al contenedor
        container_name: kibana_HM1ex5

        # Emplazar el contenedor a la red de elastic
        networks: 
        - elastic

        # Define las siguientes variables de entorno:
        # ELASTICSEARCH_HOST=elasticsearch
        # ELASTICSEARCH_PORT=9200
        environment:
        - ELASTICSEARCH_HOST=elasticsearch
        - ELASTICSEARCH_PORT=9200

        # Mapear el puerto externo 5601 al puerto interno 5601
        ports:
        - 5601:5601

        # El contenedor Kibana debe esperar a la disponibilidad del servicio elasticsearch
        depends_on:
        - "elasticsearch"

        # Definir la red elastic (bridge)
        networks:
        elastic:
            driver: bridge

    2. ejecutar el comando en la carpeta en la que se encuentra el fichero:
        - docker-compose up

    3. Acceder al enlace http://localhost:5601/
        - Redirigirá automáticamente a http://localhost:5601/app/home#/
        - Seleccionar Add Metric Data
            - Sample data
                - Add data -> View Data -> Dashboard