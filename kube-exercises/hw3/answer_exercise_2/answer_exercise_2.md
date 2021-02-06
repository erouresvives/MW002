----------------------------------------------------------------------------------------------------
2. [StatefulSet] Crear un StatefulSet con 3 instancias de MongoDB (ejemplo visto en
clase)
----------------------------------------------------------------------------------------------------
• Habilitar el clúster de MongoDB
----------------------------------------------------------------------------------------------------
* Crear un StorageClass

        kubectl apply -f mongodb-storageclass.yaml
        storageclass.storage.k8s.io/storage-mongo created

* Antes de crear el recurso StatefulSet necesitas un servicio del tipo headless. Para que un servicio sea headless simplemente hay que poner la propiedad clusterIP a None.

        kubectl apply -f mongodb-service.yaml
        service/mongodb-service created

        kubectl get svc
        NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)     AGE
        kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP     10m
        mongodb-svc   ClusterIP   None         <none>        27017/TCP   5s

        kubectl describe svc mongo
        Name:              mongo
        Namespace:         default
        Labels:            name=mongo
        Annotations:       <none>
        Selector:          role=mongo
        Type:              ClusterIP
        IP:                None
        Port:              <unset>  27017/TCP
        TargetPort:        27017/TCP
        Endpoints:         <none>
        Session Affinity:  None
        Events:            <none>

* Crear el recurso StatefulSet

        kubectl apply -f mongodb-statefulset.yaml
        statefulset.apps/mongo created

        kubectl get statefulset
        NAME    READY   AGE
        mongo   0/3     8s

        kubectl get pods
        NAME      READY   STATUS    RESTARTS   AGE
        mongo-0   0/1     Pending   0          6m28s

        kubectl describe pods
        Name:           mongo-0
        Namespace:      default
        Priority:       0
        Node:           <none>
        Labels:         app=db
                        controller-revision-hash=mongo-66c9c88d66
                        name=mongodb
                        statefulset.kubernetes.io/pod-name=mongo-0
        Annotations:    <none>
        Status:         Pending
        IP:
        IPs:            <none>
        Controlled By:  StatefulSet/mongo
        Containers:
        mongo:
            Image:      mongo:3.6
            Port:       27017/TCP
            Host Port:  0/TCP
            Command:
            mongod
            Args:
            --bind_ip=0.0.0.0
            --replSet=rs0
            --dbpath=/data/db
            Liveness:     exec [mongo --eval db.adminCommand('ping')] delay=0s timeout=1s period=10s #success=1 #failure=3
            Environment:  <none>
            Mounts:
            /data/db from mongo-storage (rw)
            /var/run/secrets/kubernetes.io/serviceaccount from default-token-wlgfg (ro)
        Conditions:
        Type           Status
        PodScheduled   False
        Volumes:
        mongo-storage:
            Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
            ClaimName:  mongo-storage-mongo-0
            ReadOnly:   false
        default-token-wlgfg:
            Type:        Secret (a volume populated by a Secret)
            SecretName:  default-token-wlgfg
            Optional:    false
        QoS Class:       BestEffort
        Node-Selectors:  <none>
        Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                        node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
        Events:
        Type     Reason            Age    From               Message
        ----     ------            ----   ----               -------
        Warning  FailedScheduling  6m51s  default-scheduler  0/1 nodes are available: 1 pod has unbound immediate PersistentVolumeClaims.
        Warning  FailedScheduling  6m51s  default-scheduler  0/1 nodes are available: 1 pod has unbound immediate PersistentVolumeClaims.


----------------------------------------------------------------------------------------------------
• Realizar una operación en una de las instancias a nivel de configuración y
verificar que el cambio se ha aplicado al resto de instancias
----------------------------------------------------------------------------------------------------

        No he conseguido crear los elementos necesarios en el apartado anterior para poder realizar este punto

----------------------------------------------------------------------------------------------------
• Diferencias que existiría si el montaje se hubiera realizado con el objeto de
ReplicaSet
----------------------------------------------------------------------------------------------------

        Los Pods desplegados por Replicaset son idénticos e intercambiables, creados en orden aleatorio con hashes aleatorios en sus nombres de Pod.

        En cambio, los Pods desplegados por el componente StatefulSet no son idénticos y el despliegue es más complejo. Cada uno de e.los tiene su propia identidad , que se conserva entre los reinicios y cada uno puede ser dirigido individualmente. Por lo tanto, no pueden ser creados o eliminados al mismo tiempo o en cualquier orden.
