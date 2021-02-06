-----------------------------------------------------------------------
4. Crear un objeto de tipo deployment con las especificaciones del ejercicio 1.
-----------------------------------------------------------------------
• Despliega una nueva versión de tu nuevo servicio mediante la técnica
“recreate”
-----------------------------------------------------------------------
* Para este ejercicio, el update consistirá en pasar de la versión nginx:1.18, a la más reciente
* Creamos el deployment a partir del fichero deployment-recreate.yaml, y nos aseguramos que todos los elementos han sido creados correctamente

    kubectl create -f deployment-recreate.yaml
    deployment.apps/nginx-deployment created

    kubectl get pods
    NAME                                READY   STATUS    RESTARTS   AGE
    nginx-deployment-75f8c5b686-28kn8   1/1     Running   0          37s
    nginx-deployment-75f8c5b686-4sl7l   1/1     Running   0          37s
    nginx-deployment-75f8c5b686-xjfl2   1/1     Running   0          37s

    kubectl get replicaset
    NAME                          DESIRED   CURRENT   READY   AGE
    nginx-deployment-75f8c5b686   3         3         3       27s

    kubectl get deployments
    NAME               READY   UP-TO-DATE   AVAILABLE   AGE
    nginx-deployment   3/3     3            3           54s

* En este primer deploy, los pods generados contienen una versión antigua de nginx, en el campo "Image: nginx:1.18"

    kubectl describe pod nginx-deployment-75f8c5b686-28kn8
    Name:         nginx-deployment-75f8c5b686-28kn8
    Namespace:    default
    Priority:     0
    Node:         minikube/192.168.49.2
    Start Time:   Sat, 23 Jan 2021 14:23:48 +0100
    Labels:       app=nginx-service
                  pod-template-hash=75f8c5b686
    Annotations:  <none>
    Status:       Running
    IP:           172.17.0.2
    IPs:
      IP:           172.17.0.2
    Controlled By:  ReplicaSet/nginx-deployment-75f8c5b686
    Containers:
      nginx-service:
        Container ID:   docker://2b5e3cdc985ba3ad3d16dc978e394153dfa6b40b9918c62d96df165c3b6501c9
        Image:          nginx:1.18
        Image ID:       docker-pullable://nginx@sha256:ebd0fd56eb30543a9195280eb81af2a9a8e6143496accd6a217c14b06acd1419
        Port:           8081/TCP
        Host Port:      0/TCP
        State:          Running
          Started:      Sat, 23 Jan 2021 14:23:51 +0100
        Ready:          True
        Restart Count:  0
        Limits:
          cpu:     100m
          memory:  256Mi
        Requests:
          cpu:        100m
          memory:     256Mi
        Environment:  <none>
        Mounts:
          /var/run/secrets/kubernetes.io/serviceaccount from default-token-wlgfg (ro)
    Conditions:
      Type              Status
      Initialized       True
      Ready             True
      ContainersReady   True
      PodScheduled      True
    Volumes:
      default-token-wlgfg:
        Type:        Secret (a volume populated by a Secret)
        SecretName:  default-token-wlgfg
        Optional:    false
    QoS Class:       Guaranteed
    Node-Selectors:  <none>
    Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                    node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
    Events:
      Type    Reason     Age   From               Message
      ----    ------     ----  ----               -------
      Normal  Scheduled  74s   default-scheduler  Successfully assigned default/nginx-deployment-75f8c5b686-28kn8 to minikube
      Normal  Pulling    73s   kubelet            Pulling image "nginx:1.18"
      Normal  Pulled     71s   kubelet            Successfully pulled image "nginx:1.18" in 1.8038936s
      Normal  Created    71s   kubelet            Created container nginx-service
      Normal  Started    71s   kubelet            Started container nginx-service

* El siguiente comando nos muestra distintos elementos del deployment, antes de lanzar la actualización

    kubectl get deploy,rs,po -l app=nginx-service
    NAME                                          DESIRED   CURRENT   READY   AGE
    replicaset.apps/nginx-deployment-75f8c5b686   3         3         3       3m17s

    NAME                                    READY   STATUS    RESTARTS   AGE
    pod/nginx-deployment-75f8c5b686-28kn8   1/1     Running   0          3m17s
    pod/nginx-deployment-75f8c5b686-4sl7l   1/1     Running   0          3m17s
    pod/nginx-deployment-75f8c5b686-xjfl2   1/1     Running   0          3m17s


