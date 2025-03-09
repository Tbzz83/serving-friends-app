### Automated deployment for Frontend
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
