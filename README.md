docker-play-framework
==================

Play Framework with CentOS

Make a Play Framework environment using the Docker.

### 1. Please correct the file to suit your environment

 - authorized_keys
 
   Your public key

 - monit.conf
 
   Your IP address to allow
  ```
set httpd port 2812 and
    allow localhost        # allow localhost to connect to the server and
    allow **Your IP address here**
    allow admin:monit      # require user 'admin' with password 'monit'
    allow @monit           # allow users of group 'monit' to connect (rw)
    allow @users readonly  # allow users of group 'users' to connect readonly
```

### 2. Build docker image

```sh
  % sudo docker build -t centos-play -rm=true .
  % sudo docker images
  REPOSITORY               TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
  centos-play              latest              8a8b20fd03c2        23 minutes ago      1.035 GB
```

### 3. Run docker container

```sh
  % sudo docker run -d -t -p 12812:2812 -p 9000:9000-p 10022:22 centos-play /usr/bin/monit -I
 9c796ab91f7d79259811b0343978ef1354a57b38e43a64d8bb83b4148aad28a0
  % play run
  % type scala
  scala is /home/play/scala-2.11.0/bin/scala
  % type play
  play is /usr/local/bin/play
  % type java
  java is /usr/bin/java
  % curl http://localhost:9000/
```
