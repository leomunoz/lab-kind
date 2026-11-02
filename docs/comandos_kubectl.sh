#!/bin/bash

## Trabajar con un namespace
kubectl config set-context --current --namespace=testleo

## Ver en que namespace estamos
kubectl config view --minify | grep namespace

## Y como siempre para poder ver los recursos dentro del namespace

kubectl gat all (pods, svc, routes)

## Aquí me he descargado y montado una imagen de nginx en un pod:
kubectl create deployment nginx \
  --image=nginx
deployment.apps/nginx created

## Ahora lo vamos a exponer como si fuera un service para poder verlo en el navegador

kubectl expose deployment nginx --port=80 --type=ClusterIP
service/nginx exposed

## 