* Actualizamos la imagen nginx:1.18 por una versión más reciente

    kubectl set image deploy nginx-deployment nginx-service=nginx:latest
    deployment.apps/nginx-deployment image updated

* Lanzando sucesivamente el comando anterior para visualizar los componentes del deploy, podremos observar que al tratarse de un Recreate, primero elimina los pods existentes, y acto seguido crea los nuevos

    kubectl get deploy,rs,po -l app=nginx-service
    NAME                                          DESIRED   CURRENT   READY   AGE
    replicaset.apps/nginx-deployment-75f8c5b686   0         0         0       4m19s

    NAME                                    READY   STATUS        RESTARTS   AGE
    pod/nginx-deployment-75f8c5b686-4sl7l   0/1     Terminating   0          4m19s
    pod/nginx-deployment-75f8c5b686-28kn8   0/1     Terminating   0          4m19s
    pod/nginx-deployment-75f8c5b686-xjfl2   0/1     Terminating   0          4m19s


    kubectl get deploy,rs,po -l app=nginx-service
    NAME                                          DESIRED   CURRENT   READY   AGE
    replicaset.apps/nginx-deployment-5c6985586c   3         3         0       1s
    replicaset.apps/nginx-deployment-75f8c5b686   0         0         0       4m41s

    NAME                                    READY   STATUS              RESTARTS   AGE
    pod/nginx-deployment-5c6985586c-mnrjt   0/1     ContainerCreating   0          1s
    pod/nginx-deployment-5c6985586c-q2b5z   0/1     ContainerCreating   0          1s
    pod/nginx-deployment-5c6985586c-vlv5q   0/1     ContainerCreating   0          1s


    kubectl get deploy,rs,po -l app=nginx-service
    NAME                                          DESIRED   CURRENT   READY   AGE
    replicaset.apps/nginx-deployment-5c6985586c   3         3         3       60s
    replicaset.apps/nginx-deployment-75f8c5b686   0         0         0       5m40s

    NAME                                    READY   STATUS    RESTARTS   AGE
    pod/nginx-deployment-5c6985586c-mnrjt   1/1     Running   0          60s
    pod/nginx-deployment-5c6985586c-q2b5z   1/1     Running   0          60s
    pod/nginx-deployment-5c6985586c-vlv5q   1/1     Running   0          60s


* Buscamos la descripción de uno de los nuevos pods para comprobar que ha sido actualizado a nginx:latest (Image:          nginx:latest)

    kubectl describe pod nginx-deployment-5c6985586c-mnrjt

    kubectl describe pod nginx-deployment-5c6985586c-mnrjt
    Name:         nginx-deployment-5c6985586c-mnrjt
    Namespace:    default
    Priority:     0
    Node:         minikube/192.168.49.2
    Start Time:   Sat, 23 Jan 2021 14:28:28 +0100
    Labels:       app=nginx-service
                  pod-template-hash=5c6985586c
    Annotations:  <none>
    Status:       Running
    IP:           172.17.0.2
    IPs:
      IP:           172.17.0.2
    Controlled By:  ReplicaSet/nginx-deployment-5c6985586c
    Containers:
      nginx-service:
        Container ID:   docker://b8db30ae4295abcf204493e26872f67c1c479250444a897b2e90a2a4af9b1002
        Image:          nginx:latest
        Image ID:       docker-pullable://nginx@sha256:10b8cc432d56da8b61b070f4c7d2543a9ed17c2b23010b43af434fd40e2ca4aa
        Port:           8081/TCP
        Host Port:      0/TCP
        State:          Running
          Started:      Sat, 23 Jan 2021 14:28:56 +0100
        Ready:          True
        Restart Count:  0
        Limits:
          cpu:     100m
          memory:  256Mi
        Requests:
          cpu:        100m
          memory:     256Mi
        Environment:  <none>
        Mounts:
          /var/run/secrets/kubernetes.io/serviceaccount from default-token-wlgfg (ro)
    Conditions:
      Type              Status
      Initialized       True
      Ready             True
      ContainersReady   True
      PodScheduled      True
    Volumes:
      default-token-wlgfg:
        Type:        Secret (a volume populated by a Secret)
        SecretName:  default-token-wlgfg
        Optional:    false
    QoS Class:       Guaranteed
    Node-Selectors:  <none>
    Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                    node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
    Events:
      Type    Reason     Age    From               Message
      ----    ------     ----   ----               -------
      Normal  Scheduled  4m8s   default-scheduler  Successfully assigned default/nginx-deployment-5c6985586c-mnrjt to minikube
      Normal  Pulling    4m8s   kubelet            Pulling image "nginx:latest"
      Normal  Pulled     3m41s  kubelet            Successfully pulled image "nginx:latest" in 26.4238492s
      Normal  Created    3m41s  kubelet            Created container nginx-service
      Normal  Started    3m41s  kubelet            Started container nginx-service


