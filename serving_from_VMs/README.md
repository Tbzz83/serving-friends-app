Let's run our application on a frontend and backend VM, that are in different subnets
First we'll pull the source code down from the github for the frontend and backend respectively.

```
git clone https://github.com/Tbzz83/friends-app-frontend.git
git clone https://github.com/Tbzz83/friends-app-backend.git
```
Now we'll need to install our packages on the VMs
Backend:
```
adminuser@backend-server:~/friends-app-backend$ python3 -m venv venv
adminuser@backend-server:~/friends-app-backend$ source venv/bin/activate
(venv) adminuser@backend-server:~/friends-app-backend$ pip install -r requirements.txt
```

Frontend:
```
adminuser@frontend-server:~$ sudo apt update
adminuser@frontend-server:~$ sudo apt install -y nodejs npm
adminuser@frontend-server:~$ cd friends-app-frontend 
adminuser@frontend-server:~$ npm install
```

In order to properly serve our application, we will also need to install and setup nginx 
First let's build our nodejs application:
```
adminuser@frontend-server:~/friends-app-frontend$ npm run build
```
Install nginx:
```
sudo apt update
sudo apt install nginx -y
cd /var/www
sudo mkdir -p friends-app-frontend
cd ~/friends-app-frontend/
sudo cp -r dist/* /var/www/friends-app-frontend/
sudo chown -R www-data:www-data /var/www/friends-app-frontend/
cd /etc/nginx/sites-available/
sudo vim friends-app-frontend
```
Put the following code into /etc/nginx/sites-available/friends-app-frontend:
```
server {
    listen 80;
    server_name your-domain.com;

    root /var/www/friends-app-frontend;
    index index.html;

    location / {
        try_files $uri /index.html;
    }

    location /api/ {
        proxy_pass http://10.0.1.4:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```
Then we need to symbolically link it in the sites-enabled folder:
```
sudo ln -s /etc/nginx/sites-available/friends-app-frontend /etc/nginx/sites-enabled/
```
Remove the default landing page:
```
sudo rm default
cd /var/www
sudo rm html -rf
sudo systemctl restart nginx
```
And we should be good to go

On the backend VM:
```
(venv) adminuser@backend-server:~/friends-app-backend$ export FLASK_RUN_HOST=0.0.0.0
(venv) adminuser@backend-server:~/friends-app-backend$ flask run
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5000
 * Running on http://10.0.1.4:5000
Press CTRL+C to quit
```
When we go to the public IP of our frontend VM on port 80 we can see that our app is running, and 
we can succesfully update our friends DB.
![image](https://github.com/user-attachments/assets/23996c50-e7ea-497f-9ad7-bb76674397b1)
![image](https://github.com/user-attachments/assets/85d45dc1-f109-453d-844d-d5272e298dd1)
![image](https://github.com/user-attachments/assets/8fe18252-fa84-4e21-872e-e7f1b5db846d)


