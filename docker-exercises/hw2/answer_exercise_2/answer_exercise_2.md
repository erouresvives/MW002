-----------------------------------------------------------------------
2. Crear un objeto de tipo replicaSet a partir del objeto anterior con las
siguientes especificaciones:
-----------------------------------------------------------------------
• Debe tener 3 replicas
-----------------------------------------------------------------------

    kubectl create -f replicaset.yaml
    replicaset.apps/nginx-replicaset created

    kubectl get replicaset
    NAME               DESIRED   CURRENT   READY   AGE
    nginx-replicaset   3         3         3       14s

-----------------------------------------------------------------------
¿Cúal sería el comando que utilizarías para escalar el número de replicas a
10?
-----------------------------------------------------------------------

    kubectl scale rs nginx-replicaset --replicas=10
    replicaset.apps/nginx-replicaset scaled

    kubectl get replicaset
    NAME               DESIRED   CURRENT   READY   AGE
    nginx-replicaset   10        10        10      51s

-----------------------------------------------------------------------
Si necesito tener una replica en cada uno de los nodos de Kubernetes,
¿qué objeto se adaptaría mejor? (No es necesario adjuntar el objeto)
-----------------------------------------------------------------------

    DaemonSet : Un DaemonSet garantiza que todos (o algunos) de los nodos ejecuten una copia de un Pod. Conforme se añade más nodos al clúster, nuevos Pods son añadidos a los mismos. Conforme se elimina nodos del clúster, dichos Pods se destruyen. Al eliminar un DaemonSet se limpian todos los Pods que han sido creados.

    ref: https://kubernetes.io/es/docs/concepts/workloads/controllers/daemonset/
        
-----------------------------------------------------------------------
