[![Build Status](https://travis-ci.org/ChinChihFeng/nginx.svg?branch=master)](https://travis-ci.org/ChinChihFeng/nginx)

# Summary

This Ansible role has the following features for installing nginx. It support modules below list on Centos7.

 - upstream check
 - upstream fair
 - upstream jvm route
 - vts
 - session sticky
 - testcookie
 - Lua
 - WAF

## Usage

ansible-playbook nginx.yml

```yaml
---
- hosts: all
  roles:
    - nginx
```

## Role Variables
The most varibles are default. If you want to change any version of modules or cores, you would modify number or string in the default configuration under the this path `default/main.yml`. Now, the version of nginx is `1.12.1`, all modules are verified that they can be capable of compiling with nginx. Changing any version should ensure that it is match with nginx version which you are using now. 


### To Do
 -

## Author
<uriahfeng@gmail.com>