* Eliminamos todos los elementos generados para finalizar
    kubectl delete deployment nginx-deployment

-----------------------------------------------------------------------
• Despliega una nueva versión haciendo “rollout deployment”
-----------------------------------------------------------------------

* Para este ejercicio, el update consistirá en pasar de la versión nginx:1.18, a la más reciente
* Creamos el deployment a partir del fichero deployment-rollingupdate.yaml, y nos aseguramos que todos los elementos han sido creados correctamente

    kubectl create -f deployment-rollingupdate.yaml
    deployment.apps/nginx-deployment created

    kubectl get pods
    NAME                                READY   STATUS    RESTARTS   AGE
    nginx-deployment-75f8c5b686-4vx44   1/1     Running   0          10s
    nginx-deployment-75f8c5b686-bmpqh   1/1     Running   0          10s
    nginx-deployment-75f8c5b686-pct7s   1/1     Running   0          10s

    kubectl get replicaset
    NAME                          DESIRED   CURRENT   READY   AGE
    nginx-deployment-75f8c5b686   3         3         3       21s

    kubectl get deployments
    NAME               READY   UP-TO-DATE   AVAILABLE   AGE
    nginx-deployment   3/3     3            3           29s

* En este primer deploy, los pods generados contienen una versión antigua de nginx, en el campo "Image: nginx:1.18"

    kubectl describe pod nginx-deployment-75f8c5b686-4vx44
    Name:         nginx-deployment-75f8c5b686-4vx44
    Namespace:    default
    Priority:     0
    Node:         minikube/192.168.49.2
    Start Time:   Sat, 23 Jan 2021 14:45:26 +0100
    Labels:       app=nginx-service
                  pod-template-hash=75f8c5b686
    Annotations:  <none>
    Status:       Running
    IP:           172.17.0.7
    IPs:
      IP:           172.17.0.7
    Controlled By:  ReplicaSet/nginx-deployment-75f8c5b686
    Containers:
      nginx-service:
        Container ID:   docker://165a1b7d75243e8a1e5e56c6bf2e137db7574a5d54dfee99b4e360d9f3a08a27
        Image:          nginx:1.18
        Image ID:       docker-pullable://nginx@sha256:ebd0fd56eb30543a9195280eb81af2a9a8e6143496accd6a217c14b06acd1419
        Port:           8081/TCP
        Host Port:      0/TCP
        State:          Running
          Started:      Sat, 23 Jan 2021 14:45:31 +0100
        Ready:          True
        Restart Count:  0
        Limits:
          cpu:     100m
          memory:  256Mi
        Requests:
          cpu:        100m
          memory:     256Mi
        Environment:  <none>
        Mounts:
          /var/run/secrets/kubernetes.io/serviceaccount from default-token-wlgfg (ro)
    Conditions:
      Type              Status
      Initialized       True
      Ready             True
      ContainersReady   True
      PodScheduled      True
    Volumes:
      default-token-wlgfg:
        Type:        Secret (a volume populated by a Secret)
        SecretName:  default-token-wlgfg
        Optional:    false
    QoS Class:       Guaranteed
    Node-Selectors:  <none>
    Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                    node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
    Events:
      Type    Reason     Age   From               Message
      ----    ------     ----  ----               -------
      Normal  Scheduled  51s   default-scheduler  Successfully assigned default/nginx-deployment-75f8c5b686-4vx44 to minikube
      Normal  Pulling    51s   kubelet            Pulling image "nginx:1.18"
      Normal  Pulled     47s   kubelet            Successfully pulled image "nginx:1.18" in 3.2387499s
      Normal  Created    47s   kubelet            Created container nginx-service
      Normal  Started    47s   kubelet            Started container nginx-service

