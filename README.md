# Chef

Fast and simple way to setup server from raw Ubuntu image to production ready
[environment](https://github.com/denwwer/chef/tree/master/chef) whit using pure Shell script, just run:

```
chmod 777 chef.sh
./chef.sh
```

### Customization:
* check file `chef/setup.sh` "*Config*" section and "*Chef's*" for customization
* check chef's files in `chef/*` directory to customize each configurations

### Example:

```
./chef.sh root@123.123.321 ~/.ssh/id_rsa.pub /root/chef staging
```
will daploy chef's to `root@123.123.321` inside `/root/chef` directory, add user SSH key `~/.ssh/id_rsa.pub` and run chef's using `staging` environment.


This chef's are tested/applied on **AWS EC2** and **DigitalOcean Droplet** with Ubuntu 16.04 LTS

## Available configurations
* Nginx as reverse proxy
* Nginx + Node.js
* Nginx + Passenger + Ruby on Rails
