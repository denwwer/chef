# Chef (Beta)

Quick and simple server setup from raw Ubuntu image to production ready environment using pure Shell script, just run

```
chmod 777 chef.sh
./chef.sh [user@host] [key.pub] [chef/path] [environment]
```
This chef's are tested/applied on **AWS EC2** and **DigitalOcean Droplet** with Ubuntu 16.04 LTS
### Available Environments
* Node.js + Nginx
* Ruby on Rails + Passenger + Nginx