* El siguiente comando nos muestra distintos elementos del deployment, antes de lanzar la actualización

    kubectl get deploy,rs,po -l app=nginx-service
    NAME                                          DESIRED   CURRENT   READY   AGE
    replicaset.apps/nginx-deployment-75f8c5b686   3         3         3       84s

    NAME                                    READY   STATUS    RESTARTS   AGE
    pod/nginx-deployment-75f8c5b686-4vx44   1/1     Running   0          84s
    pod/nginx-deployment-75f8c5b686-bmpqh   1/1     Running   0          84s
    pod/nginx-deployment-75f8c5b686-pct7s   1/1     Running   0          84s

* Actualizamos la imagen nginx:1.18 por una versión más reciente

    kubectl set image deploy nginx-deployment nginx-service=nginx:latest
    deployment.apps/nginx-deployment image updated

* Lanzando sucesivamente el comando anterior para visualizar los componentes del deploy, podremos observar que al tratarse de un rolling update, eliminara - creata los pods de forma progresiva, respetando los valores indicados en el fichero deployment-rollingupdate.yaml

    kubectl get deploy,rs,po -l app=nginx-service
    NAME                                          DESIRED   CURRENT   READY   AGE
    replicaset.apps/nginx-deployment-5c6985586c   2         2         1       4s
    replicaset.apps/nginx-deployment-75f8c5b686   2         2         2       116s

    NAME                                    READY   STATUS              RESTARTS   AGE
    pod/nginx-deployment-5c6985586c-6bqhl   1/1     Running             0          4s
    pod/nginx-deployment-5c6985586c-xgx75   0/1     ContainerCreating   0          1s
    pod/nginx-deployment-75f8c5b686-4vx44   1/1     Running             0          116s
    pod/nginx-deployment-75f8c5b686-bmpqh   1/1     Running             0          116s
    pod/nginx-deployment-75f8c5b686-pct7s   1/1     Terminating         0          116s

    kubectl get deploy,rs,po -l app=nginx-service
    NAME                                          DESIRED   CURRENT   READY   AGE
    replicaset.apps/nginx-deployment-5c6985586c   3         3         3       16s
    replicaset.apps/nginx-deployment-75f8c5b686   0         0         0       2m8s

    NAME                                    READY   STATUS        RESTARTS   AGE
    pod/nginx-deployment-5c6985586c-6bqhl   1/1     Running       0          16s
    pod/nginx-deployment-5c6985586c-7h469   1/1     Running       0          10s
    pod/nginx-deployment-5c6985586c-xgx75   1/1     Running       0          13s
    pod/nginx-deployment-75f8c5b686-bmpqh   0/1     Terminating   0          2m8s

    kubectl get deploy,rs,po -l app=nginx-service
    NAME                                          DESIRED   CURRENT   READY   AGE
    replicaset.apps/nginx-deployment-5c6985586c   3         3         3       20s
    replicaset.apps/nginx-deployment-75f8c5b686   0         0         0       2m12s

    NAME                                    READY   STATUS        RESTARTS   AGE
    pod/nginx-deployment-5c6985586c-6bqhl   1/1     Running       0          20s
    pod/nginx-deployment-5c6985586c-7h469   1/1     Running       0          14s
    pod/nginx-deployment-5c6985586c-xgx75   1/1     Running       0          17s
    pod/nginx-deployment-75f8c5b686-bmpqh   0/1     Terminating   0          2m12s

    kubectl get deploy,rs,po -l app=nginx-service
    NAME                                          DESIRED   CURRENT   READY   AGE
    replicaset.apps/nginx-deployment-5c6985586c   3         3         3       26s
    replicaset.apps/nginx-deployment-75f8c5b686   0         0         0       2m18s

    NAME                                    READY   STATUS    RESTARTS   AGE
    pod/nginx-deployment-5c6985586c-6bqhl   1/1     Running   0          26s
    pod/nginx-deployment-5c6985586c-7h469   1/1     Running   0          20s
    pod/nginx-deployment-5c6985586c-xgx75   1/1     Running   0          23s


