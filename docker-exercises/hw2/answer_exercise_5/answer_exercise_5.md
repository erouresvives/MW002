-----------------------------------------------------------------------
5. Diseña una estrategia de despliegue que se base en ”Blue Green”. Podéis
utilizar la imagen del ejercicio 1.

Recordad lo que hemos visto en clase sobre “Blue Green deployment”:
a. Existe una aplicación que está desplegada en el clúster (en el ejemplo, 1.0v):

Antes de ofrecer el servicio a los usuarios, la compañía necesita realizar una serie
de validaciones con la versión 2.0. Los usuarios siguen accediendo a la versión
1.0:

c. Una vez que el equipo ha validado la aplicación, se realiza un switch del tráfico a
la versión 2.0 sin impacto para los usuarios:

Adjunta todos los ficheros para crear esta prueba de concepto.
-----------------------------------------------------------------------

* desplegamos los dos ficheros deployment.yaml, con la version blue

    kubectl create -f deployment-blue.yaml
    deployment.apps/nginx-deployment-blue created

* creamos el servicio, que apuntarà con aquellos pods que dispongan de label group:blue , app:nginx-service

    kubectl create -f service.yaml
    service/nginx-service created

* Comprovamos que todos los elementos hayan sido creados correctamente

    kubectl get deploy,rs,po -l app=nginx-service
    NAME                                               DESIRED   CURRENT   READY   AGE
    replicaset.apps/nginx-deployment-blue-689d88875b   3         3         3       2m2s

    NAME                                         READY   STATUS    RESTARTS   AGE
    pod/nginx-deployment-blue-689d88875b-6qn5z   1/1     Running   0          2m2s
    pod/nginx-deployment-blue-689d88875b-c75w9   1/1     Running   0          2m2s
    pod/nginx-deployment-blue-689d88875b-shjfh   1/1     Running   0          2m2s


    kubectl get service
    NAME            TYPE           CLUSTER-IP       EXTERNAL-IP   PORT
    nginx-service   LoadBalancer   10.108.187.240   <pending>     80:32088/TCP   88s

    kubectl describe service nginx-service
    Name:                     nginx-service
    Namespace:                default
    Labels:                   <none>
    Annotations:              <none>
    Selector:                 app=nginx-service,group=blue
    Type:                     LoadBalancer
    IP:                       10.108.187.240
    Port:                     <unset>  80/TCP
    TargetPort:               80/TCP
    NodePort:                 <unset>  32088/TCP
    Endpoints:                172.17.0.7:80,172.17.0.8:80,172.17.0.9:80
    Session Affinity:         None
    External Traffic Policy:  Cluster
    Events:                   <none>

* Creamos el green deployment
    kubectl create -f deployment-green.yaml
    deployment.apps/nginx-deployment-green created

    kubectl get deploy,rs,po -l app=nginx-service
    NAME                                               DESIRED   CURRENT   READY   AGE
    replicaset.apps/nginx-deployment-blue-689d88875b   3         3         3       3m34s
    replicaset.apps/nginx-deployment-green-845f4496    3         3         3       15s

    NAME                                         READY   STATUS    RESTARTS   AGE
    pod/nginx-deployment-blue-689d88875b-6qn5z   1/1     Running   0          3m34s
    pod/nginx-deployment-blue-689d88875b-c75w9   1/1     Running   0          3m34s
    pod/nginx-deployment-blue-689d88875b-shjfh   1/1     Running   0          3m34s
    pod/nginx-deployment-green-845f4496-56jpn    1/1     Running   0          15s
    pod/nginx-deployment-green-845f4496-qcjgb    1/1     Running   0          15s
    pod/nginx-deployment-green-845f4496-wzk7p    1/1     Running   0          15s

* en este momento tendremos dos deployments, pero el servicio apunta únicamente a aquellos con el group: blue. Lo podemos comprobar desde minikube dashboard (ver img1.PNG)

