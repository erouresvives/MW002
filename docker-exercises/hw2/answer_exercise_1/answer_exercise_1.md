-----------------------------------------------------------------------
1. Crea un pod de forma declarativa con las siguientes especificaciones:
-----------------------------------------------------------------------
    
    kubectl create -f pod.yaml
    pod/nginx-server created

    kubectl get pods
    NAME           READY   STATUS    RESTARTS   AGE
    nginx-server   1/1     Running   0          10s

-----------------------------------------------------------------------
Realiza un despliegue en Kubernetes, y responde las siguientes preguntas:
-----------------------------------------------------------------------
• ¿Cómo puedo obtener las últimas 10 líneas de la salida estándar (logs generados por la aplicación)?
-----------------------------------------------------------------------

    kubectl logs --tail=10 nginx-server

-----------------------------------------------------------------------
• ¿Cómo podría obtener la IP interna del pod? Aporta capturas para indicar el proceso que seguirías.
-----------------------------------------------------------------------

-- Opción 1: lanzar el comando 'kubectl get pods -o wide', de tal manera aparecerá visible el campo IP del pod

    kubectl get pods -o wide
    NAME           READY   STATUS    RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES
    nginx-server   1/1     Running   0          87s   172.17.0.6   minikube   <none>           <none>

-- Opción 2: lanzar el comando 'kubectl describe pods nginx-server', para visualizar una descripción completa del pod, entre los múltiples campos aparece IP

    kubectl describe pods nginx-server

    Name:         nginx-server
    Namespace:    default
    Priority:     0
    Node:         minikube/192.168.49.2
    Start Time:   Tue, 19 Jan 2021 20:44:28 +0100
    Labels:       app=nginx-server
    Annotations:  <none>
    Status:       Running
    IP:           172.17.0.6
    IPs:
      IP:  172.17.0.6
    Containers:
      nginx-server-container:
        Container ID:   docker://1966a5f4e44150b8422e9cb1f110d3763493f8928cdc0300c3679a9f0f176083
        Image:          nginx:1.19.4
        Image ID:       docker-pullable://nginx@sha256:c3a1592d2b6d275bef4087573355827b200b00ffc2d9849890a4f3aa2128c4ae
        Port:           <none>
        Host Port:      <none>
        State:          Running
          Started:      Tue, 19 Jan 2021 20:44:30 +0100
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
      Normal  Scheduled  2m9s  default-scheduler  Successfully assigned default/nginx-server to minikube
      Normal  Pulled     2m9s  kubelet            Container image "nginx:1.19.4" already present on machine
      Normal  Created    2m9s  kubelet            Created container nginx-server-container
      Normal  Started    2m8s  kubelet            Started container nginx-server-container

-----------------------------------------------------------------------
• ¿Qué comando utilizarías para entrar dentro del pod?
-----------------------------------------------------------------------

    kubectl exec -it nginx-server -- sh

-----------------------------------------------------------------------
• Necesitas visualizar el contenido que expone NGINX, ¿qué acciones debes llevar a cabo
-----------------------------------------------------------------------

    kubectl port-forward nginx-server 80:80
    navegador -> localhost:80

-----------------------------------------------------------------------
• Indica la calidad de servicio (QoS) establecida en el pod que acabas de crear. ¿Qué lo has mirado?
-----------------------------------------------------------------------

-- Ejecutamos el comando para visualizar una descripción completa en formato yaml del pod:
Entre los últimos campos, aparece uno llamado qosClass:

    ...
    qosClass: Guaranteed
    ...

