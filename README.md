## Serving-Friends-App
A project showcasing numerous ways to serve the friends-app with!

This project is intended to showcase serving a web application ([javascript frontend](https://github.com/Tbzz83/friends-app-frontend), [python backend](https://github.com/Tbzz83/friends-app-backend)) from a number of different methods. 

### Hosting on Azure
Below you will find the links for different ways to host Friends-App using the Microsoft Azure Cloud platform. All methods are implemented using terraform IaC, and the [Azure App Service](https://github.com/Tbzz83/serving-friends-app/blob/main/serving_from_web_app/CICD.md) and [Azure Kubernetes Service](https://github.com/Tbzz83/serving-friends-app/blob/main/serving_from_aks/README.md) implementations also have accompanying CI/CD workflows implemented with GitHub actions.
1. [Serving from Virtual Machine (VM)](https://github.com/Tbzz83/serving-friends-app/tree/main/serving_from_VMs)
2. [Serving from Virtual Machine Scale Sets (VMSS)](https://github.com/Tbzz83/serving-friends-app/tree/main/serving_from_VMSS)
3. [Serving from Azure App Service](https://github.com/Tbzz83/serving-friends-app/tree/main/serving_from_web_app)
4. [Serving from Azure Kubernetes Service (AKS) Cluster](https://github.com/Tbzz83/serving-friends-app/tree/main/serving_from_aks)

This is intended to be illustrated from most granular to progressively more scalable, managed, and abstracted solutions. 
