Let's put the frontend and backend containers into our container registry

On my local machine:
```
(base) azeezoe@BBMP814:~/projects$ docker login eduacr.azurecr.io
Username: eduacr
Password:
Login Succeeded
```
Then let's push our images:
```
(base) azeezoe@BBMP814:~/projects$ docker tag friends-app-frontend eduacr.azurecr.io/friends-app:frontend-v1
(base) azeezoe@BBMP814:~/projects$ docker tag friends-app-backend eduacr.azurecr.io/friends-app:backend-v1
(base) azeezoe@BBMP814:~/projects$ docker push eduacr.azurecr.io/friends-app:frontend-v1
The push refers to repository [eduacr.azurecr.io/friends-app]
0e96ed264865: Pushed
2430c01bea64: Pushed
b11b58162504: Pushed
8b5ce426f73d: Pushed
884b72c14f15: Pushed
4a37d1b49911: Pushed
4e8a0009474a: Pushed
287563f25f8b: Pushed
75654b8eeebd: Pushed
frontend-v1: digest: sha256:7101fc254d05477fb5396bf98210f267e8c04d27bdca828085251c0417f0c243 size: 2199
(base) azeezoe@BBMP814:~/projects$ docker push eduacr.azurecr.io/friends-app:backend-v1
The push refers to repository [eduacr.azurecr.io/friends-app]
79af0042649a: Pushed
bd10d1dd7bd3: Pushed
3e89c90691a4: Pushed
ad05cdcb59cd: Pushed
3a9ca0e18fd5: Pushed
42ca3c4e0243: Pushed
c0f1022b22a9: Pushed
backend-v1: digest: sha256:7db160e3dc45ce1ea456f1548f2b6695859319b2d8fee0186d7dc4b9c01789a4 size: 1787
```

