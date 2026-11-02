#!/bin/bash

## Creamos cluster
kind create cluster --name lab

## Veamos nuestro nodo de diferentes formas

$ docker ps
CONTAINER ID   IMAGE                  COMMAND                  CREATED       STATUS       PORTS                       NAMES
a15df69818df   kindest/node:v1.37.0   "/usr/local/bin/entr…"   2 hours ago   Up 2 hours   127.0.0.1:41183->6443/tcp   lab-control-plane

$ kubectl get nodes -o wide
NAME                STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                       KERNEL-VERSION                              CONTAINER-RUNTIME
lab-control-plane   Ready    control-plane   91m   v1.37.0   172.18.0.2    <none>        Debian GNU/Linux 13 (trixie)   6.18.54.1-microsoft-standard-WSL2 (amd64)   containerd://2.3.4

## Con esto vemos muchísima información de nuestro nodo
docker inspect lab-control-plane

## Creamos namespace

kubectl create namespace testleo

## Trabajar con un namespace cambiando el contexto
kubectl config set-context --current --namespace=testleo

## Ver en que namespace estamos
kubectl config view --minify | grep namespace

## Y como siempre para poder ver los recursos dentro del namespace

kubectl gat all (pods, svc, routes)

## Aquí me he descargado y montado una imagen de nginx en un pod, desplegando una aplicación:
kubectl create deployment nginx \
  --image=nginx
deployment.apps/nginx created

## Ahora lo vamos a exponer como si fuera un service para poder verlo en el navegador

kubectl expose deployment nginx --port=80 --type=ClusterIP
service/nginx exposed

kubectl get svc -o wide
NAME    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE    SELECTOR
nginx   ClusterIP   10.96.147.250   <none>        80/TCP    3m2s   app=nginx

## Para poder verlo en el navegador

$ kubectl port-forward service/nginx 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
Handling connection for 8080

#Y abrimos el navegador con 127.0.0.1:8080
Welcome to nginx!

## Ahora veamos a nivel de nodo , en este caso dentro de nuestro laboratorio con docker ps vemos el "nodo"

$ docker ps
CONTAINER ID   IMAGE                  COMMAND                  CREATED             STATUS             PORTS                       NAMES
a15df69818df   kindest/node:v1.37.0   "/usr/local/bin/entr…"   About an hour ago   Up About an hour   127.0.0.1:41183->6443/tcp   lab-control-plane

## Entramos en el contenedor
leomr@Casa:~/repos/lab-kind (development)$ docker exec -it lab-control-plane bash
root@lab-control-plane:/# ls /etc/kubernetes/manifests/
etcd.yaml  kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml
root@lab-control-plane:/#

## Para apagar el "nodo"

docker stop lab-control-plane

$ docker stop lab-control-plane
lab-control-plane
leomr@Casa:~/repos/lab-kind (development)$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

## Para arrancar el nodo parado 

$ docker ps -a
CONTAINER ID   IMAGE                  COMMAND                  CREATED       STATUS                       PORTS     NAMES
a15df69818df   kindest/node:v1.37.0   "/usr/local/bin/entr…"   2 hours ago   Exited (137) 2 minutes ago             lab-control-plane

docker start lab-control-plane

## Comprobamos
kubectl get nodes

## Para volver a arrancar, vemos lo que teníamos .. aquí vemos que el API Server falla ya que no existe en ejecución

$ docker ps -a
CONTAINER ID   IMAGE                  COMMAND                  CREATED       STATUS                       PORTS     NAMES
a15df69818df   kindest/node:v1.37.0   "/usr/local/bin/entr…"   2 hours ago   Exited (137) 2 minutes ago             lab-control-plane
leomr@Casa:~/repos/lab-kind (development)$ kind get clusters
lab
leomr@Casa:~/repos/lab-kind (development)$ kubectl get nodes
The connection to the server 127.0.0.1:41183 was refused - did you specify the right host or port?


## Ahora lo interesante es el multinodo.. ya para otro día



