1. Setting up PostgreSQL

Following steps are required on RHEL/CENTOS to install PostgreSQL:

# Install the repository RPM:
sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Disable the built-in PostgreSQL module:
sudo dnf -qy module disable postgresql

# Install PostgreSQL:
sudo dnf install -y postgresql15-server

# Optionally initialize the database and enable automatic start:
sudo /usr/pgsql-15/bin/postgresql-15-setup initdb
sudo systemctl enable postgresql-15
sudo systemctl start postgresql-15


when accessing PostgreSQL command prompt, configuration is needed as follows:
sudo -u postgres psql
# CREATE USER hbrs WITH PASSWORD 'your preferred password' CREATEDB;
# CREATE DATABASE hbrs;
# GRANT ALL ON SCHEMA public TO hbrs;
# ALTER DATABASE hbrs OWNER TO hbrs;

if you prefer to log-in with password, it is also recommended to set password for postgresql user
w/ ALTER USER command

In file:
/var/lib/pgsql/15/data/pg_hba.conf
local   all             all                                     peer
peer will need to be replaced for md5 or scram-sha-256 to utilize password login

2. Setting up NGINX http server
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

    location /ui {
      root /usr/www-root/hbrs;
    }

    location /fcgi {
      fastcgi_pass   127.0.0.1:8000;

      fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
      fastcgi_param  SERVER_SOFTWARE    nginx;
      fastcgi_param  QUERY_STRING       $query_string;
      fastcgi_param  REQUEST_METHOD     $request_method;
      fastcgi_param  CONTENT_TYPE       $content_type;
      fastcgi_param  CONTENT_LENGTH     $content_length;
      fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
      fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
      fastcgi_param  REQUEST_URI        $request_uri;
      fastcgi_param  DOCUMENT_URI       $document_uri;
      fastcgi_param  DOCUMENT_ROOT      $document_root;
      fastcgi_param  SERVER_PROTOCOL    $server_protocol;
      fastcgi_param  REMOTE_ADDR        $remote_addr;
      fastcgi_param  REMOTE_PORT        $remote_port;
      fastcgi_param  SERVER_ADDR        $server_addr;
      fastcgi_param  SERVER_PORT        $server_port;
      fastcgi_param  SERVER_NAME        $server_name;
    }
  }
}
```

3. Setting up C++ build toolchain

sudo yum install spawn-fcgi  fcgi-devel g++ make
