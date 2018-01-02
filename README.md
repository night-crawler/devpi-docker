### INSTALLATION

1. Install latest `docker-ce` (17.12.0-ce) and `docker-compose` (1.18.0)
2. Setup [nginx-proxy](https://github.com/jwilder/nginx-proxy), or [docker-compose-letsencrypt-nginx-proxy-companion](https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion)
3. Ensure `nginx-network` exists and used by nginx-proxy:
    - `docker network create --attachable --driver overlay --subnet 10.10.10.10/24 nginx-network`
4. Clone:
    - `git clone https://github.com/night-crawler/devpi-docker/`
    - `cd devpi-docker`
5. Tune environment: `cp .env.sample .env`
6. `docker-compose up`
7. Add `devpi.test` (or whatever) to `/etc/hosts`


### USAGE

#### Update `~/.pip/pip.conf`
```ini
[global]
index-url = http://devpi.test/root/pypi/+simple/

[search]
index = http://devpi.test/root/pypi/

[install]
trusted-host=devpi.test
```

#### Update `~/.pydistutils.cfg `
```ini
[easy_install]
index_url = http://devpi.test/root/pypi/+simple/
```


```bash
# install devpi client
pip install devpi-client

# set devpi server
devpi use http://devpi.test

# login
devpi login root
# enter password from .env file

# set your email
devpi user -m root email=lilo.panic@gmail.com

# change password
devpi user -m root password=ChangeMePlease

# add `dev` index of main pypi
devpi index -c dev bases=root/pypi

# use index
devpi use root/dev

# install package
devpi install pytest
# or
pip install django

```

#### Usage with SSL

Let's assume volumes of `docker-compose-letsencrypt-nginx-proxy-companion` are mounted to 
`./data`:

```bash
pwd
# /docker/docker-compose-letsencrypt-nginx-proxy-companion]

ls ./data
# certs  conf.d  html  htpasswd  vhost.d
```

Put into `./data/vhost.d/devpi.test_location`:
```ini
proxy_set_header X-outside-url $scheme://$host:$server_port;
proxy_set_header X-Real-IP $remote_addr;
```
