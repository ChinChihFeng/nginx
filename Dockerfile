FROM uriahfeng/docker-basic-image:latest

LABEL Component="nginx" \ 
      Name="customized nginx"

# Install packages before running script

RUN yum -y install git && \
    yum -y update && \
    yum clean all

# Start to compile nginx by Ansible

WORKDIR /tmp

RUN git clone -b develop https://github.com/ChinChihFeng/nginx.git; \
    ansible-playbook /tmp/nginx/tests/test.yml --syntax-check; \
    ansible all -m setup -i /tmp/nginx/tests/inventory; \
    ansible-playbook /tmp/nginx/tests/test.yml
