## Setting Up the Frontend and Backend VMs in Different Subnets
### We'll start by pulling the source code for both the frontend and backend from GitHub:

#### Clone the repositories:
```bash
git clone https://github.com/Tbzz83/friends-app-frontend.git
git clone https://github.com/Tbzz83/friends-app-backend.git
```
#### Backend VM Setup
Create a Python virtual environment:
```bash
cd ~/friends-app-backend
python3 -m venv venv
source venv/bin/activate
```
Install the required Python packages:
```bash
pip install -r requirements.txt
Frontend VM Setup
```
Update the package list and install Node.js and npm:
```bash
sudo apt update
sudo apt install -y nodejs npm
```
Navigate to the frontend directory and install the required dependencies:
```bash
cd friends-app-frontend
npm install
```
#### Building and Deploying the Frontend with Nginx
Before we can run our build, we need to ensure that the endpoint for our
backend VM is configured. In src/App.jsx, change `BASE_URL` to the private
IP address of the backend VM. Here Ill change it to:
```javascript
export const BASE_URL = import.meta.env.MODE === "development" ? "http://10.0.1.4:5000/api" : "/api";
```
Build the Node.js application:
```bash
npm run build
```
Install Nginx:
```bash
sudo apt update
sudo apt install nginx -y
```
Set up the frontend files in the web directory:
```bash
cd /var/www
sudo mkdir -p friends-app-frontend
cd ~/friends-app-frontend/
sudo cp -r dist/* /var/www/friends-app-frontend/
sudo chown -R www-data:www-data /var/www/friends-app-frontend/
```
Configure Nginx:
```bash
cd /etc/nginx/sites-available/
sudo vim friends-app-frontend
```
Add the following Nginx configuration:

```nginx
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
Enable the site by creating a symbolic link:
```bash
sudo ln -s /etc/nginx/sites-available/friends-app-frontend /etc/nginx/sites-enabled/
```
Remove the default Nginx landing page:
```bash
sudo rm /etc/nginx/sites-enabled/default
sudo rm -rf /var/www/html
```
Restart Nginx to apply the changes:
```bash
sudo systemctl restart nginx
```
#### Backend VM Configuration
Set the Flask host to allow external access:
```bash
cd ~/friends-app-backend
export FLASK_RUN_HOST=0.0.0.0
```
Start the Flask app:
```bash
flask run
```
This will make the backend available at http://10.0.1.4:5000.


#### Final Steps
Now, when you visit the public IP of your frontend VM on port 80, you should be able to see the application running. You can also successfully update the friends database through the frontend interface.
![image](https://github.com/user-attachments/assets/23996c50-e7ea-497f-9ad7-bb76674397b1)
![image](https://github.com/user-attachments/assets/85d45dc1-f109-453d-844d-d5272e298dd1)
![image](https://github.com/user-attachments/assets/b2a10534-59bb-4461-9c6a-0ae951214b92)

#### Viewing our infrastructure topology
![image](https://github.com/user-attachments/assets/daca74bf-4897-45a5-94bc-ae6545b0f64b)



