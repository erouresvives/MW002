-------------------------------------------------------------------------------------------------------
1. [Ingress Controller / Secrets] Crea los siguientes objetos de forma declarativa con las
siguientes especificaciones:
-------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------
PREPARACIÓN EJERCICIO - creación del ingress controller
--------------------------------------------------------------------------------

* instalacion helm 

        choco install kubernetes-helm

        helm repo add stable https://charts.helm.sh/stable
        "stable" has been added to your repositories

        helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
        "ingress-nginx" has been added to your repositories

        helm install ingress-nginx ingress-nginx/ingress-nginx


* crear el despliegue de controlador de entrada nginx-ingress-controller, junto con los roles y enlaces RBAC de Kubernetes:

        kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/mandatory.yaml
        namespace/ingress-nginx configured
        configmap/nginx-configuration unchanged
        configmap/tcp-services unchanged
        configmap/udp-services unchanged
        serviceaccount/nginx-ingress-serviceaccount unchanged
        Warning: rbac.authorization.k8s.io/v1beta1 ClusterRole is deprecated in v1.17+, unavailable in v1.22+; use rbac.authorization.k8s.io/v1 ClusterRole
        clusterrole.rbac.authorization.k8s.io/nginx-ingress-clusterrole unchanged
        Warning: rbac.authorization.k8s.io/v1beta1 Role is deprecated in v1.17+, unavailable in v1.22+; use rbac.authorization.k8s.io/v1 Role
        role.rbac.authorization.k8s.io/nginx-ingress-role unchanged
        Warning: rbac.authorization.k8s.io/v1beta1 RoleBinding is deprecated in v1.17+, unavailable in v1.22+; use rbac.authorization.k8s.io/v1 RoleBinding
        rolebinding.rbac.authorization.k8s.io/nginx-ingress-role-nisa-binding unchanged
        Warning: rbac.authorization.k8s.io/v1beta1 ClusterRoleBinding is deprecated in v1.17+, unavailable in v1.22+; use rbac.authorization.k8s.io/v1 ClusterRoleBinding
        clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress-clusterrole-nisa-binding unchanged
        deployment.apps/nginx-ingress-controller configured
        limitrange/ingress-nginx created

        kubectl apply -f cloud-generic.yaml
        service/ingress-nginx configured

        kubectl get svc -n ingress-nginx
        NAME                                 TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
        ingress-nginx                        LoadBalancer   10.106.0.155   <pending>     80:32168/TCP,443:32383/TCP   36h
        ingress-nginx-controller             LoadBalancer   10.109.16.42   <pending>     80:32512/TCP,443:30794/TCP   21m
        ingress-nginx-controller-admission   ClusterIP      10.102.5.185   <none>        443/TCP                      21m


* El EXTERNAL-IP para el servicio del controlador de entrada ingress-nginx se muestra como <pending> hasta que el equilibrador de carga se haya creado completamente

* resolucion problema assignación ip externa 

        kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
        namespace/metallb-system created

        kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml

        kubectl apply -f configmap.yaml
        configmap/config created

        kubectl get svc -n ingress-nginx
        NAME                                 TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
        ingress-nginx                        LoadBalancer   10.106.0.155   172.42.42.100   80:32168/TCP,443:32383/TCP   37h
        ingress-nginx-controller             LoadBalancer   10.109.16.42   172.42.42.101   80:32512/TCP,443:30794/TCP   33m
        ingress-nginx-controller-admission   ClusterIP      10.102.5.185   <none>          443/TCP                      33m

* añadir url en el fichero host

        C:/Windows/System32/drivers/etc
        host
        172.42.42.100 emili-roures-vives.students.lasalle.com
 
--------------------------------------------------------------------------------
a. A continuación, tras haber expuesto el servicio en el puerto 80, se deberá
acceder a la página principal de Nginx a través de la siguiente URL:
http://<student_name>.student.lasalle.com
--------------------------------------------------------------------------------

* asegurar que ingress este activado:

    minikube addons enable ingress
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
    | metrics-server              | minikube | disabled     |
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

