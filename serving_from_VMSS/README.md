## Serving from VMSS
Deploying to VMs is a good first step, but what do we do when we need to dynamically scale our application layers? One VM for the frontend and one for the backend will surely not be enough if our application is getting a lot of traffic. Using a Virtual Machine Scale Set (VMSS) allows us to define backend pools of VMs for both the frontend and backend, as well as autoscaling rules based on metrics like CPU or memory usage!

#### Code preparations
By this point our code in `friends-app-backend` has been configured to use the MySQL database we've created on Azure. 

This block in `app.py` shows that authentication
```
# >>> SQL DB setup >>>

# Must quote password if it has special characters
sql_pw = quote(CONFIG["sql_pw"])

# If using Azure SQL DB connection string sql_host_db will look like:
sql_host_db = CONFIG["sql_host_db"]
sql_user = CONFIG["sql_user"]
app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://{sql_user}:{sql_pw}@{sql_host_db}"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)

# <<< SQL DB setup <<<
```
Since the NIC of our internal load balancer exists in the backend-subnet, it should have a private IP address of `10.0.1.4/24`. Let's check this in Azure to be sure.

![image](https://github.com/user-attachments/assets/a1bafa2c-8ebe-4c2f-803e-99f5c376eeb2)

In `App.jsx` for our frontend application, ensure that `BASE_URL` points to this IP address on port 5000, since the load balancer rule expects traffic on this port and will forward it to port 5000 of our backend flask application.

#### Imaging VMs
Next we will need to SSH into the two VMs we've created, pull our codebase onto them and then image them to use with our VMSS. We have our two VMs for this `image-server-0` and `image-server-1`, and we can follow the package set up and installation from the regular VM deployments [here](https://github.com/Tbzz83/serving-friends-app/blob/main/serving_from_VMs/README.md). Do make sure you create a `.env` file on the backend VM and put the MySQL credentials in there.

Once your VMs are set up, capture the VM image for each and save as a generalized image to the image gallery created from the `imaging` terraform module.

#### Deploying
We can simply deploy the `vmss` module in the terraform code, and it will pull our images from the image gallery, and start hosting our application! We can use the public IP address of the frontend load balancer to access our application.

![image](https://github.com/user-attachments/assets/c46946d8-1ac2-46cd-8c34-ca050bfd37b4)

And voila!

![image](https://github.com/user-attachments/assets/9841953c-13c0-43b8-8319-2a6aa3f9762a)
![image](https://github.com/user-attachments/assets/7d046bdc-1190-4773-bb24-ea6bd6531143)

