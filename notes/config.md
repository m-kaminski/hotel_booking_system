# 1. Setting up PostgreSQL

Following steps are required on RHEL/CENTOS to install PostgreSQL:

# Install the repository RPM:
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Disable the built-in PostgreSQL module:
sudo dnf -qy module disable postgresql

# Install PostgreSQL:
sudo dnf install -y postgresql15-server
sudo dnf install -y postgresql15-contrib

# Optionally initialize the database and enable automatic start:
sudo /usr/pgsql-15/bin/postgresql-15-setup initdb
sudo systemctl enable postgresql-15
sudo systemctl start postgresql-15


when accessing PostgreSQL command prompt, configuration is needed as follows:
```
sudo -u postgres psql
 CREATE USER hbrs WITH PASSWORD 'your preferred password' CREATEDB;
 CREATE DATABASE hbrs;
 GRANT ALL ON SCHEMA public TO hbrs;
 ALTER DATABASE hbrs OWNER TO hbrs;
```

if you prefer to log-in with password, it is also recommended to set password for postgresql user
w/ ALTER USER command

In file:
/var/lib/pgsql/15/data/pg_hba.conf
local   all             all                                     peer
peer will need to be replaced for md5 or scram-sha-256 to utilize password login

Set datasource :

```
cp example.datasource.properties  ../backends/booking/service/src/main/resources/datasource.properties
```
and set your username, db and password in datasource.properties file

# 2. Setting up NGINX http server


sudo yum install nginx 
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
systemctl restart nginx

NGINX server is located in following directory /etc/nginx/nginx.conf

```
http {
  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

  include             /etc/nginx/mime.types;
  default_type        application/octet-stream;
  access_log  /var/log/nginx/access.log  main;
  server {
    listen 80;
    server_name localhost;

    location / {
      root /usr/www-root/hbrs;
    }
  }
}
```

# 3. Setting up Java environment

```
### Linux 64-bit ###
wget https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz
tar xvf openjdk-17.0.2_linux-x64_bin.tar.gz

### Linux ARM64 ###
wget https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-aarch64_bin.tar.gz
tar xvf openjdk-17.0.2_linux-aarch64_bin.tar.gz

### regardless of arch:

sudo mv jdk-17.0.2/ /opt/jdk-17/

$EDITOR ~/.bashrc
export JAVA_HOME=/opt/jdk-17
export PATH=$PATH:$JAVA_HOME/bin 
``

$ source ~/.bashrc
```

# 3. Testing

To check behavior of booking backend, you can i.e. use wget command like this:
```
wget "http://localhost:8080/findrooms?checkin=2023-03-01T00:00:00-06:00&checkout=2023-03-24T00:00:00-05:00" -O- -o-

wget "http://localhost:8080/bookrooms?checkin=2023-03-01T00:00:00-06:00&checkout=2023-03-24T00:00:00-05:00&room_type=2" -O- -o- 

```
(or just use browser UI)


Sample commands to run performance tests

```
for j in `seq 10` ; do time for i in `seq 10000` ;\
do wget "http://localhost:8080/findrooms?checkin=2023-03-01T00:00:00-06:00&checkout=2023-03-24T00:00:00-05:00" -O- -o- >/dev/null 2>/dev/null ; done & done


for j in `seq 10` ; do time for i in `seq 10000` ; \
do wget "http://localhost:8080/bookrooms?checkin=2023-03-01T00:00:00-06:00&checkout=2023-03-24T00:00:00-05:00&room_type=2" -O- -o- >/dev/null 2>/dev/null ; done & done

```

