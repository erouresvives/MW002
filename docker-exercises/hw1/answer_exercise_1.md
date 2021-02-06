1. Indica la diferencia entre el uso de la instrucción CMD y ENTRYPOINT (Dockerfile).

    CMD define los comandos y/o parámetros por defecto para un contenedor.
        - CMD es una instrucción que es mejor usar si se necesita un comando por defecto que los usuarios pueden anular fácilmente.
        - Si un Dockerfile tiene varios CMD, sólo aplica las instrucciones del último.

    ENTRYPOINT es utilizado cuando se desea definir un contenedor con un ejecutable específico.
        - No se puede anular un ENTRYPOINT al iniciar un contenedor a menos que se añada el indicador --entrypoint.

    Es posible combinar ENTRYPOINT con CMD si necesita un contenedor con un ejecutable específico y un parámetro predeterminado que se pueda modificar fácilmente.
        - Por ejemplo, cuando se incluye un contenedor en una aplicación, utilizamos ENTRYPOINT y CMD para establecer variables específicas del entorno.