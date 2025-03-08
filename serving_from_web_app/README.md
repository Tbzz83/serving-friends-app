## Serving from Azure Web App
### Code preparations
The only real preparations we have to make here is changing the `BASE_URL` for the backend in App.jsx. Usually we would point this to whatever the IP address or FQDN the backend is usually. For the specific case of Azure Web Apps, when we use the API functionality (below) to set the API for the frontend to the Web App of the backend, it establishes a link between the two using the Azure backbone. As per the Azure documentation [here](https://learn.microsoft.com/en-us/azure/static-web-apps/apis-app-service), we should set the route to point to the domain name of the *static* web app (as long as all our routes begin with `/api`, which they do, everything will sync up correctly). Since we can only know what the FQDN of the Static web app is after it's deployed, we will have to check Azure first.

![image](https://github.com/user-attachments/assets/46414521-6d5c-4f16-8088-0dd2e4cf009f)

looks like ours is called `https://yellow-tree-045609b0f.6.azurestaticapps.net/`. 

In our frontend repo, create a `.env` with the contents:
```
VITE_REACT_APP_API_BASE_URL=https://yellow-tree-045609b0f.6.azurestaticapps.net/api
```
Take note to *not* add a `/` to the end of this url. 

In App.jsx make sure that your exportable `BASE_URL` variable collects this from the `.env` file like this:
```
export const BASE_URL = import.meta.env.VITE_REACT_APP_API_BASE_URL;
```
Save both the files are you're ready to deploy the application. 
### Deploying code (manually)
#### Frontend
Deploying the frontend code is very simple. In the root directory of the frontend repo, execute the following in the terminal.

**Note**: make sure you are logged into the az cli in the right subscription first.
```
npm install -D @azure/static-web-apps-cli
npx swa init --yes
npx swa build
npx swa login --resource-group <resource_group_name> --app-name friendsapp-frontend-dev
npx swa deploy --env production --app-name friendsapp-frontend-dev # Deploys to production not preview
```

![image](https://github.com/user-attachments/assets/b0f74356-373b-46cf-8fda-585518b77d17)

Now our frontend is set up, lets set up the backend.
#### Backend
Again this is fairly straightforward for us to do manually. In VSCode, if you have the Azure extension installed, you can deploy directly to whichever web app slot you choose.

![image](https://github.com/user-attachments/assets/202badf2-04c3-4829-83d1-bbfd525ecbb7)

Right click `friendsapp-backend-dev`

![image](https://github.com/user-attachments/assets/fb0daa4f-ad9a-4778-8d94-a858b0aab56d)

Click on `Deploy to Web App`. You'll then be prompted to browse to the repository of the backend application. Now would be a good time to double check your `app.py` and make sure everything looks right. (If you want to use the deployment slots for the API, you can also deploy your code directly to the staging slot in VSCode).

![image](https://github.com/user-attachments/assets/2dac7d8e-8351-4a02-acea-6828ae891a42)

Click select.

![image](https://github.com/user-attachments/assets/0998c52a-d957-44e2-8a72-855f951c86c4)

Click yes.

![image](https://github.com/user-attachments/assets/fd54c0cb-ca0f-4f80-a0e8-515e1f4a3afb)

Click deploy.

![image](https://github.com/user-attachments/assets/0dba977f-e72d-4a06-bf33-8c574560ebe3)

You can see that the code is now being deployed to your Web App.

![image](https://github.com/user-attachments/assets/460fbb23-9d25-42c6-a173-041b2b880c73)

Once this is done we can jump back onto Azure to see how the build is going.

![image](https://github.com/user-attachments/assets/731db2cd-e7c1-4b85-ad52-8da509f1d1c5)

If this says success, we're almost good to go. Let's now head back to the Azure portal to add the web app as the API of the static web app.

#### Linking backend API

![image](https://github.com/user-attachments/assets/65cde642-3874-49d1-9c3d-3830a8dc8eba)

Click on 'link'.

![image](https://github.com/user-attachments/assets/fad8cc47-f797-4684-99fe-925574c8e21c)

The above parameters will set the API to the production staging slot of the flask web app.

Now we can test the application!

![image](https://github.com/user-attachments/assets/c1c2d96b-4a81-4e45-8605-e66628386ee4)
![image](https://github.com/user-attachments/assets/45d7fb1d-6d8e-4ded-adba-9d2366f6a9c3)











