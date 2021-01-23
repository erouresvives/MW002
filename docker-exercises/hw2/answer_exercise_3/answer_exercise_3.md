-----------------------------------------------------------------------
3. Crea un objeto de tipo service para exponer la aplicación del ejercicio
anterior de las siguientes formas:
-----------------------------------------------------------------------
https://medium.com/@jiamin_ning/build-your-first-kubernetes-service-with-replicaset-7c37d9be689c
-----------------------------------------------------------------------
• Exponiendo el servicio hacia el exterior (crea service1.yaml)
-----------------------------------------------------------------------

-- Creamos replicaset y servicio a partir de los ficheros replicaset1.yaml, service1.yaml

        kubectl create -f replicaset1.yaml
        replicaset.apps/nginx-replicaset1 created

        kubectl create -f service1.yaml
        service/nginx-service created

-- Comprobamos que todos los elementos han sido generados correctamente

        kubectl get replicaset
        NAME                DESIRED   CURRENT   READY   AGE
        nginx-replicaset1   3         3         3       46s

        kubectl get pods
        NAME                      READY   STATUS    RESTARTS   AGE
        nginx-replicaset1-n5ggr   1/1     Running   0          64s
        nginx-replicaset1-nvnct   1/1     Running   0          64s
        nginx-replicaset1-wvcfh   1/1     Running   0          64s

        kubectl get service
        NAME            TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
        kubernetes      ClusterIP      10.96.0.1      <none>        443/TCP          4d16h
        nginx-service   LoadBalancer   10.109.1.165   <pending>     9090:30536/TCP   44s

        minikube service nginx-service --url
        * Starting tunnel for service nginx-service.
        |-----------|---------------|-------------|------------------------|
        | NAMESPACE |     NAME      | TARGET PORT |          URL           |
        |-----------|---------------|-------------|------------------------|
        | default   | nginx-service |             | http://127.0.0.1:53339 |
        |-----------|---------------|-------------|------------------------|
        http://127.0.0.1:53339


        minikube  service list
        |----------------------|---------------------------|--------------|---------------------------|
        |      NAMESPACE       |           NAME            | TARGET PORT  |            URL            |
        |----------------------|---------------------------|--------------|---------------------------|
        | default              | kubernetes                | No node port |
        | default              | nginx-service             |         9090 | http://192.168.49.2:30536 |
        | kube-system          | kube-dns                  | No node port |
        | kubernetes-dashboard | dashboard-metrics-scraper | No node port |
        | kubernetes-dashboard | kubernetes-dashboard      | No node port |
        |----------------------|---------------------------|--------------|---------------------------|

-- Borramos todos los elementos generados para finalizar

        kubectl delete service nginx-service
        service "nginx-service" deleted

        kubectl delete replicaset nginx-replicaset1
        replicaset.apps "nginx-replicaset1" deleted

-----------------------------------------------------------------------
• De forma interna, sin acceso desde el exterior (crea service2.yaml)
-----------------------------------------------------------------------

        kubectl create -f replicaset2.yaml
        replicaset.apps/nginx-replicaset2 created

        kubectl create -f service2.yaml
        service/nginx-service created

        kubectl get service
        NAME            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
        kubernetes      ClusterIP   10.96.0.1        <none>        443/TCP    4d16h
        nginx-service   ClusterIP   10.108.174.170   <none>        8081/TCP   4s

        kubectl get replicaset
        NAME                DESIRED   CURRENT   READY   AGE
        nginx-replicaset2   3         3         3       17s

        NAME                      READY   STATUS    RESTARTS   AGE
        nginx-replicaset2-bvhzn   1/1     Running   0          17s
        nginx-replicaset2-jtbkz   1/1     Running   0          17s
        nginx-replicaset2-t9525   1/1     Running   0          17s

        kubectl describe svc nginx-service
        Name:              nginx-service
        Namespace:         default
        Labels:            <none>
        Annotations:       <none>
        Selector:          app=nginx-server
        Type:              ClusterIP
        IP:                10.108.174.170
        Port:              <unset>  8081/TCP
        TargetPort:        8081/TCP
        Endpoints:         <none>
        Session Affinity:  None
        Events:            <none>

        kubectl delete service nginx-service
        service "nginx-service" deleted

        kubectl delete replicaset nginx-replicaset2
        replicaset.apps "nginx-replicaset2" deleted

-----------------------------------------------------------------------
• Abriendo un puerto especifico de la VM (crea service3.yaml)
-----------------------------------------------------------------------

        kubectl create -f replicaset3.yaml
        replicaset.apps/nginx-replicaset3 created

        kubectl create -f service3.yaml
        service/nginx-service created

        kubectl get replicaset
        NAME                DESIRED   CURRENT   READY   AGE
        nginx-replicaset3   3         3         3       31s

        kubectl get pods
        NAME                      READY   STATUS        RESTARTS   AGE
        nginx-replicaset3-5hlnm   1/1     Running       0          43s
        nginx-replicaset3-nhplm   1/1     Running       0          43s
        nginx-replicaset3-nrcm8   1/1     Running       0          43s

        kubectl get service
        NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
        kubernetes         ClusterIP   10.96.0.1        <none>        443/TCP          4d15h
        nginx-service      NodePort    10.110.173.245   <none>        9090:30036/TCP   2m55s

        minikube service list
        |----------------------|---------------------------|--------------|---------------------------|
        |      NAMESPACE       |           NAME            | TARGET PORT  |            URL            |
        |----------------------|---------------------------|--------------|---------------------------|
        | default              | kubernetes                | No node port |
        | default              | nginx-service             |         9090 | http://192.168.49.2:30036 |
        | kube-system          | kube-dns                  | No node port |
        | kubernetes-dashboard | dashboard-metrics-scraper | No node port |
        | kubernetes-dashboard | kubernetes-dashboard      | No node port |
        |----------------------|---------------------------|--------------|---------------------------|

        kubectl delete service nginx-service
        kubectl delete replicaset nginx-replicaset3

-----------------------------------------------------------------------