* Buscamos la descripción de uno de los nuevos pods para comprobar que ha sido actualizado a nginx:latest (Image:          nginx:latest)

    kubectl describe pod nginx-deployment-5c6985586c-6bqhl
    Name:         nginx-deployment-5c6985586c-6bqhl
    Namespace:    default
    Priority:     0
    Node:         minikube/192.168.49.2
    Start Time:   Sat, 23 Jan 2021 14:47:18 +0100
    Labels:       app=nginx-service
                  pod-template-hash=5c6985586c
    Annotations:  <none>
    Status:       Running
    IP:           172.17.0.9
    IPs:
      IP:           172.17.0.9
    Controlled By:  ReplicaSet/nginx-deployment-5c6985586c
    Containers:
      nginx-service:
        Container ID:   docker://a163cd42f115461ac4a41251aac5bb329ddd3d71c038afb3aa083a3ffd68b99e
        Image:          nginx:latest
        Image ID:       docker-pullable://nginx@sha256:10b8cc432d56da8b61b070f4c7d2543a9ed17c2b23010b43af434fd40e2ca4aa
        Port:           8081/TCP
        Host Port:      0/TCP
        State:          Running
          Started:      Sat, 23 Jan 2021 14:47:21 +0100
        Ready:          True
        Restart Count:  0
        Limits:
          cpu:     100m
          memory:  256Mi
        Requests:
          cpu:        100m
          memory:     256Mi
        Environment:  <none>
        Mounts:
          /var/run/secrets/kubernetes.io/serviceaccount from default-token-wlgfg (ro)
    Conditions:
      Type              Status
      Initialized       True
      Ready             True
      ContainersReady   True
      PodScheduled      True
    Volumes:
      default-token-wlgfg:
        Type:        Secret (a volume populated by a Secret)
        SecretName:  default-token-wlgfg
        Optional:    false
    QoS Class:       Guaranteed
    Node-Selectors:  <none>
    Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                    node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
    Events:
      Type    Reason     Age    From               Message
      ----    ------     ----   ----               -------
      Normal  Scheduled  2m25s  default-scheduler  Successfully assigned default/nginx-deployment-5c6985586c-6bqhl to minikube
      Normal  Pulling    2m25s  kubelet            Pulling image "nginx:latest"
      Normal  Pulled     2m23s  kubelet            Successfully pulled image "nginx:latest" in 1.6975872s
      Normal  Created    2m23s  kubelet            Created container nginx-service
      Normal  Started    2m23s  kubelet            Started container nginx-service


* Y realizamos la misma verificacion en el deployment, que en este momento estarà actualizado a nginx:latest

    kubectl describe deploy nginx-deployment

    Name:                   nginx-deployment
    Namespace:              default
    CreationTimestamp:      Sat, 23 Jan 2021 14:45:26 +0100
    Labels:                 <none>
    Annotations:            deployment.kubernetes.io/revision: 2
    Selector:               app=nginx-service
    Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
    StrategyType:           RollingUpdate
    MinReadySeconds:        0
    RollingUpdateStrategy:  0 max unavailable, 1 max surge
    Pod Template:
      Labels:  app=nginx-service
      Containers:
      nginx-service:
        Image:      nginx:latest
        Port:       8081/TCP
        Host Port:  0/TCP
        Limits:
          cpu:     100m
          memory:  256Mi
        Requests:
          cpu:        100m
          memory:     256Mi
        Environment:  <none>
        Mounts:       <none>
      Volumes:        <none>
    Conditions:
      Type           Status  Reason
      ----           ------  ------
      Available      True    MinimumReplicasAvailable
      Progressing    True    NewReplicaSetAvailable
    OldReplicaSets:  <none>
    NewReplicaSet:   nginx-deployment-5c6985586c (3/3 replicas created)
    Events:
      Type    Reason             Age    From                   Message
      ----    ------             ----   ----                   -------
      Normal  ScalingReplicaSet  6m23s  deployment-controller  Scaled up replica set nginx-deployment-75f8c5b686 to 3
      Normal  ScalingReplicaSet  4m31s  deployment-controller  Scaled up replica set nginx-deployment-5c6985586c to 1
      Normal  ScalingReplicaSet  4m28s  deployment-controller  Scaled down replica set nginx-deployment-75f8c5b686 to 2
      Normal  ScalingReplicaSet  4m28s  deployment-controller  Scaled up replica set nginx-deployment-5c6985586c to 2
      Normal  ScalingReplicaSet  4m25s  deployment-controller  Scaled down replica set nginx-deployment-75f8c5b686 to 1
      Normal  ScalingReplicaSet  4m25s  deployment-controller  Scaled up replica set nginx-deployment-5c6985586c to 3
      Normal  ScalingReplicaSet  4m22s  deployment-controller  Scaled down replica set nginx-deployment-75f8c5b686 to 0

