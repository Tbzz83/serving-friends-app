## CI/CD with GitHub actions and Azure
Even though deploying code manually is made quite easy with Azure App Service, we still want to implement CI/CD workflows where we can, to allow for as much automation as possible!

### Automated deployment for Frontend Code
The yaml file for the GitHub actions workflow can be found [here](https://github.com/Tbzz83/friends-app-frontend/tree/main/.github/workflows). This action runs whenever PRs and pushes to main occur. Since we have set up just a development environment, we can just trigger our static web app to build to the live application. 
#### GitHub set up
Create a new branch (I'll call mine develop) with `git branch develop` and switch to it with `git checkout develop`. When we push changes to our frontend app to develop and create a PR, we'll want our app to begin a new build. 

For this action to work, we'll need to a secret and a variable to our repo. Create a repository variable called `VITE_REACT_APP_API_BASE_URL`, and a value of the url/api of the Static web app.

![image](https://github.com/user-attachments/assets/47c030cd-a6d0-4441-aa3e-0b0b38315c42)

The action will create the .env needed to set our BASE_URL using this variable.

Next we'll need to add a secret variable called `AZURE_STATIC_WEB_APPS_API_TOKEN`. The value of this can be found from the deployment token in your Azure Static web app from the portal:

![image](https://github.com/user-attachments/assets/2ac60a6b-1667-4993-a196-5fced1248ea6)

![image](https://github.com/user-attachments/assets/f7992060-d52d-4e2c-a298-a539aa9524d2)

#### Testing
The home page of our app looks like this:

![image](https://github.com/user-attachments/assets/510a95ac-1970-4d3a-97ea-45c7418fdc18)

Let's modify our code for the homepage, push our changes to develop, create a PR, and see if our new version builds and approves.

In `src/App.jsx` change `My Besties` text to `My Bestest Friends!!`.

![image](https://github.com/user-attachments/assets/834caaeb-0755-43e6-a986-b84f85d8fb5e)


Now we'll commit and push our changes to the `develop` branch. (In root of frontend repo)
```
(base) azeezoe@BBMP814:~/projects/friends-app-frontend$ git add src/App.jsx
(base) azeezoe@BBMP814:~/projects/friends-app-frontend$ git commit -m "Changing homepage text"
[develop 5e67c5b] Changing homepage text
 1 file changed, 1 insertion(+), 1 deletion(-)
(base) azeezoe@BBMP814:~/projects/friends-app-frontend$ git push origin develop
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 20 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 454 bytes | 454.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To github.com:Tbzz83/friends-app-frontend.git
   2b4c5b4..5e67c5b  develop -> develop
```

Create a pull request.

![image](https://github.com/user-attachments/assets/80e686aa-1764-4a81-8054-3bd6926023cb)
![image](https://github.com/user-attachments/assets/d513279a-0bc3-4bb4-abdb-0324f8e9398e)

Once it's complete, it will automatically create and deploy to the preview environment on Azure.

![image](https://github.com/user-attachments/assets/5527b191-2309-40ba-ab8f-ab7044672880)'

![image](https://github.com/user-attachments/assets/a8f7dd95-2fa0-4bea-9e17-f12c743b3e05)

We can see that the URL for the preview environment is slightly different.

Let's approve the PR and merge it to main.

![image](https://github.com/user-attachments/assets/bcb08bec-94ce-4536-bb36-6eca9791dd7f)

Approving the PR will automatically trigger a new commit to main, meaning a new build for the actions workflow. 

![image](https://github.com/user-attachments/assets/bdce5cf0-d474-47ff-b0d3-54ee30166def)

Once that's finished, the preview version will be destroyed, and we can finally check the live application at the main url!

![image](https://github.com/user-attachments/assets/0ad8d837-7d70-4ec2-89c5-bce1a261a962)
### Automated deployment for Backend Code
Our CI/CD to the web app is going to work different to the static web app. We are going to utilize the staging and production web app slots. When PRs are created, the code will be deployed to the staging slot. When the PR is approved and merged into main, the code will be deployed to the production (default) slot. In a real live application we would *never* push changes directly to prod, we would instead deploy to staging and then swap the staging slots once we were happy. This exercise is more to help understand how we can deploy to different slots based on changes to certain branches. In reality, we could have two separate static web apps that are each linked to a different backend slot. We would also likely have many more deployment slots (develop, feature, staging etc.) where commits to `main` would trigger a deployment to staging, ready to be swapped into production. Many ways to skin a cat, but this works for our purposes for now!
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



