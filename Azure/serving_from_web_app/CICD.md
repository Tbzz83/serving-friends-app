## CI/CD with GitHub actions and Azure
Even though deploying code manually is made quite easy with Azure App Service, we still want to implement CI/CD workflows where we can, to allow for as much automation as possible!

### Automated deployment for Frontend Code
The yaml file for the GitHub actions workflow can be found [here](https://github.com/Tbzz83/friends-app-frontend/tree/main/.github/workflows). This action runs whenever PRs and pushes to main occur. Since we have set up just a development environment, we can just trigger our static web app to build to the live application. We can utilize the preview environment feature for Azure static web apps as well. Code pushes to the devleop branch will trigger deployment to the preview environment and pushes to main will deploy to the default 'prod' environment.
#### GitHub set up
Create a new branch (I'll call mine develop) with `git branch develop` and switch to it with `git checkout develop`. When we push changes to our frontend app to develop and create a PR, we'll want our app to begin a new build. 

For this action to work, we'll need to a secret and a variable to our repo. Create a repository variable called `VITE_REACT_APP_API_BASE_URL`, and a value of the url/api of the Static web app.

![image](https://github.com/user-attachments/assets/47c030cd-a6d0-4441-aa3e-0b0b38315c42)

The action will create the .env needed to set our BASE_URL using this variable.
You will also need to add another variable called `VITE_REACT_APP_API_BASE_URL_DEVELOP` which will be very similar to the above variable, but instead is the url for the preview environment. This url is the same as the default one, but contains the branch name and region as well (<static_app_url>-develop.<region>.<number>.azurestaticapps.net/).

Next we'll need to add a secret variable called `AZURE_STATIC_WEB_APPS_API_TOKEN`. The value of this can be found from the deployment token in your Azure Static web app from the portal:

![image](https://github.com/user-attachments/assets/2ac60a6b-1667-4993-a196-5fced1248ea6)

![image](https://github.com/user-attachments/assets/f7992060-d52d-4e2c-a298-a539aa9524d2)

#### Testing
When you first push something to the develop branch, a new preview environment will be created for the static app. At this point, you will need to navigate to the Azure portal, and link the develop branch preview environment to the staging slot of the API backend. While you're here, link the default environment to the default staging slot too (if you haven't already). Do this even though at this stage there is no code deployed to the backend API regardless.

When PRs are created, an additional preview environment will also be created (not the develop branch one) that is ephemeral and will be removed once the PR is approved. Commits to main will deploy to the regular environment, which is linked to our default staging slot.

![image](https://github.com/user-attachments/assets/0ad8d837-7d70-4ec2-89c5-bce1a261a962)
### Automated deployment for Backend Code
yaml code for the backend code is located [here](https://github.com/Tbzz83/friends-app-backend/tree/main/.github/workflows).


Our CI/CD to the web app is going to work different to the static web app. We are going to utilize the staging and production web app slots. When pushes and PRs are made from the develop branch, the app will deploy to the staging slot. When commits are made to main, the app will deploy to the default staging slot.
#### GitHub set up
Create a new branch in the same fashion that we did in the frontend CI/CD setup. 

We first need to download the publish profile of our app service from the Azure portal. Before you do this, ensure you have the following app settings in the terraform code (or through Azure portal) for the app service:
```
"WEBSITE_WEBDEPLOY_USE_SCM" = true
"SCM_DO_BUILD_DURING_DEPLOYMENT" = 1
```
Once this is done, download the publish profile from the Azure portal, and use it's contents to create a secret in the GitHub repo called 'AZURE_WEBAPP_PUBLISH_PROFILE`. 

![image](https://github.com/user-attachments/assets/28172d98-a840-4268-9bd0-377c21aab24f)

Do the same thing for the staging slot in Azure, however call the secret in GitHub `AZURE_WEBAPP_PUBLISH_PROFILE_STAGING`.

We also need to add three more secrets that will be used to create the `.env` file used for the Python build.

![image](https://github.com/user-attachments/assets/605c3b08-3da5-4177-969e-0d9544a5ec53)

Use the values found in the MySQL authentication/credentials tab in Azure to get these values.
#### Testing
When we create a new PR, we should expect to see our flask application get deployed to the staging slot. When we approve this PR, we should see the app deployed to the production slot.

On PR:

![image](https://github.com/user-attachments/assets/abcad47e-c7e8-4a9d-8107-5d3b686e9631)
![image](https://github.com/user-attachments/assets/4e04f461-f429-4f9b-9407-e84c8449e19a)

We can see it successfully deployed to our staging slot.

On commit to main:

![image](https://github.com/user-attachments/assets/7033b881-9ee5-400e-a384-c47f91773a22)

![image](https://github.com/user-attachments/assets/f72a2331-8aab-4bb0-8700-daf24e7f2ce1)

Success!!