-----------------------------------------------------------------------
• Realiza un rollback a la versión generada previamente
-----------------------------------------------------------------------
* Podemos ver que en este momento hay dos replicasets.

    kubectl get replicaset
    NAME                          DESIRED   CURRENT   READY   AGE
    nginx-deployment-5c6985586c   3         3         3       6m43s
    nginx-deployment-75f8c5b686   0         0         0       8m35s


* Es debido a que al actualizar el deployment, se crea un nuevo ReplicaSet, que crea nuevos Pods. Kubernetes mantiene el historial de hasta 10 ReplicaSet por defecto, podemos actualizar esa cifra utilizando revisionHistoryLimit en nuestra especificación de deployment.
* Estos historiales son rastreados como rollouts. Solo el último rollout está activo.
* Por ahora, hemos hecho dos cambios en nuestro Deployment nginx-deployment por lo que el historial de rollouts debería ser dos.

    kubectl rollout history deploy nginx-deployment
    deployment.apps/nginx-deployment
    REVISION  CHANGE-CAUSE
    1         <none>
    2         <none>

    kubectl rollout history deploy nginx-deployment --revision=1
    deployment.apps/nginx-deployment with revision #1
    Pod Template:
      Labels:       app=nginx-service
            pod-template-hash=75f8c5b686
      Containers:
      nginx-service:
        Image:      nginx:1.18
        Port:       8081/TCP
        Host Port:  0/TCP
        Limits:
          cpu:      100m
          memory:   256Mi
        Requests:
          cpu:      100m
          memory:   256Mi
        Environment:        <none>
        Mounts:     <none>
      Volumes:      <none>

    kubectl rollout history deploy nginx-deployment --revision=2
    deployment.apps/nginx-deployment with revision #2
    Pod Template:
      Labels:       app=nginx-service
            pod-template-hash=5c6985586c
      Containers:
      nginx-service:
        Image:      nginx:latest
        Port:       8081/TCP
        Host Port:  0/TCP
        Limits:
          cpu:      100m
          memory:   256Mi
        Requests:
          cpu:      100m
          memory:   256Mi
        Environment:        <none>
        Mounts:     <none>
      Volumes:      <none>

* Para llevar a cabo el rollback:

    kubectl rollout undo deploy nginx-deployment --to-revision=1
    deployment.apps/nginx-deployment rolled back

* Al igual que en el Rolling update, la implementación de rollback finaliza los pods actuales y los sustituye por los pods que contienen la especificación de la revision 1

    kubectl get deploy,rs,po -l app=nginx-service
    NAME                                          DESIRED   CURRENT   READY   AGE
    replicaset.apps/nginx-deployment-5c6985586c   1         1         1       13m
    replicaset.apps/nginx-deployment-75f8c5b686   3         3         2       15m

    NAME                                    READY   STATUS              RESTARTS   AGE
    pod/nginx-deployment-5c6985586c-6bqhl   1/1     Running             0          13m
    pod/nginx-deployment-5c6985586c-7h469   0/1     Terminating         0          13m
    pod/nginx-deployment-5c6985586c-xgx75   1/1     Terminating         0          13m
    pod/nginx-deployment-75f8c5b686-n7f28   1/1     Running             0          3s
    pod/nginx-deployment-75f8c5b686-rgk2x   1/1     Running             0          6s
    pod/nginx-deployment-75f8c5b686-xqpwk   0/1     ContainerCreating   0          0s

    kubectl get deploy,rs,po -l app=nginx-service
    NAME                                          DESIRED   CURRENT   READY   AGE
    replicaset.apps/nginx-deployment-5c6985586c   0         0         0       13m
    replicaset.apps/nginx-deployment-75f8c5b686   3         3         3       15m

    NAME                                    READY   STATUS    RESTARTS   AGE
    pod/nginx-deployment-75f8c5b686-n7f28   1/1     Running   0          19s
    pod/nginx-deployment-75f8c5b686-rgk2x   1/1     Running   0          22s
    pod/nginx-deployment-75f8c5b686-xqpwk   1/1     Running   0          16s


