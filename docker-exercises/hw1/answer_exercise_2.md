2. Indica la diferencia entre el uso de la instrucción ADD y COPY (Dockerfile).

    COPY y ADD son instrucciones de Dockerfile que sirven a propósitos similares: permiten copiar archivos de una ubicación específica a una imagen Docker.
    
    COPY toma un origen (source) y un destino.
        - Solo te permite copiar en un archivo o directorio local de tu host a la imagen Docker.

    ADD también te permite hacer eso, pero tiene la posibilidad de usar otros 2 orígenes.
        - Primero, puedes usar una URL en lugar de un archivo local o directorio.
        - En segundo lugar, puedes extraer un archivo tar de la fuente directamente al destino.