-- En este caso aparece su valor por defecto, Guaranteed, implica que el pod se consideran de máxima prioridad y se garantiza que no será eliminado hasta que supere sus límites.

    kubectl get pod nginx-server --output=yaml

    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: "2021-01-19T19:44:28Z"
      labels:
        app: nginx-server
      managedFields:
      - apiVersion: v1
        fieldsType: FieldsV1
        fieldsV1:
          f:metadata:
            f:labels:
              .: {}
              f:app: {}
          f:spec:
            f:containers:
              k:{"name":"nginx-server-container"}:
                .: {}
                f:image: {}
                f:imagePullPolicy: {}
                f:name: {}
                f:resources:
                  .: {}
                  f:limits:
                    .: {}
                    f:cpu: {}
                    f:memory: {}
                  f:requests:
                    .: {}
                    f:cpu: {}
                    f:memory: {}
                f:terminationMessagePath: {}
                f:terminationMessagePolicy: {}
            f:dnsPolicy: {}
            f:enableServiceLinks: {}
            f:restartPolicy: {}
            f:schedulerName: {}
            f:securityContext: {}
            f:terminationGracePeriodSeconds: {}
        manager: kubectl-create
        operation: Update
        time: "2021-01-19T19:44:28Z"
      - apiVersion: v1
        fieldsType: FieldsV1
        fieldsV1:
          f:status:
            f:conditions:
              k:{"type":"ContainersReady"}:
                .: {}
                f:lastProbeTime: {}
                f:lastTransitionTime: {}
                f:status: {}
                f:type: {}
              k:{"type":"Initialized"}:
                .: {}
                f:lastProbeTime: {}
                f:lastTransitionTime: {}
                f:status: {}
                f:type: {}
              k:{"type":"Ready"}:
                .: {}
                f:lastProbeTime: {}
                f:lastTransitionTime: {}
                f:status: {}
                f:type: {}
            f:containerStatuses: {}
            f:hostIP: {}
            f:phase: {}
            f:podIP: {}
            f:podIPs:
              .: {}
              k:{"ip":"172.17.0.6"}:
                .: {}
                f:ip: {}
            f:startTime: {}
        manager: kubelet
        operation: Update
        time: "2021-01-19T19:44:30Z"
      name: nginx-server
      namespace: default
      resourceVersion: "5201"
      uid: 7c3c853c-17cf-4066-a271-e95f238e4bfe
    spec:
      containers:
      - image: nginx:1.19.4
        imagePullPolicy: IfNotPresent
        name: nginx-server-container
        resources:
          limits:
            cpu: 100m
            memory: 256Mi
          requests:
            cpu: 100m
            memory: 256Mi
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
          name: default-token-wlgfg
          readOnly: true
      dnsPolicy: ClusterFirst
      enableServiceLinks: true
      nodeName: minikube
      preemptionPolicy: PreemptLowerPriority
      priority: 0
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      serviceAccount: default
      serviceAccountName: default
      terminationGracePeriodSeconds: 30
      tolerations:
      - effect: NoExecute
        key: node.kubernetes.io/not-ready
        operator: Exists
        tolerationSeconds: 300
      - effect: NoExecute
        key: node.kubernetes.io/unreachable
        operator: Exists
        tolerationSeconds: 300
      volumes:
      - name: default-token-wlgfg
        secret:
          defaultMode: 420
          secretName: default-token-wlgfg
    status:
      conditions:
      - lastProbeTime: null
        lastTransitionTime: "2021-01-19T19:44:28Z"
        status: "True"
        type: Initialized
      - lastProbeTime: null
        lastTransitionTime: "2021-01-19T19:44:30Z"
        status: "True"
        type: Ready
      - lastProbeTime: null
        lastTransitionTime: "2021-01-19T19:44:30Z"
        status: "True"
        type: ContainersReady
      - lastProbeTime: null
        lastTransitionTime: "2021-01-19T19:44:28Z"
        status: "True"
        type: PodScheduled
      containerStatuses:
      - containerID: docker://1966a5f4e44150b8422e9cb1f110d3763493f8928cdc0300c3679a9f0f176083
        image: nginx:1.19.4
        imageID: docker-pullable://nginx@sha256:c3a1592d2b6d275bef4087573355827b200b00ffc2d9849890a4f3aa2128c4ae
        lastState: {}
        name: nginx-server-container
        ready: true
        restartCount: 0
        started: true
        state:
          running:
            startedAt: "2021-01-19T19:44:30Z"
      hostIP: 192.168.49.2
      phase: Running
      podIP: 172.17.0.6
      podIPs:
      - ip: 172.17.0.6
      qosClass: Guaranteed
      startTime: "2021-01-19T19:44:28Z"