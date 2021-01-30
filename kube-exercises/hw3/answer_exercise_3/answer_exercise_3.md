---------------------------------------------------------------------------------------
3. [Horizontal Pod Autoscaler] Crea un objeto de kubernetes HPA, que escale a partir de
las métricas CPU o memoria (a vuestra elección). Establece el umbral al 50% de
CPU/memoria utilizada, cuando pase el umbral, automáticamente se deberá escalar
al doble de replicas.
---------------------------------------------------------------------------------------

* actualización de métricas

        kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

* activación de métricas 

        minikube addons enable metrics-server
        * The 'metrics-server' addon is enabled

        minikube addons list
        |-----------------------------|----------|--------------|
        |         ADDON NAME          | PROFILE  |    STATUS    |
        |-----------------------------|----------|--------------|
        | ambassador                  | minikube | disabled     |
        | csi-hostpath-driver         | minikube | disabled     |
        | dashboard                   | minikube | enabled ✅   |
        | default-storageclass        | minikube | enabled ✅   |
        | efk                         | minikube | disabled     |
        | freshpod                    | minikube | disabled     |
        | gcp-auth                    | minikube | disabled     |
        | gvisor                      | minikube | disabled     |
        | helm-tiller                 | minikube | disabled     |
        | ingress                     | minikube | enabled ✅   |
        | ingress-dns                 | minikube | disabled     |
        | istio                       | minikube | disabled     |
        | istio-provisioner           | minikube | disabled     |
        | kubevirt                    | minikube | disabled     |
        | logviewer                   | minikube | disabled     |
        | metallb                     | minikube | disabled     |
        | metrics-server              | minikube | enabled ✅   |
        | nvidia-driver-installer     | minikube | disabled     |
        | nvidia-gpu-device-plugin    | minikube | disabled     |
        | olm                         | minikube | disabled     |
        | pod-security-policy         | minikube | disabled     |
        | registry                    | minikube | disabled     |
        | registry-aliases            | minikube | disabled     |
        | registry-creds              | minikube | disabled     |
        | storage-provisioner         | minikube | enabled ✅   |
        | storage-provisioner-gluster | minikube | disabled     |
        | volumesnapshots             | minikube | disabled     |
        |-----------------------------|----------|--------------|

* Creación de deployment

        kubectl apply -f deployment.yaml
        deployment.apps/php-apache created
        service/php-apache created

* Aplicación de Horizontal Pod Autoscale

        kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10 
        horizontalpodautoscaler.autoscaling/php-apache autoscaled

        kubectl get hpa
        NAME         REFERENCE               TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
        php-apache   Deployment/php-apache   <unknown>/50%   1         10        0          11s

        kubectl describe hpa
        Name:                                                  php-apache
        Namespace:                                             kube-system
        Labels:                                                <none>
        Annotations:                                           <none>
        CreationTimestamp:                                     Sat, 30 Jan 2021 21:10:29 +0100
        Reference:                                             Deployment/php-apache
        Metrics:                                               ( current / target )
        resource cpu on pods  (as a percentage of request):  <unknown> / 50%
        Min replicas:                                          1
        Max replicas:                                          10
        Deployment pods:                                       1 current / 0 desired
        Conditions:
        Type           Status  Reason                   Message
        ----           ------  ------                   -------
        AbleToScale    True    SucceededGetScale        the HPA controller was able to get the target's current scale
        ScalingActive  False   FailedGetResourceMetric  the HPA was unable to compute the replica count: failed to get cpu utilization: unable to get metrics for resource cpu: unable to fetch metrics from resource metrics API: the server is currently unable to handle the request (get pods.metrics.k8s.io)
        Events:
        Type     Reason                        Age               From                       Message
        ----     ------                        ----              ----                       -------
        Warning  FailedGetResourceMetric       3s (x2 over 17s)  horizontal-pod-autoscaler  failed to get cpu utilization: unable to get metrics for resource cpu: unable to fetch metrics from resource metrics API: the server is currently unable to handle the request (get pods.metrics.k8s.io)
        Warning  FailedComputeMetricsReplicas  3s (x2 over 17s)  horizontal-pod-autoscaler  invalid metrics (1 invalid out of 1), first error is: failed to get cpu utilization: unable to get metrics for resource cpu: unable to fetch metrics from resource metrics API: the server is currently unable to handle the request (get pods.metrics.k8s.io)
