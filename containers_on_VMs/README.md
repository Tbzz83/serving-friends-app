Our containers are in place in eduacr.azurecr.io/friends-app
We will provision our VMs, install docker on our frontend and backend VMs, and
log into our container registry.

On our VMs, we will need to install the az cli and docker

Installing docker on both VMs
```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Installing az cli and logging into our container registry

frontend:
```
adminuser@frontend-server:~$ curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
adminuser@frontend-server:~$ sudo az login --identity --username <UAMI_ID> 
adminuser@frontend-server:~$ sudo az acr login --name eduacr
adminuser@frontend-server:~$ sudo docker pull eduacr.azurecr.io/friends-app:frontend-v1

```

backend:
```
adminuser@backend-server:~$ curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
adminuser@backend-server:~$ sudo az login --identity --username <UAMI_ID> 
adminuser@frontend-server:~$ sudo az acr login --name eduacr
adminuser@backend-server:~$ sudo docker pull eduacr.azurecr.io/friends-app:backend-v1
```

While the backend does have a public IP, we don't need it to run our application.
First we start up the backend

```
adminuser@backend-server:~$ sudo docker run -p 5000:5000 -e FLASK_RUN_HOST=0.0.0.0 -e FLASK_RUN_PORT=5000 241f1a1b015c
 * Serving Flask app 'app.py'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5000
 * Running on http://172.17.0.2:5000
Press CTRL+C to quit
10.0.0.4 - - [08/Dec/2024 19:56:01] "GET /api/friends HTTP/1.1" 200 -
```

Now we can start the frontend by giving the API base url as the private IP of the Azure VM.

```
adminuser@frontend-server:~$ sudo docker run -p 80:80 -e VITE_API_BASE_URL=http://10.0.1.4:5000/api 46f990c1ff44
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2024/12/08 19:56:48 [notice] 1#1: using the "epoll" event method
2024/12/08 19:56:48 [notice] 1#1: nginx/1.27.3
2024/12/08 19:56:48 [notice] 1#1: built by gcc 13.2.1 20240309 (Alpine 13.2.1_git20240309)
2024/12/08 19:56:48 [notice] 1#1: OS: Linux 6.5.0-1025-azure
2024/12/08 19:56:48 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2024/12/08 19:56:48 [notice] 1#1: start worker processes
2024/12/08 19:56:48 [notice] 1#1: start worker process 29
```
Just to make sure, we will dissasociate the backend public IP and check if things are still working.
![image](https://github.com/user-attachments/assets/ce6b3483-2030-4208-b3f8-4565248d8631)

And we can see that are app is working when we access the application using the public IP of our frontend machine.

![image](https://github.com/user-attachments/assets/271e0932-0a2b-403a-a6cb-12cc042a85a5)




