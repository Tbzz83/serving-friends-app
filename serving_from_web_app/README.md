## Azure Web App
### Code preparations
The only real preparations we have to make here is changing the `BASE_URL` for the backend in App.jsx. Usually we would point this to whatever the IP address or FQDN the backend is usually. For the specific case of Azure Web Apps, when we use the API functionality (below) to set the API for the frontend to the Web App of the backend, it establishes a link between the two using the Azure backbone. As per the Azure documentation [here](https://learn.microsoft.com/en-us/azure/static-web-apps/apis-app-service), we should set the route to point to the domain name of the *static* web app (as long as all our routes begin with `/api`, which they do, everything will sync up correctly). Since we can only know what the FQDN of the Static web app is after it's deployed, we will have to check Azure first.

![image](https://github.com/user-attachments/assets/46414521-6d5c-4f16-8088-0dd2e4cf009f)

looks like ours is called `https://yellow-tree-045609b0f.6.azurestaticapps.net/`. 

In our frontend repo, create a `.env` with the contents:
```
VITE_REACT_APP_API_BASE_URL=https://yellow-tree-045609b0f.6.azurestaticapps.net
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











