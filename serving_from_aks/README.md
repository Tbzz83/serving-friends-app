## Serving from Azure AKS
This section of the project focuses mainly on CI/CD practices for deploying to Azure Kubernetes cluster. There are parts of this that would not be appropriate to do for production environments, and those will be mentioned when relevant. 

#### File locations
* [Frontend helm charts](https://github.com/Tbzz83/friends-app-frontend/tree/main/helm)
* [Frontend actions workflow](https://github.com/Tbzz83/friends-app-frontend/blob/main/.github/workflows/aks_static_deploy.yml)
* [Backend helm charts](https://github.com/Tbzz83/friends-app-backend/tree/main/helm)
* [Backend actions workflow](https://github.com/Tbzz83/friends-app-backend/blob/main/.github/workflows/aks_api_deploy.yml)

Terraform code will create an Azure Kubernetes Service (AKS) cluster and an Azure Container Registry (ACR).

While that's deploying, we can create the relevant secrets in the frontend and backend repositories on GitHub.

You'll need these secrets for the frontend and the backend:
![image](https://github.com/user-attachments/assets/8422491e-ffd0-43e1-91f9-8ae63bb52c50)

`ACR_PASSWORD` and `ACR_USERNAME` and `AZURE_URL` can be grabbed from the access keys tab of the ACR resource. 

The `KUBECONFIG` can be retrieved using the Azure CLI
```
az aks get-credentials --resource-group education --name edu-k8s-dev --file kubeconfig-ss
```

When resources get deployed using our helm charts later on, namespaces will be created with the following scheme <repository_name>-<branch>. Before we can deploy the backend, we'll need to add the specific kubernetes secrets needed to authenticate to our MySQL database.
Additionally, pushes and PRs will create and deploy to the `develop` namespace, and commits to main will deploy to the `main` namespace. We'll need to add secrets to each namespace. This is done intentionally, so that if it was wanted, you could have different 
MySQL database instances that get accessed by different namespaces. You may want the 'main' namespace to access a production DB while the 'develop' branch accesses a develop one.

#### Connecting to our AKS cluster
Using the kubeconfig that we retrieved with the Azure CLI, we can temporarily set it as our context by executing `echo KUBECONFIG=/path/to/kubeconfig/file` in the terminal.
Once there we can create the required backend namespaces and add our secrets like so
```
kubectl create ns friends-app-backend-main
kubectl create ns friends-app-backend-develop
kubectl create secret generic my-database-secret \
  --from-literal=SQL_USER=myuser \
  --from-literal=SQL_PW=mypassword \
  --from-literal=SQL_HOST_DB=mydatabase \
  --namespace=my-namespace