* creación y verificación de la existencia de los distintos elementos

        kubectl create -f service.yaml
        service/nginx-service created

        kubectl create -f deployment.yaml
        deployment.apps/nginx-deployment created

        kubectl get pods
        NAME                               READY   STATUS    RESTARTS   AGE
        nginx-deployment-d96457bd6-26s4m   1/1     Running   0          83s
        nginx-deployment-d96457bd6-dpv66   1/1     Running   0          83s
        nginx-deployment-d96457bd6-xd5mj   1/1     Running   0          83s

        kubectl get svc
        NAME            TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
        kubernetes      ClusterIP   10.96.0.1      <none>        443/TCP    5m51s
        nginx-service   ClusterIP   10.99.148.27   <none>        8080/TCP   2m49s

        kubectl get deployment
        NAME               READY   UP-TO-DATE   AVAILABLE   AGE
        nginx-deployment   3/3     3            3           102s

        kubectl create -f ingress.yaml
        ingress.networking.k8s.io/nginx-ingress created

        kubectl get ingress
        NAME            CLASS    HOSTS                                     ADDRESS         PORTS     AGE
        nginx-ingress   <none>   emili-roures-vives.students.lasalle.com   172.42.42.100   80, 443   2m38s

        kubectl describe ingress nginx-ingress
        Name:             nginx-ingress
        Namespace:        default
        Address:          192.168.49.2
        Default backend:  default-http-backend:80 (<error: endpoints "default-http-backend" not found>)
        TLS:
        tls-secret terminates
        Rules:
        Host                                     Path  Backends
        ----                                     ----  --------
        emili-roures-vives.students.lasalle.com
                                                /   nginx-service:80   172.17.0.7:80,172.17.0.8:80,172.17.0.9:80)
        Annotations:                               <none>
        Events:
        Type    Reason  Age                 From                      Message
        ----    ------  ----                ----                      -------
        Normal  CREATE  3m2s                nginx-ingress-controller  Ingress default/nginx-ingress
        Normal  CREATE  3m2s                nginx-ingress-controller  Ingress default/nginx-ingress
        Normal  Sync    5s (x7 over 3m2s)   nginx-ingress-controller  Scheduled for sync
        Normal  UPDATE  5s (x6 over 2m38s)  nginx-ingress-controller  Ingress default/nginx-ingress
        Normal  UPDATE  5s (x6 over 2m38s)  nginx-ingress-controller  Ingress default/nginx-ingress


        kubectl get svc --all-namespaces
        NAMESPACE              NAME                                 TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                      AGE
        default                kubernetes                           ClusterIP      10.96.0.1       <none>          443/TCP                      6m59s
        default                nginx-service                        ClusterIP      10.99.148.27    <none>          8080/TCP                     3m57s
        ingress-nginx          ingress-nginx                        LoadBalancer   10.106.0.155    172.42.42.100   80:32168/TCP,443:32383/TCP   39h
        ingress-nginx          ingress-nginx-controller             LoadBalancer   10.109.16.42    172.42.42.101   80:32512/TCP,443:30794/TCP   159m
        ingress-nginx          ingress-nginx-controller-admission   ClusterIP      10.102.5.185    <none>          443/TCP                      159m
        kube-system            ingress-nginx-controller-admission   ClusterIP      10.102.232.86   <none>          443/TCP                      6d20h
        kube-system            kube-dns                             ClusterIP      10.96.0.10      <none>          53/UDP,53/TCP,9153/TCP       11d
        kubernetes-dashboard   dashboard-metrics-scraper            ClusterIP      10.109.46.0     <none>          8000/TCP                     11d
        kubernetes-dashboard   kubernetes-dashboard                 ClusterIP      10.102.145.82   <none>          80/TCP                       11d

        kubectl get ingress
        NAME            CLASS    HOSTS                                     ADDRESS         PORTS     AGE
        nginx-ingress   <none>   emili-roures-vives.students.lasalle.com   172.42.42.100   80, 443   6m45s

        curl -k http://emili-roures-vives.students.lasalle.com
        curl: (7) Failed to connect to emili-roures-vives.students.lasalle.com port 80: Timed out

--------------------------------------------------------------------------------
. Una vez realizadas las pruebas con el protocolo HTTP, se pide acceder al
servicio mediante la utilización del protocolo HTTPS, para ello:
    * Crear un certificado mediante la herramienta OpenSSL u otra similar
    * Crear un secret que contenga el certificado
--------------------------------------------------------------------------------

* creación de secret tls (open ssl)
    - instalar openssl
        choco install openssl

* Un secreto TLS se utiliza para la terminación SSL en el controlador de entrada. Para generar el secreto para este ejercicio, utilizamos un certificado autofirmado. 
Esto funciona con las pruebas; para la producción, hay que utilizar un certificado firmado por una autoridad de certificación

        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=nginxsvc/O=nginxsvc"
        Generating a RSA private key
        .....................................+++++
        ........................+++++
        writing new private key to 'tls.key'
        -----

        kubectl create secret tls tls-secret --key tls.key --cert tls.crt
        secret/tls-secret created

* comprobamos que se haya creado el secret

        kubectl get secret
        NAME                  TYPE                                  DATA   AGE
        default-token-wlgfg   kubernetes.io/service-account-token   3      11d
        tls-secret            kubernetes.io/tls                     2      37s

        kubectl describe secret tls-secret
        Name:         tls-secret
        Namespace:    default
        Labels:       <none>
        Annotations:  <none>

        Type:  kubernetes.io/tls

        Data
        ====
        tls.crt:  1184 bytes
        tls.key:  1732 bytes

* introducimos el secreto creado en el fichero ingress.yaml, junto a los elementos necesarios para https

        apiVersion: networking.k8s.io/v1
        kind: Ingress
        metadata:
            name: nginx-ingress
        spec:
            tls:
            - secretName: tls-secret
            rules:
            - host: emili-roures-vives.students.lasalle.com
                http:
                paths:
                    - path: /
                    pathType: Prefix
                    backend:
                        service: 
                        name: nginx-service
                        port: 
                            number: 80

                            
     curl -k http://emili-roures-vives.students.lasalle.com
     curl: (7) Failed to connect to emili-roures-vives.students.lasalle.com port 80: Timed out