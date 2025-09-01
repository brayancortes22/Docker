❯ docker build -t miapp-back-front .
[+] Building 448.0s (15/17)                                                                                     docker:desktop-linux
 => [internal] load build definition from Dockerfile                                                                            0.1s
 => => transferring dockerfile: 1.50kB                                                                                          0.0s
 => [internal] load metadata for docker.io/library/ubuntu:22.04                                                                 0.1s
 => [internal] load .dockerignore                                                                                               0.0s
 => => transferring context: 2B                                                                                                 0.0s
 => CACHED [ 1/13] FROM docker.io/library/ubuntu:22.04@sha256:1aa979d85661c488ce030ac292876cf6ed04535d3a237e49f61542d8e5de5ae0  0.1s
 => => resolve docker.io/library/ubuntu:22.04@sha256:1aa979d85661c488ce030ac292876cf6ed04535d3a237e49f61542d8e5de5ae0           0.1s
 => [internal] load build context                                                                                               0.1s
 => => transferring context: 68B                                                                                                0.0s
 => [ 2/13] RUN apt-get update &&     apt-get install -y python3 python3-pip python3-venv git nginx mariadb-server mariadb-c  180.8s
 => [ 3/13] RUN mkdir -p /etc/supervisor/conf.d                                                                                 0.8s
 => [ 4/13] RUN git clone https://github.com/brayancortes22/docker_prueba_Codigo_back_front.git /app                            2.6s
 => [ 5/13] WORKDIR /app/Back-EndProyectoFinal2025                                                                              0.2s
 => [ 6/13] RUN python3 -m venv venv                                                                                            8.7s
 => [ 7/13] RUN /bin/bash -c 'source venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt'        30.5s
 => [ 8/13] WORKDIR /app/Front-end-Proyecto-2025                                                                                0.4s
 => [ 9/13] RUN npm install                                                                                                   207.7s
 => [10/13] RUN npm run build                                                                                                  14.8s
 => ERROR [11/13] RUN cp -r build/* /var/www/html/                                                                              0.9s
------
 > [11/13] RUN cp -r build/* /var/www/html/:
0.759 cp: cannot stat 'build/*': No such file or directory
------
Dockerfile:31
--------------------
  29 |
  30 |     # Copiar el build de React a la carpeta pública de Nginx
  31 | >>> RUN cp -r build/* /var/www/html/
  32 |
  33 |
--------------------
ERROR: failed to solve: process "/bin/sh -c cp -r build/* /var/www/html/" did not complete successfully: exit code: 1

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/husbwuvqx8h3ut18yxp3eex6b