* comprobamos que los pods del replicaset green estan listos para el deployment:
* Un Pod tiene un PodStatus, que tiene un array de PodConditions por el que el Pod ha pasado o no:
  1. PodScheduled: el Pod ha sido programado en un nodo.
  2. ContainersReady: todos los contenedores del Pod están listos.
  3. Initialized: todos los contenedores init han arrancado con éxito.
  4. Ready: el Pod es capaz de servir peticiones y debería añadirse a los load balancers de todos los Servicios coincidentes.
* Comprovamos que todos los valores mencionados estan en True en los pods de 'Group:green' (a continuacion solo uno de los 3)

    kubectl describe pod nginx-deployment-green-845f4496-wzk7p
    Name:         nginx-deployment-green-845f4496-wzk7p
    Namespace:    default
    Priority:     0
    Node:         minikube/192.168.49.2
    Start Time:   Sat, 23 Jan 2021 18:57:29 +0100
    Labels:       app=nginx-service
                  group=green
                  pod-template-hash=845f4496
    Annotations:  <none>
    Status:       Running
    IP:           172.17.0.12
    IPs:
      IP:           172.17.0.12
    Controlled By:  ReplicaSet/nginx-deployment-green-845f4496
    Containers:
      nginx-service:
        Container ID:   docker://ae4be24c40614b0576e19de3d1e46718fb1ef1b50d95b21e44a54e37f6da623a
        Image:          nginx:1.19.4
        Image ID:       docker-pullable://nginx@sha256:c3a1592d2b6d275bef4087573355827b200b00ffc2d9849890a4f3aa2128c4ae
        Port:           80/TCP
        Host Port:      0/TCP
        State:          Running
          Started:      Sat, 23 Jan 2021 18:57:37 +0100
        Ready:          True
        Restart Count:  0
        Limits:
          cpu:     100m
          memory:  256Mi
        Requests:
          cpu:        100m
          memory:     256Mi
        Liveness:     http-get http://:80/ delay=5s timeout=1s period=3s #success=1 #failure=3
        Readiness:    http-get http://:80/ delay=5s timeout=1s period=3s #success=1 #failure=3
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
    Events:          <none>

* todas las condiciones están a true, por lo tanto proseguimos ha hacer el cambio / actualización de la aplicación
* modificamos el fichero 'service.yaml', reemplazamos la label 'group:blue' por 'group:green' (ambos ficheros se encuentran en la carpeta 'service')

    service.yaml (version blue - service/service-blue.yaml)   
    apiVersion: v1
    kind: Service
    metadata:
      name: nginx-service
    spec:
      ports:
        - protocol: TCP
          port: 80
          targetPort: 80
      selector:
        app: nginx-service
        group: blue
      type: LoadBalancer

    service.yaml (version green - service/service-green.yaml)
    apiVersion: v1
    kind: Service
    metadata:
      name: nginx-service
    spec:
      ports:
        - protocol: TCP
          port: 80
          targetPort: 80
      selector:
        app: nginx-service
        group: green
      type: LoadBalancer

* actualizamos el service para aplicar los cambios

    Warning: kubectl apply should be used on resource created by either kubectl create --save-config or kubectl apply
    service/nginx-service configured

* a traves de minikube dashboard, podemos observar que en este momento, el servicio ya no apunta a los pods con el label 'group:blue', sino a 'group:green' (ver img2.PNG)

* llegados a este punto, solo queda eliminar los pods / replicaset con label group:blue

    kubectl delete deployment nginx-deployment-blue
    deployment.apps "nginx-deployment-blue" deleted

    kubectl get deploy,rs,po -l app=nginx-service
    NAME                                              DESIRED   CURRENT   READY   AGE
    replicaset.apps/nginx-deployment-green-845f4496   3         3         3       126m

    NAME                                        READY   STATUS    RESTARTS   AGE
    pod/nginx-deployment-green-845f4496-56jpn   1/1     Running   0          126m
    pod/nginx-deployment-green-845f4496-qcjgb   1/1     Running   0          126m
    pod/nginx-deployment-green-845f4496-wzk7p   1/1     Running   0          126m