* Si se revisa el historial de rollouts una vez más, se puede ver que la Revisión 1 se ha utilizado para crear los últimos pods etiquetándolos con la Revisión 3. 

    kubectl rollout history deploy nginx-deployment
    deployment.apps/nginx-deployment
    REVISION  CHANGE-CAUSE
    2         <none>
    3         <none>

    kubectl rollout history deploy nginx-deployment --revision=2
    deployment.apps/nginx-deployment with revision #2
    Pod Template:
      Labels:       app=nginx-service
            pod-template-hash=5c6985586c
      Containers:
      nginx-service:
        Image:      nginx:latest
        Port:       8081/TCP
        Host Port:  0/TCP
        Limits:
          cpu:      100m
          memory:   256Mi
        Requests:
          cpu:      100m
          memory:   256Mi
        Environment:        <none>
        Mounts:     <none>
      Volumes:      <none>

    kubectl rollout history deploy nginx-deployment --revision=3
    deployment.apps/nginx-deployment with revision #3
    Pod Template:
      Labels:       app=nginx-service
            pod-template-hash=75f8c5b686
      Containers:
      nginx-service:
        Image:      nginx:1.18
        Port:       8081/TCP
        Host Port:  0/TCP
        Limits:
          cpu:      100m
          memory:   256Mi
        Requests:
          cpu:      100m
          memory:   256Mi
        Environment:        <none>
        Mounts:     <none>
      Volumes:      <none>

* Comprobamos que el deployment vuelve a estar en la version 1.18

    kubectl describe deploy nginx-deployment
    Name:                   nginx-deployment
    Namespace:              default
    CreationTimestamp:      Sat, 23 Jan 2021 14:45:26 +0100
    Labels:                 <none>
    Annotations:            deployment.kubernetes.io/revision: 3
    Selector:               app=nginx-service
    Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
    StrategyType:           RollingUpdate
    MinReadySeconds:        0
    RollingUpdateStrategy:  0 max unavailable, 1 max surge
    Pod Template:
      Labels:  app=nginx-service
      Containers:
      nginx-service:
        Image:      nginx:1.18
        Port:       8081/TCP
        Host Port:  0/TCP
        Limits:
          cpu:     100m
          memory:  256Mi
        Requests:
          cpu:        100m
          memory:     256Mi
        Environment:  <none>
        Mounts:       <none>
      Volumes:        <none>
    Conditions:
      Type           Status  Reason
      ----           ------  ------
      Available      True    MinimumReplicasAvailable
      Progressing    True    NewReplicaSetAvailable
    OldReplicaSets:  <none>
    NewReplicaSet:   nginx-deployment-75f8c5b686 (3/3 replicas created)
    Events:
      Type    Reason             Age                  From                   Message
      ----    ------             ----                 ----                   -------
      Normal  ScalingReplicaSet  21m                  deployment-controller  Scaled up replica set nginx-deployment-5c6985586c to 1
      Normal  ScalingReplicaSet  21m                  deployment-controller  Scaled down replica set nginx-deployment-75f8c5b686 to 2
      Normal  ScalingReplicaSet  21m                  deployment-controller  Scaled up replica set nginx-deployment-5c6985586c to 2
      Normal  ScalingReplicaSet  21m                  deployment-controller  Scaled down replica set nginx-deployment-75f8c5b686 to 1
      Normal  ScalingReplicaSet  21m                  deployment-controller  Scaled up replica set nginx-deployment-5c6985586c to 3
      Normal  ScalingReplicaSet  21m                  deployment-controller  Scaled down replica set nginx-deployment-75f8c5b686 to 0
      Normal  ScalingReplicaSet  8m16s                deployment-controller  Scaled up replica set nginx-deployment-75f8c5b686 to 1
      Normal  ScalingReplicaSet  8m13s                deployment-controller  Scaled down replica set nginx-deployment-5c6985586c to 2
      Normal  ScalingReplicaSet  8m13s                deployment-controller  Scaled up replica set nginx-deployment-75f8c5b686 to 2
      Normal  ScalingReplicaSet  8m10s (x2 over 23m)  deployment-controller  Scaled up replica set nginx-deployment-75f8c5b686 to 3
      Normal  ScalingReplicaSet  8m10s                deployment-controller  Scaled down replica set nginx-deployment-5c6985586c to 1
      Normal  ScalingReplicaSet  8m7s                 deployment-controller  Scaled down replica set nginx-deployment-5c6985586c to 0


* eliminamos todos los elementos generados para finalizar
    kubectl delete deployment nginx-deployment